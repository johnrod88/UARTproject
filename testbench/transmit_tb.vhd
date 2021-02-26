----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2020 01:31:32 PM
-- Design Name: 
-- Module Name: transmit_tb - Behavioral
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

entity transmit_tb is
--  Port ( );
end transmit_tb;

architecture Behavioral of transmit_tb is
    --Component Declarations
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
    signal tx: std_logic := '1';
    signal tx_start: std_logic;
    signal baudtick: std_logic;
    signal tx_done: std_logic;
    signal input_tb: std_logic_vector(7 downto 0);
begin
    baud: baud_gen port map(
        sysclk => sysclk,
        reset => reset,
        max_tick => baudtick
    );
    tsmtr: transmitter port map(
        sysclk => sysclk,
        reset => reset,
        tx_start => tx_start,
        baud_tick => baudtick,
        d_in => input_tb,
        tx_done => tx_done,
        tx => tx
    );
    
    --Clock
    process begin
        sysclk <= '1';
        wait for 20ns;
        sysclk <= '0';
        wait for 20ns;
    end process;
    
    --Output (01010101) starting with LSB;
    process begin
        reset <= '1';
        input_tb <= (others => '0');
        wait for 5ns;
        reset <= '0';
        wait for 5ns;
        --Start bit
        tx_start <= '1';
        input_tb <= "01010101";
        wait for 50ns;
        tx_start <= '0';
        wait for 2ms;
    end process;

end Behavioral;
