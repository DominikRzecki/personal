------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 06/05/2022
--File    : stack_of_int.vhd
--Design  : stack_of_int design
------------------------------------------------------------------------------------
-- Descrition: stack_of_int design
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity stack_of_int is
  generic ( stack_WIDTH       : natural  := 8;
            stack_SIZE        : natural  := 16);    
  port (CLK       : in std_logic;
        RESET_n   : in std_logic;
        ENA       : in std_logic;
        operation : in std_logic;   --push: 1 pop: 0
        data_in   : in integer;
        data_out  : out integer;
        stack_ptr : out natural range stack_SIZE downto 0);
end stack_of_int;

architecture rtl of stack_of_int is
  
  subtype limited_integer is integer range -(2**(stack_WIDTH/2) - 1) to 2**(stack_WIDTH/2) - 1;
  type stack_of_int_type is array (stack_SIZE - 1 downto 0) of limited_integer;
  signal stack_data : stack_of_int_type;

  signal ptr  : natural range stack_SIZE downto 0 := stack_SIZE;

begin

  stack_ptr <= ptr;

  PTR_PROC: process (CLK)
  begin
    if (RESET_n = '0') then
      ptr <= 0;
    elsif (rising_edge(CLK) and ENA = '1') then
      if (operation = '1') then
        if(ptr > 0) then
          ptr <= ptr - 1;
        end if;
      else
        if(ptr < stack_SIZE) then
          ptr <= ptr + 1;
        end if;
      end if;
    end if;
  end process PTR_PROC;

  DATA_IN_PROC: process (ptr)
  begin
    if (ptr < stack_SIZE and ENA = '1' and operation = '1') then
      stack_data(ptr) <= data_in;
    end if;
  end process DATA_IN_PROC;

  DATA_OUT_PROC: process (ptr)
  begin
    if (ptr < stack_SIZE and ENA = '1' and operation = '0') then
      data_out <= stack_data(ptr);
    else
      data_out <= 0;
    end if;
  end process DATA_OUT_PROC;
end rtl;
--==================================================================================
