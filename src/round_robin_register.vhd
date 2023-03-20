-- this element implements the round robin scheduling needed when the two input links have the same
-- priority
library IEEE;
  use IEEE.std_logic_1164.all;

entity round_robin_register is
  generic (
      N : natural := 10
  );
  port (
    -- general inputs
    reset         : in std_logic;
    clock         : in std_logic;
    -- inputs
    selected      : in std_logic;
    -- outputs
    last_selected : out std_logic
  );
end entity;

architecture behavioral of round_robin_register is
begin
    on_clock: process(clock, reset)
    begin 
        -- reset
        if(reset = '1') then
            last_selected <= '0';
        elsif (rising_edge(clock)) then
            if(selected = '1')then
              last_selected <= '1';
            else
              last_selected <= '0';
            end if;
        end if;
    end process;
end architecture;