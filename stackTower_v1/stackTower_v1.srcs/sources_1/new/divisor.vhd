----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creación de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        rst: in std_logic;
        clk_entrada: in std_logic; -- reloj de entrada de la entity superior
        enable: in std_logic;
        clk_salida: out std_logic -- reloj para la secuencia juego
    );
end divisor;

architecture divisor_arch of divisor is
 SIGNAL cuenta: std_logic_vector(27 downto 0);
 SIGNAL clk_aux: std_logic;
  
  begin

 
clk_salida<=clk_aux;
  contador:
  PROCESS(rst, clk_entrada)
  BEGIN
    if rst='1' then
      cuenta<= (others=>'0');
      clk_aux <= '0';
    elsif rising_edge(clk_entrada) then
        if enable = '0' then
            if cuenta="0001011111010111100001000000" then 
                clk_aux <= '1';
                cuenta<= (others=>'0');
            else
                cuenta <= cuenta+'1';
	           clk_aux<='0';
            end if;
        elsif enable = '1' then
            if cuenta="10111110101111000010000000" then 
                clk_aux <= '1';
                cuenta<= (others=>'0');
            else
                cuenta <= cuenta+'1';
	           clk_aux<='0';
            end if;
        end if;
    end if;
  end process contador;

end divisor_arch;

