------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki000
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
entity tb_debouncer is
end tb_debouncer;
architecture stru of tb_debouncer is

  constant F_CLK : natural := 40000000;
  constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;

  signal RESET_n : std_logic := '1';
  signal CLK : std_logic := '0';
  
  signal btn : std_logic;
  signal btn_ph : std_logic := '0';


begin
  CLK <= not CLK after BOUNCE_WAIT;

  btn_ph <= '1' after 2 ms;

  DUT: entity work.debouncer(rtl)
    generic map (
      F_CLK => F_CLK,
      SAMPLE_PERIOD => 500 us,
      REQ_PRESS_TIME => 20 ms
    )
    port map (
      CLK => CLK,
      RESET_n => RESET_n,
      sig_in => btn_ph,
      sig_out => btn
    );
end stru;
--==================================================================================
