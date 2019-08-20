----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: VGA - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pacage.ALL;

entity VGA is
    Port ( 
			CLK : in  STD_LOGIC;
			RESET : in STD_LOGIC;
			PLAYER_H : in integer;
			PLAYER_V : in integer;
			PLAYER_RST : out std_logic;
			RED_H : in integer;
			RED_V : in integer;
			CYAN_H : in integer;
			CYAN_V : in integer;
			GHOST_RST : out std_logic;
			SCORE : out integer range 0 to 32;
			VGA_HS : out  STD_LOGIC;
			VGA_VS : out  STD_LOGIC;
			VGA_RED : out  STD_LOGIC_VECTOR (3 downto 0);
			VGA_GREEN : out  STD_LOGIC_VECTOR (3 downto 0);
			VGA_BLUE : out  STD_LOGIC_VECTOR (3 downto 0)
		   );
end VGA;

architecture Behavioral of VGA is
----------------------------------------------------------------------------------
-- VGA sync signals 
-- Horizontal Axis
	constant HD : integer := 639;  --  639   Horizontal Display (640)
	constant HFP : integer := 16;  --   16   Right border (front porch)
	constant HSP : integer := 96;  --   96   Sync pulse (Retrace)
	constant HBP : integer := 48;  --   48   Left boarder (back porch)
-- Vertical Axis
	constant VD : integer := 479;  --  479   Vertical Display (480)
	constant VFP : integer := 10;  --   10   Right border (front porch)
	constant VSP : integer := 2;   --    2   Sync pulse (Retrace)
	constant VBP : integer := 33;  --   33   Left boarder (back porch)
----------------------------------------------------------------------------------
-- Logic Signals
-- Game Reset
	signal RST : std_logic := '0';
-- VGA Draw Positions
	signal hPos : integer := 0; -- Horizontal Draw
	signal vPos : integer := 0; -- Vertical Draw
	signal videoOn : std_logic := '0';
-- DRAW signals for entities
	signal MARGIN : STD_LOGIC := '0'; -- Draw signal for margins
	signal RECTANGLE : std_logic_vector (9 downto 0) := "0000000000"; -- Draw signal for rectangle obstacles
	signal ALIVE : STD_LOGIC := '1'; 
	signal PLAYER : std_logic := '0'; -- Draw signal for Pacman sprite
	signal RED_GHOST, CYAN_GHOST : std_logic := '0'; -- Draw signal for Ghost sprites
	signal enableFood : std_logic_vector (21 downto 0) := "1111111111111111111111";
	signal FOOD : std_logic_vector (21 downto 0) := "0000000000000000000000";
	signal currentScore : integer range 0 to 32 := 0;
