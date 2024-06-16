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
entity monoflop is
  generic ( F_CLK             : natural;
            PULSE_LENGTH      : time;
            INV               : boolean := false );    
  port (  CLK       : in std_logic;
          ENABLE    : in std_logic;
          sig_in    : in std_logic;
          sig_out   : out std_logic );
end monoflop;

architecture rtl of monoflop is
  
  constant cnt_max  : natural := natural(real(F_CLK) * real(PULSE_LENGTH / ns)/real(1000000000));

  signal clk_cnt          : natural range 0 to cnt_max := 0;
  signal sig_in_old       : std_logic := '0';

begin

  CNT: process (CLK, sig_in, ENABLE)
  begin
    if( ENABLE = '1' ) then
      if( rising_edge(CLK) ) then
        if(clk_cnt > 0) then
          clk_cnt <= clk_cnt - 1;
        end if;
      end if;

      if((sig_in = '1' and sig_in_old = '0' and not INV) or (sig_in = '0' and sig_in_old = '1'  and INV)) then
        clk_cnt <= cnt_max;
      end if;
    else
      clk_cnt <= 0;
    end if;
    sig_in_old <= sig_in;
  end process CNT;

  GEN: process (clk_cnt)
  begin
    if( clk_cnt > 0 ) then
      sig_out <= '1';
    else
      sig_out <= '0';
    end if;
  end process GEN;

end rtl;
--==================================================================================