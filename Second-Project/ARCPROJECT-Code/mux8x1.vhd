library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8x1 is
    Port ( I : in  STD_LOGIC_VECTOR (7 downto 0);
           S : in  STD_LOGIC_VECTOR (2 downto 0);
           Y : out  STD_LOGIC);
end mux8x1;

architecture Behavioral of mux8x1 is
begin  			  
	  
	
		Y <=I(0) when S="000"
Else I(1) when S="001"
	
Else I(2) when S="010"
	
Else I(3) when S="011"
	
Else I(4) when S="100"
	
Else I(5) when S="101"
	
Else I(6) when S="110"
	
	Else I(7) when S="111";
		

end Behavioral;															 