----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2020 12:00:20 PM
-- Design Name: 
-- Module Name: reciever - Behavioral
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

entity reciever is
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
end reciever;

architecture recieve_arch of reciever is
    type recieve_state is (idle, start, data, stop);
    signal curr_state, next_state:  recieve_state;
    signal baud_reg, baud_next:     unsigned(3 downto 0);
    signal curr_bit, next_bit:      unsigned(2 downto 0);
    signal out_sig, out_next:       std_logic_vector((DATA_BITS - 1) downto 0);
begin
    --Update state/Data
    process(sysclk, reset) begin
        if (reset = '1') then
            curr_state <= idle;
            baud_reg <= (others => '0');
            curr_bit <= (others => '0');
            out_sig <= (others => '0');
        elsif (rising_edge(sysclk)) then
            curr_state <= next_state;
            baud_reg <= baud_next;
            curr_bit <= next_bit;
            out_sig <= out_next;
        end if;
    end process;
    
    --Next State Logic
    process (curr_state, baud_reg, curr_bit, out_sig, baud_tick, rx) 
    begin
        next_state <= curr_state;
        baud_next <= baud_reg;
        next_bit <= curr_bit;
        out_next <= out_sig;
        rx_done <= '0';
        case curr_state is
            when idle =>
                if (rx = '0') then
                    next_state <= start;
                    baud_next <= (others => '0');
                end if;
            when start =>
                if(baud_tick = '1') then
                    if (baud_reg = 7) then
                        next_state <= data;
                        baud_next <= (others => '0');
                        next_bit <= (others => '0');
                    else
                        baud_next <= baud_reg + 1;
                    end if;
                end if;
            when data =>
                if (baud_tick = '1') then
                    if (baud_reg = 15) then 
                        baud_next <= (others => '0');
                        out_next <= rx & out_sig((DATA_BITS - 1) downto 1);
                        if (curr_bit = (DATA_BITS - 1)) then
                            next_state <= stop;
                        else
                            next_bit <= curr_bit + 1;
                        end if;
                    else
                        baud_next <= baud_reg + 1;
                    end if;
                end if;
            when stop =>
                if (baud_tick = '1') then
                    if(baud_reg = (STOP_TICKS - 1)) then
                        next_state <= idle;
                        rx_done <= '1';
                    else
                        baud_next <= baud_reg + 1;
                    end if;
                end if;
        end case;           
    end process;
    
    --Output
    d_out <= out_sig;

end recieve_arch;
