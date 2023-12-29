library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        rst: in std_logic;
        enable_cambio_dificultad: in std_logic;
        clk_entrada: in std_logic;      -- reloj de entrada de la entity superior
        dificultad: in std_logic_vector (1 downto 0);
        clk_dificultad, clk_4Hz: out std_logic    -- reloj para la secuencia de juego y reloj para la secuencia de ganar, perder, pausa 
    );
end divisor;

architecture divisor_arch of divisor is
 signal cuenta, cuenta_dificultad: std_logic_vector(27 downto 0);
 signal clk_4Hz_aux, clk_dificultad_aux: std_logic;
  
begin
    clk_4Hz<=clk_4Hz_aux;
    clk_dificultad <= clk_dificultad_aux;

  contador: process(rst, clk_entrada, enable_cambio_dificultad)
    begin
        if (rst='1') then
            cuenta<= (others =>'0');
            cuenta_dificultad<= (others =>'0');
            clk_dificultad <= '0';
            clk_4Hz_aux <= '0';
        elsif(rising_edge(clk_entrada)) then
            IF (cuenta="0001011111010111100001000000") then 
                clk_4Hz_aux <= '1';
                cuenta<= (others =>'0');
            else
                cuenta <= cuenta+'1';
	            clk_4Hz_aux<='0';
            end if;
            
            if enable_cambio_dificultad = '1' then
                if dificultad = "00" then
                    if (cuenta_dificultad="0001000000000000000000000000") then 
                        clk_dificultad_aux <= '1';
                        cuenta_dificultad<= (others =>'0');
                    else
                        cuenta <= cuenta+'1';
	                    clk_dificultad_aux<='0';
                    end if;
                elsif dificultad = "01" then
                    if (cuenta_dificultad="0000100000000000000000000000") then 
                        clk_dificultad_aux <= '1';
                        cuenta_dificultad<= (others =>'0');
                    else
                        cuenta <= cuenta+'1';
	                    clk_dificultad_aux<='0';
                    end if;
                elsif dificultad = "10" then
                    if (cuenta_dificultad="0000010000000000000000000000") then 
                        clk_dificultad_aux <= '1';
                        cuenta_dificultad<= (others =>'0');
                    else
                        cuenta <= cuenta+'1';
	                    clk_dificultad_aux<='0';
                    end if;
                elsif dificultad = "11" then
                    if (cuenta_dificultad="0000001000000000000000000000") then 
                        clk_dificultad_aux <= '1';
                        cuenta_dificultad<= (others =>'0');
                    else
                        cuenta <= cuenta+'1';
	                    clk_dificultad_aux<='0';
                    end if;
                end if;
            end if;                    
        end if;
    end process contador;
end divisor_arch;

