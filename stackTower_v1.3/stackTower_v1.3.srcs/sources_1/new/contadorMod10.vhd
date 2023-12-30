library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity contadorMod10 is
    Port (
        rst: IN std_logic;
        clk: IN std_logic;
        enable: IN std_logic;
        capacitacion: IN std_logic;
        salida: OUT std_logic_vector(3 downto 0)
        );  
end contadorMod10;

architecture Behavioral of contadorMod10 is

signal salidaAux: std_logic_vector(3 downto 0);

begin
    wol: process(rst, clk)
        begin
            if (rst = '1' or enable = '0') then
                salidaAux <= "0000";
            elsif (rising_edge(clk)) then
                if (enable = '1' and capacitacion = '1') then
                    if (salidaAux = "1001") then
                        salidaAux <= "0000";
                    else
                        salidaAux <= salidaAux + '1';
                    end if;
                end if;
            end if;
        end process wol;
    
    salida <= salidaAux;

end Behavioral;
