																									 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity control_unit_main_alu is				 
	
    Port (
	
		  opFormat: in std_logic_vector (6 downto 0);
         -- cond:in  STD_LOGIC_VECTOR (1 downto 0);
        --  opcode:in  STD_LOGIC_VECTOR (4 downto 0);
		  RegDest:out std_logic_vector(1 downto 0);
		  ExtOp:out std_logic;
		  ALUSrc:out std_logic;
		  AluOp:out std_logic_vector (4 downto 0);
		  MEMRd:out std_logic;
		  MEMWr:out std_logic;
		  WBdata:out std_logic_vector(1 downto 0);
		  PCSrc:out std_logic_vector(1 downto 0); 	
		  RegWr:out std_logic;
		  condop:out std_logic_vector(1 downto 0);
		  zerofsetfcontrol: out std_logic;
		  JorB:out std_logic --jump or branch  
	   
		   ); 
		   
end control_unit_main_alu;	  
architecture Behavioral of control_unit_main_alu is	   
signal opcode: std_logic_vector(4 downto 0);
signal cond:std_logic_vector (1 downto 0);
signal sf:std_logic;
begin 
	cond<=opFormat(6 downto 5);
	opcode<=opFormat(4 downto 0);	 
	
	
	
	Process(opcode,cond)						  
	begin
		if opcode="00011"then    --ADD
			RegDest<="01";
			ExtOp<=	'0';
			ALUSrc<= '0';
			AluOp<=	opcode;
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="00";
			PCSrc<="00";	
			RegWr<='1';	
			
			condop<=cond;
			
			if  cond ="00" then 
				zerofsetfcontrol<='1'; --ADD and SUBSF
			elsif  cond ="01" then --ADDEQ
				zerofsetfcontrol<='0';
			elsif cond ="10" then	  --ADDNE
				zerofsetfcontrol<='0';	 
			end if;
	   end if;
	   
	   
	   
	   if opcode="01000" then  --ADDI
		   RegDest<="00";
			ExtOp<=	'0';
			ALUSrc<= '1';
			AluOp<=	opcode;
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="00";
			PCSrc<="00";	   
			RegWr<='1';
			condop<=cond;
			if  cond ="00" then 
				zerofsetfcontrol<='1';	--ADDI, SUBISF
			elsif  cond ="01" then 	--ADDIEQ
				zerofsetfcontrol<='0';
			elsif cond ="10" then	  --ADDINQ
				zerofsetfcontrol<='0';	 
			end if;			
			
	   end if;
	   
	   
	   
	   
	if opcode="00100" then  --SUB
		RegDest<="01";
			ExtOp<=	'0';
			ALUSrc<= '0';
			AluOp<=	opcode;
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="00";
			PCSrc<="00";	 
			RegWr<='1';	
			condop<=cond;
			if  cond ="00" then 
				zerofsetfcontrol<='1';
			elsif  cond ="01" then --SUBEQ
				zerofsetfcontrol<='0';
			elsif cond ="10" then	  --SUBNE
				zerofsetfcontrol<='0';	 
			end if;
	   end if; 
	   
	   
	   
	   
	   if opcode="00000" OR opcode="00001"  then --AND CAS 
		    RegDest<="01";
			ExtOp<=	'0';
			ALUSrc<= '0';
			AluOp<=	opcode;
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="00";
			PCSrc<="00";	   
			RegWr<='1';	
			condop<=cond;
			zerofsetfcontrol<='1';
			
	   end if;	
	   
	   
	   
	      if opcode="00111" then --ANDI
		    RegDest<="00";
			ExtOp<='0';
			ALUSrc<='1';
			AluOp<=	opcode;
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="00";
			PCSrc<="00";	   
			RegWr<='1';	
			condop<=cond;
			zerofsetfcontrol<='1';
			
	   end if;
	   
	   
	 
	   if opcode="00010" then --LWS
		    RegDest<="01";
			ExtOp<=	'0';
			ALUSrc<='0';
			AluOp<=	"00011";	--can put the opcode of the ADD ?
			MEMRd<=	'1';
			MEMWr<=	'0';
			WBdata<="01";
			PCSrc<="00";
			RegWr<='1';
			condop<="00";
			zerofsetfcontrol<='1';	 
	   end if;
	   
	   
	   if opcode="00101" then --CMP
		   	RegDest<="XX";
			ExtOp<=	'0';
			ALUSrc<= '0';
			AluOp<=	opcode;	
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="00";
			PCSrc<="00";	
			RegWr<='X';
			condop<=cond;	
			zerofsetfcontrol<='1';
	   end if;
	   
	   
	   
	   
	   if opcode="00110" then 	 --JR
		  	RegDest<="XX";
			ExtOp<=	'X';
			ALUSrc<= 'X';
			AluOp<=	"XXXXX";	
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="XX";
			PCSrc<="01";	 
			condop<=cond;	 
		
			zerofsetfcontrol<='X';	   
			JorB<='0';
			
	   end if;			
	   
	   
	   
	   
	   if opcode="01001" then  --LW
		   
	   	    RegDest<="00";
			ExtOp<=	'0';
			ALUSrc<='1';
			AluOp<=	"00011"; --can put the opcode of the ADD ?
			MEMRd<=	'1';
			MEMWr<=	'0';
			WBdata<="01";
			PCSrc<="00";
			RegWr<='1';
			condop<="00";  
			
			zerofsetfcontrol<='1';	
			
	   end if;
	   
		   
	  if opcode="01001" then  --SW
		   
	   	    RegDest<="XX";
			ExtOp<=	'0';
			ALUSrc<='1';
			AluOp<=	"00011"; --can put the opcode of the ADD ?
			MEMRd<=	'0';
			MEMWr<=	'1';
			WBdata<="XX";
			PCSrc<="00";
			RegWr<='0';
			condop<="00";
			
			zerofsetfcontrol<='1';	
			
	   end if;	   
	   
	   
	     if opcode="01100" then 	 --J
		  	RegDest<="XX";
			ExtOp<=	'X';
			ALUSrc<= 'X';
			AluOp<=	"XXXXX";	
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="XX";
			PCSrc<="01";	 
			condop<=cond;	
		
			zerofsetfcontrol<='X';	   
			JorB<='0';
			
	   end if;	
	   
	   if opcode="01011" then --BEQ	  
		   	RegDest<="XX";
			ExtOp<=	'X';
			ALUSrc<= 'X';
			AluOp<=	"00100";	
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="XX";
			PCSrc<="10";	 
			condop<=cond;
			zerofsetfcontrol<='X';	   
			JorB<='1'; 
		
			
	   end if;	
	   
	   
	   if opcode="01101" then --JAL
		   	RegDest<="10"; --select R7
			ExtOp<=	'X';
			ALUSrc<= 'X';
			AluOp<=	"00011";	
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="10";
			PCSrc<="10";	 
			condop<=cond;
			zerofsetfcontrol<='X';	   
			JorB<='0';				  
		
			
	   end if;	
	   
	   
	   if opcode="01110" then --LUI
		   	RegDest<="11"; --select R1
			ExtOp<=	'X';
			ALUSrc<= 'X';
			AluOp<=	"00011";	
			MEMRd<=	'0';
			MEMWr<=	'0';
			WBdata<="XX";
			PCSrc<="10";	 
			condop<=cond;
			zerofsetfcontrol<='X';	   
			JorB<='X'; 
			
			
	   end if;		
		
		
	
end process;
end Behavioral;