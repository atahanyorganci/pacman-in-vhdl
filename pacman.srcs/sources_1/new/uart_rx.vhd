-- Engineer: Atahan Yorganci
-- Create Date: 28.08.2019
-- Module Name: UART RX - Behavioral
-- Project Name: UART
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
	Generic(
		g_BAUD_RATE   : integer := 9600;
		g_CLOCK_FREQ : integer := 100000000
	);
	Port(
		p_Clock : in  std_logic;
		p_Reset : in  std_logic;
		p_Rx    : in  std_logic;
		o_Data  : out std_logic_vector(7 downto 0);
		o_Done  : out std_logic
	);
end uart_rx;

architecture Behavioral of uart_rx is

	type State is (Idle, Start, Data, Stop);

	constant c_TICK_COUNT   : integer := g_CLOCK_FREQ / g_BAUD_RATE;
	constant c_SAMPLE_POINT : integer := c_TICK_COUNT / 2;

	signal s_State   : State;
	signal s_RxCount : integer;
	signal s_RxData  : std_logic_vector(7 downto 0);
	signal s_RxDone  : std_logic;
	signal s_RxIndex : integer range 0 to 7;

begin

	o_Data <= s_RxData;
	o_Done <= s_RxDone;

	RX : process(p_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_State   <= Idle;
			s_RxCount <= 0;
			s_RxData  <= (others => '0');
			s_RxDone  <= '0';
			s_RxIndex <= 0;
		elsif rising_edge(p_Clock) then
			case s_State is
				when Idle =>
					s_RxDone <= '0';
					if p_Rx = '0' then
						s_State <= Start;
					end if;
				when Start =>
					if s_RxCount = c_TICK_COUNT then
						s_State   <= Data;
						s_RxCount <= 0;
					elsif s_RxCount = c_SAMPLE_POINT then
						s_RxCount <= s_RxCount + 1;
						if p_Rx /= '0' then
							s_State <= Idle;
						end if;
					else
						s_RxCount <= s_RxCount + 1;
					end if;
				when Data =>
					if s_RxCount = c_TICK_COUNT then
						s_RxCount <= 0;
						if s_RxIndex = 7 then
							s_State   <= Stop;
							s_RxIndex <= 0;
						else
							s_RxIndex <= s_RxIndex + 1;
						end if;
					elsif s_RxCount = c_SAMPLE_POINT then
						s_RxData(s_RxIndex) <= p_Rx;
						s_RxCount           <= s_RxCount + 1;
					else
						s_RxCount <= s_RxCount + 1;
					end if;
				when Stop =>
					if s_RxCount = c_TICK_COUNT then
						s_RxCount <= 0;
						s_State   <= Idle;
						s_RxDone  <= '1';
					elsif s_RxCount = c_SAMPLE_POINT then
						s_RxCount <= s_RxCount + 1;
						if p_Rx /= '1' then
							s_State <= Idle;
						end if;
					else
						s_RxCount <= s_RxCount + 1;
					end if;
			end case;
		end if;
	end process;

end Behavioral;
