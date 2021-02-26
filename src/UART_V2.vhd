----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 03:45:09 PM
-- Design Name: 
-- Module Name: UART_V2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_V2 is
    Port ( rx : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx : out STD_LOGIC);
end UART_V2;

architecture Behavioral of UART_V2 is
    --Components
    component baud_gen is
        Port ( 
            sysclk : in STD_LOGIC;
            reset : in STD_LOGIC;
            max_tick : out STD_LOGIC
        );
    end component;
    
    component reciever is
        generic(
            DATA_BITS:  integer := 8;
            STOP_TICKS: integer := 16
        );
        Port (
            sysclk:     in STD_LOGIC;
            reset :     in STD_LOGIC;
            rx :        in STD_LOGIC;
            baud_tick : in STD_LOGIC;
            rx_done:    out STD_LOGIC;
            d_out :     out STD_LOGIC_VECTOR ((DATA_BITS - 1) downto 0)
        );
    end component;
    
    component transmitter is
        Generic(
            DATA_BITS: integer := 8;
            STOP_TICKS: integer := 16
        );
        Port ( sysclk :    in STD_LOGIC;
               reset : in STD_LOGIC;
               tx_start : in STD_LOGIC;
               baud_tick : in STD_LOGIC;
               d_in : in STD_LOGIC_VECTOR (7 downto 0);
               tx_done : out STD_LOGIC;
               tx : out STD_LOGIC);
    end component;
    
    component FIFObuffer is
        generic(WIDTH: integer := 8; --bit width of buffer
                ADDR_BITS: integer := 3 --3 bits for 8 addresses
                );
                
        Port (clk, reset: in std_logic;
              wr, rd: in std_logic;
              d_in: in std_logic_vector(WIDTH-1 downto 0);
              d_out: out std_logic_vector(WIDTH-1 downto 0);
              full, empty: out std_logic
              );
    end component;
    
    component RAMcontroller is
        generic(
            r: integer := 4);
        Port ( 
            clk, reset : in std_logic;
            data_in : in STD_LOGIC_VECTOR (7 downto 0);
            in_ready : in STD_LOGIC;
            out_ready : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (7 downto 0);
            write_done: out std_logic;
            read_done: out std_logic);
    end component;
    
    --Signals
    signal baud_tick, rx_done, tx_done,read_done, write_done: std_logic;
    signal fifo1_empty, fifo1_full, fifo2_empty, fifo2_full: std_logic;
    signal rec_fifo1, fifo1_ram, ram_fifo2, fifo2_trans: std_logic_vector(7 downto 0);
    signal fifo2_empty_inv, fifo2_full_inv, fifo1_empty_inv: std_logic;
    
begin
    baudgen: baud_gen port map ( 
        sysclk => clk,
        reset => reset,
        max_tick => baud_tick
    );
    
    rcvr: reciever port map (
        sysclk => clk,
        reset => reset,
        rx => rx,
        baud_tick => baud_tick,
        rx_done => rx_done,
        d_out => rec_fifo1
    );
    
    trns: transmitter Port map ( 
        sysclk => clk,
        reset => reset,
        tx_start => fifo2_empty_inv,
        baud_tick => baud_tick,
        d_in => fifo2_trans,
        tx_done => tx_done,
        tx => tx
    );
    
    fifo1: FIFObuffer Port map (
        clk => clk,
        reset => reset,
        wr => rx_done, 
        rd => read_done,
        d_in => rec_fifo1,
        d_out => fifo1_ram,
        full => fifo1_full,
        empty => fifo1_empty
    );
    
    fifo2: FIFObuffer Port map (
        clk => clk,
        reset => reset,
        wr => write_done, 
        rd => tx_done,
        d_in => ram_fifo2,
        d_out => fifo2_trans,
        full => fifo2_full,
        empty => fifo2_empty
    );
    
    ramcntrl: RAMcontroller Port map ( 
        clk => clk,
        reset => reset,
        data_in => fifo1_ram,
        in_ready => fifo1_empty_inv,
        out_ready => fifo2_full_inv,
        data_out => ram_fifo2,
        write_done => write_done,
        read_done => read_done
    );
    
    --inversions
    fifo2_empty_inv <= not fifo2_empty;
    fifo2_full_inv <= not fifo2_full;
    fifo1_empty_inv <= not fifo1_empty;

end Behavioral;
