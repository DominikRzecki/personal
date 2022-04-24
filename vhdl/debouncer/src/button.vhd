------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Rzecki
--Date    : 19/04/2022
--File    : button.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Descrition: Button
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

--==================================================================================
entity button is
  generic ( REQ_PRESS_TIME       : time;
            F_CLK               : natural);
  port (CLK     : in std_logic;
        btn_in  : in std_logic;
        btn_out : out std_logic);
end button;

architecture mixed of button is

  signal b_sync         : std_logic_vector (1 downto 0);

begin

    BTN_SYNC: process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            b_sync(0) <= not btn_in;
            b_sync(1) <= b_sync(0);
        end if;
    end process BTN_SYNC;

    DEBOUNCER: entity work.debouncer(rtl)
    generic map (
      F_CLK => F_CLK,
      REQ_PRESS_TIME => REQ_PRESS_TIME,
      SAMPLE_PERIOD => 500 us
    )
    port map (
      CLK => CLK,
      sig_in => b_sync(1),
      sig_out => btn_out
    );

end mixed;
--==================================================================================
