----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 21.08.2019
-- Module Name: VGA Driver - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ghost_path is
	generic (
		g_HINIT : integer := 200;
		g_VINIT : integer := 140;
		g_HCORNER : integer := 360;
		g_VCORNER : integer := 340
	);
	port (
		p_Clock : in std_logic;
		p_Reset : in std_logic;
		o_VPos : out integer;
		o_HPos : out integer
	);
end ghost_path;

architecture Behavioral of ghost_path is

	signal s_HTemp : integer := g_HINIT;
	signal s_VTemp : integer := g_VINIT;

begin

move : process(p_Clock, p_Reset) 
begin
	if (p_Reset = '1') then
		s_HTemp <= g_HINIT;
		s_VTemp <= g_VINIT;
	elsif (rising_edge(p_Clock)) then
		if (s_HTemp = g_HINIT and s_VTemp < g_VCORNER) then 
			s_VTemp <= s_VTemp + 1;
		elsif (s_VTemp = g_VCORNER and s_HTemp < g_HCORNER) then
			s_HTemp <= s_HTemp + 1;
		elsif (s_HTemp = g_HCORNER and s_VTemp > g_VINIT) then
			s_VTemp <= s_VTemp - 1;
		elsif (s_VTemp = g_VINIT and s_HTemp > g_HINIT) then 
			s_HTemp <= s_HTemp - 1;
		end if;
	end if;
end process;
o_HPos <= s_HTemp;
o_VPos <= s_VTemp;

end Behavioral;
