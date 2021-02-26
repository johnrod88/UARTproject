----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 11:33:45 AM
-- Design Name: 
-- Module Name: RAMcontroller - Behavioral
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

entity RAMcontroller is
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
end RAMcontroller;

architecture Behavioral of RAMcontroller is
    --RAM Declaration
    component RAM_BUILD is
        generic( w: integer:= 8;
                r:integer:= 4);
    
        Port ( CLK : in STD_LOGIC;
               WREN : in STD_LOGIC;
               EN : in STD_LOGIC;
               ADRS : in STD_LOGIC_VECTOR (r-1 downto 0);
               DIN : in STD_LOGIC_VECTOR (w-1 downto 0);
               DOT : out STD_LOGIC_VECTOR (w-1 downto 0));
    end component;
    --States
    type ram_state is (idle, read_state, write_state);
    signal curr_state, next_state: ram_state;
    signal write_en, ram_en: std_logic;
    signal isEmpty, isFull: std_logic;
    signal rdPointer, wrPointer: unsigned(r downto 0) := (others => '0');
    signal rdNext, wrNext : unsigned(r downto 0);
    signal ram_addr: std_logic_vector ((r-1) downto 0);
        
    
begin
    --RAM Declaration
    ram: RAM_BUILD port map (
        CLK => clk,
        WREN => write_en,
        EN => ram_en,
        ADRS => ram_addr,
        DIN => data_in,
        DOT => data_out
    );
    
    --Clock Process
    process(clk, reset) begin
        if (reset = '1') then
            curr_state <= idle;
            rdPointer <= (others => '0');
            wrPointer <= (others => '0');
        elsif(rising_edge(clk)) then
            curr_state <= next_state;
            rdPointer <= rdNext;
            wrPointer <= wrNext;
        end if;
    end process;
    
    --State Logic
    process(curr_state, in_ready) begin
        --Save Values
        next_state <= curr_state;
        rdNext <= rdPointer;
        wrNext <= wrPointer;
        --Clear Values
        write_en <= '0';
        ram_en <= '0';
        read_done <= '0';
        write_done <= '0';
        
        case curr_state is
            when idle =>
                if (in_ready = '1') then
                    if (isFull = '0') then
                        write_en <= '1';
                        ram_en <= '1';
                        next_state <= write_state;
                        ram_addr <= std_logic_vector(wrPointer((r-1) downto 0));
                        wrNext <= wrPointer + 1;
                    end if;
                elsif (out_ready = '1') then
                    if (isEmpty = '0') then
                        ram_en <= '1';
                        next_state <= read_state;
                        ram_addr <= std_logic_vector(rdPointer((r-1) downto 0));
                        rdNext <= rdPointer + 1;
                    end if;
                end if;
            when write_state =>
                --ram_addr <= std_logic_vector(wrPointer((r-1) downto 0));
                --write_en <= '1';
                read_done <= '1';
                next_state <= idle;
            when read_state =>
                --ram_addr <= std_logic_vector(rdPointer((r-1) downto 0));
                write_done <= '1';
                next_state <= idle;
        end case;
    end process;
    
    --Full/Empty logic
    isEmpty <= '1' when rdPointer = wrPointer else
               '0';
    isFull <= '1' when ((wrPointer xor rdPointer) = 2**r) else
              '0'; --'1' when MSBs are different, but other bits are same.
    
end Behavioral;
