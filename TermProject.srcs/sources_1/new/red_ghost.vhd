----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: ghost path - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity red_ghost is
	Port ( CLK : in std_logic;
		RST : in std_logic;
		  VPOS : out integer;
		  HPOS : out integer
		);
end red_ghost;

architecture Behavioral of red_ghost is
	signal tempH : integer := 120;
	signal tempV : integer := 80;
begin

move : process(CLK) 
begin
	if (rising_edge(CLK)) then
		if (RST = '1') then
			tempH <= 120;
			tempV <= 80;
		else
			if (tempH = 120 and tempV < 140) then 
				tempV <= tempV + 1;
			elsif (tempV = 140 and tempH < 440) then
				tempH <= tempH + 1;
			elsif (tempH = 440 and tempV > 40) then
				tempV <= tempV - 1;
			elsif (tempV = 40 and tempH > 120) then 
				tempH <= tempH - 1;
			end if; 
		end if;
	end if;
end process;
HPOS <= tempH;
VPOS <= tempV;
end Behavioral;
