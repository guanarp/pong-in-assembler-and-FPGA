
-- Esta es la descripcion de una memoria con todos los componentes que
-- nos permiten comunicarnos con la misma e imprimir en el monitor los
-- pixeles requeridos
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemVid_compuesta is
    Port ( 
				dirAcceso : in  STD_LOGIC_VECTOR (31 downto 0);
				datain : in  STD_LOGIC_VECTOR (31 downto 0);
				dirMonitor : in  integer range 0 to 1023;
				escribir : in  STD_LOGIC;
				leer : in  STD_LOGIC;
				clk : in  STD_LOGIC;
				dataout_mips : out  STD_LOGIC_VECTOR (31 downto 0);
				dataout_monitor : out  STD_LOGIC_VECTOR (7 downto 0)
			 );
end MemVid_compuesta;

architecture Behavioral of MemVid_compuesta is
	signal codigo_color : std_logic_vector (2 downto 0);
	signal s_8bits : std_logic_vector (7 downto 0); -- solo es para mantener ordenado todo
	signal s_32bits : std_logic_vector (31 downto 0); -- solo es para mantener ordenado todo
	signal sel_mem : integer range 0 to 1023;
	
	signal dirAcc_int : integer range 0 to 1023; -- es la direccion de acceso mapeada a un entero entre 0 y 1023
	
	type mem is array (0 to 1023) of std_logic_vector(2 downto 0);
	signal dir : mem := (others => "000");
	
	signal dato_mem : std_logic_vector (2 downto 0);

begin
	--SALIDA
	dataout_monitor <= s_8bits;
	dataout_mips <= s_32bits;	
	-------------------------------------------------------------------------------------------------
	-- Este es un codificador que nos permite convertir la direccion de acceso en un entero entre 0 y 1023
									--dir/D4										- X10008000/D4
	dirAcc_int <= to_integer(unsigned(dirAcceso(31 downto 2))) - 67117056;
	-------------------------------------------------------------------------------------------------
	-- Este es un multiplexor de acceso que nos permite apuntar a una de las direcciones en la memoria
	sel_mem <= 	dirAcc_int when ((leer or escribir)='1') else
					dirMonitor;
	-------------------------------------------------------------------------------------------------
	-- Este es el proceso de lectura/escritura de la memoria
	process(clk) is
	begin
		if clk'event and clk='1' then
			if escribir = '1' then
				dir(sel_mem) <= codigo_color; --escritura de la memoria
			else
				dato_mem <= dir(sel_mem); --lectura de la memoria
			end if;		
		end if;
	end process;
	-------------------------------------------------------------------------------------------------
	-- Este es un codificador para los colores que usamos, que nos permite guardar solo 3 bits
	codigo_color <=	"000" when datain = X"00000000" else --negro
							"001" when datain = X"00FFFFFF" else --blanco
							"010" when datain = X"00C0C0C0" else --gris
							"011" when datain = X"0000FFFF" else --cyan
							"100" when datain = X"000000FF" else --azul
							"101" when datain = X"00FF0000" else --rojo
							"110" when datain = X"0000FF00" else --verde
							"111" when datain = X"00FFFF00" else --amarillo
							"000";
	-------------------------------------------------------------------------------------------------
	-- Este es el correspondiente decodificador para mandar los colores al periferico que usa el vga
	s_8bits		 <= 	"00000000" when dato_mem = "000" and leer='0' else --negro
							"11111111" when dato_mem = "001" and leer='0' else --blanco
							"10010010" when dato_mem = "010" and leer='0' else --gris
							"00011111" when dato_mem = "011" and leer='0' else --cyan
							"00000011" when dato_mem = "100" and leer='0' else --azul
							"11100000" when dato_mem = "101" and leer='0' else --rojo
							"00011100" when dato_mem = "110" and leer='0' else --verde
							"10110000" when dato_mem = "111" and leer='0' else --amarillo
							(others=>'0');
	-------------------------------------------------------------------------------------------------
	-- Este es un correspondiente decodificador para mandar lo que se lee de la memoria al mips
	s_32bits		<= 	X"00000000" when dato_mem = "000" and leer='1' else --negro
							X"00FFFFFF" when dato_mem = "001" and leer='1' else --blanco
							X"00C0C0C0" when dato_mem = "010" and leer='1' else --gris
							X"0000FFFF" when dato_mem = "011" and leer='1' else --cyan
							X"000000FF" when dato_mem = "100" and leer='1' else --azul
							X"00FF0000" when dato_mem = "101" and leer='1' else --rojo
							X"0000FF00" when dato_mem = "110" and leer='1' else --verde
							X"00FFFF00" when dato_mem = "111" and leer='1' else --amarillo
							(others=>'0');
	-------------------------------------------------------------------------------------------------
end Behavioral;

