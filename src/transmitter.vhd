----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2020 11:51:45 AM
-- Design Name: 
-- Module Name: transmitter - trans_arch
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
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
end transmitter;

architecture trans_arch of transmitter is
    type tran_state is (idle, start, data, stop);
    signal curr_state, next_state: tran_state;
    signal baud_reg, baud_next: unsigned(3 downto 0);
    signal bit_count, bit_next: unsigned(2 downto 0);
    signal data_reg, data_next: std_logic_vector((DATA_BITS - 1) downto 0);
    signal tx_reg, tx_next: std_logic;
begin
    
    --Update state and data regs
    process(sysclk, reset) begin
        if (reset = '1') then
            curr_state <= idle;
            baud_reg <= (others => '0');
            data_reg <= (others => '0');
            bit_count <= (others => '0');
            tx_reg <= '1';
        elsif (rising_edge(sysclk)) then
            curr_state <= next_state;
            baud_reg <= baud_next;
            data_reg <= data_next;
            bit_count <= bit_next;
            tx_reg <= tx_next;
        end if;
    end process;
    
    -- Next state Logic
    process (curr_state, baud_reg, bit_count, data_reg, tx_reg, baud_tick, tx_start, d_in) begin
        next_state <= curr_state;
        baud_next <= baud_reg;
        data_next <= data_reg;
        bit_next <= bit_count;
        tx_next <= tx_reg;
        tx_done <= '0';
        case curr_state is
            when idle =>
                tx_next <= '1';
                if (tx_start = '1') then
                    next_state <= start;
                    baud_next <= (others => '0');
                    data_next <= d_in;
                end if;
            when start =>
                tx_next <= '0';
                if (baud_tick = '1') then
                    if (baud_reg = 15) then
                        next_state <= data;
                        baud_next <= (others => '0');
                        bit_next <= (others => '0');
                    else
                        baud_next <= baud_reg + 1;
                    end if;
                end if;
            when data =>
                tx_next <= data_reg(0);
                if (baud_tick = '1') then
                    if (baud_reg = 15) then
                        baud_next <= (others => '0');
                        data_next <= '0' & data_reg(7 downto 1);
                        if (bit_count = (DATA_BITS - 1)) then
                            next_state <= stop;
                        else
                            bit_next <= bit_count + 1;
                        end if;
                    else
                        baud_next <= baud_reg + 1;
                    end if;
                end if;
            when stop =>
                tx_next <= '1';
                if (baud_tick = '1') then
                    if (baud_reg = (STOP_TICKS - 1)) then
                        next_state <= idle;
                        tx_done <= '1';
                    else
                        baud_next <= baud_reg + 1;
                    end if;
                end if;
        end case;
    end process;
    
    --Output Logic
    tx <= tx_reg;
    
end trans_arch;
