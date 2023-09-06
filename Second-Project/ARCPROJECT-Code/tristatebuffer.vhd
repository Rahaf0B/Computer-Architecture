library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    Port ( D : in  STD_LOGIC;
           En : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end tri_state_buffer;

architecture Behavioral of tri_state_buffer is
begin
Q <= D when En = '1' else 'Z'; 
	
end Behavioral;