library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity stackTower is
        Port (
            rst: in  std_logic;
            clk: in  std_logic;
            jugar: in  std_logic;
            inicio: in  std_logic;
            sw_dificultad: in std_logic_vector (1 downto 0);
            dificultad: out std_logic_vector (1 downto 0);
            puntuacion: out std_logic_vector(3 downto 0);
            leds: out std_logic_vector (15 DOWNTO 0) 
        );
end stackTower;

architecture Behavioral of stackTower is

    component controller 
        Port (
            rst: in std_logic;                              -- Bot�n reset
            clk: in std_logic;                              -- Reloj
            jugar: in std_logic;                            -- Bot�n
            inicio: in std_logic;                           -- Bot�n
            fallo: in std_logic;                            -- Se�al de fallo
            puntuacion: in std_logic_vector(3 downto 0);    -- Puntuaci�n
            contador2seg: in std_logic_vector(3 downto 0);  -- El n�mero que est� contando el contador2seg
            enables: out std_logic_vector(6 downto 0)       -- Los enables del programa (enable_contador_2seg, mux_leds, sumador, cambio_dificultad)
        ); 
    end component;
    
    component ruta_datos 
        Port (
            rst: IN std_logic;
            clk: IN std_logic;
            enables: IN std_logic_vector (6 downto 0);
            sw_dificultad: in std_logic_vector(1 downto 0);
            dificultad: out std_logic_vector (1 downto 0);
            contador2seg: OUT std_logic_vector (3 downto 0);
            fallo: out std_logic;
            puntuacion: out std_logic_vector(3 downto 0);
            leds: OUT std_logic_vector (15 downto 0)
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
