
	library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity adderpc is
    port (
        pc : in std_logic_vector(23 downto 0);
       
        sum : out std_logic_vector(23 downto 0)
    );
end entity;		





-- Define the architecture
architecture Behavioral of adderpc is  

begin						  
	
	
    -- Add the inputs a and b
    sum <= std_logic_vector(unsigned(pc) +4);
end architecture;