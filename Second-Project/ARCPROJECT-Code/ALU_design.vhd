 
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all;

---------------------------------------------------------------------------------------------------------
-- the entity of ALU of 24- bit 
entity ALU is 
	port(  
	Reg1, Reg2 : in  std_logic_vector(23 downto 0);  -- 2 inputs 24-bit
	ALU_Out   : out  std_logic_vector(23 downto 0); -- 1 output 24-bit of ALU_out
	Zero_flag_orSetFlag  :  in  std_logic;			  -- one bit for zero flag that could be input and output  	
    ALU_Condition  : in  std_logic_vector(1 downto 0);  -- 2 bit for the condition
	ALU_Opcode : 	in  std_logic_vector(4 downto 0); -- 5 bit for the opcode    
    zeroFlag : out std_logic        -- zero flag
	);
	
end;  

-- the architecture of the ALU	 
-- in the ALU componant the opcode control on the operation 

architecture Behavioral of ALU is

begin
		
	process(Reg1,Reg2,ALU_Opcode,ALU_Condition,Zero_flag_orSetFlag)
	begin 	  
		   --RType	
		   
		if (ALU_Opcode = "00011" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then 	-- ADD  -- the result of mux it will pass a set flag
			ALU_Out <= Reg1 + Reg2;
	
				
			   		   
			elsif (ALU_Opcode = "00011" and ALU_Condition = "01") then  -- ADDEQ	 
				if (Zero_flag_orSetFlag='1') then  -- the result of mux it will pass a zero flag 
					ALU_Out <= Reg1 + Reg2;
				else 
					null;    -- NOP
				end if;	
				
				
				   
			elsif (ALU_Opcode = "00011" and ALU_Condition = "10") then	-- ADDNE
				if (Zero_flag_orSetFlag='0') then   -- the result of mux it will pass a zero flag
					ALU_Out <= Reg1 + Reg2;
				else 
					null;    -- NOP
				end if;	
				
				
				
			elsif (ALU_Opcode = "00100" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then	-- SUB  -- the result of mux it will pass a set flag it will be zero
				ALU_Out <= Reg1 - Reg2;
					
					
				
				   
			elsif (ALU_Opcode = "00011" and ALU_Condition = "00" and Zero_flag_orSetFlag='1') then	-- SUBSF  -- the result of mux it will pass a set flag
				ALU_Out <= Reg1 - Reg2; 
				   -- the SUBSF will Set the new Value for the zero flag 
				if (Reg1 - Reg2="0") then 	  
					zeroFlag<='1'; -- the Zero flag will be one because the result will be zero
				end if;		
				   
			elsif (ALU_Opcode = "00000" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then	-- AND  -- the result of mux it will pass a set flag it will be zero
				ALU_Out <= Reg1 and Reg2;
				
				
				 
			elsif (ALU_Opcode = "00101" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then	-- CMP  -- the result of mux it will pass a set flag it will be zero
				if (Reg1<Reg2) then 	  
					zeroFlag<='1'; -- the Zero flag will be one because the result will be zero; 
					ALU_Out<="000000000000000000000000";	--- it will be zero result 
				else
					null;   --NOP  (not do anything)
				end if;	
				   
			--IType
				
			elsif (ALU_Opcode = "01000" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then 	-- ADDI
				ALU_Out <= Reg1 + Reg2; 	 
			  
			  
			elsif (ALU_Opcode = "01000" and ALU_Condition = "01") then  -- ADDIEQ	
				if (Zero_flag_orSetFlag='1') then  -- the result of mux it will pass a zero flag 
					ALU_Out <= Reg1 + Reg2;
			   else 
				   null;    -- NOP
			   end if;	
			   
			   
			elsif (ALU_Opcode = "01000" and ALU_Condition = "10") then	-- ADDINE
				if (Zero_flag_orSetFlag='0') then   -- the result of mux it will pass a zero flag
					ALU_Out <= Reg1 + Reg2;
			   else 
				   null;    -- NOP
			   end if;	
			   
		    elsif (ALU_Opcode = "01000" and ALU_Condition = "00" and Zero_flag_orSetFlag='1') then	-- SUBISF  -- the result of mux it will pass a set flag
			       ALU_Out <= Reg1 - Reg2;	
				   -- the SUBSF will Set the new Value for the zero flag 
				   if (Reg1 - Reg2="0") then   
					   zeroFlag<='1'; -- the Zero flag will be one because the result will be zero
				   end if;	
				   	
				   
		    elsif (ALU_Opcode = "00111" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then	-- ANDI  -- the result of mux it will pass a set flag it will be zero
				ALU_Out <= Reg1 and Reg2;
				
			
				
			--elsif (ALU_Opcode = "01110" and ALU_Condition = "00" and Zero_flag_orSetFlag='0') then	-- Shift  -- the result of mux it will pass a set flag it will be zero
				--ALU_Out <= Reg2 srl 4;	   --shift left 4 bit 	
						   			   
		end if ;
	end process;
	
			   
							   	
end architecture;