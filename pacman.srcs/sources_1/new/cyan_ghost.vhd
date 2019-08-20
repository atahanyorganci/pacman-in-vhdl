----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: ghost path - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cyan_ghost is
	Port ( CLK : in std_logic;
		RST : in std_logic;
		  VPOS : out integer;
		  HPOS : out integer
		);
end cyan_ghost;

architecture Behavioral of cyan_ghost is
	signal tempH : integer := 200;
	signal tempV : integer := 140;
begin

move : process(CLK) 
begin
	if (rising_edge(CLK)) then
		if (RST = '1') then
			tempH <= 200;
			tempV <= 140;
		else
			if (tempH = 200 and tempV < 340) then 
				tempV <= tempV + 1;
			elsif (tempV = 340 and tempH < 360) then
				tempH <= tempH + 1;
			elsif (tempH = 360 and tempV > 140) then
				tempV <= tempV - 1;
			elsif (tempV = 140 and tempH > 200) then 
				tempH <= tempH - 1;
			end if; 
		end if;
	end if;
end process;
HPOS <= tempH;
VPOS <= tempV;
end Behavioral;
