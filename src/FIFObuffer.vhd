----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2020 01:38:20 PM
-- Design Name: 
-- Module Name: FIFObuffer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity FIFObuffer is
    generic(WIDTH: integer := 8; --bit width of buffer
            ADDR_BITS: integer := 3 --3 bits for 8 addresses
            );
            
    Port (clk, reset: in std_logic;
          wr, rd: in std_logic;
          d_in: in std_logic_vector(WIDTH-1 downto 0);
          d_out: out std_logic_vector(WIDTH-1 downto 0);
          full, empty: out std_logic
          );
end FIFObuffer;

architecture Behavioral of FIFObuffer is
    type regFile_type is array (0 to 2**ADDR_BITS-1) of std_logic_vector(WIDTH-1 downto 0);
    signal regFile: regFile_type :=(others=>(others=>'0'));
    signal wrPointer, rdPointer: unsigned(ADDR_BITS downto 0):=(others=>'0');
    signal isEmpty, isFull: std_logic;
begin
    process(clk, reset)
    begin
        if(reset='1') then
            regFile <= (others=>(others=>'0')); --clear regFile
            wrPointer <= (others=>'0'); --reset wrPointer
            rdPointer <= (others=>'0'); --reset rdPointer
        elsif(clk'event and clk='1') then
            if(wr='1' and isFull='0') then
                regFile(to_integer(wrPointer(ADDR_BITS-1 downto 0))) <= d_in;
                wrPointer <= wrPointer + 1;
            end if;
            if(rd='1' and isEmpty='0') then
                rdPointer <= rdPointer + 1;
            end if; 
        end if;
    end process;        
    
    --output logic
    isEmpty <= '1' when rdPointer = wrPointer else
               '0';
    isFull <= '1' when ((wrPointer xor rdPointer) = 2**ADDR_BITS) else
              '0'; --'1' when MSBs are different, but other bits are same.
    
    d_out <= regFile(to_integer(rdPointer(ADDR_BITS-1 downto 0)));
    empty <= isEmpty;
    full <= isFull;            

end Behavioral;