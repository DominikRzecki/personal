
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cos_gen is
end entity tb_cos_gen;

architecture stru of tb_cos_gen is
constant F_CLK		: natural := 50000000;
	
	constant BOUNCE_WAIT	: time := 1000000000/F_CLK/2 * 1 ns;

	signal RESET_n 		: std_logic := '1';
	signal CLK 		: std_logic := '0';

	signal output 		: signed(31 downto 0);
begin

	CLK <= not CLK after BOUNCE_WAIT;

	RESET_n <= '0' after 10 * 20 ns - 5 ns;

	DUT: entity work.cos_gen(rtl) 
	generic map (
			F_CLK => F_CLK,
			Q_M => 16,
			Q_N => 16,
			FS => real(F_CLK),
			F => 4000.0
		    )
	port map (
		 	CLK => CLK,
			RESET_n => RESET_n,
			ENA => '1',
			output => output
		 );

end architecture stru;
