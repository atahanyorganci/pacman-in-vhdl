----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 26.08.2019
-- Module Name: Clock Divider - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
	Port(
		p_Clock     : IN  std_logic;
		o_GameClock : out std_logic
	);
END clock_divider;

ARCHITECTURE Behavioral OF clock_divider IS

	signal s_TempClock  : std_logic := '0';
	constant GAME_SPEED : integer   := 500000;

BEGIN

	-- Generate clock used for game logic calculations @100Hz
	process(p_Clock)
		variable count : integer := 0;
	begin
		IF (rising_edge(p_Clock)) then
			count := count + 1;
			if (count = GAME_SPEED) then
				count       := 0;
				s_TempClock <= not s_TempClock;
			end if;
		end if;
	end process;
	o_GameClock <= s_TempClock;

END Behavioral;
