------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 01/09/2022
--File    : double_dabble.vhd
--Design  : full descending generic double_dabble
------------------------------------------------------------------------------------
-- Descrition: double_dabble design
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

--==================================================================================
entity double_dabble is
  generic (	ALPHABET_SIZE 	: natural range 3 to 64;
	   	BIN_BITWIDTH 	: natural;
	   	BCD_COUNT 	: natural
   );
  port (CLK       : in std_logic;
	RESET_n   : in std_logic;
	ENA       : in std_logic;
	bin_in    : in std_logic_vector(BIN_BITWIDTH - 1 downto 0);
	bcd_out   : out std_logic_vector(BCD_COUNT * natural(ceil(log(2.00, real(ALPHABET_SIZE)))) - 1 downto 0) := (others => '0')
);
end entity double_dabble;

architecture rtl of double_dabble is

	signal shift_cnt	: natural := 0;

begin
	CLK_PROC: process(CLK, RESET_n)
	begin
		
	end process CLK_PROC;
end architecture rtl;
--==================================================================================
