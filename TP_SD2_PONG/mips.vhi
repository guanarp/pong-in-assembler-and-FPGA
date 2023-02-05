
-- VHDL Instantiation Created from source file mips.vhd -- 14:34:20 12/03/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT mips
	PORT(
		clk100mhz : IN std_logic;
		reset1 : IN std_logic;
		reset0 : IN std_logic;
		p : IN std_logic;
		w : IN std_logic;
		a : IN std_logic;
		s : IN std_logic;
		d : IN std_logic;
		rx : IN std_logic;
		atn : IN std_logic;          
		salida : OUT std_logic_vector(7 downto 0);
		LCD_E : OUT std_logic;
		LCD_RS : OUT std_logic;
		LCD_RW : OUT std_logic;
		LCD_DB : OUT std_logic_vector(7 downto 0);
		tx : OUT std_logic;
		Hsync : OUT std_logic;
		Vsync : OUT std_logic;
		RGB_8bits : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_mips: mips PORT MAP(
		clk100mhz => ,
		reset1 => ,
		reset0 => ,
		p => ,
		w => ,
		a => ,
		s => ,
		d => ,
		salida => ,
		LCD_E => ,
		LCD_RS => ,
		LCD_RW => ,
		LCD_DB => ,
		rx => ,
		tx => ,
		atn => ,
		Hsync => ,
		Vsync => ,
		RGB_8bits => 
	);


