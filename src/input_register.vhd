library IEEE;
  use IEEE.std_logic_1164.all;

entity input_register is
  generic (
      N : natural := 10
  );
  port (
    -- general inputs
    reset     : in std_logic;
    clock     : in std_logic;
    -- inputs
    data_in   : in std_logic_vector(N - 1 downto 0);
    req_in    : in std_logic;
    -- outputs
    data_out  : out std_logic_vector(N - 1 downto 0);
    req_out   : out std_logic
  );
end entity;

architecture behavioral of input_register is
begin
    on_clock: process(clock, reset)
    begin 
        -- reset
        if(reset = '1') then
            data_out <= (others => '0');
            req_out <= '0';
        elsif (rising_edge(clock)) then
            data_out <= data_in;
            req_out <= req_in;
        end if;
    end process;
end architecture;