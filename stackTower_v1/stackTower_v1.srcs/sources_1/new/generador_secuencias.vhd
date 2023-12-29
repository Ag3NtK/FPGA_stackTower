library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generador_secuencias is
    Port (
        rst: IN std_logic; 
        clk_2Hz: IN std_logic;
        enable: IN std_logic_vector(2 downto 0);
        fallo: out std_logic;
        leds: OUT std_logic_vector (15 downto 0)
        ); 
end generador_secuencias;

architecture Behavioral of generador_secuencias is
    component registro_desplazamiento 
        Port (
            rst: IN std_logic;
            clk_2Hz: IN std_logic;
            direccion: in std_logic;
            leds: OUT std_logic_vector (15 downto 0)
            ); 
    end component;
    
    component biestable 
    Port (
        rst: IN std_logic;
        clk_2Hz: IN std_logic;
        entrada: IN std_logic;
        enable: IN std_logic_vector (2 downto 0);
        leds: OUT std_logic_vector (15 downto 0)
        );
    end component;
    
    signal leds_jugando: std_logic_vector (15 downto 0) := "0000001111000000";
    signal leds_pierde_gana: std_logic_vector (15 downto 0);
    signal leds_pausado: std_logic_vector (15 downto 0);
    signal entrada_pierde_gana: std_logic;
    signal direccion: std_logic;
    signal izq, derecha: std_logic;
    
begin
    izq <= leds_jugando(15);
    derecha <= leds_jugando(0);
    SEC_JUGANDO: registro_desplazamiento Port map (rst, clk_2Hz, direccion, leds_jugando);
    
    entrada_pierde_gana <= not leds_pierde_gana(15);
    SEC_PIERDE_GANA: biestable Port map (rst, clk_2Hz, entrada_pierde_gana, enable,leds_pierde_gana);
    
    direcc: process(derecha, izq)
        begin
        
            if(izq = '1')then
                direccion <= '1';
            elsif(derecha = '1')then
                direccion <= '0';
            else
                direccion <= direccion;
            end if;
            
    end process direcc;
     
    wol: process (enable)
        
            begin
                if enable = "000" then          --Apagado
                    leds <= (others => '0');
                elsif (enable = "001" ) then     --Jugando
                   leds <= leds_jugando;
                   leds_pausado <= leds_jugando;
                elsif (enable = "010") then      --  Estado pausado
                    leds <= leds_pausado;
                    if(leds_pausado(9 downto 6) = "0000") then
                        fallo <= '1';
                    else
                        fallo <= '0';
                    end if;
                else              --  Pierde/gana
                    leds <= leds_pierde_gana;
             end if;
        end process wol;

end Behavioral;
