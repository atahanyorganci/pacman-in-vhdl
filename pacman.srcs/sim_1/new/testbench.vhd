----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 29.08.2019
-- Module Name: Testbench - Behavioral
-- Project Name: Mini GPU
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is

	component io
		port(
			p_Clock     : in  std_logic;
			p_Reset     : in  std_logic;
			p_Rx        : in  std_logic;
			o_Clock     : out std_logic;
			o_Changed   : out std_logic;
			o_Direction : out std_logic_vector(3 downto 0)
		);
	end component io;

	component player
		port(
			p_Clock     : in  std_logic;
			p_Reset     : in  std_logic;
			p_Changed   : in  std_logic;
			p_Direction : in  std_logic_vector(3 downto 0);
			p_HPos      : in  integer range 0 to 65535;
			p_VPos      : in  integer range 0 to 65535;
			o_Draw      : out std_logic
		);
	end component player;

	-- Control
	signal s_Clock : std_logic;
	signal s_Reset : std_logic;

	signal s_Rx        : std_logic;
	signal s_GameClock : std_logic;
	signal s_Changed   : std_logic;
	signal s_Direction : std_logic_vector(3 downto 0);
	signal s_HPos      : integer range 0 to 65535;
	signal s_VPos      : integer range 0 to 65535;
	signal s_Draw      : std_logic;

begin

	my_io : io
		port map(
			p_Clock     => s_Clock,
			p_Reset     => s_Reset,
			p_Rx        => s_Rx,
			o_Clock     => s_GameClock,
			o_Changed   => s_Changed,
			o_Direction => s_Direction
		);

	my_player : player
		port map(
			p_Clock     => s_Clock,
			p_Reset     => s_Reset,
			p_Changed   => s_Changed,
			p_Direction => s_Direction,
			p_HPos      => s_HPos,
			p_VPos      => s_VPos,
			o_Draw      => s_Draw
		);

	control : process
	begin
		s_Reset <= '1';
		wait for 100 ns;
		s_Reset <= '0';
		wait;
	end process;

	clock : process
	begin
		s_Clock <= '1';
		wait for 5 ns;
		s_Clock <= '0';
		wait for 5 ns;
	end process;

end Behavioral;
