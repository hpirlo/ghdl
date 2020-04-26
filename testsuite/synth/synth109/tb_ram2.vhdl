entity tb_ram2 is
end tb_ram2;

library ieee;
use ieee.std_logic_1164.all;

architecture behav of tb_ram2 is
  signal clkA : std_logic;
  signal enA : std_logic;
  signal weA : std_logic;
  signal addrA : std_logic_vector(5 downto 0);
  signal rdatA : std_logic_vector(31 downto 0);
  signal wdatA : std_logic_vector(31 downto 0);
  
  signal clkB : std_logic;
  signal enB : std_logic;
  signal weB : std_logic;
  signal addrB : std_logic_vector(5 downto 0);
  signal rdatB : std_logic_vector(31 downto 0);
  signal wdatB : std_logic_vector(31 downto 0);
begin
  dut: entity work.ram2
    port map (clkA => clkA, clkB => clkB,
              enA => enA, enB => enB,
              weA => weA, weB => weB,
              addrA => addrA, addrB => addrB,
              diA => wdatA, diB => wdatB,
              doA => rdatA, doB => rdatB);

  process
    procedure pulseB is
    begin
      clkB <= '0';
      wait for 1 ns;
      clkB <= '1';
      wait for 1 ns;
    end pulseB;
    procedure pulseA is
    begin
      clkA <= '0';
      wait for 1 ns;
      clkA <= '1';
      wait for 1 ns;
    end pulseA;
  begin
    clkA <= '0';
    enA <= '0';

    enB <= '1';
    weB <= '1';
    addrB <= b"00_0000";
    wdatB <= x"11_22_33_f0";
    pulseB;
    assert rdatB = x"11_22_33_f0" severity failure;

    addrB <= b"00_0001";
    wdatB <= x"11_22_33_f1";
    pulseB;
    assert rdatB = x"11_22_33_f1" severity failure;

    --  Read.
    weB <= '0';
    addrB <= b"00_0000";
    wdatB <= x"ff_22_33_f1";
    pulseB;
    assert rdatB = x"11_22_33_f0" severity failure;

    addrB <= b"00_0001";
    wdatB <= x"ff_22_33_f1";
    pulseB;
    assert rdatB = x"11_22_33_f1" severity failure;

    --  Disable.
    enB <= '0';
    weB <= '1';
    addrB <= b"00_0000";
    wdatB <= x"11_22_33_f0";
    pulseB;
    assert rdatB = x"11_22_33_f1" severity failure;

    --  Read from A.
    enA <= '1';
    weA <= '0';
    addrA <= b"00_0001";
    wdatA <= x"88_22_33_f1";
    pulseA;
    assert rdatA = x"11_22_33_f1" severity failure;
    
    wait;
  end process;
end behav;
