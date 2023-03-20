
library IEEE;
  use IEEE.std_logic_1164.all;

entity mini_router is
  generic (
      N_in    : natural := 10;
      N_out   : natural := 8 
  );
  port(
    reset     : in std_logic;
    clock     : in std_logic;
    -- link 1
    data_1    : in std_logic_vector(N_in - 1 downto 0);
    req_1     : in std_logic;
    grant_1   : out std_logic;
    -- link_2
    data_2    : in std_logic_vector(N_in - 1 downto 0);
    req_2     : in std_logic;
    grant_2   : out std_logic;
    -- general output
    data_out  : out std_logic_vector(N_out - 1 downto 0);
    valid_out : out std_logic
  );
end entity;

architecture struct of mini_router is
-------------------------------------------------------------------------------------
-- Internal signals
-------------------------------------------------------------------------------------
  -- output register
  signal data_out_reg : std_logic_vector(N_out - 1 downto 0);
  signal valid_reg : std_logic;
  -- round robin signal
  signal round_robin_logic_out : std_logic;
  signal round_robin_logic_in : std_logic;
  -- grant from logic
  signal grant_link_1_logic : std_logic;
  signal grant_link_2_logic : std_logic;
  -- output from logic
  signal output_reg_logic : std_logic_vector(N_out - 1 downto 0);
  signal valid_reg_logic : std_logic;
  -- input register
  signal data_in_reg_1 : std_logic_vector(N_in - 1 downto 0);
  signal req_in_reg_1 : std_logic;
  signal data_in_reg_2 : std_logic_vector(N_in - 1 downto 0);
  signal req_in_reg_2 : std_logic;


-------------------------------------------------------------------------------------
-- Internal Components
-------------------------------------------------------------------------------------
  component routing_logic is
    generic (
        N_in : natural := 10;
        N_out : natural := 8 
    );
    port (
        data_1    : in std_logic_vector(N_in - 1 downto 0);
        req_1     : in std_logic;
        grant_1   : out std_logic;
        data_2    : in std_logic_vector(N_in - 1 downto 0);
        req_2     : in std_logic;
        grant_2   : out std_logic;
        rr_in     : in std_logic;
        rr_out    : out std_logic;  
        old_out   : in std_logic_vector(N_out - 1 downto 0);
        data_out  : out std_logic_vector(N_out - 1 downto 0);
        valid     : out std_logic
    );
  end component;

  component round_robin_register is
    generic (
        N : natural := 10
    );
    port (
        reset         : in std_logic;
        clock         : in std_logic;
        selected      : in std_logic;
        last_selected : out std_logic
    );
  end component;

  component output_register is
    generic (
        N : natural := 8
    );
    port (
      reset     : in std_logic;
      clock     : in std_logic;
      data_in   : in std_logic_vector(N - 1 downto 0);
      valid_in  : in std_logic;
      data_out  : out std_logic_vector(N - 1 downto 0);
      valid_out   : out std_logic
    );
  end component;

  component input_register is
    generic (
        N : natural := 10
    );
    port (
      reset     : in std_logic;
      clock     : in std_logic;
      data_in   : in std_logic_vector(N - 1 downto 0);
      req_in    : in std_logic;
      data_out  : out std_logic_vector(N - 1 downto 0);
      req_out   : out std_logic
    );
  end component;

  component grant_register is
    port (
        reset     : in std_logic;
        clock     : in std_logic;
        grant_in    : in std_logic;
        grant_out   : out std_logic
    );
  end component;


-------------------------------------------------------------------------------------
-- End Components
-------------------------------------------------------------------------------------

begin

    GRANT_REG_1: grant_register
        port map (
            reset => reset,
            clock => clock,
            grant_in => grant_link_1_logic,
            grant_out => grant_1
        );

    GRANT_REG_2: grant_register
        port map (
            reset => reset,
            clock => clock,
            grant_in => grant_link_2_logic,
            grant_out => grant_2
        );
    INPUT_REG_1: input_register
        generic map (N => 10)
        port map(
            reset => reset,
            clock => clock,
            data_in => data_1,
            req_in => req_1,
            data_out => data_in_reg_1,
            req_out => req_in_reg_1
        );
    INPUT_REG_2: input_register
        generic map (N => 10)
        port map(
            reset => reset,
            clock => clock,
            data_in => data_2,
            req_in => req_2,
            data_out => data_in_reg_2,
            req_out => req_in_reg_2
        );
    OUTPUT_REG_1: output_register
        generic map (N => 8)
        port map(
            reset => reset,
            clock => clock,
            data_in => output_reg_logic,
            valid_in => valid_reg_logic,
            data_out => data_out_reg,
            valid_out => valid_out
        );
    ROUND_ROBIN_REG: round_robin_register
        port map(
            reset => reset,
            clock => clock,
            selected => round_robin_logic_out,
            last_selected => round_robin_logic_in
        );
    ROUTING_LOGIC_1: routing_logic
        generic map (N_in => 10, N_out => 8)
        port map(
            data_1 => data_in_reg_1,
            req_1 => req_in_reg_1,
            grant_1 => grant_link_1_logic,
            data_2 => data_in_reg_2,
            req_2 => req_in_reg_2,
            grant_2 => grant_link_2_logic,
            rr_in => round_robin_logic_in,
            rr_out => round_robin_logic_out,
            old_out => data_out_reg,
            data_out => output_reg_logic,
            valid => valid_reg_logic
        );
    data_out <= data_out_reg;
end architecture;