library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller is
    Port (
        rst: in std_logic;
        clk: in std_logic;
        jugar: in std_logic;    -- Boton
        inicio: in std_logic;   -- Boton
        fallo: in std_logic;
        puntuacion: in std_logic_vector(3 downto 0);
        contador2seg: in std_logic_vector(3 downto 0);
        enables: out std_logic_vector(6 downto 0)
    ); 
end controller;

architecture Behavioral of controller is

type T_ESTADOS is (S0, S1, S2, S3, S4, SIntermedio);             -- Tipo estados
signal ESTADO, SIG_ESTADO: T_ESTADOS;

signal enablesAux: std_logic_vector(6 downto 0);    -- Enables

alias enable_contador_2seg: std_logic is enablesAux(0);                     --  Contador 2 seg
alias mux_leds: std_logic_vector (2 downto 0) is enablesAux(3 downto 1);    --  Mux_leds                         --  Enable Divisor
alias sumador: std_logic_vector(1 downto 0) is enablesAux(5 downto 4);
alias cambio_dificultad: std_logic is enablesAux(6);

begin
    enables <= enablesAux;
    
    SYNC: process (clk, rst)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    ESTADO <= S0;
                else
                    ESTADO <= SIG_ESTADO;
                end if;
            end if;
    end process SYNC;
    
    
    COMB: process (ESTADO, inicio, jugar, contador2seg)
        begin
            sumador <= "00";
            
            case ESTADO is
                when S0 =>                  -- Secuencia jugando
                    mux_leds <= "000";
                    sumador <= "11";
                    cambio_dificultad <= '1';
                    enable_contador_2seg <= '0';
                    
                    if inicio = '1' then    -- Determina el siguiente estado
                        SIG_ESTADO <= S1;
                    else 
                        SIG_ESTADO <= S0;
                    end if;
                    
                when S1 =>
                    mux_leds <= "001";
                    cambio_dificultad <= '0';
                    enable_contador_2seg <= '0';
                    
                    if jugar = '1' then       -- Determina el siguiente estado
                        SIG_ESTADO <= S2;
                    else
                        SIG_ESTADO <= S1;
                    end if;
                             
                when S2 =>
                    mux_leds <= "010";
                    enable_contador_2seg <= '1';
                    
                    if (contador2seg = "1001") then -- Determina el siguiente estado
                        SIG_ESTADO <= SIntermedio;
                    else
                        SIG_ESTADO <= S2;
                    end if;
   
                when S3 =>
                    mux_leds <= "100";
                    enable_contador_2seg <= '1';
                    
                    if contador2seg = "1001" then -- Determina el siguiente estado
                        SIG_ESTADO <= S0;
                    else
                        SIG_ESTADO <= S3;
                    end if;
                    
                when S4 =>                          
                    mux_leds <= "011";                       
                    enable_contador_2seg <= '1';
                     
                    if (contador2seg = "1001") then
                        
                        if puntuacion = "1001" then
                            SIG_ESTADO <= S0;
                        else 
                            SIG_ESTADO <= S1;
                        end if;
                    else
                        SIG_ESTADO <= S4;
                    end if; 

                when SIntermedio =>
                        enable_contador_2seg <= '0';
                        
                        if fallo = '1' then
                            SIG_ESTADO <= S3;
                        else
                            sumador <= "01";
                            SIG_ESTADO <= S4;
                        end if;
            end case;
            
    end process COMB;

end Behavioral;