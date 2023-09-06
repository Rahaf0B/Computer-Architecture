						 
library IEEE;
use IEEE.std_logic_1164.all;	
use ieee.numeric_std.all;

entity InstructionMemory is
	 port(
		 ReadAddress : in STD_LOGIC_VECTOR(23 downto 0);
		 Instruction : out STD_LOGIC_VECTOR(23 downto 0)
	     );
end InstructionMemory;

--}} End of automatically maintained section

architecture Behavioral of InstructionMemory is	 
	type RAM is array (0 to 7) of std_logic_vector(23 downto 0);
	signal IM : RAM;
begin	  
	IM(0) <= "000001100000101110000000";
	IM(1) <="000000001000000100000000";	
	IM(2) <="000001110001011100000000";
	IM(3) <="000100000001010010100000";
	IM(4) <="000100010010000010101010";
	IM(5) <="000101100001000101010101";
	IM(6) <="000110001010010100010101";
	IM(7) <="000111000000000000000011"; 	 
	

	Instruction <= IM((to_integer(unsigned(ReadAddress)))) ;

end Behavioral;
