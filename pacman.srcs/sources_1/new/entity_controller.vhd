----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 22.08.2019
-- Module Name: Entity Controller - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pacage.ALL;

entity entity_controller is
	Port (
		p_VGAClock : in std_logic;
		p_GameClock : in std_logic;
		p_Reset : in std_logic;
		p_HPos : in integer;
		p_VPos: in integer;
		p_PlayerHPos : in integer;
		p_PlayerVPos : in integer;
		o_Color : out std_logic_vector (2 downto 0);
		o_Score : out integer range 0 to 65535;
		o_Highscore : out integer range 0 to 65535;
		o_Reset : out std_logic
	);
end entity_controller;

architecture Behavioral of entity_controller is

	signal s_Margin : std_logic := '0';

	signal s_DrawRectangle : std_logic_vector (9 downto 0) := "0000000000";
	signal s_DrawingRectangle : std_logic := '0';

	signal s_DrawPlayer : std_logic := '0';
	signal s_EnablePlayer : std_logic := '0';

	signal s_DrawFood : std_logic_vector (21 downto 0) := "0000000000000000000000";
	signal s_DrawingFood : std_logic := '0';
	signal s_EnableFood : std_logic_vector (21 downto 0) := "1111111111111111111111";

	signal s_DrawRedGhost : std_logic := '0';
	signal s_RedGhostHPos : integer;
	signal s_RedGhostVPos : integer;

	signal s_DrawCyanGhost : std_logic := '0';
	signal s_CyanGhostHPos : integer;
	signal s_CyanGhostVPos : integer;

	signal s_Reset : std_logic := '0';

	signal s_Color : std_logic_vector (2 downto 0) := "000";

	signal s_Score : integer range 0 to 65535 := 0;
	signal s_Highscore : integer range 0 to 65535 := 0;

	component ghost_path is
		generic (
			g_HINIT : integer := 200;
			g_VINIT : integer := 140;
			g_HCORNER : integer := 360;
			g_VCORNER : integer := 340
		);
		port (
			p_Clock : in std_logic;
			p_Reset : in std_logic;
			o_VPos : out integer;
			o_HPos : out integer
		);
	end component;

begin

RED_GHOST : ghost_path generic map (
	g_HINIT => 200,
	g_VINIT => 140,
	g_HCORNER => 360,
	g_VCORNER => 340
) port map (
	p_Clock => p_GameClock,
	p_Reset => p_Reset,
	o_VPos => s_RedGhostHPos,
	o_HPos => s_RedGhostVPos
);

CYAN_GHOST : ghost_path generic map (
	g_HINIT => 120,
	g_VINIT => 140,
	g_HCORNER => 440,
	g_VCORNER => 40
) port map (
	p_Clock => p_GameClock,
	p_Reset => p_Reset,
	o_VPos => s_CyanGhostHPos,
	o_HPos => s_CyanGhostVPos
);


color : process(p_VGAClock, s_Reset)
begin
	if (s_Reset = '1') then
		s_Color <= "000";
	elsif (rising_edge(p_VGAClock)) then
		if (s_Margin = '1' or s_DrawRectangle /= "0000000000") then
			s_Color <= "001";
		elsif (s_DrawCyanGhost = '1') then
			s_Color <= "011";
		elsif (s_DrawRedGhost = '1') then
			s_Color <= "100";
		elsif (s_DrawFood /= "0000000000000000000000") then
			s_Color <= "101";
		elsif (s_DrawPlayer = '1') then
			s_Color <= "110";
		else
			s_Color <= "000";
		end if;
	end if;
end process;
o_Color <= s_Color;

-- Detect Eat
detectEat : process(p_VGAClock, s_Reset)
begin
	if (s_Reset = '1') then
		s_Score <= 0;
		s_EnableFood <= "1111111111111111111111";
	elsif (rising_edge(p_VGAClock)) then
		for i in 0 to 21 loop
			if(s_DrawFood(i) = '1' AND s_DrawPlayer = '1') then
				s_EnableFood(i) <= '0';
				s_Score <= s_Score + 1;
			end if;
		end loop;
	end if;
end process;
o_Score <= s_Score;

highscore : process(p_VGAClock, s_Reset)
begin
	if (rising_edge(p_VGAClock) and s_Reset = '0') then
		if (s_Score >= s_Highscore) then
			s_Highscore <= s_Score;
		end if;
	end if;
end process;
o_Highscore <= s_Highscore;

-- Detect Spook
detectSpook : process(p_VGAClock, s_Reset)
begin
	if (s_Reset = '0') then
		s_EnablePlayer <= '1';
	elsif (rising_edge(p_VGAClock)) then
		if (s_DrawPlayer = '1' AND (s_DrawCyanGhost = '1' OR s_DrawRedGhost = '1')) then
			s_EnablePlayer <= '0';
		end if;
	end if;
