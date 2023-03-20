library IEEE;
  use IEEE.std_logic_1164.all;
entity routing_logic is
  generic (
      N_in : natural := 10;
      N_out : natural := 8 
  );
  port (
    -- link_1
    data_1    : in std_logic_vector(N_in - 1 downto 0);
    req_1     : in std_logic;
    grant_1   : out std_logic;
    -- link_2
    data_2    : in std_logic_vector(N_in - 1 downto 0);
    req_2     : in std_logic;
    grant_2   : out std_logic;
    -- data round robin 
    rr_in     : in std_logic;
    rr_out    : out std_logic;  
    -- data outputs
    old_out   : in std_logic_vector(N_out - 1 downto 0);
    data_out  : out std_logic_vector(N_out - 1 downto 0);
    valid     : out std_logic
  );
end entity;

architecture struct of routing_logic is
begin
  -- data output selection
  data_out <= data_1(N_in - 3 downto 0) when ((req_1 = '1' and req_2 = '0') or 
                                              (req_1 = '1' and (data_1(N_in - 1 downto N_in - 2) > data_2(N_in - 1 downto N_in - 2)))or
                                              (req_1 = '1' and (data_1(N_in - 1 downto N_in - 2) = data_2(N_in - 1 downto N_in - 2)) and rr_in = '0'))else
              data_2(N_in - 3 downto 0) when ((req_2 = '1' and req_1 = '0') or 
                                              (req_2 = '1' and (data_2(N_in - 1 downto N_in - 2) > data_1(N_in - 1 downto N_in - 2)))or
                                              (req_2 = '1' and (data_2(N_in - 1 downto N_in - 2) = data_1(N_in - 1 downto N_in - 2)) and rr_in = '1'))else                        
              old_out;
  -- grant up
  grant_1 <= '1' when ((req_1 = '1' and req_2 = '0') or 
                                              (req_1 = '1' and (data_1(N_in - 1 downto N_in - 2) > data_2(N_in - 1 downto N_in - 2)))or
                                              (req_1 = '1' and (data_1(N_in - 1 downto N_in - 2) = data_2(N_in - 1 downto N_in - 2)) and rr_in = '0'))else
              '0';
  grant_2 <= '1' when ((req_2 = '1' and req_1 = '0') or 
                                              (req_2 = '1' and (data_2(N_in - 1 downto N_in - 2) > data_1(N_in - 1 downto N_in - 2)))or
                                              (req_2 = '1' and (data_2(N_in - 1 downto N_in - 2) = data_1(N_in - 1 downto N_in - 2)) and rr_in = '1'))else
              '0';
  -- valid up
  valid <= '1' when (req_1 = '1' or req_2 = '1') else '0';

  -- round robin handling
  rr_out <= '0'  when ( req_1 = '1' and req_2 = '1' and (data_2(N_in - 1 downto N_in - 2) = data_1(N_in - 1 downto N_in - 2)) and rr_in = '1') else
            '1' when ( req_1 = '1' and req_2 = '1' and (data_2(N_in - 1 downto N_in - 2) = data_1(N_in - 1 downto N_in - 2)) and rr_in = '0') else
            rr_in;
end architecture;         