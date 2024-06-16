------------------------------------------------------------------------------------
--Project : DIC 4BHEL
--Author  : Rzecki
--Date    : 20/09/2022
--File    : rotary_encoder.vhd
--Design  : rotary_encoder
------------------------------------------------------------------------------------
-- Descrition: rotary_encoder
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity rotary_encoder is
  port (CLK       	: in std_logic;
        RESET_n   	: in std_logic;
  	rot_in		: in std_logic_vector(1 downto 0);
	TL, TR		: out std_logic := '0' ); 
end entity rotary_encoder;

architecture rtl of rotary_encoder is

	type rot_state_type is (ST_00, ST_11, ST_TR, ST_TL, ST_WAIT);

	signal current_state	: rot_state_type := ST_00;

begin


  PROC: process (CLK)
  begin
    if (RESET_n = '0') then
	current_state <= ST_00;
    elsif (rising_edge(CLK)) then
	    	case current_state is
		    	when ST_00 =>
			    case rot_in is
				when "01" =>
					current_state <= ST_TL;
				when "10" =>
   					current_state <= ST_TR;
				when "11" =>
					current_state <= ST_11;
				when others => 
					current_state <= ST_00;
			    end case;
			    
			    TL <= '0';
			    TR <= '0';

			when ST_11 =>
			    case rot_in is
				when "01" =>
					current_state <= ST_TR;
				when "10" =>
   					current_state <= ST_TL;
				when "00" =>
					current_state <= ST_00;
				when others => 
					current_state <= ST_11;
			    end case;

			    TL <= '0';
		 	    TR <= '0';
			
		    	when ST_TL =>
				   
			    current_state <= ST_WAIT;
			    TL <= '1';
 			
			when ST_TR =>
			    
			    current_state <= ST_WAIT;
			    TR <= '1';
			
			when ST_WAIT =>
			    case rot_in is
				when "00" =>
					current_state <= ST_00;
				when "11" =>
   					current_state <= ST_11;
				when others => 
					current_state <= ST_WAIT;
			    end case;

			    TL <= '0'; 
			    TR <= '0';

			--when others => current_state <= ST_00;
		end case;	
    end if;

  end process PROC;

 
  
end architecture rtl;
--==================================================================================
