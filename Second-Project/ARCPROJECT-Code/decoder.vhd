library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder3x8 is
    Port ( A : in  STD_LOGIC_VECTOR (2 downto 0);
           Y : out  STD_LOGIC_VECTOR (7 downto 0));
end decoder3x8;

architecture Behavioral of decoder3x8 is
begin
    Y(0) <= A(2) and A(1) and not A(0);
    Y(1) <= A(2) and A(1) and A(0);
    Y(2) <= A(2) and not A(1) and not A(0);
    Y(3) <= A(2) and not A(1) and A(0);
    Y(4) <= A(2) and A(1) and not A(0);
    Y(5) <= not A(2) and A(1) and A(0);
    Y(6) <= not A(2) and not A(1) and not A(0);
    Y(7) <= not A(2) and not A(1) and A(0);
end Behavioral;											
