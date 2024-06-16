------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Gr�bner
--Date    : 19/02/2020
--File    : DE10_Lite.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Description: LED blink all leds
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--=======================================================================================================
entity tb_bin_to_bcd_2 is
end tb_bin_to_bcd_2;

architecture bhv of tb_bin_to_bcd_2 is
	signal clk		: std_logic := '0';
	signal reset_n 		: std_logic;
	signal bin 		: unsigned(6 downto 0);
	signal bcd_0 		: unsigned(3 downto 0);
	signal bcd_1 		: unsigned(3 downto 0);

begin
	clk <= not CLK after 20 ns;
	reset_n <= '0', '1' after 60 ns;
	
	DUT: entity work.bin_to_bcd_2(rtl)
		port map (RESET_n => reset_n, CLK => clk, BIN => bin, BCD_0 => bcd_0, BCD_1 => bcd_1);
		
	process
		begin
			bin	<=	"0001010";
			wait for 20 ns;
			
		wait;
	end process;
---------------------------------------------------
end bhv;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
