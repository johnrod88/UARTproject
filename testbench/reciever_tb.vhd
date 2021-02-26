----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2020 01:31:32 PM
-- Design Name: 
-- Module Name: recieve_tb - Behavioral
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

entity recieve_tb is
--  Port ( );
end recieve_tb;

architecture Behavioral of recieve_tb is
    --Component Declarations
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
    
    component baud_gen is
        generic(
            BAUD_COUNT: integer := 163;  --9600 * 16 = 153,600, 25mhz / 153600 = 162.7
            N: integer := 8             --Number of bits in counter
        );
        Port ( 
            sysclk : in STD_LOGIC;
            reset : in STD_LOGIC;
            max_tick : out STD_LOGIC
        );
    end component;
    
    --Signals
    signal sysclk: std_logic;
    signal reset: std_logic;
    signal rx: std_logic := '1';
    signal baudtick: std_logic;
    signal rx_done: std_logic;
    signal output_tb: std_logic_vector(7 downto 0);
begin
    baud: baud_gen port map(
        sysclk => sysclk,
        reset => reset,
        max_tick => baudtick
    );
    rcvr: reciever port map(
        sysclk => sysclk,
        reset => reset,
        rx => rx,
        baud_tick => baudtick,
        rx_done => rx_done,
        d_out => output_tb
    );
    
    --Clock
    process begin
        sysclk <= '1';
        wait for 20ns;
        sysclk <= '0';
        wait for 20ns;
    end process;
    
    --Input (01010101) starting with LSB;
    process begin
        reset <= '1';
        rx <= '1';
        wait for 5ns;
        reset <= '0';
        wait for 104161ns;
        --Start bit
        rx <= '0';
        wait for 104166ns;
        --Data Bits
        rx <= '1';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        --Stop bit
        rx <= '1';
        wait for 500000ns;
    end process;

end Behavioral;
