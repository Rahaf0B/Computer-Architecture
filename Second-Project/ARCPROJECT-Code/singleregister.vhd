library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity singleregister is
    Port ( D : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end singleregister;

architecture Behavioral of singleregister is
begin
    process (Clk)
    begin
        if (Clk'event and Clk = '1') then
            Q <= D;
        end if;
    end process;
end Behavioral;