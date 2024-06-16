------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Dominik Rzecki
--Date    : 18/02/2021
--File    : bin_to_bcd_2.vhd
--Design  : Double dabble algorithm
------------------------------------------------------------------------------------
-- Description: Convert binary into decimal numbers.
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--=======================================================================================================
entity bin_to_bcd_2 is
  port (
        RESET_n	  	:  in std_logic;
        ---------------------------------------------------------------
        CLK        	:  in std_logic;
        BIN        	:  in unsigned(6 downto 0);
        BCD_0     	:  out unsigned(3 downto 0);
        BCD_1     	:  out unsigned(3 downto 0)
        );
        --------------------------------------------------------------
        
end bin_to_bcd_2;
--=======================================================================================================

architecture rtl of bin_to_bcd_2 is
  --
  type state_type is (ST_LOAD, ST_ADJUST, ST_SHIFT, ST_WRITE); --===================================================================================================
  signal sreg 		: unsigned(6 downto 0);
  signal digit_0	: unsigned(3 downto 0);
  signal digit_1	: unsigned(3 downto 0);
  signal n			: natural range 0 to 6;
  
  signal state 		: state_type;
  
  --=====================================================================================================
begin
	--=====================================================================================================
-- finite state machine
	FSM: process (CLK, RESET_n)
	begin
		if(RESET_n = '0') then
			digit_0	<= 	(others => '0');
			digit_1	<= 	(others => '0');
			BCD_0	<= 	(others => '0');
			BCD_1	<= 	(others => '0');
			state 	<= 	ST_LOAD;
			n 		<= 	6;
			sreg 	<= 	(others => '0');
			
		elsif (CLK'event and CLK = '1') then
			case state is
				when ST_LOAD =>
					sreg 	<= 	BIN;
					n	 	<= 	6;
					digit_0	<= 	(others => '0');
					digit_1	<= 	(others => '0');
					state	<= ST_ADJUST;
				
				when ST_ADJUST =>
					if(digit_0 > 4) then
						digit_0 <= digit_0 + 3;
					end if;
					
					if(digit_1 > 4) then
						digit_1 <= digit_1 + 3;
					end if;	
					
					state	<=	ST_SHIFT;
				
				when ST_SHIFT =>
					digit_1	<= 	digit_1(2 downto 0) & digit_0(3);
					digit_0	<= 	digit_0(2 downto 0) & sreg(6);
					sreg	<=	sreg(5 downto 0) & '0';
					
					if(n > 0) then
						n <= n - 1;
						state <= ST_ADJUST;
						
					else
						state <= ST_WRITE;
					
					end if;
					
				when ST_WRITE =>
					BCD_0	<=	digit_0;
					BCD_1	<=	digit_1;
					state	<= ST_LOAD;
			end case;
		end if;
	end process FSM;
  --=====================================================================================================
end rtl;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
