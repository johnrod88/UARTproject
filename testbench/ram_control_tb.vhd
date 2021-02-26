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

entity ram_control_tb is
--  Port ( );
end ram_control_tb;

architecture Behavioral of ram_control_tb is
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
    signal sysclk, reset, in_ready, out_ready, write_done, read_done: std_logic;
    signal data_in, data_out: std_logic_vector(7 downto 0);
begin
    test1: RAMcontroller Port map( 
        clk => sysclk,
        reset => reset,
        data_in => data_in,
        in_ready => in_ready,
        out_ready => out_ready,
        data_out => data_out,
        write_done => write_done,
        read_done => read_done
    );

    --Clock
    process begin
        sysclk <= '1';
        wait for 10ns;
        sysclk <= '0';
        wait for 10ns;
    end process;
    
    -- Control
    process begin
        reset <= '1';
        data_in <= (others => '0');
        in_ready <= '0';
        out_ready <= '1';
        wait for 5ns;
        reset <= '0';
        wait for 50ns;
        data_in <= "11111111";
        in_ready <= '1';
        wait for 25ns;
        in_ready <= '0';
        wait for 80ns;
        data_in <= "10101010";
        in_ready <= '1';
        
        wait for 40ns;
        data_in <= "01010101";
        wait for 20ns;
        in_ready <= '0';
        wait for 800ns;
    end process;
        
end Behavioral;