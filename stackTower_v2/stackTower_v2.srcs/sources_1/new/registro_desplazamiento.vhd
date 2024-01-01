library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registro_desplazamiento is
    Port (
        rst: IN std_logic;                          -- Reset
        clk_Dificultad: in std_logic;               -- Clk de la dificultad para la secuencia juego
        direccion: in std_logic;                    -- Dirección hacia la que está yendo la plataforma(leds encendidos)
        leds: OUT std_logic_vector (15 downto 0)    -- La salida de los leds    
        ); 
end registro_desplazamiento;

architecture Behavioral of registro_desplazamiento is

signal leds_aux: std_logic_vector (15 downto 0);

begin
    leds <= leds_aux;
    
    wol: process (rst, clk_dificultad)
        begin
            if rst = '1' then                       -- Si reset es 1 se reinician los leds a 0000 0011 1100 0000
                leds_aux <= "0000001111000000";
            elsif rising_edge(clk_dificultad) then  -- Si hay señal del clk_dificultad, se avanzan los leds hacia la dirección que toca.
                if(direccion = '0') then
                    leds_aux(15 downto 1) <= leds_aux(14 downto 0);
                    leds_aux(0) <= '0';
                else
                    leds_aux(14 downto 0) <= leds_aux(15 downto 1);
                    leds_aux(15) <= '0';
                end if;
            end if;
    end process wol;

end Behavioral;
