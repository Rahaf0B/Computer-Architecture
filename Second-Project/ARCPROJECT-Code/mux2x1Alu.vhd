
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all; 
-- the entity of Mux2x1 to select between zero flag or set flag 
entity mux2ALU is
  port (input1, input2 : in std_logic_vector(23 downto 0);
      control : in std_logic;
     outputAlu : out std_logic_vector(23 downto 0)); 
end mux2ALU;

architecture behaviour of mux2ALU is 
begin
  process (input1, input2, control)
  begin
    if control = '0' then
      outputAlu <= input1;
    else
      outputAlu <= input2;
    end if;
  end process;
end behaviour; 