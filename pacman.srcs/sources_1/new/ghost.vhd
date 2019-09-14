----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 21.08.2019
-- Module Name: Ghost - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ghost is
	generic(
		g_HINIT   : integer := 200;
		g_VINIT   : integer := 140;
		g_HCORNER : integer := 360;
		g_VCORNER : integer := 340
	);
	Port(
		p_GameClock : in  std_logic;
		p_Clock     : in  std_logic;
		p_Reset     : in  std_logic;
		p_HPos      : in  integer range 0 to 65535;
		p_VPos      : in  integer range 0 to 65535;
		o_Draw      : out std_logic
	);
end ghost;

architecture Behavioral of ghost is

	constant c_BITMAP_WIDTH : integer := 40;

	signal s_BitmapAddr : std_logic_vector(5 downto 0);
	signal s_BitmapRow  : std_logic_vector(39 downto 0);

	signal s_RAMIn  : std_logic_vector(31 downto 0);
	signal s_RAMOut : std_logic_vector(31 downto 0);

	signal s_GhostHPos : integer range 0 to 65535;
	signal s_GhostVPos : integer range 0 to 65535;
	signal s_HPosSlow  : std_logic_vector(15 downto 0);
	signal s_VPosSlow  : std_logic_vector(15 downto 0);

	signal s_Draw : std_logic := '0';

	signal s_HOffset : integer range 0 to 65535 := 0;
	signal s_VOffset : integer range 0 to 65535 := 0;

	COMPONENT ghost_rom
		Port(
			clka  : IN  STD_LOGIC;
			addra : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT position_ram
		Port(
			clka  : IN  STD_LOGIC;
			wea   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			dina  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			clkb  : IN  STD_LOGIC;
			addrb : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

begin

	s_RAMIn <= s_VPosSlow & s_HPosSlow;

	c_BITMAP : ghost_rom
		Port MAP(
			clka  => p_Clock,
			addra => s_BitmapAddr,
			douta => s_BitmapRow
		);

	c_POSITION : position_ram
		Port MAP(
			clka  => p_GameClock,
			wea   => "1",
			addra => "0",
			dina  => s_RAMIn,
			clkb  => p_Clock,
			addrb => "0",
			doutb => s_RAMOut
		);

	move : process(p_GameClock, p_Reset)
	begin
		if p_Reset = '1' then
			s_GhostHPos <= g_HINIT;
			s_GhostVPos <= g_VINIT;
			s_HPosSlow  <= std_logic_vector(to_unsigned(g_HINIT, s_HPosSlow'length));
			s_VPosSlow  <= std_logic_vector(to_unsigned(g_VINIT, s_VPosSlow'length));
		elsif rising_edge(p_GameClock) then
			s_HPosSlow <= std_logic_vector(to_unsigned(s_GhostHPos, s_HPosSlow'length));
			s_VPosSlow <= std_logic_vector(to_unsigned(s_GhostVPos, s_VPosSlow'length));
			if (s_GhostHPos = g_HINIT and s_GhostVPos < g_VCORNER) then
				s_GhostVPos <= s_GhostVPos + 1;
			elsif (s_GhostVPos = g_VCORNER and s_GhostHPos < g_HCORNER) then
				s_GhostHPos <= s_GhostHPos + 1;
			elsif (s_GhostHPos = g_HCORNER and s_GhostVPos > g_VINIT) then
				s_GhostVPos <= s_GhostVPos - 1;
			elsif (s_GhostVPos = g_VINIT and s_GhostHPos > g_HINIT) then
				s_GhostHPos <= s_GhostHPos - 1;
			end if;
		end if;
	end process;

	draw : process(p_Clock, p_Reset)
	begin
		if p_Reset = '1' then
			s_Draw       <= '0';
			s_BitmapAddr <= (others => '0');
			s_HOffset    <= 0;
			s_VOffset    <= 0;
		elsif rising_edge(p_Clock) then
			s_HOffset <= p_HPos - to_integer(unsigned(s_RAMOut(15 downto 0)));
			s_VOffset <= p_VPos - to_integer(unsigned(s_RAMOut(31 downto 16)));
			if (s_HOffset >= 0 and s_HOffset < c_BITMAP_WIDTH and s_VOffset >= 0 and s_VOffset < c_BITMAP_WIDTH) then
				s_BitmapAddr <= std_logic_vector(to_unsigned(s_VOffset, s_BitmapAddr'length));
				s_Draw       <= s_BitmapRow(s_HOffset);
			else
				s_Draw <= '0';
			end if;
		end if;
	end process;
	o_Draw <= s_Draw;

end Behavioral;
