library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity sumadorPuntuacion is
    Port ( 
        rst, clk: in std_logic;
        control: in std_logic_vector(1 downto 0);
        entrada: in std_logic_vector(3 downto 0);
        salida: out std_logic_vector(3 downto 0)
    );
end sumadorPuntuacion;

architecture Behavioral of sumadorPuntuacion is

begin

Sync: process(clk, control, rst)
begin

if rst = '1' or control = "11" then
    salida <= (others => '0');
elsif rising_edge(clk)then
    if control = "01" then
        salida <= entrada + "001";
    end if;
end if;

end process sync;

end Behavioral;
