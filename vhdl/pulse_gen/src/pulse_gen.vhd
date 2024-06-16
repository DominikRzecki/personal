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
            FREQ              : natural );    
  port (  CLK       : in std_logic;
          ENABLE    : in std_logic;
          sig_out   : out std_logic );
end pulse_gen;

architecture rtl of pulse_gen is
  
  constant c_req_clk_num  : natural := ((1 sec)/FREQ) / ((1 sec)/F_CLK);

  signal clk_cnt          : natural := 0;

begin

  CNT: process (CLK)
  begin
    if( rising_edge(CLK) ) then
      if( ENABLE = '1' ) then
        clk_cnt <= (clk_cnt + 1) mod (c_req_clk_num + 1);
      else
        clk_cnt <= 0;
      end if;
    end if;
  end process CNT;

  GEN: process (clk_cnt)
  begin
    if( clk_cnt = c_req_clk_num ) then
      sig_out <= '1';
    else
      sig_out <= '0';
    end if;
  end process GEN;

end rtl;
--==================================================================================