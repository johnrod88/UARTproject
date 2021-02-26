
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity RAM_BUILD is
    generic( w: integer:= 8;
            r:integer:= 4);

    Port ( CLK : in STD_LOGIC;
           WREN : in STD_LOGIC;
           EN : in STD_LOGIC;
           ADRS : in STD_LOGIC_VECTOR (r-1 downto 0);
           DIN : in STD_LOGIC_VECTOR (w-1 downto 0);
           DOT : out STD_LOGIC_VECTOR (w-1 downto 0));
end RAM_BUILD;

architecture Behavioral of RAM_BUILD is
    type ram_type is array (0 to 2**r-1) of STD_LOGIC_VECTOR (w-1 DOWNTO 0);
    SIGNAL RAM: RAM_TYPE:=(OTHERS => (OTHERS=>'0'));
    
    begin
    
    PROCESS(CLK)
        BEGIN
            IF RISING_EDGE(CLK) THEN
                IF (EN = '1') THEN
                    DOT<= RAM(TO_INTEGER(UNSIGNED(ADRS)));
                        IF (WREN='1') THEN
                            RAM(TO_INTEGER(UNSIGNED(ADRS)))<= DIN;
                        END IF;
                END IF;
            END IF;
    END PROCESS;

end Behavioral;
