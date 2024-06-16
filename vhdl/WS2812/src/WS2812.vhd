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
entity WS2812 is
  generic ( F_CLK             : natural;
	    N_LED	      : natural );   
  port (  CLK       : in std_logic;
          ENABLE    : in std_logic;
  	  RESET_n   : in std_logic;
	  r_in      : in unsigned(7 downto 0);
          g_in 	    : in unsigned(7 downto 0); 
	  b_in      : in unsigned(7 downto 0);
	  led_n	    : out natural; 
          sig_out   : out std_logic );
end WS2812;

architecture rtl of WS2812 is
  
  constant c_req_clk_num  : natural := (1.25 us) / ((1 sec)/F_CLK);
  constant on_time_1	  : natural := natural(0.72 * real(c_req_clk_num));
  constant on_time_0	  : natural := natural(0.28 * real(c_req_clk_num));

  signal clk_cnt          : natural := 0;

  signal led_cnt	  : natural := 0;

  signal bit_cnt	  : natural := 0;

  type state_t is ( ST_RESET, ST_START, ST_0, ST_1, ST_BIT_CHOOSE, ST_COUNT_LED );

  signal state	          : state_t := ST_START;

  signal bits_24	  : std_logic_vector( 23 downto 0);

begin

  bits_24 <= std_logic_vector(b_in) & std_logic_vector(r_in) & std_logic_vector(g_in);
  led_n   <= led_cnt;

  FSM: process (CLK)
  begin
    if( RESET_n = '0' ) then
      state <= ST_START;	    
    elsif( rising_edge(CLK) ) then
	
	case (state) is
	  when ST_START =>
	    bit_cnt <= 0;
	    led_cnt <= 0;
	    clk_cnt <= 0;
	    if( ENABLE = '0' ) then
	    	state <= ST_RESET;
	    else
		state <= ST_COUNT_LED;
	    end if;
	  when ST_COUNT_LED =>
		led_cnt <= led_cnt + 1;
		if( led_cnt < N_LED) then
			state <= ST_BIT_CHOOSE;
		else
			state <= ST_RESET;
			led_cnt <= 0;
		end if;
	  when ST_BIT_CHOOSE =>
		if( bit_cnt < 24) then
			if( bits_24(23 - bit_cnt) = '0') then
				state <= ST_0;
			else
				state <= ST_1;
			end if;
		else
			state <= ST_COUNT_LED;
			bit_cnt <= 0;
		end if;
	  when ST_0 =>
		if( clk_cnt <= on_time_0 ) then
			sig_out <= '1';
		else
			sig_out <= '0';
		end if;
		clk_cnt <= clk_cnt + 1;
		if( clk_cnt = c_req_clk_num ) then
			bit_cnt <= bit_cnt + 1;
			clk_cnt <= 0;
			state <= ST_BIT_CHOOSE;
		end if;
	  when ST_1 =>
		if( clk_cnt <= on_time_1 ) then
			sig_out <= '1';
		else
			sig_out <= '0';
		end if;
		clk_cnt <= clk_cnt + 1;
		if( clk_cnt = c_req_clk_num ) then
			bit_cnt <= bit_cnt + 1;
			clk_cnt <= 0;
			state <= ST_BIT_CHOOSE;
		end if;
	  when ST_RESET =>
		sig_out <= '0';
		clk_cnt <= clk_cnt + 1;
		if( clk_cnt = 25000 ) then
			clk_cnt <= 0;
			state <= ST_START;
		end if;
	  when others => state <= ST_START;
	end case;
    end if;
  end process FSM;
end rtl;
--==================================================================================