end process;

-- Game Check
gameCheck : process(p_VGAClock, p_Reset)
begin
	if (p_Reset = '1') then
		s_Reset <= '1';
	elsif (rising_edge(p_VGAClock)) then
		if (s_EnableFood = "0000000000000000000000" or s_EnablePlayer = '0') then
			s_Reset <= '1';
		else
			s_Reset <= '0';
		end if;
	end if;
end process;
o_Reset <= s_Reset;

DRAW_MARGIN(p_HPos, p_VPos, s_Margin); -- margins
DRAW_RECTANGLE(p_HPos, p_VPos, 160, 80, 120, 60,  s_DrawRectangle(0)); -- rectangle 1
DRAW_RECTANGLE(p_HPos, p_VPos, 320, 80, 120, 60,  s_DrawRectangle(1)); -- rectangle 2
DRAW_RECTANGLE(p_HPos, p_VPos, 160, 180, 40, 120, s_DrawRectangle(2)); -- rectangle 3
DRAW_RECTANGLE(p_HPos, p_VPos, 240, 180, 120, 41, s_DrawRectangle(3)); -- rectangle 4
DRAW_RECTANGLE(p_HPos, p_VPos, 400, 180, 40, 120, s_DrawRectangle(4)); -- rectangle 5
DRAW_RECTANGLE(p_HPos, p_VPos, 280, 220, 40, 41, s_DrawRectangle(5)); -- rectangle 6
DRAW_RECTANGLE(p_HPos, p_VPos, 240, 260, 120, 80, s_DrawRectangle(6)); -- rectangle 7
DRAW_RECTANGLE(p_HPos, p_VPos, 160, 340, 40, 60, s_DrawRectangle(7)); -- rectangle 8
DRAW_RECTANGLE(p_HPos, p_VPos, 240, 380, 120, 61, s_DrawRectangle(8)); -- rectangle 9
DRAW_RECTANGLE(p_HPos, p_VPos, 400, 340, 40, 60, s_DrawRectangle(9)); -- rectangle 10

-- Player
DRAW_CIRCLE(p_HPos, p_VPos, p_PlayerHPos, p_PlayerVPos, s_EnablePlayer, 15, s_DrawPlayer);

-- s_DrawFood MAGENTA CIRCLES
-- FIRST LINE
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(0), 0, 0, 10, s_DrawFood(0)); -- Food 1
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(1), 80, 0, 10, s_DrawFood(1)); -- Food 2
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(2), 160, 0, 10, s_DrawFood(2)); -- Food 3
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(3), 240, 0, 10, s_DrawFood(3)); -- Food 4
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(4), 320, 0, 10, s_DrawFood(4)); -- Food 5
-- THIRD LINE
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(5), 0, 100, 10, s_DrawFood(5)); -- Food 6
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(6), 80, 100, 10, s_DrawFood(6)); -- Food 7
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(7), 160, 100, 10, s_DrawFood(7)); -- Food 8
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(8), 240, 100, 10, s_DrawFood(8)); -- Food 9
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(9), 320, 100, 10, s_DrawFood(9)); -- Food 10
-- FIFTH LINE
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(10), 0, 180, 10, s_DrawFood(10)); -- Food 11
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(11), 120, 180, 10, s_DrawFood(11)); -- Food 12
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(12), 200, 180, 10, s_DrawFood(12)); -- Food 13
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(13), 320, 180, 10, s_DrawFood(13)); -- Food 14
-- SEVENTH LINE
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(14), 0, 260, 10, s_DrawFood(14)); -- Food 15
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(15), 80, 260, 10, s_DrawFood(15)); -- Food 16
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(16), 240, 260, 10, s_DrawFood(16)); -- Food 17
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(17), 320, 260, 10, s_DrawFood(17)); -- Food 18
-- NINETH LINE
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(18), 0, 360, 10, s_DrawFood(18)); -- Food 19
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(19), 80, 360, 10, s_DrawFood(19)); -- Food 20
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(20), 240, 360, 10, s_DrawFood(20)); -- Food 21
DRAW_FOOD(p_HPos, p_VPos, s_EnableFood(21), 320, 360, 10, s_DrawFood(21)); -- Food 22

DRAW_GHOST(p_HPos, p_VPos, s_RedGhostHPos, s_RedGhostVPos, s_DrawRedGhost);
DRAW_GHOST(p_HPos, p_VPos, s_CyanGhostHPos, s_CyanGhostVPos, s_DrawCyanGhost);

end Behavioral;