----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 26.08.2019
-- Module Name: Player - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity player is
	Port(
		p_Clock     : in  std_logic;
		p_Reset     : in  std_logic;
		p_Move      : in  std_logic;
		p_Direction : in  std_logic_vector(3 downto 0);
		p_HPos      : in  integer range 0 to 65535;
		p_VPos      : in  integer range 0 to 65535;
		o_Draw      : out std_logic
	);
end player;

architecture Behavioral of player is

	COMPONENT player_rom
		Port(
			clka  : IN  STD_LOGIC;
			addra : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
		);
	END COMPONENT;

	constant c_BITMAP_WIDTH : integer := 40;

	signal s_BitmapAddr : std_logic_vector(5 downto 0);
	signal s_BitmapRow  : std_logic_vector(39 downto 0);
	signal s_Draw       : std_logic;
	signal s_HOffset    : integer range 0 to 65535;
	signal s_VOffset    : integer range 0 to 65535;

	signal s_PlayerH : integer;
	signal s_PlayerV : integer;

begin

	c_BITMAP : player_rom
		Port MAP(
			clka  => p_Clock,
			addra => s_BitmapAddr,
			douta => s_BitmapRow
		);
	process(p_Clock, p_Reset)
	begin
		if (p_Reset = '1') then
			s_PlayerH <= 281;
			s_PlayerV <= 91;
		elsif (rising_edge(p_Clock)) then
			if p_Direction(0) = '1' and p_Move = '1' then
				if (s_PlayerV < 80 and s_PlayerV > 40) then
					if (s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 140 and s_PlayerV > 80) then
					if (s_PlayerH - 1 > 120 and s_PlayerH < 160) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH - 1 > 280 and s_PlayerH < 320) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH - 1 > 440 and s_PlayerH < 480) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 180) then
					if (s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 220 and s_PlayerV > 180) then
					if ((s_PlayerH < 160 and s_PlayerH - 1 > 120) or (s_PlayerH < 240 and s_PlayerH - 1 > 200) or (s_PlayerH < 400 and s_PlayerH - 1 > 360) or (s_PlayerH < 480 and s_PlayerH - 1 > 440)) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 260 and s_PlayerV > 220) then
					if (s_PlayerH < 160 and s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 280 and s_PlayerH - 1 > 200) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 400 and s_PlayerH - 1 > 320) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 480 and s_PlayerH - 1 > 440) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 300) then
					if (s_PlayerH < 160 and s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 240 and s_PlayerH - 1 > 200) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 400 and s_PlayerH - 1 > 360) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 480 and s_PlayerH - 1 > 440) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 340) then
					if (s_PlayerH < 240 and s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 480 and s_PlayerH - 1 > 360) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 380) then
					if (s_PlayerH < 160 and s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 400 and s_PlayerH - 1 > 200) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 480 and s_PlayerH - 1 > 440) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 390) then
					if (s_PlayerH < 160 and s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 240 and s_PlayerH - 1 > 200) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 400 and s_PlayerH - 1 > 320) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 480 and s_PlayerH - 1 > 440) then
						s_PlayerH <= s_PlayerH - 1;
					else
						s_PlayerH <= s_PlayerH - 1;
					end if;
				elsif (s_PlayerV < 430) then
					if (s_PlayerH < 240 and s_PlayerH - 1 > 120) then
						s_PlayerH <= s_PlayerH - 1;
					elsif (s_PlayerH < 480 and s_PlayerH - 1 > 360) then
						s_PlayerH <= s_PlayerH - 1;
					end if;
				else
					s_PlayerH <= s_PlayerH - 1;
				end if;
			elsif p_Direction(1) = '1' and p_Move = '1' then
				if (s_PlayerV < 80 and s_PlayerV > 40) then
					if (s_PlayerH + 31 < 480) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 140 and s_PlayerV > 80) then
					if (s_PlayerH + 31 < 160 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 320 and s_PlayerH > 280) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 440) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 180 and s_PlayerV > 140) then
					if (s_PlayerH + 31 < 480) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 220 and s_PlayerV > 180) then
					if ((s_PlayerH + 31 < 160 and s_PlayerH > 120) or (s_PlayerH + 31 < 240 and s_PlayerH > 200) or (s_PlayerH + 31 < 400 and s_PlayerH > 360) or (s_PlayerH + 31 < 480 and s_PlayerH > 440)) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 260 and s_PlayerV > 220) then
					if (s_PlayerH + 31 < 160 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 280 and s_PlayerH > 200) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 400 and s_PlayerH > 320) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 440) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 300) then
					if (s_PlayerH + 31 < 160 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 240 and s_PlayerH > 200) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 400 and s_PlayerH > 360) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 440) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 340) then
					if (s_PlayerH + 31 < 240 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 360) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 380) then
					if (s_PlayerH + 31 < 160 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 400 and s_PlayerH > 200) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 440) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 390) then
					if (s_PlayerH + 31 < 160 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 240 and s_PlayerH > 200) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 400 and s_PlayerH > 320) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 440) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				elsif (s_PlayerV < 430) then
					if (s_PlayerH + 31 < 240 and s_PlayerH > 120) then
						s_PlayerH <= s_PlayerH + 1;
					elsif (s_PlayerH + 31 < 480 and s_PlayerH > 360) then
						s_PlayerH <= s_PlayerH + 1;
					end if;
				else
					s_PlayerH <= s_PlayerH + 1;
				end if;
			elsif p_Direction(2) = '1' and p_Move = '1' then
				if (s_PlayerH < 240 and s_PlayerV > 200) or (s_PlayerV < 400 and s_PlayerV > 360) then
					if (s_PlayerV + 31 < 440) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 160 and s_PlayerH > 120) then
					if (s_PlayerV + 31 < 440) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 200 and s_PlayerH > 160) then
					if (s_PlayerV + 31 < 80) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 180 and s_PlayerV > 140) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 340 and s_PlayerV > 300) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 440 and s_PlayerV > 400) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 280 and s_PlayerH > 240) then
					if (s_PlayerV + 31 < 80) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 180 and s_PlayerV > 140) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 260 and s_PlayerV > 220) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 380 and s_PlayerV > 340) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 320 and s_PlayerH > 280) then -- Middle
					if (s_PlayerV + 31 < 180) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 380 and s_PlayerV > 340) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 360 and s_PlayerH > 320) then
					if (s_PlayerV + 31 < 80) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 180 and s_PlayerV > 140) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 260 and s_PlayerV > 220) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 380 and s_PlayerV > 340) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 440 and s_PlayerH > 400) then
					if (s_PlayerV + 31 < 80) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 180 and s_PlayerV > 140) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 340 and s_PlayerV > 300) then
						s_PlayerV <= s_PlayerV + 1;
					elsif (s_PlayerV + 31 < 440 and s_PlayerV > 400) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				elsif (s_PlayerH < 480 and s_PlayerH > 400) then
					if (s_PlayerV + 31 < 440) then
						s_PlayerV <= s_PlayerV + 1;
					end if;
				else
					s_PlayerV <= s_PlayerV + 1;
				end if;
			elsif p_Direction(3) = '1' and p_Move = '1' then
				if (s_PlayerH < 240 and s_PlayerV > 200) or (s_PlayerV < 400 and s_PlayerV > 360) then
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 160 and s_PlayerH > 120) then
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 200 and s_PlayerH > 160) then
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 140 and s_PlayerV < 180) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 300 and s_PlayerV < 340) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 400 and s_PlayerV < 440) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 280 and s_PlayerH > 240) then
					if (s_PlayerV - 1 < 40) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 140 and s_PlayerV < 180) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 260 and s_PlayerV < 220) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 380 and s_PlayerV < 340) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 320 and s_PlayerH > 280) then -- Middle
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 340 and s_PlayerV > 380) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 360 and s_PlayerH > 320) then
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 140 and s_PlayerV < 180) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 220 and s_PlayerV < 260) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 340 and s_PlayerV < 380) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 440 and s_PlayerH > 400) then
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 180 and s_PlayerV < 140) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 340 and s_PlayerV < 300) then
						s_PlayerV <= s_PlayerV - 1;
					elsif (s_PlayerV - 1 > 440 and s_PlayerV < 400) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				elsif (s_PlayerH < 480 and s_PlayerH > 400) then
					if (s_PlayerV - 1 > 40) then
						s_PlayerV <= s_PlayerV - 1;
					end if;
				else
					s_PlayerV <= s_PlayerV - 1;
				end if;
			end if;
		end if;
	end process;

	draw : process(p_Clock, p_Reset)
	begin
		if (p_Reset = '1') then
			s_Draw       <= '0';
			s_BitmapAddr <= (others => '0');
			s_HOffset    <= 0;
			s_VOffset    <= 0;
		elsif (rising_edge(p_Clock)) then
			s_HOffset <= p_HPos - s_PlayerH;
			s_VOffset <= p_VPos - s_PlayerV;
			if (s_HOffset >= 0 and s_HOffset < c_BITMAP_WIDTH and s_VOffset >= 0 and s_VOffset < c_BITMAP_WIDTH) then
				s_BitmapAddr <= std_logic_vector(to_unsigned(s_VOffset, s_BitmapAddr'length));
				s_Draw       <= s_BitmapRow(s_HOffset);
			else
				s_Draw <= '0';
			end if;
		end if;
	end process;
	o_Draw <= s_Draw;

end Behavioral;
