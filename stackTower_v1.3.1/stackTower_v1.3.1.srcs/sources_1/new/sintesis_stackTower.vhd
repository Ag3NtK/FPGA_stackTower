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
            rst: in  std_logic;
            clk: in  std_logic;
            jugar: in  std_logic;
            inicio: in  std_logic;
            dificultad: in std_logic_vector (1 downto 0);
            puntuacion: out std_logic_vector(3 downto 0);
            leds: out std_logic_vector (15 DOWNTO 0)   
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
    
     component conv_7seg
        Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
               display : out  STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    signal s_displays : std_logic_vector (3 DOWNTO 0);
    signal jugar, inicio, fallo: std_logic;
    signal puntuacion: std_logic_vector (3 DOWNTO 0);
    signal reset_n:  std_logic;
    
begin

    reset_n <= not rst;
    debouncerInsts_displayce1: debouncer Port Map (reset_n, clk, boton_jugar,open, open, jugar);
    debouncerInsts_displayce2: debouncer Port Map (reset_n, clk, boton_inicio, open, open, inicio);
    stackTowerInsts_displayce : stackTower Port Map (rst, clk, jugar, inicio, sw_dificultad, puntuacion, leds);

    display_insts: conv_7seg Port Map (puntuacion, display);
    
    s_display <= "1110";
    
end Behavioral;
