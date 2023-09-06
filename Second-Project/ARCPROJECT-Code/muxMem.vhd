
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all; 
-- the entity of Mux2x1 to select between zero flag or set flag 
entity mux3x1MemWB is
  port (ALU, MEM , Shift: in std_logic_vector(23 downto 0);
      control : in std_logic_vector(1 downto 0);
     outputMUX : out std_logic_vector(23 downto 0)); 
end mux3x1MemWB;

architecture behaviour of mux3x1MemWB is 
begin
  process (ALU, MEM, Shift)
  begin
    if control = "00" then
      outputMUX <= ALU;
    elsif control = "01" then
      outputMUX <= MEM;	
	 elsif control = "10" then
      outputMUX <= Shift;
    end if;
  end process;
end behaviour; 