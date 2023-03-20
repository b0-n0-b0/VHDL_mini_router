library IEEE;
  use IEEE.std_logic_1164.all;

-- basically this is a D Flip-Flop
entity grant_register is
  port (
    -- general inputs
    reset     : in std_logic;
    clock     : in std_logic;
    -- inputs
    grant_in    : in std_logic;
    -- outputs
    grant_out   : out std_logic
  );
end entity;

architecture behavioral of grant_register is
begin
    on_clock: process(clock, reset)
    begin 
        -- reset
        if(reset = '1') then
            grant_out <= '0';
        elsif (rising_edge(clock)) then
            grant_out <= grant_in;
        end if;
    end process;
end architecture;