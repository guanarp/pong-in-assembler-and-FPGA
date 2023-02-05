-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY tb_ModuloVGA IS
  END tb_ModuloVGA;

ARCHITECTURE behavior OF tb_ModuloVGA IS 

  -- Component Declaration
	COMPONENT ModuloVGA
	PORT(
	  hab_VGA : in STD_LOGIC; --habilita el chip cuando se entra en la direccion X10008...
	  clk : in  STD_LOGIC;
	  -----------------------------------------------------
	  Vsync : out  STD_LOGIC;
	  Hsync : out  STD_LOGIC;
	  RGB_8bits : out  STD_LOGIC_VECTOR (7 downto 0);
	  -----------------------------------------------------
	  EscribirOLeer : in  STD_LOGIC; --'1' escribir '0' leer
	  DatosAEscribir : in  STD_LOGIC_VECTOR (31 downto 0); --son colores en hexadecimal para meter en la memoria
	  DirecAEscribir : in STD_LOGIC_VECTOR (31 downto 0) --es la direccion en la que se tiene que pintar el color
	  );
	END COMPONENT;

signal hab_VGA 	:   STD_LOGIC; --habilita el chip cuando se entra en la direccion X10008...
signal clk 			:   STD_LOGIC;
-----------------------------------------------------
signal Vsync 		:   STD_LOGIC;
signal Hsync 		:   STD_LOGIC;
signal RGB_8bits 	:   STD_LOGIC_VECTOR (7 downto 0);
-----------------------------------------------------
signal EscribirOLeer  :  STD_LOGIC; --'1' escribir '0' leer
signal DatosAEscribir :  STD_LOGIC_VECTOR (31 downto 0); --son colores en hexadecimal para meter en la memoria
signal DirecAEscribir :  STD_LOGIC_VECTOR (31 downto 0);

-- Clock period definitions
constant clk_period : time := 20 ns;


  BEGIN
  -- Component Instantiation
   uut: ModuloVGA
	PORT MAP(
              hab_VGA => hab_VGA,
				  clk => clk,
				  Vsync => Vsync,
				  Hsync => Hsync,
				  RGB_8bits => RGB_8bits,
				  EscribirOLeer => EscribirOLeer,
				  DatosAEscribir => DatosAEscribir,
				  DirecAEscribir => DirecAEscribir
          );



	-- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
  -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		hab_VGA <= '0';
      wait for clk_period*2;	
		hab_VGA <= '1';

      wait for clk_period*2;	
		EscribirOLeer <= '1';
		DatosAEscribir <= X"00FF0000";
		
		DirecAEscribir <= X"10008000";
		wait for clk_period;
		DirecAEscribir <= X"10008004";
		wait for clk_period;
		DirecAEscribir <= X"10008008";
		wait for clk_period;
		DirecAEscribir <= X"1000800c";
		wait for clk_period;
		DirecAEscribir <= X"10008010";
		wait for clk_period;
		DirecAEscribir <= X"10008014";
		wait for clk_period;
		DirecAEscribir <= X"10008018";
		wait for clk_period;
		DirecAEscribir <= X"1000801c";
		wait for clk_period;
		
		EscribirOLeer <= '0';
		
	
      wait for clk_period*20;

      wait;
   end process;

  END;
