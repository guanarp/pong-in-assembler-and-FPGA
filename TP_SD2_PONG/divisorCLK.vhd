library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisorCLK is
    Port ( clk100mhz : in  STD_LOGIC;
           clk : out  STD_LOGIC);
end divisorCLK;

-- Divisor de Frecuencia para el MIPS.
-- La frecuencia de 100 MHz es dividida por 4.
architecture Behavioral of divisorCLK is
    signal clk50mhz: std_logic := '0';
	 signal clk25mhz: std_logic := '0';
begin
	process (clk100mhz)
	begin
		if clk100mhz'event and clk100mhz = '1' then
			clk50mhz <= not clk50mhz;
		end if;
	end process;
	
	process (clk50mhz)
	begin
		if clk50mhz'event and clk50mhz = '1' then
			clk25mhz <= not clk25mhz;
		end if;
	end process;

   clk <= clk25mhz;

end Behavioral;

