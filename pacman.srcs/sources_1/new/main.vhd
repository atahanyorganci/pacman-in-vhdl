----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 26.08.2019
-- Module Name: Main - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
	Port (
		CLOCK : in std_logic;
		RESET : in std_logic;
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

	component clock_divider is
		port (
			p_Clock	: IN std_logic;
			o_GameClock : out std_logic
		);
	end component;

	component vga_clock
		Port (
		clk_out: out std_logic;
		reset : in std_logic;
		locked : out std_logic;
		clk_in1 : in std_logic
		);
	end component;

	component entity_controller is
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
	end component;

	component ssd_controller is
		Port ( 
			p_Clock : in std_logic;
			p_Score : in integer range 0 to 65535;
			p_Highscore: in integer range 0 to 65535;
			o_Anode : out std_logic_vector (3 downto 0);
			o_Cathode : out std_logic_vector (6 downto 0)
		);
	end component;

	component user_io is
		Port ( 
			p_Left : in std_logic;
			p_Up : in std_logic;
			p_Down : in std_logic;
			p_Right : in std_logic;
			p_Clock : in std_logic;
			p_Reset : in std_logic;
			o_PlayerHPos : out integer;
			o_PlayerVPos : out integer
		);
	end component;

	component vga_driver is
		Port (
			p_Clock : in  std_logic;
			p_Reset : in std_logic;
			p_Color : in std_logic_vector (2 downto 0);
			o_HPos : out integer;
			o_VPos : out integer;
			o_VGAHS : out std_logic;
			o_VGAVS : out std_logic;
			o_VGARed : out std_logic_vector (3 downto 0);
			o_VGAGreen : out std_logic_vector (3 downto 0);
			o_VGABlue : out std_logic_vector (3 downto 0)
		);
	end component;

	-- Clock Driver Output
	signal s_GameClock : std_logic := '0';

	-- VGA Clock
	signal s_VGALocked : std_logic := '0';
	signal s_VGANotLocked : std_logic := '0';
	signal s_VGAClock : std_logic := '0';

	-- Entity Controller Output
	signal s_Color : std_logic_vector (2 downto 0) := "000";
	signal s_Score : integer range 0 to 65535 := 0;
	signal s_Highscore: integer range 0 to 65535 := 0;
	signal s_Reset : std_logic := '0';

	-- User I/O Output
	signal s_PlayerHPos : integer := 0;
	signal s_PlayerVPos : integer := 0;

	-- VGA Driver Output
	signal s_HPos : integer := 0;
	signal s_VPos : integer := 0;

begin

GAME_LOGIC_CLOCK : clock_divider port map(
	p_Clock => CLOCK,
	o_GameClock => s_GameClock
);

VGA_CLOCK_IP : vga_clock port map (
	clk_out => s_VGAClock,
	reset => RESET,
	locked => s_VGALocked,
	clk_in1 => CLOCK
);
s_VGANotLocked <= not s_VGALocked;

ENTITY_CONTROL : entity_controller port map (
	p_VGAClock => s_VGAClock,
	p_GameClock => s_GameClock,
	p_Reset => s_VGANotLocked,
	p_HPos => s_HPos,
	p_VPos => s_VPos,
	p_PlayerHPos => s_PlayerHPos,
	p_PlayerVPos => s_PlayerVPos,
	o_Color => s_Color,
	o_Score => s_Score,
	o_Highscore => s_Highscore,
	o_Reset => s_Reset
);

SSD : ssd_controller port map (
	p_Clock => CLOCK,
	p_Score => s_Score,
	p_Highscore => s_Highscore,
	o_Anode => ANODE,
	o_Cathode => CATHODE
);

USER : user_io port map (
	p_Left => LEFT,
	p_Up => UP,
	p_Down => DOWN,
	p_Right => RIGHT,
	p_Clock => s_GameClock,
	p_Reset => s_Reset,
	o_PlayerHPos => s_PlayerHPos,
	o_PlayerVPos => s_PlayerVPos
);

VGA : vga_driver port map(
	p_Clock => s_VGAClock,
	p_Reset => s_Reset,
	p_Color => s_Color,
	o_HPos => s_HPos,
	o_VPos => s_VPos,
	o_VGAHS => VGA_HS,
	o_VGAVS => VGA_VS,
	o_VGARed => VGA_RED,
	o_VGAGreen => VGA_GREEN,
	o_VGABlue => VGA_BLUE
);

end Behavioral;
