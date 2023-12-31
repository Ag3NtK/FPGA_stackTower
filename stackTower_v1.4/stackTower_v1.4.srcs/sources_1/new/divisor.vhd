library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        rst: in std_logic;
        clk_entrada: in std_logic;      -- reloj de entrada de la entity superior
        dificultad: in std_logic_vector (1 downto 0);
        clk_dificultad, clk_4Hz: out std_logic    -- reloj para la secuencia de juego y reloj para la secuencia de ganar, perder, pausa 
    );
end divisor;

architecture divisor_arch of divisor is
 signal cuenta, cuenta_dificultad, cuenta_final: std_logic_vector(27 downto 0);
 signal clk_4Hz_aux, clk_dificultad_aux: std_logic;
  
begin
    clk_4Hz<=clk_4Hz_aux;
    clk_dificultad <= clk_dificultad_aux;

  contador: process(rst, clk_entrada)
    begin
        if (rst='1') then
            cuenta<= (others =>'0');
            cuenta_dificultad<= (others =>'0');
            clk_dificultad_aux <= '0';
            clk_4Hz_aux <= '0';
        elsif(rising_edge(clk_entrada)) then
            if (cuenta="0001011111010111100001000000") then 
                clk_4Hz_aux <= '1';
                cuenta<= (others =>'0');
            else
                cuenta <= cuenta+'1';
	            clk_4Hz_aux<='0';
            end if;
            
            if dificultad = "00" then                               -- Según la dificultad cambia la cuenta_final y así va más rápido o más lento
                cuenta_final <= "0000101111101011110000100000";
            elsif dificultad = "01" then
                cuenta_final <= "0000010111110101111000010000";
            elsif dificultad = "10" then
                cuenta_final <= "0000001011111010111100001000";
            else 
                cuenta_final <= "0000000101111101011110000100";
            end if;    

            if (cuenta_dificultad = cuenta_final) then 
                clk_dificultad_aux <= '1';
                cuenta_dificultad<= (others =>'0');
            else
                cuenta_dificultad <= cuenta_dificultad+'1';
                clk_dificultad_aux<='0';
            end if;
                       
        end if;
    end process contador;
    
end divisor_arch;

