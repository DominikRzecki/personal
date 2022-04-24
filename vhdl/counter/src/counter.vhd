------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 19/04/2022
--File    : counter.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Descrition: Counter
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity counter is
  generic ( SPEED               : natural;
            F_CLK               : natural;
            MAX_VAL             : natural);
  port (RESET_n : in std_logic;
        CLK     : in std_logic;
        enabled : in boolean;
        val     : out natural);
end counter;

architecture rtl of counter is

    constant c_req_clk_cnt : natural := F_CLK / SPEED;

    signal PULSE        : std_logic := '0';
    signal clk_counter  : natural := 0;
    signal cnt          : natural := 0;

begin

    PULSE_GEN: process (CLK, RESET_n)
    begin
        if (RESET_n = '0') then
            PULSE <= '0';
            clk_counter <= 0;
        elsif (CLK'event and CLK = '1') then
            clk_counter <= (clk_counter + 1) mod (c_req_clk_cnt + 1);
        end if;

        if (clk_counter = c_req_clk_cnt) then
            PULSE <= '1';
        else
            PULSE <= '0';
        end if;
    end process PULSE_GEN;

    COUNTER: process (PULSE, RESET_n)
    begin
        if (RESET_n = '0') then
            cnt <= 0;
        elsif (PULSE'event and PULSE = '1' and enabled) then
            cnt <= (cnt + 1) mod (MAX_VAL + 1);
        end if;

        val <= cnt;

    end process COUNTER;

end rtl;
--==================================================================================