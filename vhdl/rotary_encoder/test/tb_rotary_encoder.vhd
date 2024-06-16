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
entity tb_rotary_encoder is
end tb_rotary_encoder;
architecture stru of tb_rotary_encoder is

  constant F_CLK : natural := 40000000;
  constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;

  signal RESET_n : std_logic := '1';
  signal CLK : std_logic := '0';
  
  signal TL, TR		: std_logic;
  signal rot_in		: unsigned(1 downto 0) := "00";
  
  signal i		: natural := 0;


begin
  CLK <= not CLK after BOUNCE_WAIT;

  TEST: process (CLK)
  begin
    if (rising_edge(CLK)) then
   	 rot_in <= (rot_in + 1) mod 4;
	 if((i mod 16) > 7)then
	 	rot_in <= 3 - ((rot_in + 1) mod 4);
	 end if;
	 i <= i + 1;
    end if;     
  end process TEST;

  DUT: entity work.rotary_encoder(rtl)
    port map (
      CLK => CLK,
      RESET_n => RESET_n,
      TR	=> TR,
      TL	=> TL,
      rot_in	=> std_logic_vector(rot_in)
    );
end stru;
--==================================================================================
