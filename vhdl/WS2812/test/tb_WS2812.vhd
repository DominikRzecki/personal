------------------------------------------------------------------------------------
--Project : DIC 4BHEL 
--Author  : Rzecki
--Date    : 20/09/2022
--File    : tb_rotary_encoder.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Descrition: rotary encoder
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity tb_WS2812 is
end tb_WS2812;
architecture stru of tb_WS2812 is

  constant F_CLK : natural := 50000000;
  constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;

  signal RESET_n : std_logic := '1';
  signal CLK : std_logic := '0';
  
  signal sig_out : std_logic;
  signal n_led : natural;

  signal R 	: unsigned(7 downto 0) := "00000000";
  signal G 	: unsigned(7 downto 0) := "00000000";
  signal B 	: unsigned(7 downto 0) := "00000000";
begin
  CLK <= not CLK after BOUNCE_WAIT;

  COLORGEN: process(n_led)
  begin
	  R <= to_unsigned(50, R'length);
	  G <= to_unsigned(0, G'length);
	  B <= to_unsigned(0, B'length);
  end process COLORGEN;

  DUT: entity work.WS2812(rtl)
    generic map ( F_CLK => F_CLK,
	          N_LED => 3	)
    port map (
      CLK => CLK,
      RESET_n => RESET_n,
      ENABLE => '1',
      r_in => R,
      g_in => G,
      b_in => B,
      led_n => n_led,
      sig_out => sig_out
    );
end stru;
--==================================================================================
