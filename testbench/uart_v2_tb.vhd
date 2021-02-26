----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2020 12:51:13 PM
-- Design Name: 
-- Module Name: uart_v1_tb - Behavioral
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

entity uart_v2_tb is
--  Port ( );
end uart_v2_tb;

architecture Behavioral of uart_v2_tb is
    component UART_V2 is
    Port ( rx : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx : out STD_LOGIC);
    end component;
    signal rx: std_logic := '1';
    signal reset: std_logic := '0';
    signal tx,clk: std_logic;
begin
    test1: UART_V2 port map ( 
        rx => rx,
        clk => clk,
        reset => reset,
        tx => tx
    );

    --Clock
    process begin
        clk <= '1';
        wait for 20ns;
        clk <= '0';
        wait for 20ns;
    end process;
    
    --Data
    process begin
        wait for 104166ns;
        --Start_bit
        rx <= '0';
        wait for 104166ns;
        -- Data LSB first
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
        --Set high and wait
        rx <= '1';
        wait for 104166ns;
        
        --Start_bit
        rx <= '0';
        wait for 104166ns;
        -- Data LSB first
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
        rx <= '1';
        wait for 104166ns;
        --Set high and wait
        rx <= '1';
        wait for 104166ns;
        
        --Start_bit
        rx <= '0';
        wait for 104166ns;
        -- Data LSB first
        rx <= '0';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        --Set high and wait
        rx <= '1';
        wait for 104166ns;
        
        --Start_bit
        rx <= '0';
        wait for 104166ns;
        -- Data LSB first
        rx <= '1';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '1';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        rx <= '0';
        wait for 104166ns;
        --Set high and wait
        rx <= '1';
        wait for 2ms;
    end process;
        
end Behavioral;