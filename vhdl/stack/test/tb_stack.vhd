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
entity tb_stack is
end tb_stack;
architecture stru of tb_stack is

  constant F_CLK : natural := 40000000;
  constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;

  signal RESET_n : std_logic := '1';
  signal CLK : std_logic := '0';
  
  signal ENA                  : std_logic := '0';
  signal data_in, data_out    : integer; --std_logic_vector(9 downto 0);
  signal stack_ptr	      : natural;
  signal operation, peek      : std_logic;

  signal i, j : integer := 0;

begin
  CLK <= not CLK after BOUNCE_WAIT;

  TEST: process (CLK)
  begin
    if (rising_edge(CLK)) then
	  ENA <= '1';
	  operation <= '1';
          data_in <= i - 11; --std_logic_vector(to_signed(i - 10, data_in'length));
	  if(j > 0) then 
	  if(i < 20) then
		operation <= '1';
	  else
		operation <= '0';
	  end if;
	  if(i > 10 and i < 30) then
		  peek <= '1';
	  else
		  peek <= '0';
	  end if; 

  	end if;
	i <= i + 1;
	j <= j + 1;
    end if;     
  end process TEST;

  DUT: entity work.stack(rtl)
    generic map (
      stack_DATATYPE => integer, --std_logic_vector(9 downto 0),
      stack_ZERO_VAL => 0, --(others => '0'),
      stack_SIZE => 20
    )
    port map (
      CLK => CLK,
      RESET_n => RESET_n,
      ENA => ENA,
      operation => operation,
      peek	=> peek,
      data_in => data_in,
      data_out => data_out,
      stack_ptr => stack_ptr
    );
end stru;
--==================================================================================
