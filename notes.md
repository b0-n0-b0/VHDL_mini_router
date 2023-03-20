## test:
only one req up

both up and priority
```vhdl
        when 2 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '0');
          data_2_tb <= (9 downto 0 => '1');
          -- expected output: data = 11111111, grant_2 = 1
        when 3 =>
          req_1_tb <= '0';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '0');
          -- expected output: data = 00000000, grant_2 = 1
        when 4 =>
          req_1_tb <= '1';
          req_2_tb <= '0';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '0');
          -- expected output: data = 11111111, grant_1 = 1
        when 5 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "01" & (7 downto 0 => '1');
          data_2_tb <= "00" & (7 downto 0 => '0');
          -- expected output: data = 11111111, grant_1 = 0, valid = 0
        when 6 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "10" & (7 downto 0 => '1');
          data_2_tb <= "01" & (7 downto 0 => '1');
          -- expected output: data = 11111111, grant_1 = 1, valid = 0
        when 7 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "11" & (7 downto 0 => '1');
          data_2_tb <= "10" & (7 downto 0 => '1');
          -- expected output: data = 11111111, grant_2 = 1, valid = 0
        when 8 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= "10" & (7 downto 0 => '1');
          data_2_tb <= "00" & (7 downto 0 => '1');
          -- expected output: data = 11111111, grant_1 = 1, valid = 0
```

round robin 
```vhdl
        when 2 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '1');
        when 3 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '1');
        when 4 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '1');
        when 5 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '1');
        when 6 =>
          req_1_tb <= '1';
          req_2_tb <= '1';
          data_1_tb <= (9 downto 0 => '1');
          data_2_tb <= (9 downto 0 => '1');   
```
