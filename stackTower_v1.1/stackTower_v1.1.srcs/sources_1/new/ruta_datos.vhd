library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ruta_datos is
    Port ( 
        rst: IN std_logic;
        clk: IN std_logic;
        enables: IN std_logic_vector (5 downto 0);
        contador5seg: OUT std_logic_vector (3 downto 0);
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
        clk_entrada: in std_logic; -- reloj de entrada de la entity superior
        clk_salida: out std_logic -- reloj para la secuencia juego
        ); 
    end component;

    component generador_secuencias 
    Port (
        rst: IN std_logic; 
        clk_2Hz: IN std_logic;
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

    signal enablesAux: std_logic_vector (5 downto 0); -- Vector con los enables de los contadores y el multiplexor

    alias enable_contador_5seg: std_logic is enablesAux(0);                     --  Contador 5 seg
    alias mux_leds: std_logic_vector (2 downto 0) is enablesAux(3 downto 1);    --  Mux_leds
    alias sumador: std_logic_vector(1 downto 0) is enablesAux(5 downto 4);
    
    signal clk_2Hz: std_logic;
    signal suma: std_logic_vector(3 downto 0);

begin

    enablesAux <= enables;

    C_DIVISOR: divisor port map (rst, clk, clk_2Hz);
    
    C_GENERADOR_SECUENCIAS: generador_secuencias port map (rst, clk_2Hz, mux_leds, fallo, leds);

    C_CONT_2HZ: contadorMod10 port map (rst, clk, enable_contador_5seg, clk_2Hz, contador5seg);

    SUMA_PUNTUACION: sumadorPuntuacion port map(rst, clk, sumador, suma, suma);
    
    puntuacion <= suma;
    
end Behavioral;
