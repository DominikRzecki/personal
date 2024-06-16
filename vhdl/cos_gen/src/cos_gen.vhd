------------------------------------------------------------------------------------
--Project : DIC 5BHEL 
--Author  : Rzecki
--Date    : 17/01/2024
--File    : cos_gen.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
 -- Descrition: Counter
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

--==================================================================================
entity cos_gen is
  generic ( 		F_CLK			: natural;
		 	Q_M			: natural;
			Q_N			: natural;
			FS			: real;		   	
        		F			: real );
  port (RESET_n 	: in std_logic;
        CLK     	: in std_logic;
        ENA 		: in std_logic;
        output  	: out signed(Q_M + Q_N - 1 downto 0));
end cos_gen;

architecture rtl of cos_gen is

	function to_fixed( input : real; Q_M : natural; Q_N : natural ) return signed is
			variable output : signed(Q_M + Q_N - 1 downto 0 );
		begin	
			if (input >= 0.0) then
				output := to_signed(integer(input * 2.0 ** Q_N), Q_M + Q_N);
			else
				output := to_signed(integer(input * 2.0 ** Q_N) + 1, Q_M + Q_N);
			end if;
			return output;
	end function to_fixed;

	
	constant BITWIDTH : natural := Q_M + Q_N;
 
	constant OMEGA : real := (2.0 * MATH_PI * F/FS);

	type array_of_signed is array(natural range <>) of signed(BITWIDTH - 1 downto 0);

	constant A	: array_of_signed := (to_fixed(1.0, Q_M, Q_N), to_fixed(-2.0*cos(OMEGA), Q_M, Q_N), to_fixed(1.0, Q_M, Q_N));
	constant B	: array_of_signed := (to_signed(0, BITWIDTH), to_fixed(-1.0*cos(OMEGA), Q_M, Q_N), to_signed(0, BITWIDTH));
	
	signal x : signed(BITWIDTH - 1 downto 0) := to_fixed(1.0, Q_M, Q_N); 
	signal y : signed(BITWIDTH - 1 downto 0) := to_signed(0, BITWIDTH); 

	
begin

	output <= y;
	
	COS_GEN: process(CLK, RESET_n)
		variable z : array_of_signed(1 downto 0) := (to_signed(0, BITWIDTH), to_signed(0, BITWIDTH));
		variable sum : signed(BITWIDTH - 1 downto 0);
	begin
		if(falling_edge(RESET_n))
		then
		-- asynchronous assertion
			y <= to_signed(0, BITWIDTH);
			z := (others => to_signed(0, BITWIDTH));
			x <= to_fixed(1.0, Q_M, Q_N);

		elsif(rising_edge(CLK) and (RESET_n = '0') and (ENA = '1'))
		then
		-- synchronous deassertion & 2. order IIR filter
			sum := x + z(0);
			z(0) := z(1) + shift_right(x * b(1) - sum * a(1), Q_N)(BITWIDTH - 1 downto 0);
			z(1) := shift_right(-sum * a(2), Q_N)(BITWIDTH - 1 downto 0);
			x <= to_signed(0, BITWIDTH);
			y <= sum(BITWIDTH - 1 downto 0);
		end if;
	end process COS_GEN;


end rtl;
--==================================================================================
