library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity biestable is
   Port (
        rst: IN std_logic;                              -- Reset
        clk_4Hz: IN std_logic;                          -- Clk para las secuencias de ganar, perder, quietos
        entrada: IN std_logic;                          -- Entrada de leds_pierde_gana(15);
        enable: IN std_logic_vector (2 downto 0);       -- Enable del biestable para saber que secuencia realizar
        leds: OUT std_logic_vector (15 downto 0)        -- La salida de los leds
        );
end biestable;

architecture Behavioral of biestable is

signal wololo: std_logic_vector(3 downto 0);
signal ledsAux: std_logic_vector (15 downto 0);

begin
    leds <= ledsAux;
    wololo <= (others => entrada);
    wol: process (enable, clk_4Hz, rst)
        begin
            if (rst = '1') then             -- Resetea
                ledsAux <= (others => '0');     
            elsif (rising_edge(clk_4Hz)) then
                if (enable = "011") then                            -- Secuencia gana
                    ledsAux(15 downto 12) <= wololo;
                    ledsAux(11 downto 8) <= not wololo;
                    ledsAux(7 downto 4) <= wololo;
                    ledsAux(3 downto 0) <=  not wololo;
                elsif (enable = "100") then                         -- Secuencia pierde
                    ledsAux(15 downto 0) <= (others => entrada);                   
                end if;
            end if;
    end process;
end Behavioral;
