library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generador_secuencias is
    Port (
        rst: IN std_logic;                              -- Reset
        clk_4Hz: IN std_logic;                          -- Clkpara las secuencias de ganar, perder y quietos
        clk_dificultad: in std_logic;                   -- Clk para la secuencia de juego
        enable: IN std_logic_vector(2 downto 0);        -- Enables de las secuencias de juego
        fallo: out std_logic;                           -- Salida del fallo del jugador
        leds: OUT std_logic_vector (15 downto 0)        -- Salida de los leds que se encenderán
        ); 
end generador_secuencias;

architecture Behavioral of generador_secuencias is
    component registro_desplazamiento 
        Port (
            rst: IN std_logic;                          -- Reset
            clk_Dificultad: in std_logic;               -- Clk de la dificultad para la secuencia juego
            direccion: in std_logic;                    -- Dirección hacia la que está yendo la plataforma(leds encendidos)
            leds: OUT std_logic_vector (15 downto 0)    -- La salida de los leds    
            ); 
    end component;
    
    component biestable 
    Port (
        rst: IN std_logic;                              -- Reset
        clk_4Hz: IN std_logic;                          -- Clk para las secuencias de ganar, perder, quietos
        entrada: IN std_logic;                          -- Entrada de leds_pierde_gana(15);
        enable: IN std_logic_vector (2 downto 0);       -- Enable del biestable para saber que secuencia realizar
        leds: OUT std_logic_vector (15 downto 0)        -- La salida de los leds
        );
    end component;
    
    signal leds_jugando: std_logic_vector (15 downto 0) := "0000001111000000";  -- Inicializa los leds a 0000 0011 1100 0000
    signal leds_pierde_gana: std_logic_vector (15 downto 0);                    -- Los leds para las secuencias pierde_gana
    signal leds_pausado: std_logic_vector (15 downto 0);                        -- Los leds para leds pausado
    signal entrada_pierde_gana: std_logic;                                      -- La entrada leds_pierde_gana(15);
    signal direccion: std_logic;                                                -- Dirección en la que va la plataforma(leds encendidos)
    signal izq, derecha: std_logic;                                             -- Direcciones
    
begin
    izq <= leds_jugando(15);
    derecha <= leds_jugando(0);
    SEC_JUGANDO: registro_desplazamiento Port map (rst, clk_dificultad, direccion, leds_jugando);
    
    entrada_pierde_gana <= not leds_pierde_gana(15);
    SEC_PIERDE_GANA: biestable Port map (rst, clk_4Hz, entrada_pierde_gana, enable,leds_pierde_gana);
    
    direcc: process(derecha, izq)       -- Establece la dirección en caso de producirse un cambio de dirección
        begin
        
            if(izq = '1')then
                direccion <= '1';
            elsif(derecha = '1')then
                direccion <= '0';
            else
                direccion <= direccion;
            end if;
            
    end process direcc;
     
    wol: process (enable)                   -- Realiza las secuencias de apagar, jugando, pausado, pierde, gana y también actualiza la señal de fallo(1 si el jugador hace un fallo)
        
            begin
                if enable = "000" then          --Apagado
                    leds <= (others => '0');
                elsif (enable = "001" ) then     --Jugando
                   leds <= leds_jugando;
                   leds_pausado <= leds_jugando;
                elsif (enable = "010") then      --  Estado pausado
                    leds <= leds_pausado;
                    if(leds_pausado(8 downto 7) = "00") then
                        fallo <= '1';
                    else
                        fallo <= '0';
                    end if;
                else              --  Pierde/gana
                    leds <= leds_pierde_gana;
             end if;
        end process wol;

end Behavioral;
