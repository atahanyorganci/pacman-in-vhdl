----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 26.08.2019
-- Module Name: Entity Controller - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity entity_controller is
	Port(
		p_Clock     : in  std_logic;
		p_GameClock : in  std_logic;
		p_Reset     : in  std_logic;
		p_HPos      : in  integer;
		p_VPos      : in  integer;
		p_Direction : in  std_logic_vector(3 downto 0);
		p_Move      : in  std_logic;
		o_Color     : out std_logic_vector(2 downto 0);
		o_Data      : out std_logic_vector(15 downto 0)
	);
end entity_controller;

architecture Behavioral of entity_controller is

	component ghost is
		generic(
			g_HINIT   : integer := 200;
			g_VINIT   : integer := 140;
			g_HCORNER : integer := 360;
			g_VCORNER : integer := 340
		);
		Port(
			p_GameClock : in  std_logic;
			p_Clock     : in  std_logic;
			p_Reset     : in  std_logic;
			p_HPos      : in  integer range 0 to 65535;
			p_VPos      : in  integer range 0 to 65535;
			o_Draw      : out std_logic
		);
	end component;

	component food
		generic(
			g_HINIT : integer;
			g_VINIT : integer
		);
		Port(
			p_Clock  : in  std_logic;
			p_Reset  : in  std_logic;
			p_Enable : in  std_logic;
			p_HPos   : in  integer range 0 to 65535;
			p_VPos   : in  integer range 0 to 65535;
			o_Draw   : out std_logic
		);
	end component food;

	component rectangle
		generic(
			g_HCORNER : integer;
			g_VCORNER : integer;
			g_WIDTH   : integer;
			g_HEIGHT  : integer
		);
		Port(
			p_Clock : in  std_logic;
			p_Reset : in  std_logic;
			p_HPos  : in  integer range 0 to 65535;
			p_VPos  : in  integer range 0 to 65535;
			o_Draw  : out std_logic
		);
	end component rectangle;

	component player
		port(
			p_Clock     : in  std_logic;
			p_Reset     : in  std_logic;
			p_Move      : in  std_logic;
			p_Direction : in  std_logic_vector(3 downto 0);
			p_HPos      : in  integer range 0 to 65535;
			p_VPos      : in  integer range 0 to 65535;
			o_Draw      : out std_logic
		);
	end component player;

	signal s_DrawMargin    : std_logic_vector(3 downto 0);
	signal s_DrawRectangle : std_logic_vector(9 downto 0);
	signal s_DrawPlayer    : std_logic := '0';
	signal s_DrawFood      : std_logic_vector(21 downto 0);
	signal s_DrawRedGhost  : std_logic := '0';
	signal s_DrawCyanGhost : std_logic := '0';

	signal s_EnableFood : std_logic_vector(21 downto 0);

	signal s_GameOver : std_logic := '0';

	signal s_Color     : std_logic_vector(2 downto 0);
	signal s_Highscore : std_logic_vector(7 downto 0);
	signal s_Score     : std_logic_vector(7 downto 0);

