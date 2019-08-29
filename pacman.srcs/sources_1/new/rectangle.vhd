----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 26.08.2019
-- Module Name: Rectangle - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rectangle is
	generic(
		g_HCORNER : integer := 200;
		g_VCORNER : integer := 140;
		g_WIDTH   : integer := 200;
		g_HEIGHT  : integer := 140
	);
	Port(
		p_Clock : in  std_logic;
		p_Reset : in  std_logic;
		p_HPos  : in  integer range 0 to 65535;
		p_VPos  : in  integer range 0 to 65535;
		o_Draw  : out std_logic
	);
end rectangle;

architecture Behavioral of rectangle is

	constant c_HOFFSET : integer := g_HCORNER + g_WIDTH;
	constant c_VOFFSET : integer := g_VCORNER + g_HEIGHT;
	signal s_Draw      : std_logic;

begin

	draw : process(p_Clock, p_Reset)
	begin
		if (p_Reset = '1') then
			s_Draw <= '0';
		elsif (rising_edge(p_Clock)) then
			if ((p_HPos >= g_HCORNER and p_HPos < c_HOFFSET) and (p_VPos >= g_VCORNER and p_VPos < c_VOFFSET)) then
				s_Draw <= '1';
			else
				s_Draw <= '0';
			end if;
		end if;
	end process;
	o_Draw <= s_Draw;

end Behavioral;
