					 																									 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_pc is
    Port (
           
	opcode:in  STD_LOGIC_VECTOR (4 downto 0);
	JorB:in std_logic; --jump or branch	 
	branchTakenornot:in std_logic;
	JorJR:out std_logic;
	PCSrc:out std_logic_vector (1 downto 0)
		   
		   ); 
		   
end  control_unit_pc;	  


architecture Behavioral of  control_unit_pc is
begin 
	process(opcode,JorB)
	begin	   
		
		
		 if JorB='0' then 
			if opcode="01100" then 	 --J
			  JorJR<='0'; 
			  PCSrc<="01";
			
			elsif opcode="00110" then  --JR
				JorJR<='1';
				PCSrc<="10";
			
			end if;	   
			
		elsif JorB='1' then 
			if branchTakenornot='1' then 
				PCSrc<="11";
			else
				PCSrc<="00";
			end if;
				
			
		 end if;
		 
	
	
	
	end process;
end Behavioral;