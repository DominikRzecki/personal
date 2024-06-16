------------------------------------------------------------------------------------
--Project : DIC 4AHEL 
--Author  : Gr�bner
--Date    : 15/09/2020
--File    : DE10_Lite.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Description: Button Up/Down Counter, HEX
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.DE10_Lite_const_pkg.ALL;

--=======================================================================================================
entity DE10_Lite is
  port (
        MAX10_CLK1_50 :  in std_logic;
        ---------------------------------------------------------------
        KEY           :  in std_logic_vector(    keys_c - 1 downto 0);
        SW            :  in std_logic_vector(switches_c - 1 downto 0);
        LEDR          : out std_logic_vector(    leds_c - 1 downto 0);
        ---------------------------------------------------------------
        HEX0          : out std_logic_vector(7 downto 0);
        HEX1          : out std_logic_vector(7 downto 0);
        HEX2          : out std_logic_vector(7 downto 0);
        HEX3          : out std_logic_vector(7 downto 0);
        HEX4          : out std_logic_vector(7 downto 0);
        HEX5          : out std_logic_vector(7 downto 0);
        GPIO          : out std_logic_vector(35 downto 0)
        ---------------------------------------------------------------
       );
end DE10_Lite;
--=======================================================================================================

--MAX10_CLK1_50 = not MAX10_CLK1_50 after de10_cycle_time_c;

architecture rtl of DE10_Lite is
  --=====================================================================================================
  signal n_led : natural;

  constant MAX : natural := 50;

  signal R 	: unsigned(7 downto 0) := "00000000";
  signal G 	: unsigned(7 downto 0) := "00000000";
  signal B 	: unsigned(7 downto 0) := "00000000";

  signal RESET_n : std_logic := '1';

  signal counter : natural := 0;
  signal clk_n : natural := 0;

  --=====================================================================================================
begin
  --=====================================================================================================
  HEX0(7) <= '1';
  HEX1(7) <= '1';
  HEX2(7) <= '1';
  HEX3(7) <= '1';
  HEX4(7) <= '1';
  HEX5(7) <= '1';

  LEDR(1) <= not KEY(0);
  
  --=====================================================================================================

  COLORGEN: process(n_led)
  begin
	  R <= to_unsigned(counter, R'length);
	  G <= to_unsigned((counter + MAX/3) mod MAX, G'length);
	  B <= to_unsigned((counter + 2 * MAX/3) mod MAX, B'length);
  end process COLORGEN;

  COUNTER_GEN: process(clk_n)
  begin
    if(clk_n = 833332) then
      counter <= (counter + 1) mod MAX;
    end if;
  end process COUNTER_GEN; 

  CNT_GEN: process(MAX10_CLK1_50)
  begin
	  if(rising_edge(MAX10_CLK1_50)) then
      clk_n <= (clk_n + 1) mod 833333;
    end if;
  end process CNT_GEN;

  LEDS: entity work.WS2812(rtl)
    generic map ( F_CLK => (1 sec)/de10_cycle_time_c,
	          N_LED => 3	)
    port map (
      CLK => MAX10_CLK1_50,
      RESET_n => RESET_n,
      ENABLE => '1',
      r_in => R,
      g_in => G,
      b_in => B,
      led_n => n_led,
      sig_out => GPIO(35)
    );
  --=====================================================================================================

  --=====================================================================================================
end rtl;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
