----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2020 04:14:48 PM
-- Design Name: 
-- Module Name: FIFObufferTB - Behavioral
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

entity FIFObufferTB is
    generic(WIDTH: integer := 8; --bit width of buffer
            ADDR_BITS: integer := 3 --3 bits for 8 addresses
            );
end FIFObufferTB;

architecture Behavioral of FIFObufferTB is
    component FIFObuffer is
    Port (clk, reset: in std_logic;
          wr, rd: in std_logic;
          d_in: in std_logic_vector(WIDTH-1 downto 0);
          d_out: out std_logic_vector(WIDTH-1 downto 0);
          full, empty: out std_logic
          );
    end component;
    
    signal clkTB, resetTB, wrTB, rdTB, fullTB, emptyTB: std_logic :='0';
    signal d_inTB, d_outTB: std_logic_vector(WIDTH-1 downto 0):=(others=>'0');
    signal incrNum: unsigned(WIDTH-1 downto 0):=(others=>'0');
    Constant T: time := 40 ns; -- clk period for 25MHz clock
begin
    uut: FIFObuffer
        port map(clk => clkTB,
                 reset => resetTB,
                 wr => wrTB,
                 rd => rdTB,
                 d_in => d_inTB,
                 d_out => d_outTB,
                 full => fullTB,
                 empty => emptyTB
                );
    
    --create clk signal            
    process 
    begin
        clkTB <= '1';
        wait for T/2;
        clkTB <= '0';
        wait for T/2;
    end process;
    
    --for writing data into FIFO
    process
    begin
        incrNum <= incrNum + 1;
        wait for T; -- a clk period of doing nothing
        while(fullTB='0') loop --fill up the FIFO
            d_inTB <= std_logic_vector(incrNum);                
            wrTB <= '1';
            wait for T;
            wrTB <= '0';
            incrNum <= incrNum + 1;
            wait for T;
        end loop;
        wait until emptyTB='1'; --let FIFO be fully read
        wait for 2*T;
        for i in 0 to 3 loop--fill FIFO half way
            d_inTB <= std_logic_vector(incrNum);                
            wrTB <= '1';
            wait for T;
            wrTB <= '0';
            incrNum <= incrNum + 1;
            wait for T;
        end loop;
        wait until emptyTB='1';--let those 4 bytes be read
        wait for 2*T; 
        resetTB<='1';--test the reset function
        wait for T;
        resetTB<='0';
        wait for T;       
        while(fullTB='0') loop --start writing, reading will occur simultaneously
            d_inTB <= std_logic_vector(incrNum);                
            wrTB <= '1';
            wait for T;
            wrTB <= '0';
            incrNum <= incrNum + 1;
            wait for T;
        end loop;
        
             
    end process;
    
    --for reading data from FIFO
    process
    begin
        wait until fullTB='1'; --let FIFO get full
        wait for 2*T;
        while(emptyTB='0') loop --read data until FIFO empty
            rdTB <= '1';                
            wait for T;
            rdTB <= '0';
            wait for T;
        end loop;        
        wait for 10*T; --let a few writes occur
        while(emptyTB='0') loop --start reading data out
            rdTB <= '1';                
            wait for T;
            rdTB <= '0';
            wait for T;
        end loop;       
        wait until resetTB='1';
        wait until resetTB='0';
        wait for T;
        while(emptyTB='0') loop --start reading, data will be written simultaneously
            rdTB <= '1';                
            wait for T;
            rdTB <= '0';
            wait for T;
        end loop;    
    end process;       
end Behavioral;
