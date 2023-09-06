-- the library that needed 
library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_signed.all;  			
use ieee.numeric_std.all;
-- the entity of the system 
ENTITY mips IS 
	PORT(clock : IN std_logic
		);
END ENTITY mips;   

-- start the behavioral of the system 

ARCHITECTURE simple OF mips IS 
	SIGNAL pc 			: std_logic_vector(23 DOWNTO 0):=x"000000";  -- the signal for pc 
	SIGNAL instruction 	: std_logic_vector(23 DOWNTO 0);	-- the signal for instruction  
		----------------------------------------------------------------
	SIGNAL buffer1data : std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');
	
	--SIGNAL condtion : std_logic_vector(1 DOWNTO 0):=(OTHERS => '0');
	--SIGNAL opcode: std_logic_vector(4 DOWNTO 0):=(OTHERS => '0');
	SIGNAL SF: std_logic:='0';
	SIGNAL RS: std_logic_vector(2 DOWNTO 0):=(OTHERS => '0');
	SIGNAL Rt: std_logic_vector(2 DOWNTO 0):=(OTHERS => '0'); 
	SIGNAL Rd: std_logic_vector(2 DOWNTO 0):=(OTHERS => '0');
	SIGNAL immediateI: std_logic_vector(9 DOWNTO 0):=(OTHERS => '0');	  -- immediate Itype 
	SIGNAL immediateJ: std_logic_vector(16 DOWNTO 0):=(OTHERS => '0');	  -- immadiate Jtpe 
	
	---------------------------------------------------------------
	SIGNAL control_signal: std_logic_vector(6 DOWNTO 0):=(OTHERS => '0'); -- condtioin +opcode  input for control unit 	 
	SIGNAL RegDest: std_logic_vector(1 DOWNTO 0):=(OTHERS => '0');	     -- the output of control unit 
	SIGNAL ExtOp: std_logic:='0';
	SIGNAL ALUSrc: std_logic:= '0';
	SIGNAL AluOp: std_logic_vector(4 DOWNTO 0):=(OTHERS => '0');
	SIGNAL MEMRd: std_logic:= '0';
	SIGNAL MEMWr: std_logic:='0';
	SIGNAL WBdata: std_logic_vector(1 DOWNTO 0):=(OTHERS => '0');
	SIGNAL PCSrc: std_logic_vector(1 DOWNTO 0):=(OTHERS => '0');
	SIGNAL RegWr: std_logic:='0'; 	  -- input to regisiter file 
	SIGNAL condop: std_logic_vector(1 DOWNTO 0):=(OTHERS => '0');
	SIGNAL zerofsetfcontrol: std_logic:='0';
	SIGNAL JorB: std_logic:='0';
	SIGNAL DworImm: std_logic:= '0';
   	------------------------------------------------------------------------		   				                                               
	SIGNAL dataIn : std_logic_vector(23 DOWNTO 0):=(OTHERS => '0'); 	  -- Regisiter File 
	SIGNAL RA  : std_logic_vector(2 DOWNTO 0):=(OTHERS => '0');
	SIGNAL RB: std_logic_vector(2 DOWNTO 0):=(OTHERS => '0');
	SIGNAL BUSA: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');
	SIGNAL BUSB: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');
	SIGNAL writeAddress: std_logic_vector(2 DOWNTO 0):=(OTHERS => '0');	
	----------------------------------------------------------------------
	SIGNAL R7: std_logic_vector(2 DOWNTO 0):= "111";	
	SIGNAL R1: std_logic_vector(2 DOWNTO 0):="001";	
	-----------------------------------------------------  
	SIGNAL lengthofimmediate: integer:=17;	   
	------------------------------------  
	SIGNAL data_outImmadiate: std_logic_vector(23 DOWNTO 0):= (OTHERS => '0');	
	SIGNAL buffer2data: std_logic_vector(71 DOWNTO 0):=(OTHERS => '0');
	
	SIGNAL dataInBuffer: std_logic_vector(71 DOWNTO 0):= (OTHERS => '0');
	SIGNAL MuxALu: std_logic_vector(23 DOWNTO 0):= (OTHERS => '0');
	
	
	SIGNAL ALU_Out: std_logic_vector(23 DOWNTO 0):= (OTHERS => '0');
	SIGNAL Zero_flag_orSetFlag: std_logic;  
	SIGNAL ZeroFlag: std_logic:='0';
	SIGNAL SetFlag: std_logic:='0';
	
	-------------------------------------------------------------------------
	SIGNAL buffer3data: std_logic_vector(47 DOWNTO 0):=(OTHERS => '0'); -- the data from the third Buffer 
	
	SIGNAL dataInBuffer3: std_logic_vector(47 DOWNTO 0):=(OTHERS => '0'); 
	
	SIGNAL dataInBuffer4: std_logic_vector(71 DOWNTO 0):=(OTHERS => '0'); 
	SIGNAL dataInBuffer5: std_logic_vector(71 DOWNTO 0):=(OTHERS => '0'); 
	
	-----------------------------------------------------------------------------
	SIGNAL Address_Memory: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');   -- for the Data Address Memory 
	SIGNAL DataMemory: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');    -- for Data Memory  
	SIGNAL ReadData: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');	 -- the output for the Data Memory 
	SIGNAL WriteData: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');
	
	SIGNAL WriteDataout: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');	 
	---------------------------------------------------------------------------
	SIGNAL ShiftOutput: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0'); 		
	---------------------------------------------------------------
	Signal JorJR: std_logic:='0';
	-------------------
	
	SIGNAL x1: std_logic_vector(6 DOWNTO 0):=(OTHERS => '0');	
	
	SIGNAL x2: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');	
	
	SIGNAL x3: std_logic_vector(23 DOWNTO 0):=(OTHERS => '0');	
	
	  Signal expression: integer:=1;
	   
