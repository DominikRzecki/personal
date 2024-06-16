------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 01/09/2022
--File    : stack.vhd
--Design  : full descending generic stack
------------------------------------------------------------------------------------
-- Descrition: stack design
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity stack is
  generic (	type stack_DATATYPE;
  		stack_ZERO_VAL		: stack_DATATYPE;
            	stack_SIZE       	: natural  := 16);    
  port (CLK       : in std_logic;
        RESET_n   : in std_logic;
        ENA       : in std_logic;
  	peek	  : in std_logic;   --peek
        operation : in std_logic;   --push: 1 pop: 0
        data_in   : in stack_DATATYPE;
        data_out  : out stack_DATATYPE;
        stack_ptr : out integer range stack_SIZE downto 0);
end stack;

architecture rtl of stack is
  
  type stack_type is array (stack_SIZE - 1 downto 0) of stack_DATATYPE;
  signal stack_data 	: stack_type;
  signal stack_buf 	: stack_DATATYPE;
  signal operation_buf, peek_buf	: std_logic;
  
  signal ptr  		: natural range stack_SIZE downto 0 := stack_SIZE;

begin

  stack_ptr <= ptr;

  PTR_PROC: process (CLK)
  begin
    if (RESET_n = '0') then
      ptr <= stack_SIZE;
    elsif (rising_edge(CLK) and ENA = '1') then
      stack_buf <= data_in;
      operation_buf <= operation;
      peek_buf <= peek;
      if (operation = '1') then -- push
        if(ptr > 0) then
          ptr <= ptr - 1;
        end if;
      else
        if(ptr < stack_SIZE) then -- pop
          ptr <= ptr + 1;
        end if;
      end if;
    end if;
  end process PTR_PROC;

  DATA_PROC: process (ptr)
  begin
    if (ptr < stack_SIZE and operation_buf = '1') then
      stack_data(ptr) <= stack_buf;
      if(peek_buf = '1') then
	      data_out <= stack_buf;
      end if;
    elsif (ptr < stack_SIZE and operation_buf = '0') then	    
      data_out <= stack_data(ptr);
    else
      data_out <= stack_ZERO_VAL;
    end if;
  end process DATA_PROC;
  
end architecture rtl;
--==================================================================================
