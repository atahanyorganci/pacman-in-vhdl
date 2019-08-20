----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 20.08.2019
-- Module Name: circle - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity circle is
	generic (
		g_HCORNER : integer := 0;
		g_VCORNER : integer := 0;
		g_RADIUS : integer := 0
	);
	Port (
		p_HPos : in integer;
        p_VPos : in integer;
        p_Enable : std_logic;
        p_Reset : in integer;
		o_Draw : out std_logic
	);
end circle;

architecture Behavioral of circle is

	constant c_VOFFSET : integer := g_VCORNER + g_RADIUS;
    constant c_HOFFSET : integer := g_HCORNER + g_RADIUS;
    constant c_RADIUS2 : integer := g_RADIUS * g_RADIUS;
    signal s_Draw : std_logic := '0';

begin

o_Draw <= s_Draw;

draw : process(p_HPos, p_VPos)
begin
    if ((p_HPos - c_HOFFSET) * (p_HPos - c_HOFFSET) + (p_VPos - c_VOFFSET) * (p_VPos - c_VOFFSET) <= c_RADIUS2 and 
    p_Enable = '1') then
		s_Draw <= '1';
	else
		s_Draw <= '0';
	end if;
end process ; -- draw

end Behavioral;
