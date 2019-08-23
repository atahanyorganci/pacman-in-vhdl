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
	generic (
		g_HINIT : integer := 200;
		g_VINIT : integer := 140;
		g_HCORNER : integer := 360;
		g_VCORNER : integer := 340
	);
	port (
		p_GameClock : in std_logic;
		p_VGAClock : in std_logic;
		p_Reset : in std_logic;
		p_HPos : in integer;
		p_VPos: in integer;
		o_Draw : out std_logic
	);
end ghost;

architecture Behavioral of ghost is

	constant c_BITMAP : std_logic_vector (0 to 399) := "0000000001111000000000000011111111100000000011111111111110000001111111111111110000111111111111111110001111111111111111100111111111111111111101111111111111111111011111111111111111110111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
	constant c_BITMAP_WIDTH : integer := 20;
	signal s_GhostHPos : integer := g_HINIT;
	signal s_GhostVPos : integer := g_VINIT;
	signal s_Draw : std_logic := '0';

	signal s_HOffset : integer := 0;
	signal s_VOffset : integer := 0;
	signal s_BitmapIndex : integer := 0;

begin

move : process(p_GameClock, p_Reset)
	
begin
	if (p_Reset = '1') then
		s_GhostHPos <= g_HINIT;
		s_GhostVPos <= g_VINIT;
	elsif (rising_edge(p_GameClock)) then
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

draw : process(p_VGAClock, p_Reset)
begin
	if (p_Reset = '1') then
		s_Draw <= '0';
	elsif (rising_edge(p_VGAClock)) then
		s_HOffset <= p_HPos - s_GhostHPos;
		s_VOffset <= p_VPos - s_GhostVPos;
		if (s_HOffset >= 0 and s_HOffset < c_BITMAP_WIDTH and s_VOffset >= 0 and s_VOffset < c_BITMAP_WIDTH) then
			s_BitmapIndex <= s_VOffset * c_BITMAP_WIDTH + s_HOffset;
			s_Draw <= c_BITMAP(s_BitmapIndex);
		else
			s_Draw <= '0';
		end if;
	end if;
end process;
o_Draw <= s_Draw;

end Behavioral;
