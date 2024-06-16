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
        VGA_R         : out std_logic_vector(3 downto 0);
        VGA_G         : out std_logic_vector(3 downto 0);
        VGA_B         : out std_logic_vector(3 downto 0);
        VGA_HS        : out std_logic;
        VGA_VS        : out std_logic;
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
  alias CLK: std_logic is MAX10_CLK1_50;
  constant F_CLK : natural := 50000000;
  signal ENA                  : std_logic := '1';

  -- data inputs
  signal trig      : std_logic := '0';
  signal p_x       : integer;
  signal p_y       : integer;
  signal p_r       : unsigned(4 - 1 downto 0);
  signal p_g       : unsigned(4 - 1 downto 0);
  signal p_b       : unsigned(4 - 1 downto 0);
  -- VGA outputs
  signal h_sync    : std_logic;
  signal v_sync    : std_logic;

  --=====================================================================================================
begin
  --=====================================================================================================
  HEX0(7) <= '1';
  HEX1(7) <= '1';
  HEX2(7) <= '1';
  HEX3(7) <= '1';
  HEX4(7) <= '1';
  HEX5(7) <= '1';

  -- VGA_HS  <= h_sync;
  -- VGA_VS  <= v_sync;

  IMG_GEN: process (p_y, trig)
  begin
    if(true) then
      --if( p_y > 200)then
        p_r <= to_unsigned(15, p_r'length);
        p_g <= to_unsigned(0, p_r'length);
        p_b <= to_unsigned(0, p_r'length);
      --else 
      --  p_r <= to_unsigned(0, p_r'length);
      --  p_g <= to_unsigned(0, p_r'length);
      --  p_b <= to_unsigned(0, p_r'length);
      --end if;
    end if;
  end process;
  
  --=====================================================================================================
  VGA: entity work.vga(rtl)
    generic map (
      F_CLK => F_CLK
    )
    port map (
      RESET_n => KEY(0),
      CLK => CLK,
      ENA => ENA,
      p_x => p_x,
      p_y => p_y,
      trig => trig,
      p_r => p_r,
      p_g => p_g,
      p_b => p_b,
      h_sync => VGA_HS,
      v_sync => VGA_VS,
      vga_r => vga_r,
      vga_g => vga_g,
      vga_b => vga_b
    );
  --=====================================================================================================

  --=====================================================================================================
end rtl;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
