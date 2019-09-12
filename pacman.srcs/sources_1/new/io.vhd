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
		o_Direction : out std_logic_vector(3 downto 0)
	);
end io;

architecture Behavioral of io is

	COMPONENT direction_ram
		PORT(
			clka  : IN  std_logic;
			wea   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			dina  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			clkb  : IN  STD_LOGIC;
			addrb : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

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

BEGIN

	o_Clock <= s_Clock;

	my_ram : direction_ram
		PORT MAP(
			clka  => p_Clock,
			wea   => "1",
			addra => "0",
			dina  => s_Direction,
			clkb  => s_Clock,
			addrb => "0",
			doutb => o_Direction
		);

	my_rx : uart_rx
		generic map(
			g_BAUD_RATE  => 9600,
			g_CLOCK_FREQ => 100_000_000
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
	
	direction : process (s_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_Direction <= (others => '0');
		elsif rising_edge(s_Clock) then
			if s_Done = '1' then
				case s_Data is
					when x"61" => s_Direction <= "0001";
					when x"64" => s_Direction <= "0010";
					when x"73" => s_Direction <= "0100";
					when x"77" => s_Direction <= "1000";
					when others => null;
				end case;
			end if;
		end if;
	end process direction;	

end Behavioral;
