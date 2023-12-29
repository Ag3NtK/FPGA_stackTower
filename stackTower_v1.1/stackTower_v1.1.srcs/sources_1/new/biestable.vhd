library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity biestable is
   Port (
        rst: IN std_logic;
        clk_2Hz: IN std_logic;
        entrada: IN std_logic;
        enable: IN std_logic_vector (2 downto 0);
        leds: OUT std_logic_vector (15 downto 0)
        );
end biestable;

architecture Behavioral of biestable is

signal wololo: std_logic_vector(3 downto 0);
signal ledsAux: std_logic_vector (15 downto 0);

begin
    
    leds <= ledsAux;
    wololo <= (others => entrada);
    wol: process (enable, clk_2Hz, rst)
        begin
            if (rst = '1') then
                ledsAux <= (others => '0');
            elsif (rising_edge(clk_2Hz)) then
                if (enable = "011") then -- Ganas
                    ledsAux(15 downto 12) <= wololo;
                    ledsAux(11 downto 8) <= not wololo;
                    ledsAux(7 downto 4) <= wololo;
                    ledsAux(3 downto 0) <=  not wololo;
                elsif (enable = "100") then -- Pierdes
                    ledsAux(15 downto 0) <= (others => entrada);                   
                end if;
            end if;
            
    end process;
end Behavioral;
