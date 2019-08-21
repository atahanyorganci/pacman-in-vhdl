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
	Port (
		CLK : in std_logic;
		RST : in std_logic;
		VPOS : out integer;
		HPOS : out integer
	);
end component;

component user_io is
	Port (
		LEFT : in STD_LOGIC;
		UP : in STD_LOGIC;
		DOWN : in STD_LOGIC;
		RIGHT : in STD_LOGIC;
		CLK : in std_logic;
		RST : in std_logic;
		PLAYER_H, PLAYER_V: out integer
	);
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
		o_Score : out integer range 0 to 65535;
		o_HighScore : out integer range 0 to 65535;
		VGA_HS : out  STD_LOGIC;
		VGA_VS : out  STD_LOGIC;
		VGA_RED : out  STD_LOGIC_VECTOR (3 downto 0);
		VGA_GREEN : out  STD_LOGIC_VECTOR (3 downto 0);
		VGA_BLUE : out  STD_LOGIC_VECTOR (3 downto 0)
	);
end component;

component clk_div IS
	PORT (
		p_Clock	: IN std_logic; -- p_Clock 100MHz
		o_VGAClock  : OUT std_logic;
		o_GameClock : out std_logic
	);
END component;

component cyan_ghost is
	Port (
		CLK : in std_logic;
		RST : in std_logic;
		VPOS : out integer;
		HPOS : out integer
	);
end component;

component ssd_controller is
	Port (
		p_Clock : in STD_LOGIC;
		p_Score : in integer range 0 to 65535;
		p_HighScore: in integer range 0 to 65535;
		o_Anode : out STD_LOGIC_VECTOR (3 downto 0);
		o_Cathode : out STD_LOGIC_VECTOR (6 downto 0)
	);
end component;

signal s_VGAClock : std_logic := '0';
signal s_GameClock : std_logic := '0';
signal PLAYER_H, PLAYER_V : integer := 0;
signal RED_H, RED_V : integer := 0;
signal CYAN_H, CYAN_V : integer := 0;
signal PLAYER_RESET, GHOST_RESET : STD_LOGIC := '0';
signal s_Score : integer range 0 to 65535 := 0;
signal s_HighScore: integer range 0 to 65535 := 0;

begin

CLOCK_DIVIDER : clk_div port map(
	p_Clock => CLK,
	o_VGAClock => s_VGAClock,
	o_GameClock => s_GameClock
);

VGA_DRIVER : VGA port map(
	CLK => s_VGAClock,
	RESET => RST,
	PLAYER_H => PLAYER_H,
	PLAYER_V => PLAYER_V,
	PLAYER_RST => PLAYER_RESET,
	RED_H => RED_H,
	RED_V => RED_V,
	CYAN_H => CYAN_H,
	CYAN_V => CYAN_V,
	GHOST_RST => GHOST_RESET,
	o_Score => s_Score,
	o_HighScore => s_HighScore,
	VGA_HS => VGA_HS,
	VGA_VS => VGA_VS,
	VGA_RED => VGA_RED,
	VGA_GREEN => VGA_GREEN,
	VGA_BLUE => VGA_BLUE
);

SSD_DRIVER : ssd_controller port map (
	p_Clock => CLK,
	p_Score => s_Score,
	p_HighScore => s_HighScore,
	o_Anode => ANODE,
	o_Cathode => CATHODE
);

USER_INPUT : user_io port map(
	LEFT => LEFT,
	UP => UP,
	DOWN => DOWN,
	RIGHT => RIGHT,
	CLK => s_GameClock,
	RST => PLAYER_RESET,
	PLAYER_H => PLAYER_H,
	PLAYER_V => PLAYER_V
);

RED_GHOST_HANDLER : red_ghost port map (
	CLK => s_GameClock,
	RST => GHOST_RESET,
	HPOS => RED_H,
	VPOS => RED_V
);

CYAN_GHOST_HANDLER : cyan_ghost port map (
	CLK => s_GameClock,
	RST => GHOST_RESET,
	HPOS => CYAN_H,
	VPOS => CYAN_V
);
end Behavioral;
