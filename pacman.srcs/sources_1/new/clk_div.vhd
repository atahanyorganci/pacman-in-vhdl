LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.pacage.ALL;

ENTITY clk_div IS
	PORT 
	(
		p_Clock	: IN std_logic; -- p_Clock 100MHz
		o_VGAClock  : OUT std_logic;
		o_GameClock : out std_logic
	);
END clk_div;

ARCHITECTURE Behavioral OF clk_div IS

	signal s_TempClock : std_logic := '0';
	signal s_VGALocked : std_logic := '0';
	constant GAME_SPEED : integer := 500000;

	component clk_wiz_0 is
		port (
			clk_out1 : out std_logic;
			reset : in std_logic;
			locked : out std_logic;
			clk_in1 : in std_logic
		);
	end component;

BEGIN

	vga_clock_gen : clk_wiz_0 port map (
		clk_out1 => o_VGAClock,
		reset => '0',
		locked => s_VGALocked,
		clk_in1 => p_Clock
	);

	-- Generate clock used for game logic calculations @100Hz
	gameLogicClockGen : PROCESS (p_Clock)
	variable count : integer := 0;
	begin
		IF (rising_edge(p_Clock)) then
			count := count + 1;
			if ( count = GAME_SPEED ) then
				count := 0;
				s_TempClock <= not s_TempClock;
			end if;
		end if;
	end process;
	o_GameClock <= s_TempClock;

END Behavioral;