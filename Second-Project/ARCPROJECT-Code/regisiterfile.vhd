library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity registerfile is
  generic (
    numberOfRegister : integer := 8;
    registerLength : integer := 24);
  port (
    clk      : in std_logic;
    writeEnable       : in std_logic;
    writeAddress   : in std_logic_vector(2 downto 0);
    dataIn  : in std_logic_vector(registerLength-1 downto 0);
    RA  : in std_logic_vector(2 downto 0);
    RB  : in std_logic_vector(2 downto 0);
    BUSA: out std_logic_vector(registerLength-1 downto 0);
    BUSB: out std_logic_vector(registerLength-1 downto 0)
  );
end entity;

architecture regfile of registerfile is
  type arrayOfRegisters is array(0 to numberOfRegister-1) of std_logic_vector(registerLength-1 downto 0);
  signal registers : arrayOfRegisters:=(X"000000",X"000001",  X"000011", X"001001",X"010001", X"101001",X"110001",X"011101");
begin					  
	
  process(clk)
  begin
    if rising_edge(clk) then
      if writeEnable = '1' then
        registers(to_integer(unsigned(writeAddress))) <= dataIn;
      end if;
    end if;
  end process;
  
  BUSA <= registers(to_integer(unsigned(RA)));
  BUSB <= registers(to_integer(unsigned(RB)));
end architecture;