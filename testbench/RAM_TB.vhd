
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM_TB is
--  Port ( );
end RAM_TB;

architecture Behavioral of RAM_TB is
COMPONENT RAM_BUILD IS
GENERIC
    (
            w: integer:=8;
            r:integer:=4
    );

PORT
    (
           CLK : in STD_LOGIC;
           WREN : in STD_LOGIC;
           EN : in STD_LOGIC;
           ADRS : in STD_LOGIC_VECTOR (r-1 downto 0);
           DIN : in STD_LOGIC_VECTOR (w-1 downto 0);
           DOT : out STD_LOGIC_VECTOR (w-1 downto 0)
    );
    
END COMPONENT;

SIGNAL CLKSIG : STD_LOGIC;
SIGNAL WRTEN  : STD_LOGIC;
SIGNAL ENABLE : STD_LOGIC;
SIGNAL ADDRE  : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL DINPT  : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL DOPT   : STD_LOGIC_VECTOR (7 DOWNTO 0);
CONSTANT T : TIME:= 50ns;

BEGIN
    PROCESS
        BEGIN
            CLKSIG <= '0';
            WAIT FOR T/2;
            CLKSIG <= '1';
            WAIT FOR T/2;
        END PROCESS;

RAM0: ENTITY WORK.RAM_BUILD(BEHAVIORAL)
    PORT MAP
        (
            CLK => CLKSIG,
            WREN => WRTEN,
            EN => ENABLE,
            ADRS => ADDRE,
            DIN => DINPT,
            DOT => DOPT 
        );

    PROCESS
        BEGIN
            ENABLE <= '1';
            DINPT  <= "00000000";
            ADDRE  <= "1010";
            WRTEN  <= '0';
            
            WAIT FOR 2*T;
            ENABLE <= '1';
            DINPT  <= "11011111";
            ADDRE  <= "1011";
            WRTEN  <= '1';
            
            WAIT FOR 2*T;
            ENABLE <= '1';
            DINPT  <= "11011111";
            ADDRE  <= "1011";
            WRTEN  <= '0';
            WAIT FOR 2*T;
            
            ENABLE <= '1';
            DINPT  <= "11011111";
            ADDRE  <= "1001";
            WRTEN  <= '0';
            WAIT FOR 2*T;
            
            ENABLE <= '1';
            DINPT  <= "11011011";
            ADDRE  <= "1001";
            WRTEN  <= '1';
            WAIT FOR 2*T;
            
            ENABLE <= '1';
            DINPT  <= "11011011";
            ADDRE  <= "1011";
            WRTEN  <= '0';
            WAIT FOR 2*T;
            
    END PROCESS;

    


end Behavioral;
