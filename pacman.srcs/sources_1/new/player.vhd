----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 20.08.2019
-- Module Name: player - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity player is
	Port (
		p_HCorner : in integer;
		p_VCorner : in integer;
		p_HPos : in integer;
        p_VPos : in integer;
        p_Enable : std_logic;
        p_Reset : in integer;
		o_Draw : out std_logic
	);
end player;

architecture Behavioral of player is

    constant c_RADIUS : integer := 15;
    constant c_RADIUS2 : integer := c_RADIUS * c_RADIUS;
    signal s_Draw : std_logic := '0';

begin

o_Draw <= s_Draw;

draw : process(p_HPos, p_VPos)
begin
    if((p_HPos - p_HCorner - c_RADIUS) * (p_HPos - p_HCorner - c_RADIUS) + (VPOS - VCORNER - c_RADIUS) * (VPOS - VCORNER - c_RADIUS) <= c_RADIUS2) then
		DRAW <= '1';
	else
		DRAW <= '0';
	end if;
end process ; -- draw

end Behavioral;