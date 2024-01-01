library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller is
    Port (
        rst: in std_logic;                              -- Botón reset
        clk: in std_logic;                              -- Reloj
        jugar: in std_logic;                            -- Botón
        inicio: in std_logic;                           -- Botón
        fallo: in std_logic;                            -- Señal de fallo
        puntuacion: in std_logic_vector(3 downto 0);    -- Puntuación
        contador2seg: in std_logic_vector(3 downto 0);  -- El número que está contando el contador2seg
        enables: out std_logic_vector(6 downto 0)       -- Los enables del programa (enable_contador_2seg, mux_leds, sumador, cambio_dificultad)
        ); 
end controller;

architecture Behavioral of controller is

type T_ESTADOS is (S0, S1, S2, S3, S4, SIntermedio);             -- Tipo estados
signal ESTADO, SIG_ESTADO: T_ESTADOS;

signal enablesAux: std_logic_vector(6 downto 0);    -- Enables

alias enable_contador_2seg: std_logic is enablesAux(0);                     --  Contador 2 seg
alias mux_leds: std_logic_vector (2 downto 0) is enablesAux(3 downto 1);    --  Mux_leds 
alias sumador: std_logic_vector(1 downto 0) is enablesAux(5 downto 4);      --  Enable sumador
alias cambio_dificultad: std_logic is enablesAux(6);                        --  Enable cambio de dificultad

begin
    enables <= enablesAux;
    
    SYNC: process (clk, rst)                --  Resetea si se pulsa el botón reset, en caso contrario establece estado sig_estado
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    ESTADO <= S0;
                else
                    ESTADO <= SIG_ESTADO;
                end if;
            end if;
    end process SYNC;
    
    
    COMB: process (ESTADO, inicio, jugar, contador2seg)     --  Secuencia de Diagrama de estados
        begin
            sumador <= "00";
            
            case ESTADO is
                when S0 =>                  
                    mux_leds <= "000";              -- Secuencia leds -> Apagados
                    sumador <= "11";                -- Control de sumador "11" -> El sumador lo trata como si fuese un rst
                    cambio_dificultad <= '1';       -- Permite el cambio de dificultad
                    enable_contador_2seg <= '0';    -- El control de contador 2 seg '0' -> El contador se apaga
                    
                    if inicio = '1' then    -- Si se pulsa el botón de inicio se empieza el juego y se cambia al estado S1, en caso contrario sigue en estado S0
                        SIG_ESTADO <= S1;
                    else 
                        SIG_ESTADO <= S0;
                    end if;
                    
                when S1 =>
                    mux_leds <= "001";              -- Secuencia leds -> jugando
                    cambio_dificultad <= '0';       -- No permite el cambio de dificultad
                    enable_contador_2seg <= '0';    -- El control de contador 2 seg '0' -> El contador se apaga
                    
                    if jugar = '1' then       -- Si se pulsa el botón de jugar pasa al siguiente estado S2, en caso contrario sigue en el mismo estado S1
                        SIG_ESTADO <= S2;
                    else
                        SIG_ESTADO <= S1;
                    end if;
                             
                when S2 =>
                    mux_leds <= "010";              -- Secuencia leds -> quietos
                    enable_contador_2seg <= '1';    -- El control de contador 2 seg '1' -> El contador se enciende
                    
                    if (contador2seg = "1001") then -- Se espera a que el contador 2 seg cuente a "1001" y después pasa al siguiente estado SIntermedio, en caso contrario sigue en el mismo estado S2
                        SIG_ESTADO <= SIntermedio;
                    else
                        SIG_ESTADO <= S2;
                    end if;
   
                when S3 =>
                    mux_leds <= "100";              -- Secuencia leds -> pierde
                    enable_contador_2seg <= '1';    -- El control de contador 2 seg '1' -> El contador se enciende
                    
                    if contador2seg = "1001" then   -- Se espera a que el contador 2 seg cuente a "1001" y después pasa al siguiente estado S0, en caso contrario sigue en el mismo estado S3
                        SIG_ESTADO <= S0;
                    else
                        SIG_ESTADO <= S3;
                    end if;
                    
                when S4 =>                          
                    mux_leds <= "011";              -- Secuencia leds -> gana                   
                    enable_contador_2seg <= '1';    -- El control de contador 2 seg '1' -> El contador se enciende
                     
                    if (contador2seg = "1001") then -- Se espera a que el contador 2 seg cuente a "1001" y después pasa al siguiente estado
                        if puntuacion = "1001" then -- Si la puntuación llega a 9, el siguiente estado es S0, si la puntuación es inferior a 9 pasa al estado S1
                            SIG_ESTADO <= S0;
                        else 
                            SIG_ESTADO <= S1;
                        end if;
                    else
                        SIG_ESTADO <= S4;
                    end if; 

                when SIntermedio =>
                        enable_contador_2seg <= '0';    -- El control de contador 2 seg '0' -> El contador se apaga
                        
                        if fallo = '1' then             -- Si el jugador no ha acertado, y ha fallado, pasa al estado S3(Perdido), en caso de que no haya fallado pasa al estado S4(SumaPunto) y enciende el sumador
                            SIG_ESTADO <= S3;
                        else
                            sumador <= "01";            -- Enciende el sumador
                            SIG_ESTADO <= S4;
                        end if;
            end case;
            
    end process COMB;

end Behavioral;