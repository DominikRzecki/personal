------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 01/09/2022
--File    : vga.vhd
--Design  : full descending generic vga
------------------------------------------------------------------------------------
-- Descrition: vga design
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

--==================================================================================
entity vga is
  generic ( F_CLK           : natural;
            X_RES           : natural := 640;
            Y_RES           : natural := 480;
            bits            : natural := 4;
            -- Horizontal timings
            T_X_LINE        : time := 31.77 us;
            T_X_SYNC        : time := 3.77 us;
            T_X_BACK_PORCH  : time := 1.89 us;
            T_X_VIDEO       : time := 25.17 us; 
            T_X_FRONT_PORCH : time := 0.94 us;
            -- Vertical Timings
            T_Y_FRAME       : time := 16.68 ms;
            T_Y_SYNC        : time := 0.06 ms;
            T_Y_BACK_PORCH  : time := 1.02 ms;
            T_Y_VIDEO       : time := 15.25 ms; 
            T_Y_FRONT_PORCH : time := 0.35 ms
          );    
  port  ( CLK       : in std_logic;
          RESET_n   : in std_logic;
          ENA       : in std_logic;
          -- data outputs
          trig      : out std_logic := '0';
          p_x       : out integer := -1;
          p_y       : out integer := -1;
          -- data inputs
          p_r       : in unsigned(bits - 1 downto 0);
          p_g       : in unsigned(bits - 1 downto 0);
          p_b       : in unsigned(bits - 1 downto 0);
          -- VGA outputs
          h_sync    : out std_logic;
          v_sync    : out std_logic;
          vga_r     : out std_logic_vector(bits - 1 downto 0);
          vga_g     : out std_logic_vector(bits - 1 downto 0);
          vga_b     : out std_logic_vector(bits - 1 downto 0)
        );
end vga;

architecture rtl of vga is

  -- vertical signals
  signal O                    : std_logic := '0';
  signal inv_v_sync           : std_logic := '0';
  signal back_porch_v         : std_logic := '0';
  signal frame                : std_logic := '0';

  -- horizontal signals
  signal A_gen_out, A_firstp,A: std_logic := '0';
  signal inv_h_sync           : std_logic := '0';
  signal back_porch_h         : std_logic := '0';
  signal row                  : std_logic := '0';
  signal row_ena              : std_logic := '0';

  -- pixels
  signal pix_trig             : std_logic := '0';
  signal x                    : integer := -1; 
  signal y                    : integer := -1; 

  -- constants for low clock speeds
  constant T_X_VIDEO_ADJ      : time := time(floor( real((T_X_VIDEO/X_RES)/ns) / real(1000000000/F_CLK) + 0.5) * (sec/F_CLK)) * X_RES;
  constant T_Y_VIDEO_ADJ      : time := time(floor( real((T_Y_VIDEO/Y_RES)/ns) / real(1000000000/F_CLK) + 0.5) * (sec/F_CLK)) * Y_RES;


  constant colors             : natural := 2**bits;

  signal frame_old            : std_logic := '0';

  type state_type is (SYNC, BACK_PORCH, VIDEO_TIME FRONT_PORCH);

  signal v_state              : state_type := SYNC;
  signal h_state              : state_type := SYNC;

  signal v_counter            : natural := 0;
  signal h_counter            : natural := 0;

begin
  v_sync <= not inv_v_sync;
  h_sync <= not inv_h_sync;
  p_y <= y;
  p_x <= x;
  trig <= pix_trig;
  
  -- pixel generator

  PIXEL_GEN: entity work.pulse_gen(rtl)
    generic map (F_CLK => F_CLK, FREQ => sec/(T_X_VIDEO/X_RES), START_HIGH => true)
    port map (CLK => CLK, ENABLE => row, sig_out => pix_trig);

  X_GEN: process (pix_trig, row)
  begin
    if(rising_edge(pix_trig)) then
      if(row = '1' and frame = '1') then
        x <= (x + 1) mod X_RES;
      else
        x <= -1;
      end if;
    end if;
  end process;

  Y_GEN: process (row, frame)
  begin
    if (rising_edge(row)) then
      if(frame = '1') then
        y <= (y + 1) mod Y_RES;
      else 
        y <= -1;
      end if;
    end if;
  end process;

  RGB_GEN: process (p_r, p_g, p_b, row, frame) 
  begin
    if (frame = '1' and row = '1') then
      vga_r <= std_logic_vector(p_r);
      vga_g <= std_logic_vector(p_g);
      vga_b <= std_logic_vector(p_b);
    else
      vga_r <= (others => '0');
      vga_g <= (others => '0');
      vga_b <= (others => '0');
    end if;
  end process;
end architecture rtl;
--==================================================================================
