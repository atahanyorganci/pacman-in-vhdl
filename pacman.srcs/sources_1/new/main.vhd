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
	Port(
		CLOCK     : in  std_logic;
		RESET     : in  std_logic;
		RX        : in  std_logic;
		ANODE     : out std_logic_vector(3 downto 0);
		CATHODE   : out std_logic_vector(6 downto 0);
		VGA_VS    : out std_logic;
		VGA_HS    : out std_logic;
		VGA_RED   : out std_logic_vector(3 downto 0);
		VGA_BLUE  : out std_logic_vector(3 downto 0);
		VGA_GREEN : out std_logic_vector(3 downto 0)
	);
end main;

architecture Behavioral of main is

	component io
		generic(
			g_BAUD_RATE  : integer;
			g_CLOCK_FREQ : integer
		);
		port(
			p_Clock     : in  std_logic;
			p_Reset     : in  std_logic;
			p_Rx        : in  std_logic;
			o_Clock     : out std_logic;
			o_Move      : out std_logic;
			o_Direction : out std_logic_vector(3 downto 0)
		);
	end component io;

	component clock_wizard
		port(
			vga_clock : out std_logic;
			reset     : in  std_logic;
			locked    : out std_logic;
			clock_in  : in  std_logic
		);
	end component;

	component entity_controller
		port(
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
	end component entity_controller;

	component ssd_controller
		generic(g_CLOCK_FREQ : integer);
		port(
			p_Clock   : in  std_logic;
			p_Reset   : in  std_logic;
			p_Data    : in  std_logic_vector(15 downto 0);
			o_Anode   : out std_logic_vector(3 downto 0);
			o_Cathode : out std_logic_vector(6 downto 0)
		);
	end component ssd_controller;

	component vga_driver is
		Port(
			p_Clock    : in  std_logic;
			p_Reset    : in  std_logic;
			p_Color    : in  std_logic_vector(2 downto 0);
			o_HPos     : out integer;
			o_VPos     : out integer;
			o_VGAHS    : out std_logic;
			o_VGAVS    : out std_logic;
			o_VGARed   : out std_logic_vector(3 downto 0);
			o_VGAGreen : out std_logic_vector(3 downto 0);
			o_VGABlue  : out std_logic_vector(3 downto 0)
		);
	end component;

	-- Constants
	constant c_CLOCK_FREQ : integer := 40_000_000;
	constant c_BAUD_RATE  : integer := 9600;

	-- Clock Driver Output
	signal s_GameClock : std_logic;

	-- VGA Clock
	signal s_VGAClock : std_logic;
	signal s_Locked   : std_logic;
	signal s_Reset    : std_logic;

	-- Entity Controller Output
	signal s_Color     : std_logic_vector(2 downto 0);
	signal s_Score     : std_logic_vector(15 downto 0);
	signal s_GameReset : std_logic;

	-- VGA Driver Output
	signal s_HPos : integer := 0;
	signal s_VPos : integer := 0;

	-- IO
	signal s_Move      : std_logic;
	signal s_Direction : std_logic_vector(3 downto 0);

begin

	my_wizard : clock_wizard
		port map(
			vga_clock => s_VGAClock,
			reset     => RESET,
			locked    => s_Locked,
			clock_in  => CLOCK
		);
	s_Reset <= not s_Locked;

	my_controller : entity_controller
		port map(
			p_Clock     => s_VGAClock,
			p_GameClock => s_GameClock,
			p_Reset     => s_Reset,
			p_HPos      => s_HPos,
			p_VPos      => s_VPos,
			p_Direction => s_Direction,
			p_Move      => s_Move,
			o_Color     => s_Color,
			o_Data      => s_Score
		);

	my_ssd : ssd_controller
		generic map(
			g_CLOCK_FREQ => c_CLOCK_FREQ
		)
		Port map(
			p_Reset   => s_Reset,
			p_Clock   => s_VGAClock,
			p_Data    => s_Score,
			o_Anode   => ANODE,
			o_Cathode => CATHODE
		);

	my_io : io
		generic map(
			g_BAUD_RATE  => c_BAUD_RATE,
			g_CLOCK_FREQ => c_CLOCK_FREQ
		)
		port map(
			p_Clock     => s_VGAClock,
			p_Reset     => s_Reset,
			p_Rx        => RX,
			o_Clock     => s_GameClock,
			o_Move      => s_Move,
			o_Direction => s_Direction
		);

	my_vga : vga_driver
		Port map(
			p_Clock    => s_VGAClock,
			p_Reset    => s_GameReset,
			p_Color    => s_Color,
			o_HPos     => s_HPos,
			o_VPos     => s_VPos,
			o_VGAHS    => VGA_HS,
			o_VGAVS    => VGA_VS,
			o_VGARed   => VGA_RED,
			o_VGAGreen => VGA_GREEN,
			o_VGABlue  => VGA_BLUE
		);

end Behavioral;
