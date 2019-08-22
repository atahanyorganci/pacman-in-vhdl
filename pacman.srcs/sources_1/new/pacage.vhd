----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: Pacage - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pacage is

procedure DRAW_MARGIN (signal HPOS, VPOS : in integer; signal DRAW : out std_logic);
procedure DRAW_RECTANGLE (signal HPOS, VPOS: in integer; constant HCORNER, VCORNER, WIDTH, HEIGHT: in integer; signal DRAW : out std_logic);
procedure DRAW_CIRCLE (signal HPOS, VPOS, HCORNER, VCORNER: in integer; signal ENABLE : in std_logic; constant RADIUS : in integer; signal DRAW : out std_logic);
procedure DRAW_FOOD (signal HPOS, VPOS : in integer; signal enable : in std_logic; constant HCORNER, VCORNER, RADIUS : in integer; signal DRAW : out std_logic);
procedure DRAW_GHOST (signal HPOS, VPOS, HCORNER, VCORNER: in integer; signal DRAW : out std_logic);
end package;

package body pacage is
-------------------------------------------------------------------------
procedure DRAW_MARGIN (signal HPOS, VPOS : in integer; signal DRAW : out std_logic) is
begin
	if((VPOS < 40 OR VPOS > 440) OR (HPOS < 120 OR HPOS > 480))then
		DRAW <= '1';
	else
		DRAW <= '0';
	end if;
end DRAW_MARGIN;
-------------------------------------------------------------------------
procedure DRAW_RECTANGLE (signal HPOS, VPOS: in integer; constant HCORNER, VCORNER, WIDTH, HEIGHT: in integer; signal DRAW : out std_logic) is
begin
	if((VPOS > VCORNER AND VPOS < VCORNER + HEIGHT) AND (HPOS > HCORNER AND HPOS < HCORNER + WIDTH))then
		DRAW <= '1';
	else
		DRAW <= '0';
	end if;
end DRAW_RECTANGLE;
-----------------------------------------------------------------------
procedure DRAW_CIRCLE (signal HPOS, VPOS, HCORNER, VCORNER: in integer; signal ENABLE : in std_logic; constant RADIUS : in integer; signal DRAW : out std_logic) is
begin
	if( (HPOS - HCORNER - RADIUS)*(HPOS - HCORNER - RADIUS) + (VPOS - VCORNER - RADIUS) * (VPOS - VCORNER - RADIUS) <= RADIUS * RADIUS and ENABLE = '1' )then
		DRAW <= '1';
	else
		DRAW <= '0';
	end if;
end DRAW_CIRCLE;
-----------------------------------------------------------------------
procedure DRAW_FOOD (signal HPOS, VPOS : in integer; signal enable : in std_logic; constant HCORNER, VCORNER, RADIUS : in integer; signal DRAW : out std_logic) is
begin 
	if (enable = '1') then
		if( (HPOS - HCORNER - RADIUS - 130)*(HPOS - HCORNER - RADIUS - 130) + (VPOS - VCORNER - RADIUS - 50) * (VPOS - VCORNER - RADIUS - 50) <= RADIUS * RADIUS )then
			DRAW <= '1';
		else
			DRAW <= '0';
		end if;
	else
		DRAW <= '0';
	end if;
end procedure;
-----------------------------------------------------------------------
procedure DRAW_GHOST (signal HPOS, VPOS, HCORNER, VCORNER: in integer; signal DRAW : out std_logic) is
begin
	if( (HPOS - HCORNER - 20)*(HPOS - HCORNER - 20) + (VPOS - VCORNER - 20) * (VPOS - VCORNER - 20) <= 100) then
		DRAW <= '1';
	elsif ((HPOS - HCORNER > 10 and HPOS - HCORNER < 30) and (VPOS - VCORNER > 20 and VPOS - VCORNER < 30)) then
		DRAW <= '1';
	else
		DRAW <= '0';
	end if;
end DRAW_GHOST;
end package body;
