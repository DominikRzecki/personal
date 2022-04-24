------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 08/04/2022
--File    : debounce.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Descrition: simple debouncer
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity debouncer is
  generic ( F_CLK             : natural;
            REQ_PRESS_TIME    : time  := 20 ms;
            SAMPLE_PERIOD     : time  := 500 us);    
  port (CLK     : in std_logic;
        sig_in  : in std_logic;
        sig_out : out std_logic);
end debouncer;

architecture rtl of debouncer is
  
  constant c_req_clk_num      : natural := SAMPLE_PERIOD / ((1 sec)/F_CLK);
  constant c_req_sample_num   : natural := REQ_PRESS_TIME / SAMPLE_PERIOD;

  signal SAMPLE_PULSE   : std_logic := '0';
  
  signal clk_counter    : natural range 0 to c_req_clk_num + 1 := 0;
  signal pulse_counter  : natural;

  signal b_sync         : std_logic_vector (1 downto 0);

begin

  BTN_SYNC: process(CLK)
  begin
      if (CLK'event and CLK = '1') then
          b_sync(0) <= not sig_in;
          b_sync(1) <= b_sync(0);
      end if;
  end process BTN_SYNC;

  SAMPLE_GEN: process (CLK)
  begin
    if (CLK'event and CLK = '1') then
      --clk_counter <= (clk_counter + 1) mod (c_req_clk_num);
      if (clk_counter = c_req_clk_num) then
        clk_counter <=  0;
        SAMPLE_PULSE   <= '1';
      else
        clk_counter <= clk_counter + 1;
        SAMPLE_PULSE   <= '0';
      end if;
    end if;

    --if (clk_counter = c_req_clk_num) then
    --  SAMPLE_PULSE <= '1';
    --else
    --  SAMPLE_PULSE <= '0';
    --end if;
  end process SAMPLE_GEN;

  CNT_PROC: process (CLK)
  begin
    if (CLK'event and CLK = '1') then
   	  if (b_sync(1) = '0') then
      		pulse_counter <= 0;
      		sig_out <= '0';
      elsif (SAMPLE_PULSE = '1') then
		    if (pulse_counter = c_req_sample_num) then
      			sig_out <= '1';
    		else	
        		pulse_counter <= pulse_counter  + 1;
    		end if;
    	end if;
    end if;
  end process CNT_PROC;

end rtl;
--==================================================================================
