library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity genb is
    Port ( rs1 : in  STD_LOGIC_VECTOR (31 downto 0);
           rs2 : in  STD_LOGIC_VECTOR (31 downto 0);
           cmd : in  STD_LOGIC_VECTOR ( 2 downto 0);
           bok : out  STD_LOGIC);
end genb;

architecture Behavioral of genb is
   signal eq, lt  :  std_logic;
begin
   slt:  entity work.cmp(Behavioral)
         generic map(N     => 32)
         port map   (rs1   => rs1,
                     rs2   => rs2,
                     uns   => cmd(1),
                     eq    => eq,
                     lt    => lt);
   bok <= (eq xor cmd(0)) when cmd(2) = '0' else (lt xor cmd(0));
end Behavioral;
