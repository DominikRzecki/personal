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
entity tb_stack_of_int is
end tb_stack_of_int;
architecture stru of tb_stack_of_int is

  constant F_CLK : natural := 40000000;
  constant BOUNCE_WAIT : time := 1000000000/F_CLK/2 * 1 ns;

  signal RESET_n : std_logic := '1';
  signal CLK : std_logic := '0';
  
  signal ENA, operation     : std_logic;
  signal data_in, data_out  : integer;
  signal stack_ptr          : natural;


begin
  CLK <= not CLK after BOUNCE_WAIT;

  TEST: process (CLK)
    variable i, j : natural := 0;
  begin
    if (rising_edge(CLK)) then
      if (i < 40) then
        if (i < 20) then
          data_in <= i - 10;
          operation <= '1';
        else
          operation <= '0';
        end if;
        if(j = 1) then
          i := i + 1;
        end if;
        ENA <= '1';
      else
      end if;
      j := 1;
    else
    end if;
  end process TEST;

  DUT: entity work.stack_of_int(rtl)
    generic map (
      stack_WIDTH => 10,
      stack_SIZE => 20
    )
    port map (
      CLK => CLK,
      RESET_n => RESET_n,
      ENA => ENA,
      operation => operation,
      data_in => data_in,
      data_out => data_out,
      stack_ptr => stack_ptr
    );
end stru;
--==================================================================================
