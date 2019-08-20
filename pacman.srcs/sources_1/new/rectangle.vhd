----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 20.08.2019
-- Module Name: rectangle - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rectangle is
	generic (
		g_HCORNER : integer := 0;
		g_VCORNER : integer := 0;
		g_WIDTH: integer := 0;
		g_HEIGHT : integer := 0
	);
	Port (
		p_HPos : in integer;
        p_VPos : in integer;
        p_Enalbe : in integer;
        p_Reset : in integer;
		o_Draw : out std_logic
	);
end rectangle;

architecture Behavioral of rectangle is

	constant c_VOFFSET : integer := g_VCORNER + g_HEIGHT;
    constant c_HOFFSET : integer := g_HCORNER + g_WIDTH;
    signal s_Draw : std_logic := '0';

begin

o_Draw <= s_Draw;

draw : process(p_HPos, p_VPos)
begin
	if((p_VPos > g_VCORNER AND p_VPos < c_VOFFSET) AND (p_HPos > g_HCORNER AND p_HPos < c_HOFFSET))then
		s_Draw <= '1';
	else
		s_Draw <= '0';
	end if;
end process ; -- draw

end Behavioral;
