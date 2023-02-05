--Josias Grau Figueredo

--Este codificador agarra el word que representa alguno de los 8 colores
--usados en el juego y lo convierte a su respectivo codigo en binario de 3 bits

--Como dato, mi memoria de video tendra 32x32 posiciones (correspondientes a los pixeles)
--sin embargo solo se guardan 3 bits en cada posicion ya que no es necesario mas que eso
--gracias a que solo se usan 8 colores, luego un decodificador nos ayuda a convertir
--estos valores en la memoria a colores de 8 bits para pasar al vga
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Codificador_colores is
    Port ( color_hex : in  STD_LOGIC_VECTOR (31 downto 0);		--la entrada va a venir del mips
           codigo_color : out  STD_LOGIC_VECTOR (2 downto 0));	--la salida tiene que guardarse en la memoria de video
end Codificador_colores;

architecture Behavioral of Codificador_colores is

begin
	codigo_color <=	"000" when color_hex = X"00000000" else --negro
							"001" when color_hex = X"00FFFFFF" else --blanco
							"010" when color_hex = X"00C0C0C0" else --gris
							"011" when color_hex = X"0000FFFF" else --cyan
							"100" when color_hex = X"000000FF" else --azul
							"101" when color_hex = X"00FF0000" else --rojo
							"110" when color_hex = X"0000FF00" else --verde
							"111" when color_hex = X"00FFFF00" else --amarillo
							"000";
end Behavioral;

