LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

entity sintesis_stackTower is
    Port (         
            rst			    : in  std_logic;
            clk			    : in  std_logic;
            boton_jugar     : in  std_logic;
            boton_inicio	: in  std_logic;
            sw_dificultad   : in  std_logic_vector(1 downto 0);
            display		    : out std_logic_vector (6 DOWNTO 0);
            leds		    : out std_logic_vector (15 DOWNTO 0);
            s_display	    : out std_logic_vector (3 DOWNTO 0)
    );
end sintesis_stackTower;

architecture Behavioral of sintesis_stackTower is

    component stackTower
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
        end component ;

    component debouncer
        Port (
            rst: in std_logic;
            clk: in std_logic;
            x: in std_logic;
            xDeb: out std_logic;
            xDebFallingEdge: out std_logic;
            xDebRisingEdge: out std_logic
        );
    end component;
    
    component displays is
         Port ( 
        rst : in STD_LOGIC;                                     -- Reset
        clk : in STD_LOGIC;                                     -- Reloj
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);           -- Puntuación
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);           -- Dificultad
        display : out  STD_LOGIC_VECTOR (6 downto 0);           -- Salida para los displays_7seg
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)     -- Enables para los displays_7seg
     );
end component;
    
    
    signal s_displays : std_logic_vector (3 DOWNTO 0);          -- Enables de los displays
    signal jugar, inicio, fallo: std_logic;                     -- Botón jugar, botón inicio y la señal fallo
    signal puntuacion: std_logic_vector (3 DOWNTO 0);           -- Puntuación
    signal reset_n:  std_logic;                                 
    signal dificultad: std_logic_vector (1 downto 0);           -- La dificultad en los switches
    signal dificultad_display: std_logic_vector(3 downto 0);    -- Dificutlad actualizada en S0
    
begin
    
    dificultad_display (3 downto 2) <= (others => '0');
    dificultad_display (1 downto 0) <= dificultad;
    reset_n <= not rst;
    
    debouncerInsts_displayce1: debouncer Port Map (reset_n, clk, boton_jugar,open, open, jugar);
    debouncerInsts_displayce2: debouncer Port Map (reset_n, clk, boton_inicio, open, open, inicio);
    stackTowerInsts_displayce : stackTower Port Map (rst, clk, jugar, inicio, sw_dificultad, dificultad, puntuacion, leds);

    displays_inst:  displays PORT MAP (rst, clk, puntuacion, dificultad_display, display, s_display);

end Behavioral;
