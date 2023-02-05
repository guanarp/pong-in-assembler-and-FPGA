--Josias Grau Figueredo

--Esta es la memoria de video que estare utilizando
--la misma es de 32x32 posiciones y guarda 3 bits en cada
--posicion (debido a que se usan 8 colores en el programa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memoria_video is
    Port ( clk : in  STD_LOGIC;
           escribir : in  STD_LOGIC; --'1' escribir '0' leer
           selector : in  integer range 0 to 1023; --apunta a la direccion de memoria
           dataOut : out  STD_LOGIC_VECTOR (2 downto 0);
           dataIn : in  STD_LOGIC_VECTOR (2 downto 0));
end Memoria_video;

architecture Behavioral of Memoria_video is
	type mem is array (0 to 1023) of std_logic_vector(2 downto 0);
	signal dir : mem := (others => "000");
begin
	process(clk) is
	begin
		if clk'event and clk='1' then
			if escribir = '1' then
				dir(selector) <= dataIn; --escritura de la memoria
			else
				dataOut <= dir(selector); --lectura de la memoria
			end if;		
		end if;
	end process;

end Behavioral;

