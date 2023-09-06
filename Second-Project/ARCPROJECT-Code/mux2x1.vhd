
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all; 
-- the entity of Mux2x1 to select between zero flag or set flag 
entity mux2to1 is
  port (zero_flag, set_flag, control : in std_logic;
     Zero_flag_orSetFlag_out : out std_logic); 
end mux2to1;

architecture behaviour of mux2to1 is 
begin
  process (zero_flag, set_flag, control)
  begin
    if control = '0' then
      Zero_flag_orSetFlag_out <= zero_flag;
    else
      Zero_flag_orSetFlag_out <= set_flag;
    end if;
  end process;
end behaviour; 
