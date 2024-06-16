
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_lfsr is
end entity tb_lfsr;

architecture stru of tb_lfsr is
constant F_CLK		: natural := 40000000;
	
	constant BOUNCE_WAIT	: time := 1000000000/F_CLK/2 * 1 ns;

	signal RESET_n 		: std_logic := '1';
	signal CLK 		: std_logic := '0';
	signal input 		: std_logic := '1';
	signal output		: std_logic_vector(7 downto 0);

	signal counter		: natural := 0;

begin

	CLK <= not CLK after BOUNCE_WAIT;

	TEST_PROC: process (CLK)
	begin
		if(rising_edge(CLK)) then
			if(counter = 0) then
				input <= '0';
			end if;

			counter <= counter + 1;
		end if;

	end process;

	DUT: entity work.lfsr(fibonacci_rtl) 
	generic map (
			BITWIDTH => 8
		    )
	port map (
		 	CLK => CLK,
			RESET_n => RESET_n,
			seed => "11000011",
			input => input,
			output => output
		 );

end architecture stru;
