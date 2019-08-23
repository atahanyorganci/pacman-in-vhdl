----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 21.08.2019
-- Module Name: Seven Segment Driver - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ssd_controller is
	Port ( 
		p_Clock : in std_logic;
		p_Score : in integer range 0 to 65535;
		p_Highscore: in integer range 0 to 65535;
		o_Anode : out std_logic_vector (3 downto 0);
		o_Cathode : out std_logic_vector (6 downto 0)
	);
end ssd_controller;

architecture Behavioral of ssd_controller is

	constant c_MAXCOUNT : integer := 500000;
	signal s_Temp : std_logic_vector (1 downto 0);
	signal s_MuxOutput : integer range 0 to 32 := 0;

begin

-- Clock signal for the SSD
SSD_CLOCK : process (p_Clock)
variable  count : integer := 0;
begin
	if rising_edge(p_Clock) then
		if(count = c_MAXCOUNT) then
			case s_Temp is
				when "00" => s_Temp <= "01";
				when "01" => s_Temp <= "10";
				when "10" => s_Temp <= "11";
				when "11" => s_Temp <= "00";
				when others => s_Temp <= "00";
			end case;
			count := 0;
		else
			count := count + 1;
		end if;
	end if;
end process;

-- Decode s_Temp signal for asserting the anodes
INVERTED_DECODER : process( s_Temp )
begin
	case s_Temp is
		when "00" => o_Anode <= "1110";
		when "01" => o_Anode <= "1101";
		when "10" => o_Anode <= "1011";
		when "11" => o_Anode <= "0111";
		when others => o_Anode <= "0000";
	end case;
end process;

-- Encoder for the cathodes
DECIMAL_TO_SSD : process (s_MuxOutput) is
begin
	case s_MuxOutput is
		when 0 => o_Cathode <= "1000000"; -- 0
		when 1 => o_Cathode <= "1111001"; -- 1
		when 2 => o_Cathode <= "0100100"; -- 2
		when 3 => o_Cathode <= "0110000"; -- 3
		when 4 => o_Cathode <= "0011001"; -- 4
		when 5 => o_Cathode <= "0010010"; -- 5
		when 6 => o_Cathode <= "0000010"; -- 6
		when 7 => o_Cathode <= "1111000"; -- 7
		when 8 => o_Cathode <= "0000000"; -- 8
		when 9 => o_Cathode <= "0011000"; -- 9
		when 10 => o_Cathode <= "0001000"; -- A
		when 11 => o_Cathode <= "0000011"; -- B
		when 12 => o_Cathode <= "1000110"; -- C
		when 13 => o_Cathode <= "0100001"; -- D
		when 14 => o_Cathode <= "0000110"; -- E
		when 15 => o_Cathode <= "0001110"; -- F
		when others => o_Cathode <= "0000000"; -- Dont cause implied memory
	end case;
end process;

-- Multiplexer for the the display
MUX : process (s_Temp, p_Score, p_Highscore) is
begin
	case s_Temp is
		when "00" => s_MuxOutput <= p_Score mod 16;
		when "01" => s_MuxOutput <= p_Score / 16;
		when "10" => s_MuxOutput <= p_Highscore mod 16;
		when "11" => s_MuxOutput <= p_Highscore / 16;
		when others => s_MuxOutput <= 0;
	end case;
end process;

end Behavioral;
