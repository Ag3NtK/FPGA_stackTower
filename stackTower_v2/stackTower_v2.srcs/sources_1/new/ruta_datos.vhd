library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ruta_datos is
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
end ruta_datos;

architecture Behavioral of ruta_datos is

    component contadorMod10     
    Port (
        rst: IN std_logic;                          -- Reset
        clk: IN std_logic;                          -- Reloj
        enable: IN std_logic;                       -- Enable del contadorMod10
        capacitacion: IN std_logic;                 -- Clk_4Hz
        salida: OUT std_logic_vector(3 downto 0)    -- Salida de la cuenta
        );
    end component;
    
    component divisor
    Port (        
        rst: in std_logic;                              -- Reset
        clk_entrada: in std_logic;                      -- Reloj
        dificultad: in std_logic_vector (1 downto 0);   -- La dificultad
        clk_dificultad, clk_4Hz: out std_logic          -- Salida del reloj para la secuencia de juego y reloj para la secuencia de ganar, perder, pausa 
        ); 
    end component;

    component generador_secuencias 
    Port (
        rst: IN std_logic;                              -- Reset
        clk_4Hz: IN std_logic;                          -- Clkpara las secuencias de ganar, perder y quietos
        clk_dificultad: in std_logic;                   -- Clk para la secuencia de juego
        enable: IN std_logic_vector(2 downto 0);        -- Enables de las secuencias de juego
        fallo: out std_logic;                           -- Salida del fallo del jugador
        leds: OUT std_logic_vector (15 downto 0)        -- Salida de los leds que se encenderán
        ); 
    end component; 
    
    component sumadorPuntuacion
    Port ( 
        rst, clk: in std_logic;                         -- Reset
        control: in std_logic_vector(1 downto 0);       -- Enable del sumador
        entrada: in std_logic_vector(3 downto 0);       -- Entrada de la suma del sumador
        salida: out std_logic_vector(3 downto 0)        -- Salida de la suma realizada por el sumador
    );
    end component;
    
    component selector_dif is
    Port (  
        rst, clk, enable: in std_logic;                 --Reset, reloj y señal control
        selec: in std_logic_vector(1 downto 0);         --Selector de dificultad
        dificultad: out std_logic_vector(1 downto 0)    --Dificultad final
    );
    end component;

    signal enablesAux: std_logic_vector (6 downto 0); -- Vector con los enables de los contadores y el multiplexor

    alias enable_contador_2seg: std_logic is enablesAux(0);                     --  Contador 2 seg
    alias mux_leds: std_logic_vector (2 downto 0) is enablesAux(3 downto 1);    --  Mux_leds
    alias sumador: std_logic_vector(1 downto 0) is enablesAux(5 downto 4);      --  Enables del sumador
    alias cambio_dificultad: std_logic is enablesAux(6);                        --  Enable del cambio de dificultad
    
    signal clk_4Hz, clk_dificultad: std_logic;              --  Clk de la secuencia de ganar, perder y quietos, y clk de la dificultad(secuencia juego)
    signal suma: std_logic_vector(3 downto 0);              --  Suma de la puntuación
    signal dificultad_aux: std_logic_vector(1 downto 0);    --  La dificultad

begin

    enablesAux <= enables;
    puntuacion <= suma;
    dificultad <= dificultad_aux;

    C_DIVISOR: divisor port map (rst, clk, dificultad_aux, clk_dificultad, clk_4Hz);
    
    C_GENERADOR_SECUENCIAS: generador_secuencias port map (rst, clk_4Hz, clk_dificultad, mux_leds, fallo, leds);

    C_CONT_2seg: contadorMod10 port map (rst, clk, enable_contador_2seg, clk_4Hz, contador2seg);

    SUMA_PUNTUACION: sumadorPuntuacion port map(rst, clk, sumador, suma, suma);
    
    SELECTOR_DIFICULTAD: selector_dif port map(rst, clk, cambio_dificultad, sw_dificultad, dificultad_aux);
    
end Behavioral;
