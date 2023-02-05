
--Este es el controlador de salida, que nos pide cada direccion
--de la memoria de video y nos va pintando los pixeles en la pantalla
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

entity Controlador_salida is
    Port ( 
				clk : in  STD_LOGIC;
				ContX : in  integer range 0 to 799;
				ContY : in  integer range 0 to 524;
				iterar_en_memoria : out  integer range 0 to 1023;
				datos_RGB_8bits : in  STD_LOGIC_VECTOR (7 downto 0);
				salida_RGB_8bits : out  STD_LOGIC_VECTOR (7 downto 0)
			);
end Controlador_salida;

architecture Behavioral of Controlador_salida is
	--640 x 480 @ 60Hz (CLK = 25MHz)
	--==================================================================
	--Horizontal ___________|-----------|---------|------------|____
	--				  SyncPulse	  BackPorch   Display   FrontPorch
	--pixel        	96          48         640         16      Total: 800pixels
	--==================================================================
	--Vertical   ___________|-----------|---------|------------|____
	-- 				SyncPulse  BackPorch   Display    FrontPorch
	--lines			   2           33         480         10      Total: 525lines
	signal contPos : integer range 0 to 1023 := 0;
	signal RGBsignal : std_logic_vector(7 downto 0) := (others => '0');
begin
	process (clk) is 
	begin
		if clk'event and clk='1' then 
		--Screen Output
			if (ContX > 143 and ContX < 784) and (ContY > 34 and ContY < 515) then  --In Range
				if (ContX < 224 or ContX > 703) then --pintamos los costados ya que nuestro juego es cuadrado
					RGBsignal<="10101010"; --se pintan esos costados en blanco
				else
					RGBsignal <= datos_RGB_8bits; --Se carga lo que sale del decod de colores
					--contX-224 nos da la pos x en la matriz de memoria. /15 es para pintar 15 pixeles
					--contY-34 nos da la pos y en la matriz de memoria, cada linea son 32 pixeles entonces *32
					-- /15 es para lo mismo ya mencionado
					contPos <= ((ContX-224)/15) + ( ((ContY-34)/15)*32 );
				end if;
			else --Out of range
				RGBsignal<="11100001";
			end if;
		--End Screen Output
		end if;
	end process;
	iterar_en_memoria <= contPos;
	salida_RGB_8bits <= RGBsignal;
end Behavioral;