BEGIN
	
	

	
	
	fetch1 : ENTITY work.InstructionMemory(Behavioral) -- the fetch of the system 
	PORT MAP (pc,instruction);
	
	buffer1: ENTITY work.bufferNew(bufferr) GENERIC MAP (24) --- the buffer that send to it 24 bit 
	PORT MAP(clock, instruction,
	buffer1data );
	
	--condtion<= buffer1data(1 downto 0); --- condtion 	
	--opcode<= buffer1data(6 downto 2);  --- opcode 
	process(buffer1data(6 downto 2))
	
	begin
		if (buffer1data(5)='1' and buffer1data(4)='1') then  -- Jtype 
			SF <='X';
			immediateJ <=buffer1data(16 downto 0 );	
			lengthofimmediate<=17;	
			
	
			
		end if;	
		
		if (buffer1data(6 downto 2)="00111" or buffer1data(6 downto 2)="01000" or buffer1data(6 downto 2)="01001" or buffer1data(6 downto 2)="01010" or buffer1data(6 downto 2)="01011") then  -- IType 
			Rt<= buffer1data(15 downto 13);
			RS<= buffer1data(12 downto 10);
			SF <=buffer1data(16);
			immediateI <=buffer1data(9 downto 0);
			lengthofimmediate<=10;
		end if;	
		
		if (buffer1data(6 downto 2)="00011" or buffer1data(6 downto 2)="00000" or buffer1data(6 downto 2)="00001" or buffer1data(6 downto 2)="00010" or buffer1data(6 downto 2)="00011" or buffer1data(6 downto 2)="00100" or buffer1data(6 downto 2)="00101" or buffer1data(6 downto 2)="00110") then  -- RType 
			SF <=buffer1data(16);
			Rd<= buffer1data(15 downto 13);
			RS<= buffer1data(12 downto 10);
			
			Rt<= buffer1data(9 downto 7);
			 
		end if;			  
		---------------------------------
		
		
	--control_signal<= buffer1data(6 downto 0); 
	end process;
	x1<= buffer1data(23 downto 17);

		
	control_unit : ENTITY work.control_unit_main_alu(Behavioral)  --- control unit 
	PORT MAP( buffer1data(23 downto 17), RegDest, ExtOp, ALUSrc, AluOp, MEMRd, MEMWr, WBdata, PCSrc, RegWr, condop, zerofsetfcontrol, JorB); 
	
	-------------------------------------------		 
	Mux : ENTITY work.mux4x1Regisiter(behaviour) -- Mux 
	PORT MAP (Rt,Rd,R7,R1,RegDest,writeAddress);	
	
	
	RegisterFile : ENTITY work.registerfile(regfile) --  
	PORT MAP (clock,RegWr,writeAddress,WriteDataout,RS,Rt,BUSA,BUSB);	
	
	 Extender : ENTITY work.sing_extend(signExt) GENERIC MAP (lengthofimmediate) 
	 PORT MAP (immediateJ,ExtOp,data_outImmadiate);	
	 
	 
	 
	 dataInBuffer <= BUSA & BUSB & data_outImmadiate;	 
	 
	 
	 buffer2: ENTITY work.bufferNew(bufferr) GENERIC MAP (72) --- the buffer that send to it 24 bit 
	PORT MAP(clock, dataInBuffer,
	buffer2data );	
	
		 
   	MuxALU2: ENTITY work.mux2ALU(behaviour)  --- the Mux to select between 
	PORT MAP(buffer2data(47 downto 24),buffer2data(23 downto 0),ALUSrc,MuxALu); 
	
	MuxALUZero: ENTITY work.mux2to1(behaviour)  --- the Mux to select between them 
	PORT MAP(ZeroFlag,SF,zerofsetfcontrol,Zero_flag_orSetFlag);
	
	
	ALUcomp: ENTITY work.ALU(Behavioral)  --- the ALU 
	PORT MAP(buffer2data(71 downto 48),MuxALu,ALU_Out,Zero_flag_orSetFlag,condop,AluOp,ZeroFlag ); 
	
	
	Shiftcomp: Entity work.shift(shiftbyfour)
		Port MAP(buffer2data(23 downto 0),ShiftOutput);		 
		
				 
	
	dataInBuffer3 <= ALU_Out & ShiftOutput;
	buffer3:ENTITY work.bufferNew(bufferr) GENERIC MAP (48) --- the buffer that send to it 24 bit 
	PORT MAP(clock, dataInBuffer3,buffer3data );
	
	
	
	
	DataMemory1:ENTITY work.DataMemory(Behavioral)  --- Memory data
	PORT MAP(MEMWr, MEMRd,buffer3data(47 downto 24),BUSB,ReadData);	 
	
	dataInBuffer5<=ReadData&buffer3data;
	
	buffer4:ENTITY work.bufferNew(bufferr) GENERIC MAP (72) --- the buffer that send to it 24 bit 
	PORT MAP(clock, dataInBuffer5,dataInBuffer4 ); 
	
	MuxWrite: ENTITY work.mux3x1MemWB(behaviour)  --- the Mux to select between 
	PORT MAP(dataInBuffer4(47 downto 24),dataInBuffer4(71 downto 48),dataInBuffer4(23 downto 0),WBdata,WriteDataout);
	
	
	
	process(JorB,buffer1data(21 downto 17))
	begin
	if JorB='0' then 
			if buffer1data(21 downto 17)="01100" then 	 --J
			 pc <= std_logic_vector(unsigned(pc) +unsigned(data_outImmadiate));	 
			elsif buffer1data(21 downto 17)="00110" then  --JR

				pc <= BUSA;
			
			end if;	   
			
		elsif JorB='1' then 
			if ZeroFlag='1' then 
			pc <= std_logic_vector(unsigned(pc) +unsigned(data_outImmadiate));	 
			else
					pc <= std_logic_vector(unsigned(pc) +1);	 
			end if;	 
		else
			pc <= std_logic_vector(unsigned(pc) +1);
			
	end if;
			
	end process;
	
			

	
	
	

end;	
	

	
	
	
	
	
	

