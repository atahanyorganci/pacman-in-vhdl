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
			o_Score : out integer range 0 to 65535;
			o_HighScore : out integer range 0 to 65535;
			VGA_HS : out  STD_LOGIC;
			VGA_VS : out  STD_LOGIC;
			VGA_RED : out  STD_LOGIC_VECTOR (3 downto 0);
			VGA_GREEN : out  STD_LOGIC_VECTOR (3 downto 0);
			VGA_BLUE : out  STD_LOGIC_VECTOR (3 downto 0)
		);
end VGA;

architecture Behavioral of VGA is

-- VGA sync signals
-- For polarity '0' means negative polarity

-- Horizontal Axis
	constant HD : integer := 800; -- Visiable Area
	constant HFP : integer := 40; -- Front Porch
	constant HSP : integer := 128; -- Sync Pulse
	constant HBP : integer := 88; -- Back porch
	constant c_HPOLARITY : std_logic := '1'; -- Polartity
	constant c_HTOTAL : integer := HD + HFP + HSP + HBP; -- Whole Line

-- Vertical Axis
	constant VD : integer := 600; -- Visiable Area
	constant VFP : integer := 1; -- Front Porch
	constant VSP : integer := 4; -- Sync Pulse
	constant VBP : integer := 23; -- Back porch
	constant c_VPOLARITY : std_logic := '1'; -- Polartity
	constant c_VTOTAL : integer := VD + VFP + VSP + VBP; -- Whole Line

-- Logic Signals
-- Game Reset
	signal RST : std_logic := '0';
-- VGA Draw Positions
	signal hPos : integer := 0; -- Horizontal Draw
	signal vPos : integer := 0; -- Vertical Draw
	signal s_videoOn : std_logic := '0';
-- DRAW signals for entities
	signal MARGIN : STD_LOGIC := '0'; -- Draw signal for margins
	signal s_Rectangle : std_logic_vector (9 downto 0) := "0000000000"; -- Draw signal for rectangle obstacles
	signal ALIVE : STD_LOGIC := '1'; 
	signal PLAYER : std_logic := '0'; -- Draw signal for Pacman sprite
	signal RED_GHOST, CYAN_GHOST : std_logic := '0'; -- Draw signal for Ghost sprites
	signal enableFood : std_logic_vector (21 downto 0) := "1111111111111111111111";
	signal FOOD : std_logic_vector (21 downto 0) := "0000000000000000000000";
	signal s_Score : integer range 0 to 65535 := 0;
	signal s_HighScore : integer range 0 to 65535 := 0;

begin

