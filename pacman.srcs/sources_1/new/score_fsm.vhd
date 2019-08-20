----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: Score Seven Segment Display - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity score_fsm is
    Port ( CLK : in std_logic;
    		 SCORE : in integer range 0 to 32;
           HIGHSCORE : out integer range 0 to 32);
end score_fsm;

architecture Behavioral of score_fsm is
	signal TEMP : integer range 0 to 32 := 0;
begin
detect_score : process(CLK)
begin
	if rising_edge(CLK) then
		if (SCORE > TEMP) then 
			TEMP <= SCORE;
		end if;
	end if;
end process;
HIGHSCORE <= TEMP;
end Behavioral;
