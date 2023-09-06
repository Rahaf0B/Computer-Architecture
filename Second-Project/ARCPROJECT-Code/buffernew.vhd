-- the library that needed
library ieee;  -- the library needed 

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all;

entity bufferNew is 
	generic(n : integer);
	
	port(clock : in std_logic;
	datain : in std_logic_vector(n-1 DOWNTO 0);
	dataout: out std_logic_vector(n-1 DOWNTO 0)
	); 	
end; 
-- end of entity 

architecture bufferr of bufferNew is  

begin 
	process(clock) 
	variable data: std_logic_vector(n-1 DOWNTO 0); 
	begin
		if rising_edge(clock) THEN
			dataout <= data;
		else
			data := datain;
		end if;
		
	end process;
	
end;