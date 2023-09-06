					
library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
-- the entity of Mux2x1 to select between zero flag or set flag 
entity muxPC is
  port (PCSrc: in std_logic_vector(1 downto 0);
  jorB : in std_logic;					
  RS:  in std_logic_vector(23 downto 0);
  IMM: in std_logic_vector(23 downto 0);
     PC : in std_logic_vector(23 downto 0)	;
	 PCout:out std_logic_vector(23 downto 0)); 
end muxPC;

architecture behaviour of muxPC is 
begin
  process (PCSrc, jorB)
  begin
    if PCSrc="00" then 
		PCout <= std_logic_vector(unsigned(PC) +1);	 
	elsif PCSrc="01" then 
		PCout <= std_logic_vector(unsigned(PC) +unsigned(IMM));	 	  
	elsif PCSrc="10" then 
		PCout <= RS;	 	  
	elsif PCSrc="11" then 
		PCout <=std_logic_vector(unsigned(PC) +unsigned(IMM));	
		
    end if;
  end process;
end behaviour; 
