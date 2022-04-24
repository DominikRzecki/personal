------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 19/04/2022
--File    : tb_button.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Descrition: Button
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity tb_button is
  end tb_button;
  architecture stru of tb_button is
  
    constant F_CLK : natural := 40000000;
    constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;
  
    signal RESET_n : std_logic := '1';
    signal CLK : std_logic := '0';
    
    signal btn : std_logic;
    signal btn_ph : std_logic := '1';
  
  
  begin
    btn_ph <= '0' after 2 ms;

    CLK <= not CLK after BOUNCE_WAIT;
  
    BTN0: entity work.button(mixed)
    generic map (
      F_CLK => F_CLK,
      REQ_PRESS_TIME => 20 ms
    )
    port map (
      CLK => CLK,
      RESET_n => RESET_n,
      btn_in => btn_ph,
      btn_out => btn
    );

end stru;
--==================================================================================