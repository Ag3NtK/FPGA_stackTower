library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity displays is
    Port ( 
        rst : in STD_LOGIC;                                     -- Reset
        clk : in STD_LOGIC;                                     -- Reloj
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);           -- Puntuación
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);           -- Dificultad
        display : out  STD_LOGIC_VECTOR (6 downto 0);           -- Salida para los displays_7seg
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)     -- Enables para los displays_7seg
     );
end displays;

architecture Behavioral of displays is

    component conv_7seg
        Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);           -- Dígito que se mostrará en el display_7seg
               display : out  STD_LOGIC_VECTOR (6 downto 0));   -- La salida para el display 7_seg
    end component;

    signal display_0 : STD_LOGIC_VECTOR (6 downto 0);           -- La salida para el display 7_seg(0)
    signal display_1 : STD_LOGIC_VECTOR (6 downto 0);           -- La salida para el display 7_seg(1)
    signal contador_refresco : STD_LOGIC_VECTOR (19 downto 0);  -- Cuenta para actualizar los enables de los displays
    

begin

    conv_7seg_digito_0 : conv_7seg port map(x => digito_0, display => display_0);   -- Display_7seg(0)
    conv_7seg_digito_1 : conv_7seg port map(x => digito_1, display => display_1);   -- Display_7seg(1)

    display <=  display_0 when (contador_refresco(19) = '0') else                   -- Muestra el valor del display(0) cuando la cuenta acaba en 0 y muestra el valor del display(1) cuando la cuenta acaba en 1
                display_1 when (contador_refresco(19) = '1');

    process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                contador_refresco <= (others=>'0');             -- Va aumentando la cuenta según va pasando el tiempo
            else
                contador_refresco <= contador_refresco + 1;
            end if;
        end if;
    end process;

    display_enable <=   "1110" when (contador_refresco(19) = '0') else      -- Activa y desactiva los displays_7seg, según que toque mostrar en los displays
                        "0111";

end Behavioral;