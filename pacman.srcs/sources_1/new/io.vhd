-- Engineer: Atahan Yorganci
-- Create Date: 28.08.2019
-- Module Name: I/O - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity io is
	Generic(
		g_BAUD_RATE  : integer;
		g_CLOCK_FREQ : integer
	);
	Port(
		p_Clock     : in  std_logic;
		p_Reset     : in  std_logic;
		p_Rx        : in  std_logic;
		o_Clock     : out std_logic;
		o_Move      : out std_logic;
		o_Direction : out std_logic_vector(3 downto 0)
	);
end io;

architecture Behavioral of io is

	component uart_rx
		generic(
			g_BAUD_RATE  : integer;
			g_CLOCK_FREQ : integer
		);
		port(
			p_Clock : in  std_logic;
			p_Reset : in  std_logic;
			p_Rx    : in  std_logic;
			o_Data  : out std_logic_vector(7 downto 0);
			o_Done  : out std_logic
		);
	end component uart_rx;

	constant GAME_SPEED : integer := 200000;
	signal s_Clock      : std_logic;
	signal s_Count      : integer;

	signal s_Data : std_logic_vector(7 downto 0);
	signal s_Done : std_logic;

	signal s_Direction : std_logic_vector(3 downto 0);
	signal s_Move      : std_logic;
	signal s_MoveCount : integer range 0 to 7;

BEGIN

	o_Clock     <= s_Clock;
	o_Move      <= s_Move;
	o_Direction <= s_Direction;

	my_rx : uart_rx
		generic map(
			g_BAUD_RATE  => g_BAUD_RATE,
			g_CLOCK_FREQ => g_CLOCK_FREQ
		)
		port map(
			p_Clock => p_Clock,
			p_Reset => p_Reset,
			p_Rx    => p_Rx,
			o_Data  => s_Data,
			o_Done  => s_Done
		);

	divide : process(p_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_Clock <= '0';
		elsif rising_edge(p_Clock) then
			if (s_Count = GAME_SPEED) then
				s_Count <= 0;
				s_Clock <= not s_Clock;
			else
				s_Count <= s_Count + 1;
			end if;
		end if;
	end process divide;

	direction : process(p_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_Direction <= (others => '0');
			s_Move      <= '0';
			s_MoveCount <= 0;
		elsif rising_edge(p_Clock) then
			if s_Move = '1' then
				s_MoveCount <= s_MoveCount + 1;
				if s_MoveCount = 5 then
					s_Move <= '0';
				end if;
			elsif s_Done = '1' then
				s_MoveCount <= 0;
				case s_Data is
					when x"61" =>
						s_Direction <= "0001";
						s_Move      <= '1';
					when x"64" =>
						s_Direction <= "0010";
						s_Move      <= '1';
					when x"73" =>
						s_Direction <= "0100";
						s_Move      <= '1';
					when x"77" =>
						s_Direction <= "1000";
						s_Move      <= '1';
					when others => s_Direction <= "0000";
				end case;
			end if;
		end if;
	end process direction;

end Behavioral;
