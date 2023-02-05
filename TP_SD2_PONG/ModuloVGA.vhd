
-- Modulo del puerto VGA --
-- Su funcion es dibujar la imagen y guardar los colores
-- para cada pixel mientras nos comunicamos con el MIPS
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ModuloVGA is
    Port ( 
			  --hab_VGA : in STD_LOGIC; --habilita el chip cuando se entra en la direccion X10008...
			  clk : in  STD_LOGIC;
			  -----------------------------------------------------
           Vsync : out  STD_LOGIC;
           Hsync : out  STD_LOGIC;
           RGB_8bits : out  STD_LOGIC_VECTOR (7 downto 0);
			  memOut : out STD_LOGIC_VECTOR (31 downto 0);
			  -----------------------------------------------------
           Leer : in STD_LOGIC;
			  Escribir : in  STD_LOGIC; --'1' escribir '0' mostrar en pantalla
           DatosAEscribir : in  STD_LOGIC_VECTOR (31 downto 0); --son colores en hexadecimal para meter en la memoria
           DirecAAcceder : in STD_LOGIC_VECTOR (31 downto 0) --es la direccion en la que se tiene que pintar el color
			  );
end ModuloVGA;

architecture Behavioral of ModuloVGA is
------------------------------------------------------------------
--	component Codificador_colores
--	port (
--			color_hex	: in std_logic_vector(31 downto 0);
--			codigo_color: out std_logic_vector(2 downto 0)
--			);
--	end component;
--	----------------------------------------------------------
--	component Decodificador_colores
--	port (
--			clk : in STD_LOGIC;
--			leer : in STD_LOGIC;
--			e_de_Vmemoria: in  STD_LOGIC_VECTOR (2 downto 0);
--			s_8bits_vga	 : out  STD_LOGIC_VECTOR (7 downto 0);
--			s_32bits_mips : out STD_LOGIC_VECTOR (31 downto 0)
--			);
--	end component;
--	----------------------------------------------------------
--	--sirve exclusivamente para escribir con mips en la memoria
--	component Codificador_memoria_video
--	port (
--			dir_ent_hex : in  STD_LOGIC_VECTOR (31 downto 0);
--			sel_sal_int : out  integer range 0 to 1023
--			);
--	end component;
--	----------------------------------------------------------
--	component Mux_memoria_video
--	port (
--			dir_controlador : in integer range 0 to 1023;
--         dir_acceso : in integer range 0 to 1023;
--         sel_leerOescribir : in  STD_LOGIC; --'1' va a ser escribir o leer '0' para mostrar nomas la pantalla
--         dir_out : out integer range 0 to 1023
--			);
--	end component;
--	----------------------------------------------------------
--	component Memoria_video
--	port (
--			clk : in  STD_LOGIC;
--         escribir : in  STD_LOGIC;
--         selector : in  integer range 0 to 1023;
--         dataOut : out  STD_LOGIC_VECTOR (2 downto 0);
--         dataIn : in  STD_LOGIC_VECTOR (2 downto 0)
--			);
--	end component;
	----------------------------------------------------------
	component MemVid_compuesta
	port (
			dirAcceso : in  STD_LOGIC_VECTOR (31 downto 0);
			datain : in  STD_LOGIC_VECTOR (31 downto 0);
			dirMonitor : in  integer range 0 to 1023;
			escribir : in  STD_LOGIC;
			leer : in  STD_LOGIC;
			clk : in  STD_LOGIC;
			dataout_mips : out  STD_LOGIC_VECTOR (31 downto 0);
			dataout_monitor : out  STD_LOGIC_VECTOR (7 downto 0)
			);
	end component;
	----------------------------------------------------------
	component Sync_vga
	port (
			clk : in  STD_LOGIC;
         Hsync : out  STD_LOGIC;
         Vsync : out  STD_LOGIC;
         ContX : out  integer range 0 to 799;
         ContY : out  integer range 0 to 524
			);
	end component;
	----------------------------------------------------------
	component Controlador_salida
	port (
			clk : in  STD_LOGIC;
			ContX : in  integer range 0 to 799;
			ContY : in  integer range 0 to 524;
			iterar_en_memoria : out integer range 0 to 1023;
			datos_RGB_8bits  : in  STD_LOGIC_VECTOR (7 downto 0);
			salida_RGB_8bits : out  STD_LOGIC_VECTOR (7 downto 0)
			);
	end component;
