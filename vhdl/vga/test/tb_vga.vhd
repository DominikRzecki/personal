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
entity tb_vga is
end tb_vga;
architecture stru of tb_vga is

  constant F_CLK : natural := 50000000;
  constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;

  signal RESET_n : std_logic := '1';
  signal CLK : std_logic := '0';
  
  signal ENA                  : std_logic := '0';

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
  signal vga_r     : std_logic_vector(3 downto 0);
  signal vga_g     : std_logic_vector(3 downto 0);
  signal vga_b     : std_logic_vector(3 downto 0);

begin

  CLK <= not CLK after BOUNCE_WAIT;

  ENA <= '1' after 10 ms; 

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

  DUT: entity work.vga(rtl)
    generic map (
      F_CLK => F_CLK
    )
    port map (
      RESET_n => RESET_n,
      CLK => CLK,
      ENA => ENA,
      p_x => p_x,
      p_y => p_y,
      trig => trig,
      p_r => p_r,
      p_g => p_g,
      p_b => p_b,
      h_sync => h_sync,
      v_sync => v_sync,
      vga_r => vga_r,
      vga_g => vga_g,
      vga_b => vga_b
    );
end stru;
--==================================================================================
