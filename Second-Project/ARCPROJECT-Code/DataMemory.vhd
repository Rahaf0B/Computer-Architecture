														  
library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_STD.ALL   ;

entity DataMemory is
	 port(
		 MemRead : in STD_LOGIC;
		 MemWrite : in STD_LOGIC;
		 Address : in STD_LOGIC_VECTOR(23 downto 0);
		 WriteData : in STD_LOGIC_VECTOR(23 downto 0);
		 ReadData : out STD_LOGIC_VECTOR(23 downto 0)
	     );
end DataMemory;

--}} End of automatically maintained section

architecture Behavioral of DataMemory is   
	type RAM_16_X_24 is array (0 to 15) of std_logic_vector(23 downto 0);
	signal DM : RAM_16_X_24 :=( x"000000",	--Assume starts at 0x100010000
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000",
								x"000000"
						);
begin
	process( MemWrite,MemRead )  --only execute if one of them is 1
		
	begin 
		if (MemWrite = '1')then		 
			DM((to_integer(unsigned(Address)))/3) <= WriteData; --3 byte per word
		end if;
		if (MemRead = '1')then		 
			 ReadData<= DM((to_integer(unsigned(Address)))/3) ;--3 byte per word
			
		end if;
		
	end process;		
	 -- enter your statements here --

end Behavioral;
