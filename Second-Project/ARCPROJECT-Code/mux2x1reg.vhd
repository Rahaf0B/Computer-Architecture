
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all; 
-- the entity of Mux2x1 to select between zero flag or set flag 
entity mux4x1Regisiter is
  port (Rt, Rd ,R7, R1: in std_logic_vector(2 downto 0);
     control : in std_logic_vector(1 downto 0 );
     regisiterDes : out std_logic_vector(2 downto 0)); 
end mux4x1Regisiter;

architecture behaviour of mux4x1Regisiter is 
begin
  process (Rt, Rd, control)
  begin
    if control = "00" then
      regisiterDes <= Rt;
    elsif control = "01" then 
      regisiterDes <= Rd; 
	elsif  control = "10" then 
		regisiterDes <= R7;
	elsif  control = "11" then 
			regisiterDes <= R1;
    end if;
  end process;
end behaviour; 
