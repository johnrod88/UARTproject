----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 09:50:24 PM
-- Design Name: 
-- Module Name: baud_gen - Behavioral
-- Project Name: Project 1
-- Target Devices: Zynq 7010
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

entity baud_gen is
    generic(
        BAUD_COUNT: integer := 163;  --9600 * 16 = 153,600, 25mhz / 153600 = 162.7
        N: integer := 8             --Number of bits in counter
    );
    Port ( 
        sysclk : in STD_LOGIC;
        reset : in STD_LOGIC;
        max_tick : out STD_LOGIC
    );
end baud_gen;

architecture baud_arch of baud_gen is
    --Counter Declaration
    signal r_reg: unsigned(N-1 downto 0) := (others => '0');
    signal r_next: unsigned(N-1 downto 0);
begin

    -- Update/ Reset
    process(sysclk, reset) begin
        if (reset = '1') then
            r_reg <= (others => '0');
        elsif (rising_edge(sysclk)) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- Reset Counter Logic
    r_next <= (others => '0') when r_reg = (BAUD_COUNT - 1) else r_reg + 1;
    
    -- Output Logic
    max_tick <= '1' when r_reg = (BAUD_COUNT - 1) else '0';

end baud_arch;
