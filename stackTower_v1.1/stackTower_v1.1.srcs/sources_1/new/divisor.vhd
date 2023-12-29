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
    IF (rst='1') THEN
      cuenta<= (OTHERS=>'0');
      clk_aux<='0';
    ELSIF(rising_edge(clk_entrada)) THEN
      IF (cuenta="0001011111010111100001000000") THEN 
      	clk_aux <= '1';
        cuenta<= (OTHERS=>'0');
      ELSE
        cuenta <= cuenta+'1';
	   clk_aux<='0';
      END IF;
    END IF;
  END PROCESS contador;

end divisor_arch;