-- Horizontal Position Counter
HPCounter : process(CLK, RST)
begin
	if (RST = '1') then
		hpos <= 0;
	elsif (rising_edge(CLK)) then
		if (hPos = (c_HTOTAL)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
end process;

-- Vertical Position Counter
VPCounter :process(CLK, RST)
begin
	if (RST = '1') then
		vPos <= 0;
	elsif (rising_edge(CLK)) then
		if (hPos = c_HTOTAL) then
			if (vPos = c_VTOTAL) then
				vPos <= 0;
			else
				vPos <= vPos + 1;
			end if;
		end if;
	end if;
end process;

-- Horizontal Synchronisation
HSync :process(CLK, RST)
begin
	if (RST = '1') then
		VGA_HS <= c_HPOLARITY;
	elsif (rising_edge(CLK)) then
		if ((hPos < HD + HFP) OR (hPos > HD + HFP + HSP)) then
			VGA_HS <= not c_HPOLARITY;
		else
			VGA_HS <= c_HPOLARITY;
		end if;
	end if;
end process;

-- Vertical Synchronisation
VSync : process(CLK, RST)
begin
	if(RST = '1')then
		VGA_VS <= c_VPOLARITY;
	elsif (rising_edge(CLK)) then
		if ((vPos < VD + VFP) OR (vPos > VD + VFP + VSP)) then
			VGA_VS <= not c_VPOLARITY;
		else
			VGA_VS <= c_VPOLARITY;
		end if;
	end if;
end process;

-- Video On
videoOn : process(CLK, RST)
begin
	if (RST = '1') then
		s_videoOn <= '0';
	elsif (rising_edge(CLK)) then
		if (hPos <= HD and vPos <= VD) then
			s_videoOn <= '1';
		else
			s_videoOn <= '0';
		end if;
	end if;
end process;

-- Draw
draw : process(CLK, RST)
begin
	if(RST = '1')then
		VGA_RED   <= "0000";
		VGA_GREEN <= "0000";
		VGA_BLUE   <= "0000";
	elsif(rising_edge(CLK))then
		if(s_videoOn = '1')then
			if(MARGIN = '1')then
				VGA_RED <= "0000";
				VGA_GREEN <= "0000";
				VGA_BLUE <= "1111";
			elsif ( s_Rectangle /= "0000000000") then
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
			VGA_RED <= "0000";
			VGA_GREEN <= "0000";
			VGA_BLUE <= "0000";
		end if;
	end if;
end process;

-- Detect Eat
detectEat : process(CLK, RST)
begin
	if (RST = '1') then
		s_Score <= 0;
		enableFood <= "1111111111111111111111";
	else
		if (rising_edge(CLK)) then
			for i in 0 to 21 loop
				if(FOOD(i) = '1' AND PLAYER = '1') then
					enableFood(i) <= '0';
					s_Score <= s_Score + 1;
					if (s_Score > s_HighScore) then
						s_HighScore <= s_Score;
					end if;
				end if;
			end loop;
		end if;
	end if;
end process;
o_Score <= s_Score;
o_HighScore <= s_HighScore;

-- Detect Spook
detectSpook : process(CLK, RST)
begin
	if (RST = '0') then
		if (rising_edge(CLK)) then
			if (PLAYER = '1' AND (CYAN_GHOST = '1' OR RED_GHOST = '1')) then
				ALIVE <= '0';
			end if;
		end if;
	else
		ALIVE <= '1';
	end if;
end process;

-- Game Check
gameCheck : process(CLK, RST)
begin
	if (RST = '0') then
		if (falling_edge(CLK)) then
			if (enableFood = "0000000000000000000000" or ALIVE = '0' or RESET = '1') then
				RST <= '1';
				PLAYER_RST <= '1';
				GHOST_RST <= '1';
			else 
				RST <= '0';
				PLAYER_RST <= '0';
				GHOST_RST <= '0';
			end if;
		end if;
	else
		RST <= '0';
		PLAYER_RST <= '0';
		GHOST_RST <= '0';
	end if;
end process;

DRAW_MARGIN(hPos, vPos, MARGIN); -- margins
-- RECTANGLE OBSTACLE
DRAW_RECTANGLE(hPos, vPos, 160, 80, 120, 60,  s_Rectangle(0)); -- rectangle 1
DRAW_RECTANGLE(hPos, vPos, 320, 80, 120, 60,  s_Rectangle(1)); -- rectangle 2
DRAW_RECTANGLE(hPos, vPos, 160, 180, 40, 120, s_Rectangle(2)); -- rectangle 3
DRAW_RECTANGLE(hPos, vPos, 240, 180, 120, 41, s_Rectangle(3)); -- rectangle 4
DRAW_RECTANGLE(hPos, vPos, 400, 180, 40, 120, s_Rectangle(4)); -- rectangle 5
DRAW_RECTANGLE(hPos, vPos, 280, 220, 40, 41, s_Rectangle(5)); -- rectangle 6
DRAW_RECTANGLE(hPos, vPos, 240, 260, 120, 80, s_Rectangle(6)); -- rectangle 7
DRAW_RECTANGLE(hPos, vPos, 160, 340, 40, 60, s_Rectangle(7)); -- rectangle 8
DRAW_RECTANGLE(hPos, vPos, 240, 380, 120, 61, s_Rectangle(8)); -- rectangle 9
DRAW_RECTANGLE(hPos, vPos, 400, 340, 40, 60, s_Rectangle(9)); -- rectangle 10

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