library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity contadorMod10 is
    Port (
        rst: IN std_logic;                          -- Reset
        clk: IN std_logic;                          -- Reloj
        enable: IN std_logic;                       -- Enable del contadorMod10
        capacitacion: IN std_logic;                 -- Clk_4Hz
        salida: OUT std_logic_vector(3 downto 0)    -- Salida de la cuenta
        );  
end contadorMod10;

architecture Behavioral of contadorMod10 is

signal salidaAux: std_logic_vector(3 downto 0);

begin
    wol: process(rst, clk)
        begin
            if (rst = '1' or enable = '0') then     -- Resetea a 0 cuando el reset es 1 o el enable es 0
                salidaAux <= "0000";
            elsif (rising_edge(clk)) then
                if (enable = '1' and capacitacion = '1') then   -- Cuando el enable = 1 y el clk_4Hz está activo suma 1 a la cuenta
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
