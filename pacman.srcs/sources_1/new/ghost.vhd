----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 20.08.2019
-- Module Name: ghost - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ghost is
	Port (
		p_HCorner : in integer;
		p_VCorner : in integer;
		p_HPos : in integer;
        p_VPos : in integer;
        p_Enable : std_logic;
        p_Reset : in integer;
		o_Draw : out std_logic
	);
end ghost;

architecture Behavioral of ghost is

    signal s_Draw : std_logic := '0';

begin

o_Draw <= s_Draw;

draw : process(p_HPos, p_VPos)
begin
    if((p_HPos - p_HCorner - 20) * (p_HPos - p_HCorner - 20) + (VPOS - VCORNER - 20) * (VPOS - VCORNER - 20) <= 100) then
		DRAW <= '1';
	elsif ((p_HPos - p_HCorner > 10 and p_HPos - p_HCorner < 30) and (VPOS - VCORNER > 20 and VPOS - VCORNER < 30)) then
		DRAW <= '1';
	else
		DRAW <= '0';
	end if;
end process ; -- draw

end Behavioral;