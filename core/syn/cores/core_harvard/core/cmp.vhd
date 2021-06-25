library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cmp is
    Generic(N  : natural := 8);
    Port ( rs1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rs2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           uns : in  STD_LOGIC;
           lt  : out STD_LOGIC;
           eq  : out STD_LOGIC);
end cmp;

architecture Behavioral of cmp is
   signal rs1_i:  unsigned(N-1 downto 0);
   signal rs2_i:  unsigned(N-1 downto 0);
begin
  rs1_i(N-2 downto 0) <= unsigned(rs1(N-2 downto 0));
  rs2_i(N-2 downto 0) <= unsigned(rs2(N-2 downto 0));
  rs1_i(N-1)          <= rs1(N-1) when uns = '1' else rs2(N-1);
  rs2_i(N-1)          <= rs2(N-1) when uns = '1' else rs1(N-1);
  lt                  <= '1' when rs1_i <  rs2_i else '0'; 
  eq                  <= '1' when rs1 = rs2 else '0';
end Behavioral;
