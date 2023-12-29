library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registro_desplazamiento is
    Port (
        rst: IN std_logic;
        clk_2Hz: IN std_logic;
        direccion: in std_logic;
        leds: OUT std_logic_vector (15 downto 0)
        ); 
end registro_desplazamiento;

architecture Behavioral of registro_desplazamiento is

signal leds_aux: std_logic_vector (15 downto 0);

begin
    leds <= leds_aux;
    
    wol: process (rst, clk_2Hz)
        begin
            if rst = '1' then
                leds_aux <= "0000001111000000";
            elsif rising_edge(clk_2Hz) then
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
