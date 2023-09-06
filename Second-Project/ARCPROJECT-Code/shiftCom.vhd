
-- the library that needed
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all;

entity shift  is 
	port(
	datain : in std_logic_vector(23 DOWNTO 0);
	dataout: out std_logic_vector(23 DOWNTO 0)
	); 	  
end;

-- the behavioral of shift entity 
	
	
architecture shiftbyfour of shift is 	  

begin 	
	-- shift by 4  
	dataout<= datain(19 downto 0) & "0000";
	
end;	