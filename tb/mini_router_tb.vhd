library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mini_router_tb is
end entity;


architecture testbench of mini_router_tb is
-----------------------------------------------------------------------------------------------------
-- components declaration
-----------------------------------------------------------------------------------------------------
  component mini_router is
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
  end component;

  -----------------------------------------------------------------------------------------------------
  -- constants declaration
  -----------------------------------------------------------------------------------------------------

  -- CLK period (f_CLK = 125 MHz)
  constant T_clk : time := 8 ns;

  -----------------------------------------------------------------------------------------------------
  -- signals declaration
  -----------------------------------------------------------------------------------------------------

  -- clk signal (initialized to '0')
  signal clk_tb : std_logic := '0';

  -- Active high asynchronous reset 
  signal reset_tb : std_logic := '1';

  -- Set to '0' to stop the simulation
  signal run_simulation : std_logic := '1';

  -- input data
  signal data_1_tb : std_logic_vector(9 downto 0) := (others => '0');
  signal data_2_tb : std_logic_vector(9 downto 0) := (others => '0');
  signal req_1_tb : std_logic := '0' ;
  signal req_2_tb : std_logic := '0';

  -- output signals (the declaration is useful to make it visible without observing the ddfs component)
  signal mini_router_std_out_tb : std_logic_vector(7 downto 0);  
  signal mini_router_valid_tb : std_logic;
  signal mini_router_grant_1_tb : std_logic;
  signal mini_router_grant_2_tb : std_logic;

-- start

begin
  -- clk signal
  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  STD_DUT: mini_router
  generic map(N_in => 10, N_out => 8)
  port map (
    clock   => clk_tb,
    reset => reset_tb,
    data_1 => data_1_tb,
    req_1 => req_1_tb,
    grant_1 => mini_router_grant_1_tb,
    data_2 => data_2_tb,
    req_2 => req_2_tb,
    grant_2 => mini_router_grant_2_tb,
    data_out => mini_router_std_out_tb,
    valid_out => mini_router_valid_tb
  );

  -- process used to make the testbench signals change synchronously with the rising edge of the clock
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- variable used to count the clock cycle after the reset
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 0 =>
          reset_tb <= '0';
        when 1 =>
          req_1_tb <= '1';
          req_2_tb <= '0';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '1');
        -- data_out:11111111|valid:1|grant_1:1|grant_2:0
        when 2 =>
          req_1_tb <= '0';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '0');
        -- data_out:00000000|valid:1|grant_1:0|grant_2:1
        when 3 =>
          req_1_tb <= '0';
          req_2_tb <= '0';
          data_1_tb <= "1010101010";
          data_2_tb <= "1010101010";
        -- data_out:00000000|valid:0|grant_1:0|grant_2:0

        -- start of the priority tests
        when 4 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "01"&(7 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '0');
        -- data_out:11111111|valid:1|grant_1:1|grant_2:0
        when 5 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "10"&(7 downto 0 => '0');
          data_2_tb <= "01"&(7 downto 0 => '1');
        -- data_out:00000000|valid:1|grant_1:1|grant_2:0

        -- FIRST RR
        when 6 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "11"&(7 downto 0 => '1');
          data_2_tb <= "11"&(7 downto 0 => '0');
        -- data_out:11111111|valid:1|grant_1:1|grant_2:0    
        when 7 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "10"&(7 downto 0 => '1');
          data_2_tb <= "11"&(7 downto 0 => '0');
        -- data_out:00000000|valid:1|grant_1:0|grant_2:1    
        when 8 =>
          req_1_tb <= '0';
          req_2_tb <= '0';
          data_1_tb <= "11"&(7 downto 0 => '0');
          data_2_tb <= "10"&(7 downto 0 => '1');
        -- data_out:00000000|valid:0|grant_1:0|grant_2:0    
        when 9 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "1011111111";
          data_2_tb <= "1010101010";
        -- data_out:10101010|valid:1|grant_1:0|grant_2:1            
        when others => 
          run_simulation <= '0';
      end case;
      clock_cycle := clock_cycle + 1;
    end if;
  end process;

end architecture;
