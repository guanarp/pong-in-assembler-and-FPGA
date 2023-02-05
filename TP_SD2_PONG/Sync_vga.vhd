----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:21 10/30/2021 
-- Design Name: 
-- Module Name:    Sync_vga - Behavioral 
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

entity Sync_vga is
    Port ( 
			  clk : in  STD_LOGIC;
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           ContX : out  integer range 0 to 799;
           ContY : out  integer range 0 to 524
			  );
end Sync_vga;

architecture Behavioral of Sync_vga is
	signal Hcounter : integer range 0 to 799 := 0;
	signal Vcounter : integer range 0 to 524 := 0;
	signal Hsync_t : std_logic := '0';
	signal Vsync_t : std_logic := '0';
	
	--640 x 480 @ 60Hz (CLK = 25MHz)
	--==================================================================
	--Horizontal ___________|-----------|---------|------------|____
	--				  SyncPulse	  BackPorch   Display   FrontPorch
	--pixel        	96          48         640         16      Total: 800pixels
	--==================================================================
	--Vertical   ___________|-----------|---------|------------|____
	-- 				SyncPulse  BackPorch   Display    FrontPorch
	--lines			   2           33         480         10      Total: 525lines
	
begin
	process(clk) is
	begin 
		if clk'event and clk='1' then 
			Hcounter <= Hcounter + 1;
			if Hcounter = 95 then 
				Hsync_t <= '1';
			elsif Hcounter = 799 then 
				Hsync_t <= '0';
				Hcounter <= 0;
				Vcounter <= Vcounter + 1;
				if Vcounter = 1 then
					Vsync_t <= '1';
				elsif Vcounter = 524 then 
					Vsync_t <= '0';
					Vcounter <= 0;
				end if;
			end if;		
		end if;
	end process;
	
	Hsync <= Hsync_t;
	Vsync <= Vsync_t;
	ContX <= HCounter;
	ContY <= VCounter;

end Behavioral;

