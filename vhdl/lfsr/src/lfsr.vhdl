
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr is
	generic(
		BITWIDTH	: natural := 8
		);
	port (
		CLK, RESET_n	: in std_logic;
		seed		: in std_logic_vector(BITWIDTH - 1 downto 0);
		input		: in std_logic;
		output		: out std_logic_vector(BITWIDTH - 1 downto 0)
	    	);
end entity lfsr;


architecture fibonacci_rtl of lfsr is

signal reg 	 	: std_logic_vector(BITWIDTH - 1 downto 0) := (others => '0');	
signal feedback		: std_logic := '0';

begin

	output <= reg;

	XOR_PROC: process(reg, seed)
		variable val : std_logic := '0';
	begin
		val := reg(0);
		for i in 1 to BITWIDTH - 1 loop
			val := val xor (reg(i) and seed(i));
		end loop;
		feedback <= val;
	end process;

	UPDATE: process(CLK, RESET_n)
	begin
		if(RESET_n = '0') then
			reg <= (others => '0');
		elsif (rising_edge(CLK)) then
			reg <= (feedback xor input) & reg(BITWIDTH - 1 downto 1);
		end if;
	end process;

end architecture fibonacci_rtl;
