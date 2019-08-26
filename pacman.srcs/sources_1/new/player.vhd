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
	port (
		p_Clock : in std_logic;
		p_Enable : in std_logic;
		p_Reset : in std_logic;
		p_HPos : in integer range 0 to 65535;
		p_VPos: in integer range 0 to 65535;
		p_PlayerHPos: in integer range 0 to 65535;
		p_PlayerVPos: in integer range 0 to 65535;
		o_Draw : out std_logic
	);
end player;

architecture Behavioral of player is

	constant c_BITMAP_WIDTH : integer := 40;
	signal s_BitmapAddr : std_logic_vector (5 downto 0) := "000000";
	signal s_BitmapRow : std_logic_vector (39 downto 0) := "0000000000000000000000000000000000000000";

	signal s_Draw : std_logic := '0';

	signal s_HOffset : integer range 0 to 65535 := 0;
	signal s_VOffset : integer range 0 to 65535 := 0;

COMPONENT player_rom
	PORT (
		clka : IN STD_LOGIC;
		addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
	);
END COMPONENT;

begin

c_BITMAP : player_rom PORT MAP (
	clka => p_Clock,
	addra => s_BitmapAddr,
	douta => s_BitmapRow
);

draw : process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		s_Draw <= '0';
	elsif (rising_edge(p_Clock)) then
		s_HOffset <= p_HPos - p_PlayerHPos;
		s_VOffset <= p_VPos - p_PlayerVPos;
		if (s_HOffset >= 0 and s_HOffset < c_BITMAP_WIDTH and s_VOffset >= 0 and s_VOffset < c_BITMAP_WIDTH and p_Enable = '1') then
			s_BitmapAddr <= std_logic_vector(to_unsigned(s_VOffset, s_BitmapAddr'length));
			s_Draw <= s_BitmapRow(s_HOffset);
		else
			s_Draw <= '0';
		end if;
	end if;
end process;
o_Draw <= s_Draw;

end Behavioral;