----------------------------------------------------------------------------------
-- constants
begin
-------------------------------------------------------------------------
Horizontal_position_counter:process(CLK, RST)
begin
	if(RST = '1')then
		hpos <= 0;
	elsif(rising_edge(CLK))then
		if (hPos = (HD + HFP + HSP + HBP)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
end process;
-------------------------------------------------------------------------
Vertical_position_counter:process(CLK, hPos, RST)
begin
	if(RST = '1')then
		vPos <= 0;
	elsif(rising_edge(CLK))then
		if(hPos = (HD + HFP + HSP + HBP))then
			if (vPos = (VD + VFP + VSP + VBP)) then
				vPos <= 0;
			else
				vPos <= vPos + 1;
			end if;
		end if;
	end if;
end process;
-------------------------------------------------------------------------
Horizontal_Synchronisation:process(CLK, hPos, RST)
begin
	if(RST = '1')then
		VGA_HS <= '0';
	elsif(rising_edge(CLK))then
		if((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP))then
			VGA_HS <= '1';
		else
			VGA_HS <= '0';
		end if;
	end if;
end process;
-------------------------------------------------------------------------
Vertical_Synchronisation:process(CLK, vPos, RST)
begin
	if(RST = '1')then
		VGA_VS <= '0';
	elsif(rising_edge(CLK))then
		if((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP))then
			VGA_VS <= '1';
		else
			VGA_VS <= '0';
		end if;
	end if;
end process;
-------------------------------------------------------------------------
video_on:process(CLK, hPos, vPos, RST)
begin
	if(RST = '1')then
		videoOn <= '0';
	elsif(rising_edge(CLK))then
		if(hPos <= HD and vPos <= VD)then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;
-------------------------------------------------------------------------
draw:process(CLK, RST, hPos, vPos, videoOn)
begin
	if(RST = '1')then
		VGA_RED   <= "0000";
		VGA_GREEN <= "0000";
		VGA_BLUE   <= "0000";
	elsif(rising_edge(CLK))then
		if(videoOn = '1')then
			if(MARGIN = '1')then
				VGA_RED <= "0000";
				VGA_GREEN <= "0000";
				VGA_BLUE <= "1111";
			elsif ( RECTANGLE /= "0000000000") then
				VGA_RED <= "0000";
				VGA_GREEN <= "0000";
				VGA_BLUE <= "1111";
			elsif (RED_GHOST = '1') then 
				VGA_RED <= "1111";
				VGA_GREEN <= "0000";
				VGA_BLUE <= "0000";
			elsif (CYAN_GHOST = '1') then 
				VGA_RED <= "0000";
				VGA_GREEN <= "1111";
				VGA_BLUE <= "1111";
			elsif ( FOOD /= "0000000000000000000000") then
				VGA_RED <= "1111";
				VGA_GREEN <= "0000";
				VGA_BLUE <= "1111";
			elsif ( PLAYER = '1') then
				VGA_RED <= "1111";
				VGA_GREEN <= "1111";
				VGA_BLUE <= "0000";
			else
				VGA_RED <= "0000";
				VGA_GREEN <= "0000";
				VGA_BLUE <= "0000";
			end if;
		else
			VGA_RED   <= "0000";
			VGA_GREEN <= "0000";
			VGA_BLUE   <= "0000";
		end if;
	end if;
end process;
-------------------------------------------------------------------------
detect_eat : process(CLK, PLAYER, FOOD, RST)
begin
	if (rising_edge(CLK)) then
		if (RST = '0') then
			for i in 0 to 21 loop
				if(PLAYER = '1' AND FOOD(i) = '1') then
					enableFood(i) <= '0';
					currentScore <= currentScore + 1;
				end if;
			end loop;
		else
			currentScore <= 0;
			enableFood <= "1111111111111111111111";
		end if;
	end if;
end process;
-------------------------------------------------------------------------
detect_spook : process(CLK, PLAYER, FOOD, RST)
begin
	if (rising_edge(CLK)) then
		if (RST = '0') then
			if(PLAYER = '1' AND (CYAN_GHOST = '1' OR RED_GHOST = '1')) then
				ALIVE <= '0';
			end if;
		else	
			ALIVE <= '1';
		end if;
	end if;
end process;
-------------------------------------------------------------------------
game_check : process(CLK, enableFood, ALIVE, RST)
begin
if (falling_edge(CLK)) then
	if (RST = '0') then
		if (enableFood = "0000000000000000000000" or ALIVE = '0' or RESET = '1') then
			RST <= '1';
			PLAYER_RST <= '1';
			GHOST_RST <= '1';
		else 
			RST <= '0';
			PLAYER_RST <= '0';
			GHOST_RST <= '0';
		end if;
	else
		RST <= '0';
		PLAYER_RST <= '0';
		GHOST_RST <= '0';
	end if;
end if;
end process;
-------------------------------------------------------------------------
SCORE <= currentScore;

DRAW_MARGIN(hPos, vPos, MARGIN); -- margins
-- RECTANGLE OBSTACLE
DRAW_RECTANGLE(hPos, vPos, 160, 80, 120, 60,  RECTANGLE(0)); -- rectangle 1
DRAW_RECTANGLE(hPos, vPos, 320, 80, 120, 60,  RECTANGLE(1)); -- rectangle 2
DRAW_RECTANGLE(hPos, vPos, 160, 180, 40, 120, RECTANGLE(2)); -- rectangle 3
DRAW_RECTANGLE(hPos, vPos, 240, 180, 120, 41, RECTANGLE(3)); -- rectangle 4
DRAW_RECTANGLE(hPos, vPos, 400, 180, 40, 120, RECTANGLE(4)); -- rectangle 5
DRAW_RECTANGLE(hPos, vPos, 280, 220, 40, 41, RECTANGLE(5)); -- rectangle 6
DRAW_RECTANGLE(hPos, vPos, 240, 260, 120, 80, RECTANGLE(6)); -- rectangle 7
DRAW_RECTANGLE(hPos, vPos, 160, 340, 40, 60, RECTANGLE(7)); -- rectangle 8
DRAW_RECTANGLE(hPos, vPos, 240, 380, 120, 61, RECTANGLE(8)); -- rectangle 9
DRAW_RECTANGLE(hPos, vPos, 400, 340, 40, 60, RECTANGLE(9)); -- rectangle 10

DRAW_CIRCLE(hPos, vPos, PLAYER_H, PLAYER_V, ALIVE, 15, PLAYER); -- PLAYER 

-- FOOD MAGENTA CIRCLES
-- FIRST LINE
DRAW_FOOD(hPos, vPos, enableFood(0), 0, 0, 10, FOOD(0)); -- Food 1
DRAW_FOOD(hPos, vPos, enableFood(1), 80, 0, 10, FOOD(1)); -- Food 2
DRAW_FOOD(hPos, vPos, enableFood(2), 160, 0, 10, FOOD(2)); -- Food 3
DRAW_FOOD(hPos, vPos, enableFood(3), 240, 0, 10, FOOD(3)); -- Food 4
DRAW_FOOD(hPos, vPos, enableFood(4), 320, 0, 10, FOOD(4)); -- Food 5
-- THIRD LINE
DRAW_FOOD(hPos, vPos, enableFood(5), 0, 100, 10, FOOD(5)); -- Food 6
DRAW_FOOD(hPos, vPos, enableFood(6), 80, 100, 10, FOOD(6)); -- Food 7
DRAW_FOOD(hPos, vPos, enableFood(7), 160, 100, 10, FOOD(7)); -- Food 8
DRAW_FOOD(hPos, vPos, enableFood(8), 240, 100, 10, FOOD(8)); -- Food 9
DRAW_FOOD(hPos, vPos, enableFood(9), 320, 100, 10, FOOD(9)); -- Food 10
-- FIFTH LINE
DRAW_FOOD(hPos, vPos, enableFood(10), 0, 180, 10, FOOD(10)); -- Food 11
DRAW_FOOD(hPos, vPos, enableFood(11), 120, 180, 10, FOOD(11)); -- Food 12
DRAW_FOOD(hPos, vPos, enableFood(12), 200, 180, 10, FOOD(12)); -- Food 13
DRAW_FOOD(hPos, vPos, enableFood(13), 320, 180, 10, FOOD(13)); -- Food 14
-- SEVENTH LINE
DRAW_FOOD(hPos, vPos, enableFood(14), 0, 260, 10, FOOD(14)); -- Food 15
DRAW_FOOD(hPos, vPos, enableFood(15), 80, 260, 10, FOOD(15)); -- Food 16
DRAW_FOOD(hPos, vPos, enableFood(16), 240, 260, 10, FOOD(16)); -- Food 17
DRAW_FOOD(hPos, vPos, enableFood(17), 320, 260, 10, FOOD(17)); -- Food 18
-- NINETH LINE
DRAW_FOOD(hPos, vPos, enableFood(18), 0, 360, 10, FOOD(18)); -- Food 19
DRAW_FOOD(hPos, vPos, enableFood(19), 80, 360, 10, FOOD(19)); -- Food 20
DRAW_FOOD(hPos, vPos, enableFood(20), 240, 360, 10, FOOD(20)); -- Food 21
DRAW_FOOD(hPos, vPos, enableFood(21), 320, 360, 10, FOOD(21)); -- Food 22

DRAW_GHOST(hPos, vPos, RED_H, RED_V, RED_GHOST);
DRAW_GHOST(hPos, vPos, CYAN_H, CYAN_V, CYAN_GHOST);
end Behavioral;