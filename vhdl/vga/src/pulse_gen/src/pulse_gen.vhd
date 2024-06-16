------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 29/04/2022
--File    : pulse_gen.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Descrition: Pulse generator.
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity pulse_gen is
  generic ( F_CLK             : natural;
            FREQ              : natural;
            START_HIGH        : boolean := false);   
  port (  CLK       : in std_logic;
          ENABLE    : in std_logic;
          sig_out   : out std_logic );
end pulse_gen;

architecture rtl of pulse_gen is
  
  constant c_req_clk_num  : natural := ((1 sec)/FREQ) / ((1 sec)/F_CLK);

  signal clk_cnt          : integer range -1 to c_req_clk_num := -1;
  signal ENABLE_OLD       : std_logic := '0';

begin

  CNT: process (CLK, ENABLE)
  begin
    if(ENABLE = '1') then
      if( rising_edge(CLK)) then
        clk_cnt <= (clk_cnt + 1) mod (c_req_clk_num + 1);
      end if;
      if(ENABLE_OLD = '0') then
        clk_cnt <= (clk_cnt + 1) mod (c_req_clk_num + 1);
      end if;
    else
      clk_cnt <= -1;
    end if;
    ENABLE_OLD <= ENABLE;
  end process CNT;

  GEN: process (clk_cnt)
  begin
    if( ((clk_cnt = c_req_clk_num) and not START_HIGH) or ((clk_cnt = 0) and START_HIGH)) then
      sig_out <= '1';
    else
      sig_out <= '0';
    end if;
  end process GEN;

end rtl;
--==================================================================================