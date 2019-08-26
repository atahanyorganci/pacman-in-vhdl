----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 22.08.2019
-- Module Name: VGA Driver - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_driver is
	Port (
		p_Clock : in  std_logic;
		p_Reset : in std_logic;
		p_Color : in std_logic_vector (2 downto 0);
		o_HPos : out integer;
		o_VPos : out integer;
		o_VGAHS : out std_logic;
		o_VGAVS : out std_logic;
		o_VGARed : out std_logic_vector (3 downto 0);
		o_VGAGreen : out std_logic_vector (3 downto 0);
		o_VGABlue : out std_logic_vector (3 downto 0)
	);
end vga_driver;

architecture Behavioral of vga_driver is

-- Timing Constants
-- For polarity '0' means negative polarity

-- Horizontal Axis
	constant HD : integer := 800; -- Visiable Area
	constant HFP : integer := 40; -- Front Porch
	constant HSP : integer := 128; -- Sync Pulse
	constant HBP : integer := 88; -- Back porch
	constant HPOLARITY : std_logic := '1'; -- Polartity
	constant HTOTAL : integer := HD + HFP + HSP + HBP; -- Whole Line

-- Vertical Axis
	constant VD : integer := 600; -- Visiable Area
	constant VFP : integer := 1; -- Front Porch
	constant VSP : integer := 4; -- Sync Pulse
	constant VBP : integer := 23; -- Back porch
	constant VPOLARITY : std_logic := '1'; -- Polartity
	constant VTOTAL : integer := VD + VFP + VSP + VBP; -- Whole Line

	signal s_HPos : integer := 0;
	signal s_VPos : integer := 0;
	signal s_videoOn : std_logic := '0';
	signal s_VGARed : std_logic_vector (3 downto 0) := "0000";
	signal s_VGAGreen : std_logic_vector (3 downto 0) := "0000";
	signal s_VGABlue : std_logic_vector (3 downto 0) := "0000";

begin

-- Horizontal Position Counter
HPCounter : process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		s_HPos <= 0;
	elsif (rising_edge(p_Clock)) then
		if (s_HPos = HTOTAL) then
			s_HPos <= 0;
		else
			s_HPos <= s_HPos + 1;
		end if;
	end if;
end process;
o_HPos <= s_HPos;

-- Vertical Position Counter
VPCounter :process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		s_VPos <= 0;
	elsif (rising_edge(p_Clock)) then
		if (s_HPos = HTOTAL) then
			if (s_VPos = VTOTAL) then
				s_VPos <= 0;
			else
				s_VPos <= s_VPos + 1;
			end if;
		end if;
	end if;
end process;
o_VPos <= s_VPos;

-- Horizontal Synchronisation
HSync :process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		o_VGAHS <= HPOLARITY;
	elsif (rising_edge(p_Clock)) then
		if ((s_HPos < HD + HFP) OR (s_HPos > HD + HFP + HSP)) then
			o_VGAHS <= not HPOLARITY;
		else
			o_VGAHS <= HPOLARITY;
		end if;
	end if;
end process;

-- Vertical Synchronisation
VSync : process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		o_VGAVS <= VPOLARITY;
	elsif (rising_edge(p_Clock)) then
		if ((s_VPos < VD + VFP) OR (s_VPos > VD + VFP + VSP)) then
			o_VGAVS <= not VPOLARITY;
		else
			o_VGAVS <= VPOLARITY;
		end if;
	end if;
end process;

-- Video On
videoOn : process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		s_videoOn <= '0';
	elsif (rising_edge(p_Clock)) then
		if (s_HPos <= HD and s_VPos <= VD) then
			s_videoOn <= '1';
		else
			s_videoOn <= '0';
		end if;
	end if;
end process;

colorOutput : process(p_Clock, p_Reset)
begin
	if (p_Reset = '1') then
		s_VGARed  <= (others => '1');
		s_VGAGreen <= (others => '1');
		s_VGABlue <= (others => '1');
	elsif (rising_edge(p_Clock)) then
		if (s_VideoOn = '1') then
			s_VGARed <= p_Color(2) & p_Color(2) & p_Color(2) & p_Color(2);
			s_VGAGreen <= p_Color(1) & p_Color(1) & p_Color(1) & p_Color(1);
			s_VGABlue <= p_Color(0) & p_Color(0) & p_Color(0) & p_Color(0);
		else
			s_VGARed  <= (others => '1');
			s_VGAGreen <= (others => '1');
			s_VGABlue <= (others => '1');
		end if ;
	end if;
end process;

o_VGARed <= s_VGARed;
o_VGAGreen <= s_VGAGreen;
o_VGABlue <= s_VGABlue;

end Behavioral;
