----------------------------------------------------------------------------------
-- Engineer: Atahan Yorganci
-- Create Date: 19.12.2018
-- Module Name: Score Seven Segment Display - Behavioral
-- Project Name: Pacman
-- Target Devices: BASYS 3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity score_ssd is
    Port ( 
    		 SCORE : in integer range 0 to 32;
    		 HIGHSCORE: in integer range 0 to 32;
           clock: in STD_LOGIC;
           ANODE : out STD_LOGIC_VECTOR (3 downto 0);
           CATHODE : out STD_LOGIC_VECTOR (6 downto 0));
end score_ssd;

architecture Behavioral of score_ssd is
	constant MAX_COUNT : integer := 6250; -- Adjust the refresh rate of the clock signal
	signal TEMP : STD_LOGIC_VECTOR(1 downto 0); -- Intermediate two bit clock signal for inverted decoder
	signal MUX_OUT : integer range 0 to 32 := 0; -- Multiplexer output
begin
-- Clock signal for the SSD
SSD_CLOCK : process (clock)
variable  count : integer := 0;
begin
	if rising_edge( clock ) then
		if( count = MAX_COUNT ) then
			case TEMP is
				when "00" => TEMP <= "01";
				when "01" => TEMP <= "10";
				when "10" => TEMP <= "11";
				when "11" => TEMP <= "00";
				when others => TEMP <= "00";
			end case;
			count := 0;
		else
			count := count + 1;
		end if;
	end if;
end process;
-- Decode TEMP signal for asserting the anodes
INVERTED_DECODER : process( TEMP )
begin
	case TEMP is
		when "00" => ANODE <= "1110";
		when "01" => ANODE <= "1101";
		when "10" => ANODE <= "1011";
		when "11" => ANODE <= "0111";
		when others => ANODE <= "0000";
	end case;
end process;
-- Encoder for the cathodes
DECIMAL_TO_SSD : process (MUX_OUT) is
begin
	case MUX_OUT is
		when 0 => CATHODE <= "1000000"; -- 0
		when 1 => CATHODE <= "1111001"; -- 1
		when 2 => CATHODE <= "0100100"; -- 2
		when 3 => CATHODE <= "0110000"; -- 3
		when 4 => CATHODE <= "0011001"; -- 4
		when 5 => CATHODE <= "0010010"; -- 5
		when 6 => CATHODE <= "0000010"; -- 6
		when 7 => CATHODE <= "1111000"; -- 7
		when 8 => CATHODE <= "0000000"; -- 8
		when 9 => CATHODE <= "0011000"; -- 9
		when others => CATHODE <= "0000000"; -- Dont cause implied memory
	end case;
end process;
-- Multiplexer for the the display
MUX : process (TEMP, SCORE, HIGHSCORE) is
begin
	case TEMP is
		when "00" => MUX_OUT <= SCORE - 10 * (SCORE / 10);
		when "01" => MUX_OUT <= SCORE / 10;
		when "10" => MUX_OUT <= HIGHSCORE - 10 * (HIGHSCORE / 10);
		when "11" => MUX_OUT <= HIGHSCORE / 10;
		when others => MUX_OUT <= 0;
	end case;
end process;
end Behavioral;

