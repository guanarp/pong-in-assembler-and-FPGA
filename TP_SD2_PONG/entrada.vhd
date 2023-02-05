----------------------------------------------------------------------------------
-- Company: Universidad Católica
-- Engineer: Vicente González
-- 
-- Create Date:    16:36:42 06/13/2019 
-- Design Name: 
-- Module Name:    entrada - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
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

entity entrada is
    Port ( 
				p : in  STD_LOGIC;
				w : in  STD_LOGIC;
				a : in STD_LOGIC;
				s : in STD_LOGIC;
				d : in STD_LOGIC;
				alMIPS : out  STD_LOGIC_VECTOR (6 downto 0)
				);
end entrada;

architecture Behavioral of entrada is

begin
	alMIPS <= 	"1101001" when a='0' else
					"1101011" when d='0' else
					"1110111" when w='0' else
					"1110011" when s='0' else
					"1110000" when p='0' else
					(others => '0');

end Behavioral;

