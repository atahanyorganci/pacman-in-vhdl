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

	-- RX
	type DataArray is array (0 to 3) of std_logic_vector(9 downto 0);
	constant c_CLOCK_FREQ : integer   := 100_000_000;
	constant c_BAUD_RATE  : integer   := 9600;
	constant c_TICK_COUNT : integer   := c_CLOCK_FREQ / c_BAUD_RATE;
	constant c_DATA       : DataArray := ("1011100110", "1011100110", "1011100110", "1011100110");
	constant c_DATA_COUNT : integer   := 4;
	signal s_TickCount    : integer;
	signal s_Index        : integer;
	signal s_DataCount    : integer;

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
		generic map(
			g_BAUD_RATE  => c_BAUD_RATE,
			g_CLOCK_FREQ => c_CLOCK_FREQ
		)
		port map(
			p_Clock     => s_Clock,
			p_Reset     => s_Reset,
			p_Rx        => s_Rx,
			o_Clock     => s_GameClock,
			o_Move      => s_Changed,
			o_Direction => s_Direction
		);

	my_player : player
		port map(
			p_Clock     => s_Clock,
			p_Reset     => s_Reset,
			p_Move      => s_Changed,
			p_Direction => s_Direction,
			p_HPos      => s_HPos,
			p_VPos      => s_VPos,
			o_Draw      => s_Draw
		);

	rx : process(s_Clock, s_Reset) is
	begin
		if s_Reset = '1' then
			s_TickCount <= 0;
			s_DataCount <= 0;
			s_Index     <= 0;
			s_Rx        <= '1';
		elsif rising_edge(s_Clock) then
			if s_DataCount = c_DATA_COUNT then
				s_Rx <= '1';
			elsif s_TickCount < c_TICK_COUNT then
				s_TickCount <= s_TickCount + 1;
			else
				if s_Index < 9 then
					s_Index <= s_Index + 1;
				else
					s_DataCount <= s_DataCount + 1;
					s_Index     <= 0;
				end if;
				s_Rx        <= c_DATA(s_DataCount)(s_Index);
				s_TickCount <= 0;
			end if;
		end if;
	end process rx;

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
