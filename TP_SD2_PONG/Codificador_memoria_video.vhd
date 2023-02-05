--Josias Grau Figueredo

--Este codificador se encarga de traducir la direccion de memoria de 32
--bits que usa el mips para su memoria de video al utilizar el simulador
--en enteros que podemos usar para acceder a la direccion de memoria
--correspondiente en el componente real de hardware
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Codificador_memoria_video is
    Port(
			dir_ent_hex : in  STD_LOGIC_VECTOR (31 downto 0);
         sel_sal_int : out  integer range 0 to 1023
			 );
end Codificador_memoria_video;

architecture Behavioral of Codificador_memoria_video is

begin
																	--entrada/4  --X10008000/D4
	sel_sal_int <= to_integer(unsigned(dir_ent_hex(31 downto 2))) - 67117056;

end Behavioral;

