library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity selector_dif is
    Port ( 
    rst, clk, enable: in std_logic;
    selec: in std_logic_vector(1 downto 0);
    dificultad: out std_logic_vector(1 downto 0)
    );
end selector_dif;

architecture Behavioral of selector_dif is

begin

 wol: process(enable)     --  Cuando el enable cambio dificultad está activo(en S0) cambia la dificultad a lo que ponían los switches
        begin
            if rst = '1' then
                dificultad <= "00";
            elsif rising_edge(clk) then
                if enable = '1' then
                    if selec = "00" then 
                        dificultad <= "00";
                    elsif selec = "01" then
                        dificultad <= "01";
                    elsif selec = "10" then
                        dificultad <= "10";
                    else
                        dificultad <= "11";
                    end if;
                end if;
            end if;
    end process wol;

end Behavioral;
