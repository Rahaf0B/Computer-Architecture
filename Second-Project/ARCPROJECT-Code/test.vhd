library ieee;
use ieee.std_logic_1164.all;

entity bit_counter is
  port (
    bin_in : in std_logic_vector(7 downto 0)
  );
end entity bit_counter;

architecture behavior of bit_counter is
  signal bit_count : integer := 0;
begin
  bit_count <= integer(bin_in'length);
end architecture behavior;