----------------------------------------------------------------
--aca agregamos las seales(cables) que estaremos usando
signal codigo_color : std_logic_vector(2 downto 0);

signal e_de_Vmemoria : std_logic_vector(2 downto 0);
signal s_8bits_vga : std_logic_vector(7 downto 0);

signal escribir_mem : std_logic := '0';
signal sel_mem_escribir : integer range 0 to 1023;
signal sel_mem : integer range 0 to 1023;

signal ContX : integer range 0 to 799;
signal ContY : integer range 0 to 524;

signal dir_salida : integer range 0 to 1023;

signal sel_leerOescribir : std_logic := '0';
----------------------------------------------------------------
--aca agregamos las instanciaciones de los componentes con sus conecciones
begin
--	Inst_Codificador_colores : Codificador_colores
--	port map(
--				color_hex => DatosAEscribir,
--				codigo_color => codigo_color
--				);
--	----------------------------------------------------------
--	Inst_Decodificador_colores : Decodificador_colores
--	port map(
--				clk => clk,
--				leer => Leer,
--				e_de_Vmemoria => e_de_Vmemoria,
--				s_8bits_vga => s_8bits_vga,
--				s_32bits_mips => memOut
--				);
--	----------------------------------------------------------
--	--sirve exclusivamente para escribir con mips en la memoria
--	Inst_Codificador_memoria_video : Codificador_memoria_video 
--	port map(
--				dir_ent_hex => DirecAAcceder,
--				sel_sal_int => sel_mem_escribir
--				);
--	----------------------------------------------------------
--	--Logica de entremedio
--	sel_leerOescribir <= Leer or Escribir;
--	----------------------------------------------------------
--	Inst_Mux_memoria_video : Mux_memoria_video
--	port map(
--				dir_controlador => dir_salida,
--				dir_acceso => sel_mem_escribir,
--				sel_leerOescribir => sel_leerOescribir,
--				dir_out => sel_mem
--				);
--	----------------------------------------------------------
--	Inst_Memoria_video : Memoria_video
--	port map(
--				clk => clk,
--				escribir => Escribir, --'1' escribir '0' mostrar en pantalla
--				selector => sel_mem,
--				dataOut => e_de_Vmemoria,
--				dataIn => codigo_color
--				);
	----------------------------------------------------------
	Inst_MemVid_compuesta : MemVid_compuesta
	port map(
				clk => clk,
				escribir => Escribir,
				leer => Leer,
				dirAcceso => DirecAAcceder,
				datain => DatosAEscribir,
				dirMonitor => dir_salida, --dir_salida viene del controlador de salida y se va iterando en memoria de video
				dataout_mips => memout,
				dataout_monitor => s_8bits_vga
				);
	----------------------------------------------------------
	Inst_Sync_vga : Sync_vga
	port map(
				clk => clk,
				Hsync => Hsync,
				Vsync => Vsync,
				ContX => ContX,
				ContY => ContY
				);
	----------------------------------------------------------
	Inst_Controlador_salida : Controlador_salida
	port map(
				clk => clk,
				ContX => ContX,
				ContY => ContY,
				iterar_en_memoria => dir_salida, 
				datos_RGB_8bits => s_8bits_vga, --viene del decodificador de colores
				salida_RGB_8bits => RGB_8bits --va por los perifericos de salida
				);
end Behavioral;

