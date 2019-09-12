----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 28.08.2019
-- Module Name: SSD Controller - Behavioral
-- Project Name: UART
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ssd_controller is
	Generic(
		g_CLOCK_FREQ : integer := 100000000
	);
	Port(
		p_Clock   : in  std_logic;
		p_Reset   : in  std_logic;
		p_Data    : in  std_logic_vector(15 downto 0);
		o_Anode   : out std_logic_vector(3 downto 0);
		o_Cathode : out std_logic_vector(6 downto 0)
	);
end ssd_controller;

architecture Behavioral of ssd_controller is

	constant REFRESH_RATE : integer := 4000;
	constant MAX_COUNT    : integer := g_CLOCK_FREQ / REFRESH_RATE;

	-- SSD Signals
	signal s_Anode    : std_logic_vector(3 downto 0);
	signal s_Cathode  : std_logic_vector(6 downto 0);
	signal s_Mux      : integer range 0 to 15;
	signal s_MuxCount : integer range 0 to 3;
	signal s_MuxData  : std_logic_vector(15 downto 0);

	-- Clock Gen
	signal s_Count : integer;
	signal s_Clock : std_logic;

begin

	o_Anode    <= s_Anode;
	o_Cathode  <= s_Cathode;

	ssd_clock : process(p_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_Count <= 0;
			s_Clock <= '0';
		elsif rising_edge(p_Clock) then
			if (s_Count = MAX_COUNT) then
				s_Clock <= not s_Clock;
				s_Count <= 0;
			else
				s_Count <= s_Count + 1;
			end if;
		end if;
	end process ssd_clock;

	ssd_write : process(s_Clock, p_Reset) is
	begin
		if p_Reset = '1' then
			s_Anode    <= "1110";
			s_Cathode  <= "1111111";
			s_Mux      <= 0;
			s_MuxCount <= 0;
			s_MuxData  <= (others => '0');
		elsif rising_edge(s_Clock) then
			case s_Mux is
				when 0  => s_Cathode <= "1000000"; -- 0
				when 1  => s_Cathode <= "1111001"; -- 1
				when 2  => s_Cathode <= "0100100"; -- 2
				when 3  => s_Cathode <= "0110000"; -- 3
				when 4  => s_Cathode <= "0011001"; -- 4
				when 5  => s_Cathode <= "0010010"; -- 5
				when 6  => s_Cathode <= "0000010"; -- 6
				when 7  => s_Cathode <= "1111000"; -- 7
				when 8  => s_Cathode <= "0000000"; -- 8
				when 9  => s_Cathode <= "0011000"; -- 9
				when 10 => s_Cathode <= "0001000"; -- A
				when 11 => s_Cathode <= "0000011"; -- B
				when 12 => s_Cathode <= "1000110"; -- C
				when 13 => s_Cathode <= "0100001"; -- D
				when 14 => s_Cathode <= "0000110"; -- E
				when 15 => s_Cathode <= "0001110"; -- F
			end case;
			s_Anode <= s_Anode(2 downto 0) & s_Anode(3);
			s_Mux   <= to_integer(unsigned(s_MuxData(3 downto 0)));
			if s_MuxCount = 3 then
				s_MuxData  <= p_Data;
				s_MuxCount <= 0;
			else
				s_MuxData  <= s_MuxData(3 downto 0) & s_MuxData(15 downto 4);
				s_MuxCount <= s_MuxCount + 1;
			end if;
		end if;
	end process ssd_write;

end Behavioral;
