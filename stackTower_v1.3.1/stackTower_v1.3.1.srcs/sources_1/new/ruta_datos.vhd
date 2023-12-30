library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ruta_datos is
    Port ( 
        rst: IN std_logic;
        clk: IN std_logic;
        enables: IN std_logic_vector (6 downto 0);
        dificultad: in std_logic_vector(1 downto 0);
        contador2seg: OUT std_logic_vector (3 downto 0);
        fallo: out std_logic;
        puntuacion: out std_logic_vector(3 downto 0);
        leds: OUT std_logic_vector (15 downto 0)
    );
end ruta_datos;

architecture Behavioral of ruta_datos is

    component contadorMod10     
    Port (
        rst: IN std_logic;
        clk: IN std_logic;
        enable: IN std_logic;
        capacitacion: IN std_logic;
        salida: OUT std_logic_vector(3 downto 0)
        );
    end component;
    
    component divisor
    Port (        
        rst: in std_logic;
        clk_entrada: in std_logic;      -- reloj de entrada de la entity superior
        dificultad: in std_logic_vector (1 downto 0);
        clk_dificultad, clk_4Hz: out std_logic    -- reloj para la secuencia de juego y reloj para la secuencia de ganar, perder, pausa 
        ); 
    end component;

    component generador_secuencias 
    Port (
        rst: IN std_logic; 
        clk_4Hz: IN std_logic;
        clk_dificultad: in std_logic;
        enable: IN std_logic_vector(2 downto 0);
        fallo: out std_logic;
        leds: OUT std_logic_vector (15 downto 0)
        ); 
    end component; 
    
    component sumadorPuntuacion
    Port ( 
        rst, clk: in std_logic;
        control: in std_logic_vector(1 downto 0);
        entrada: in std_logic_vector(3 downto 0);
        salida: out std_logic_vector(3 downto 0)
    );
    end component;

    signal enablesAux: std_logic_vector (6 downto 0); -- Vector con los enables de los contadores y el multiplexor

    alias enable_contador_2seg: std_logic is enablesAux(0);                     --  Contador 5 seg
    alias mux_leds: std_logic_vector (2 downto 0) is enablesAux(3 downto 1);    --  Mux_leds
    alias sumador: std_logic_vector(1 downto 0) is enablesAux(5 downto 4);
    alias cambio_dificultad: std_logic is enablesAux(6);
    
    signal clk_4Hz, clk_dificultad: std_logic;
    signal suma: std_logic_vector(3 downto 0);
    signal dificultad_aux: std_logic_vector(1 downto 0);

begin

    enablesAux <= enables;
    puntuacion <= suma;

    C_DIVISOR: divisor port map (rst, clk, dificultad_aux, clk_dificultad, clk_4Hz);
    
    C_GENERADOR_SECUENCIAS: generador_secuencias port map (rst, clk_4Hz, clk_dificultad, mux_leds, fallo, leds);

    C_CONT_2HZ: contadorMod10 port map (rst, clk, enable_contador_2seg, clk_4Hz, contador2seg);

    SUMA_PUNTUACION: sumadorPuntuacion port map(rst, clk, sumador, suma, suma);
    
    wol: process(enablesAux(6))
        begin
            if enablesAux(6) = '1' then
                dificultad_aux <= dificultad;
            end if;
    end process wol;
    
    
end Behavioral;
