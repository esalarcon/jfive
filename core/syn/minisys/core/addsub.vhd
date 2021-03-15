library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addsub is
    Generic(N  : natural := 8);
    Port ( ans : in  STD_LOGIC;
           rs1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rs2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rd  : out STD_LOGIC_VECTOR (N-1 downto 0));
end addsub;

architecture Behavioral of addsub is
   signal s    :  unsigned(N downto 0);
   signal op2  :  unsigned(N downto 0);
begin
   op2(0)            <= ans;
   op2(N downto 1)   <= unsigned(rs2) when ans = '0' else (not unsigned(rs2));   
   s                 <= unsigned(rs1&"1")+op2;
   rd                <= std_logic_vector(s(N downto 1));
end Behavioral;
