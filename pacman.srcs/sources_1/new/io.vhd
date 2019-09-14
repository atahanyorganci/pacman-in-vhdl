-- Engineer: Atahan Yorganci
-- Create Date: 28.08.2019
-- Module Name: I/O - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity io is
	Port(
		p_Clock     : in  std_logic;
		p_Reset     : in  std_logic;
		p_Rx        : in  std_logic;
		o_Clock     : out std_logic;
		o_Changed   : out std_logic;
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
	signal s_Move : std_logic;

	signal s_Direction : std_logic_vector(3 downto 0);

BEGIN

	o_Clock     <= s_Clock;
	o_Changed   <= s_Move;
	o_Direction <= s_Direction;

	my_rx : uart_rx
		generic map(
			g_BAUD_RATE  => 9600,
			g_CLOCK_FREQ => 40_000_000
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

	direction : process(s_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_Direction <= (others => '0');
			s_Move <= '0';
		elsif rising_edge(s_Clock) then
			if s_Done = '1' then
				case s_Data is
					when x"61"  => s_Direction <= "0001";
					when x"64"  => s_Direction <= "0010";
					when x"73"  => s_Direction <= "0100";
					when x"77"  => s_Direction <= "1000";
					when others => s_Direction <= "0000";
				end case;
				s_Move <= '1';
			else
				s_Move <= '0';
			end if;
		end if;
	end process direction;

end Behavioral;
