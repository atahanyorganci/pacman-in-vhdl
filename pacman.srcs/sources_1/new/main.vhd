----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: main - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pacage.all;

entity main is
	Port (
	CLK : in std_logic; -- Clk 100MHz
	RST : in std_logic;
	DOWN, UP, LEFT, RIGHT : in std_logic;
	ANODE : out std_logic_vector (3 downto 0);
	CATHODE : out std_logic_vector (6 downto 0);
	VGA_VS : out std_logic;
	VGA_HS : out std_logic;
	VGA_RED : out std_logic_vector (3 downto 0);
	VGA_BLUE : out std_logic_vector (3 downto 0);
	VGA_GREEN: out std_logic_vector (3 downto 0)
	);
end main;

architecture Behavioral of main is

component red_ghost is
	Port ( CLK : in std_logic;
		RST : in std_logic;
		  VPOS : out integer;
		  HPOS : out integer
		);
end component;

component user_io is
	Port ( LEFT : in STD_LOGIC;
		   UP : in STD_LOGIC;
		   DOWN : in STD_LOGIC;
		   RIGHT : in STD_LOGIC;
		   CLK : in std_logic;
		   RST : in std_logic;
		 PLAYER_H, PLAYER_V: out integer);
end component;

component VGA is
	Port ( 
			CLK : in  STD_LOGIC;
			RESET : in STD_LOGIC;
			PLAYER_H : in integer;
			PLAYER_V : in integer;
			PLAYER_RST : out std_logic;
			RED_H : in integer;
			RED_V : in integer;
			CYAN_H : in integer;
			CYAN_V : in integer;
			GHOST_RST : out std_logic;
			SCORE : out integer range 0 to 32;
			VGA_HS : out  STD_LOGIC;
			VGA_VS : out  STD_LOGIC;
			VGA_RED : out  STD_LOGIC_VECTOR (3 downto 0);
			VGA_GREEN : out  STD_LOGIC_VECTOR (3 downto 0);
			VGA_BLUE : out  STD_LOGIC_VECTOR (3 downto 0)
		   );
end component;

component clk_div IS
	PORT 
	(
		CLK	: IN std_logic; -- Clk 100MHz
		CLK25  : OUT std_logic;
		CLK_SLOW : out std_logic
	);
END component;

component cyan_ghost is
	Port ( CLK : in std_logic;
		RST : in std_logic;
		  VPOS : out integer;
		  HPOS : out integer
		);
end component;

component score_ssd is
	Port ( 
			 SCORE : in integer range 0 to 32;
			 HIGHSCORE: in integer range 0 to 32;
		   clock: in STD_LOGIC;
		   ANODE : out STD_LOGIC_VECTOR (3 downto 0);
		   CATHODE : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component score_fsm is
	Port ( CLK : in std_logic;
			 SCORE : in integer range 0 to 32;
		   HIGHSCORE : out integer range 0 to 32);
end component;

signal CLK25 : std_logic := '0';
signal SLOW : std_logic := '0';
signal PLAYER_H, PLAYER_V : integer := 0;
signal RED_H, RED_V : integer := 0;
signal CYAN_H, CYAN_V : integer := 0;
signal PLAYER_RESET, GHOST_RESET : STD_LOGIC := '0';
signal SCORE : integer range 0 to 32 := 0;
signal HIGHSCORE: integer range 0 to 32 := 0;

begin

CLOCK_DIVIDER : clk_div port map(
	CLK => CLK,
	CLK25 => CLK25,
	CLK_SLOW => SLOW
);

VGA_DRIVER : VGA port map(
	CLK => CLK25,
	RESET => RST,
	PLAYER_H => PLAYER_H,
	PLAYER_V => PLAYER_V,
	PLAYER_RST => PLAYER_RESET,
	RED_H => RED_H,
	RED_V => RED_V,
	CYAN_H => CYAN_H,
	CYAN_V => CYAN_V,
	GHOST_RST => GHOST_RESET,
	SCORE => SCORE,
	VGA_HS => VGA_HS,
	VGA_VS => VGA_VS,
	VGA_RED => VGA_RED,
	VGA_GREEN => VGA_GREEN,
	VGA_BLUE => VGA_BLUE
);

SSD_DRIVER : score_ssd port map (
	SCORE => SCORE,
	HIGHSCORE => HIGHSCORE,
	clock => CLK,
	ANODE => ANODE,
	CATHODE => CATHODE
);

USER_INPUT : user_io port map(
	LEFT => LEFT,
	UP => UP,
	DOWN => DOWN,
	RIGHT => RIGHT,
	CLK => SLOW,
	RST => PLAYER_RESET,
	PLAYER_H => PLAYER_H,
	PLAYER_V => PLAYER_V
);

SCORE_HANDLER : score_fsm port map(
	CLK => CLK,
	SCORE => SCORE,
	HIGHSCORE => HIGHSCORE
);
RED_GHOST_HANDLER : red_ghost port map (
	CLK => SLOW,
	RST => GHOST_RESET,
	HPOS => RED_H,
	VPOS => RED_V
);

CYAN_GHOST_HANDLER : cyan_ghost port map(
	CLK => SLOW,
	RST => GHOST_RESET,
	HPOS => CYAN_H,
	VPOS => CYAN_V
);
end Behavioral;
