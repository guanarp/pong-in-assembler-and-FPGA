--Josias Grau Figueredo

--Este decodificador va a mirar una posicion de memoria en la memoria de video y
--va a encargarse de convertir esa posicion de memoria a un color en formato 8 bits
--que puede ser utilizado por el conector vga
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decodificador_colores is
    Port ( 
			  clk : in STD_LOGIC;
			  leer : in STD_LOGIC;
			  e_de_Vmemoria : in  STD_LOGIC_VECTOR (2 downto 0);
           s_8bits_vga : out  STD_LOGIC_VECTOR (7 downto 0);
			  s_32bits_mips : out STD_LOGIC_VECTOR (31 downto 0)
			 );
end Decodificador_colores;

architecture Behavioral of Decodificador_colores is

begin
	s_8bits_vga <= 	"00000000" when e_de_Vmemoria = "000" and leer='0' else --negro
							"11111111" when e_de_Vmemoria = "001" and leer='0' else --blanco
							"10010010" when e_de_Vmemoria = "010" and leer='0' else --gris
							"00011111" when e_de_Vmemoria = "011" and leer='0' else --cyan
							"00000011" when e_de_Vmemoria = "100" and leer='0' else --azul
							"11100000" when e_de_Vmemoria = "101" and leer='0' else --rojo
							"00011100" when e_de_Vmemoria = "110" and leer='0' else --verde
							"10110000" when e_de_Vmemoria = "111" and leer='0' else --amarillo
							(others=>'0');
						
	s_32bits_mips <= 	X"00000000" when e_de_Vmemoria = "000" and leer='1' else --negro
							X"00FFFFFF" when e_de_Vmemoria = "001" and leer='1' else --blanco
							X"00C0C0C0" when e_de_Vmemoria = "010" and leer='1' else --gris
							X"0000FFFF" when e_de_Vmemoria = "011" and leer='1' else --cyan
							X"000000FF" when e_de_Vmemoria = "100" and leer='1' else --azul
							X"00FF0000" when e_de_Vmemoria = "101" and leer='1' else --rojo
							X"0000FF00" when e_de_Vmemoria = "110" and leer='1' else --verde
							X"00FFFF00" when e_de_Vmemoria = "111" and leer='1' else --amarillo
							(others=>'0');
end Behavioral;

