									   -- the library that needed
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all;

-- we have in Itype Immediate is 10 bit we must extend it to zero extention   
-- the entity of the sign extention 

entity sing_extend is  
    generic(length_ofImmediate : integer);
	port (data_in : in std_logic_vector(length_ofImmediate-1 downto 0);

	      	  Extop:in std_logic;
		  data_out : out std_logic_vector(23 downto 0)
	);	
end;

architecture signExt of sing_extend is 	  

begin 
	
	process(data_in)
	begin	
		if (length_ofImmediate=17) then 
		  if (Extop='0') then 	
			   data_out<= "0000000"& data_in ;
		else 
			if (data_in(9)='0') then 
				data_out<= "0000000"& data_in ;
			elsif (data_in(9)='1') then 
				data_out<="1111111" & data_in;	
			end if;	
		end if;	
		
	    elsif(length_ofImmediate=10) then 
			if (Extop='0') then 	
			   data_out<= "00000000000000"& data_in ;
		else 
			if (data_in(16)='0') then 
				data_out<= "00000000000000"& data_in ;
			elsif (data_in(16)='1') then 
				data_out<="11111111111111" & data_in;	
			end if;	
		end if;
			
		end if ;
		
		

	end process;		
end;