begin

	o_Data  <= s_Score & s_Highscore;
	o_Color <= s_Color;

	color : process(p_Clock, p_Reset)
	begin
		if (p_Reset = '1') then
			s_Color <= "000";
		elsif (rising_edge(p_Clock)) then
			if (s_DrawMargin /= "0000" or s_DrawRectangle /= "0000000000") then
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

	detectEat : process(p_Clock, p_Reset)
	begin
		if p_Reset = '1' then
			s_EnableFood <= (others => '1');
			s_Score      <= (others => '0');
			s_Highscore  <= (others => '0');
		elsif rising_edge(p_Clock) then
			if s_GameOver = '1' then
				s_Score      <= (others => '0');
				s_EnableFood <= (others => '1');
			else
				if to_integer(unsigned(s_Score)) > to_integer(unsigned(s_Highscore)) then
					s_Highscore <= s_Score;
				end if;
				for i in 0 to 21 loop
					if (s_DrawFood(i) = '1' AND s_DrawPlayer = '1') then
						s_EnableFood(i) <= '0';
						s_Score         <= std_logic_vector(unsigned(s_Score) + 1);
					end if;
				end loop;
			end if;
		end if;
	end process;

	gameCheck : process(p_Clock, p_Reset)
	begin
		if p_Reset = '1' then
			s_GameOver <= '1';
		elsif rising_edge(p_Clock) then
			if s_EnableFood = "0000000000000000000000" then
				s_GameOver <= '1';
			elsif s_DrawPlayer = '1' AND (s_DrawCyanGhost = '1' OR s_DrawRedGhost = '1') then
				s_GameOver <= '1';
			else
				s_GameOver <= '0';
			end if;
		end if;
	end process;

	RED_GHOST : ghost
		generic map(
			g_HINIT   => 120,
			g_VINIT   => 40,
			g_HCORNER => 440,
			g_VCORNER => 140
		)
		Port map(
			p_GameClock => p_GameClock,
			p_Clock     => p_Clock,
			p_Reset     => s_GameOver,
			p_HPos      => p_HPos,
			p_VPos      => p_VPos,
			o_Draw      => s_DrawRedGhost
		);

	CYAN_GHOST : ghost
		generic map(
			g_HINIT   => 200,
			g_VINIT   => 140,
			g_HCORNER => 360,
			g_VCORNER => 340
		)
		Port map(
			p_GameClock => p_GameClock,
			p_Clock     => p_Clock,
			p_Reset     => s_GameOver,
			p_HPos      => p_HPos,
			p_VPos      => p_VPos,
			o_Draw      => s_DrawCyanGhost
		);

	MARGIN_UP : rectangle
		generic map(
			g_HCORNER => 110,
			g_VCORNER => 30,
			g_WIDTH   => 370,
			g_HEIGHT  => 10
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawMargin(0)
		);

	MARGIN_RIGHT : rectangle
		generic map(
			g_HCORNER => 480,
			g_VCORNER => 30,
			g_WIDTH   => 10,
			g_HEIGHT  => 410
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawMargin(1)
		);

	MARGIN_DOWN : rectangle
		generic map(
			g_HCORNER => 120,
			g_VCORNER => 440,
			g_WIDTH   => 370,
			g_HEIGHT  => 10
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawMargin(2)
		);

	MARGIN_LEFT : rectangle
		generic map(
			g_HCORNER => 110,
			g_VCORNER => 40,
			g_WIDTH   => 10,
			g_HEIGHT  => 410
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawMargin(3)
		);

	RECTANGLE00 : rectangle
		generic map(
			g_HCORNER => 160,
			g_VCORNER => 80,
			g_WIDTH   => 120,
			g_HEIGHT  => 60
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(0)
		);

	RECTANGLE01 : rectangle
		generic map(
			g_HCORNER => 320,
			g_VCORNER => 80,
			g_WIDTH   => 120,
			g_HEIGHT  => 60
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(1)
		);

	RECTANGLE02 : rectangle
		generic map(
			g_HCORNER => 160,
			g_VCORNER => 180,
			g_WIDTH   => 40,
			g_HEIGHT  => 120
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(2)
		);

	RECTANGLE03 : rectangle
		generic map(
			g_HCORNER => 240,
			g_VCORNER => 180,
			g_WIDTH   => 120,
			g_HEIGHT  => 41
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(3)
		);

	RECTANGLE04 : rectangle
		generic map(
			g_HCORNER => 400,
			g_VCORNER => 180,
			g_WIDTH   => 40,
			g_HEIGHT  => 120
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(4)
		);

	RECTANGLE05 : rectangle
		generic map(
			g_HCORNER => 280,
			g_VCORNER => 220,
			g_WIDTH   => 40,
			g_HEIGHT  => 41
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(5)
		);

	RECTANGLE06 : rectangle
		generic map(
			g_HCORNER => 240,
			g_VCORNER => 260,
			g_WIDTH   => 120,
			g_HEIGHT  => 80
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(6)
		);

	RECTANGLE07 : rectangle
		generic map(
			g_HCORNER => 160,
			g_VCORNER => 340,
			g_WIDTH   => 40,
			g_HEIGHT  => 60
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(7)
		);

	RECTANGLE08 : rectangle
		generic map(
			g_HCORNER => 240,
			g_VCORNER => 380,
			g_WIDTH   => 120,
			g_HEIGHT  => 61
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(8)
		);

	RECTANGLE09 : rectangle
		generic map(
			g_HCORNER => 400,
			g_VCORNER => 340,
			g_WIDTH   => 40,
			g_HEIGHT  => 60
		)
		Port map(
			p_Clock => p_Clock,
			p_Reset => s_GameOver,
			p_HPos  => p_HPos,
			p_VPos  => p_VPos,
			o_Draw  => s_DrawRectangle(9)
		);

	c_PLAYER : player
		port map(
			p_Clock     => p_Clock,
			p_Reset     => s_GameOver,
			p_Move      => p_Move,
			p_Direction => p_Direction,
			p_HPos      => p_HPos,
			p_VPos      => p_VPos,
			o_Draw      => s_DrawPlayer
		);

	-- First Line
	FOOD00 : food
		generic map(
			g_HINIT => 120,
			g_VINIT => 40
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(0),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(0)
		);

	FOOD01 : food
		generic map(
			g_HINIT => 200,
			g_VINIT => 40
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(1),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(1)
		);

	FOOD02 : food
		generic map(
			g_HINIT => 280,
			g_VINIT => 40
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(2),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(2)
		);

	FOOD03 : food
		generic map(
			g_HINIT => 360,
			g_VINIT => 40
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(3),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(3)
		);

	FOOD04 : food
		generic map(
			g_HINIT => 440,
			g_VINIT => 40
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(4),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(4)
		);

	-- Second Line
	FOOD05 : food
		generic map(
			g_HINIT => 120,
			g_VINIT => 140
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(5),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(5)
		);

	FOOD06 : food
		generic map(
			g_HINIT => 200,
			g_VINIT => 140
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(6),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(6)
		);

	FOOD07 : food
		generic map(
			g_HINIT => 280,
			g_VINIT => 140
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(7),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(7)
		);

	FOOD08 : food
		generic map(
			g_HINIT => 360,
			g_VINIT => 140
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(8),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(8)
		);

	FOOD09 : food
		generic map(
			g_HINIT => 440,
			g_VINIT => 140
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(9),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(9)
		);

	-- Third Line
	FOOD10 : food
		generic map(
			g_HINIT => 120,
			g_VINIT => 220
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(10),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(10)
		);

	FOOD11 : food
		generic map(
			g_HINIT => 240,
			g_VINIT => 220
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(11),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(11)
		);

	FOOD12 : food
		generic map(
			g_HINIT => 320,
			g_VINIT => 220
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(12),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(12)
		);

	FOOD13 : food
		generic map(
			g_HINIT => 440,
			g_VINIT => 220
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(13),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(13)
		);

	-- Forth Line
	FOOD14 : food
		generic map(
			g_HINIT => 120,
			g_VINIT => 300
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(14),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(14)
		);

	FOOD15 : food
		generic map(
			g_HINIT => 200,
			g_VINIT => 300
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(15),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(15)
		);

	FOOD16 : food
		generic map(
			g_HINIT => 360,
			g_VINIT => 300
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(16),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(16)
		);

	FOOD17 : food
		generic map(
			g_HINIT => 440,
			g_VINIT => 300
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(17),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(17)
		);

	-- Fifth Line
	FOOD18 : food
		generic map(
			g_HINIT => 120,
			g_VINIT => 400
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(18),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(18)
		);

	FOOD19 : food
		generic map(
			g_HINIT => 200,
			g_VINIT => 400
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(19),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(19)
		);

	FOOD20 : food
		generic map(
			g_HINIT => 360,
			g_VINIT => 400
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(20),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(20)
		);

	FOOD21 : food
		generic map(
			g_HINIT => 440,
			g_VINIT => 400
		)
		Port map(
			p_Clock  => p_Clock,
			p_Reset  => s_GameOver,
			p_Enable => s_EnableFood(21),
			p_HPos   => p_HPos,
			p_VPos   => p_VPos,
			o_Draw   => s_DrawFood(21)
		);
end Behavioral;
