library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity stackTower is
        Port (
            rst: in std_logic;                              -- Botón reset
            clk: in std_logic;                              -- Reloj
            jugar: in std_logic;                            -- Botón
            inicio: in std_logic;                           -- Botón
            sw_dificultad: in std_logic_vector (1 downto 0);-- Switches con la dificutlad
            dificultad: out std_logic_vector (1 downto 0);  -- La dificultad solo actualizada en S0
            puntuacion: out std_logic_vector(3 downto 0);   -- La puntuación
            leds: out std_logic_vector (15 DOWNTO 0)        -- Los leds encima de los switches
        );
end stackTower;

architecture Behavioral of stackTower is

    component controller 
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
    end component;
    
    component ruta_datos 
        Port ( 
            rst: IN std_logic;                                  -- Reset
            clk: IN std_logic;                                  -- Reloj
            enables: IN std_logic_vector (6 downto 0);          -- Los enables del programa (enable_contador_2seg, mux_leds, sumador, cambio_dificultad)
            sw_dificultad: in std_logic_vector(1 downto 0);     -- Entrada de la dificultad de los switches de la placa
            dificultad: out std_logic_vector (1 downto 0);      -- Salida de la dificulta que solo se actualiza en el estado S0
            contador2seg: OUT std_logic_vector (3 downto 0);    -- Salida del contador_2seg
            fallo: out std_logic;                               -- Salida de si el jugador ha fallado
            puntuacion: out std_logic_vector(3 downto 0);       -- Salida de la puntuación
            leds: OUT std_logic_vector (15 downto 0)            -- Salida de los 16 leds encima de los switches en la placa
        ); 
    end component;

    signal enables: std_logic_vector(6 downto 0);
    signal contador5seg: std_logic_vector(3 downto 0) := "0000";
    signal puntuacion_aux: std_logic_vector(3 downto 0);
    signal fallo: std_logic := '0';
    signal dificultad_aux: std_logic_vector(1 downto 0);

begin
    
    C_RUTA_DATOS: ruta_datos port map(rst, clk, enables, sw_dificultad, dificultad_aux, contador5seg, fallo, puntuacion_aux, leds);
    C_CONTROLLER: controller port map(rst, clk, jugar, inicio, fallo, puntuacion_aux, contador5seg, enables);
    
    dificultad <= dificultad_aux;
    puntuacion <= puntuacion_aux;
    
end Behavioral;
