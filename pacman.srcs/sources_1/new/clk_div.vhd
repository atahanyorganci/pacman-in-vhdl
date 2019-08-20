LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.pacage.ALL;

ENTITY clk_div IS
	PORT 
	(
		CLK	: IN std_logic; -- Clk 100MHz
		CLK25  : OUT std_logic;
		CLK_SLOW : out std_logic
	);
END clk_div;

ARCHITECTURE Behavioral OF clk_div IS
	SIGNAL Q : std_logic := '0';
	SIGNAL D : std_logic := '0';
	SIGNAL S : std_logic := '0';
	constant GAME_SPEED : integer := 500000;
BEGIN

	clk_div50 : PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			Q <= NOT Q;
		END IF;
	END PROCESS;
	
	clk_div25 : PROCESS (Q)
	BEGIN
		IF (rising_edge(Q)) THEN
			D <= NOT D;
		END IF;
	END PROCESS;
	CLK25 <= D;
	
	slow_clk : PROCESS (CLK)
	variable count : integer := 0;
	begin
		IF (rising_edge(CLK)) then
			count := count + 1;
			if ( count = GAME_SPEED ) then
				count := 0;
				S <= not S;
			end if;
		end if;
	end process;
	CLK_SLOW <= S;
	
END Behavioral;