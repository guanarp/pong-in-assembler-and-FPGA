
-- VHDL Instantiation Created from source file ModuloVGA.vhd -- 16:47:24 11/11/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ModuloVGA
	PORT(
		clk : IN std_logic;
		Leer : IN std_logic;
		Escribir : IN std_logic;
		DatosAEscribir : IN std_logic_vector(31 downto 0);
		DirecAAcceder : IN std_logic_vector(31 downto 0);          
		Vsync : OUT std_logic;
		Hsync : OUT std_logic;
		RGB_8bits : OUT std_logic_vector(7 downto 0);
		memOut : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	Inst_ModuloVGA: ModuloVGA PORT MAP(
		clk => ,
		Vsync => ,
		Hsync => ,
		RGB_8bits => ,
		memOut => ,
		Leer => ,
		Escribir => ,
		DatosAEscribir => ,
		DirecAAcceder => 
	);


