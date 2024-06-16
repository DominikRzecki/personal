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
        HEX5          : out std_logic_vector(7 downto 0)
        ---------------------------------------------------------------
       );
end DE10_Lite;
--=======================================================================================================

--MAX10_CLK1_50 = not MAX10_CLK1_50 after de10_cycle_time_c;

architecture rtl of DE10_Lite is
  --=====================================================================================================
  signal count, count_mod      : natural := 0;
  --=====================================================================================================
begin
  --=====================================================================================================

  count_mod <= count mod 10;

  HEX0(6 downto 0) <= not (disp_array_c(count_mod));

  --=====================================================================================================
  BTN_1: entity work.counter(rtl)
  generic map (
    F_CLK => natural(de10_clk_freq_c),
    SPEED => 10,
    MAX_VAL => 500
  )
  port map (
    CLK => MAX10_CLK1_50,
    RESET_n => '1',
    enabled => true,
    val => count
  );
  --=====================================================================================================

  --=====================================================================================================
end rtl;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
