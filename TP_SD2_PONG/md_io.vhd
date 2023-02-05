library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.general.all;


entity md_io is
    Port ( dir       : in  STD_LOGIC_VECTOR (31 downto 0);
           datain    : in  STD_LOGIC_VECTOR (31 downto 0);
           memwrite  : in  STD_LOGIC;
           memread   : in  STD_LOGIC;
			  tipoAcc   : in STD_LOGIC_VECTOR (2 downto 0); --tipo de operación a realizar, cargar bytes, half word y word
           clk       : in  STD_LOGIC;
			  clk100mhz : in STD_LOGIC;
			  reset     : in STD_LOGIC;
			  -- botones 
			  p : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  a : in STD_LOGIC;
			  s : in STD_LOGIC;
			  d : in STD_LOGIC;
           dataout   : out  STD_LOGIC_VECTOR (31 downto 0);
			  --salida    : out std_logic_vector(7 downto 0);
			  ------------------------------------------------
			  ------------------------------------------------
			  Vsync 		: out  STD_LOGIC;
			  Hsync 		: out  STD_LOGIC;
			  RGB_8bits : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end md_io;

architecture Behavioral of md_io is
	COMPONENT entrada
    Port ( 
				p : in  STD_LOGIC;
				w : in  STD_LOGIC;
				a : in STD_LOGIC;
				s : in STD_LOGIC;
				d : in STD_LOGIC;
				alMIPS : out  STD_LOGIC_VECTOR (6 downto 0)
			 );
	END COMPONENT;
	COMPONENT decodificador
    Port ( ent       : in  STD_LOGIC_VECTOR (31 downto 0);
           csMem     : out  STD_LOGIC;
           csParPort : out  STD_LOGIC;
           csLCD     : out  STD_LOGIC;
			  csEntrada : out STD_LOGIC;
			  csVGA		: out STD_LOGIC
			);
	END COMPONENT;
	COMPONENT md
    Port ( dir      : STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_DATOS -1 +2 downto 0);
           datain   : in  STD_LOGIC_VECTOR (31 downto 0);
           cs       : in  STD_LOGIC;
           memwrite : in  STD_LOGIC;
           memread  : in  STD_LOGIC;
			  tipoAcc  : in STD_LOGIC_VECTOR (2 downto 0);
           clk      : in  STD_LOGIC;
           dataout  : out  STD_LOGIC_VECTOR (31 downto 0)
			);
	END COMPONENT;
	COMPONENT ModuloVGA
	PORT(
		--hab_VGA : in STD_LOGIC; --habilita el chip cuando se entra en la direccion X10008...
		clk : in  STD_LOGIC;
		-----------------------------------------------------
		Vsync : out  STD_LOGIC;
		Hsync : out  STD_LOGIC;
		RGB_8bits : out  STD_LOGIC_VECTOR (7 downto 0);
		memOut : out STD_LOGIC_VECTOR (31 downto 0);
		-----------------------------------------------------
		Leer : in STD_LOGIC; --nos dice si queremos un valor de la memoria de video
		Escribir : in  STD_LOGIC; --'1' escribir '0' leer
		DatosAEscribir : in  STD_LOGIC_VECTOR (31 downto 0); --son colores en hexadecimal para meter en la memoria
		DirecAAcceder : in STD_LOGIC_VECTOR (31 downto 0) --es la direccion en la que se tiene que pintar el color o leer
		);
	END COMPONENT;

-- Definimos señales para interconexión interna en este módulo
	signal csMem       : STD_LOGIC;
	signal csSalidaPar : STD_LOGIC;
	signal csLCD       : STD_LOGIC;
	signal csEntrada   : STD_LOGIC;
	signal csVGA		 : STD_LOGIC;
	signal datosMem    : STD_LOGIC_VECTOR (31 downto 0);
	signal datosEntrada: STD_LOGIC_VECTOR (6 downto 0);
	signal salida_color_mem_video : STD_LOGIC_VECTOR (31 downto 0);
	
-- Para mis accesos al vga
	signal leer_memv		: STD_LOGIC:='0';
	signal escribir_memv : STD_LOGIC:='0';
begin
	-- Multiplexor de salida
	dataout <= datosMem                                    when csMem = '1'     else
			     "0000000000000000000000000" & datosEntrada  when csEntrada = '1' else
			     salida_color_mem_video							 when csVGA = '1' 	 else
				  (others => '0');

	Inst_entrada: entrada PORT MAP (
		p => p,
		w => w,
		a => a,
		s => s,
		d => d,
		alMIPS => datosEntrada
	);
	
	Inst_decodificador: decodificador PORT MAP(
		ent       => dir(31 downto 0),
      csMem     => csMem,
		csParPort => csSalidaPar,
      csLCD     => csLCD,
		csEntrada => csEntrada,
		csVGA 	 => csVGA
	);

	Inst_md: md PORT MAP(
		dir      => dir(NUM_BITS_MEMORIA_DATOS -1+2 downto 0),
      datain   => datain,
      cs       => csMem,
      memwrite => memwrite,
      memread  => memread,
		tipoAcc  => tipoAcc,
      clk      => clk,
      dataout  => datosMem
	);
	
	-- And para leer o escribir en la memoria de video
	leer_memv <= memread and csVGA;
	escribir_memv <= memwrite and csVGA;
	
	Inst_ModuloVGA: ModuloVGA PORT MAP(
		--hab_VGA => hab_VGA
		clk => clk,
		Vsync => Vsync,
		Hsync => Hsync,
		RGB_8bits => RGB_8bits,
		memOut => salida_color_mem_video,
		Leer => leer_memv,
		Escribir => escribir_memv,
		DatosAEscribir => datain,
		DirecAAcceder => dir
		
	);

end Behavioral;

