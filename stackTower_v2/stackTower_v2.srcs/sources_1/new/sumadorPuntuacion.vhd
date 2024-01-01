library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity sumadorPuntuacion is
    Port ( 
        rst, clk: in std_logic;                         -- Reset
        control: in std_logic_vector(1 downto 0);       -- Enable del sumador
        entrada: in std_logic_vector(3 downto 0);       -- Entrada de la suma del sumador
        salida: out std_logic_vector(3 downto 0)        -- Salida de la suma realizada por el sumador
    );
end sumadorPuntuacion;

architecture Behavioral of sumadorPuntuacion is

begin

    Sync: process(clk, control, rst)
    begin
        if rst = '1' or control = "11" then     -- Si el reset es 0 y el control es 01, le suma 1 a la entrada
            salida <= (others => '0');
        elsif rising_edge(clk)then
            if control = "01" then
                salida <= entrada + "001";
            end if;
        end if;
    end process sync;

end Behavioral;
