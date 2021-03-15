library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity puerto_entrada is
    Generic(N  : natural := 8);
    Port ( clk : in  STD_LOGIC;
           pin : in  STD_LOGIC_VECTOR (N-1 downto 0);
           q   : out STD_LOGIC_VECTOR (N-1 downto 0));
end puerto_entrada;

architecture Behavioral of puerto_entrada is
   signal qi   :  std_logic_vector(pin'range);
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         qi <= pin;
         q  <= qi;
      end if;
   end process;
end Behavioral;
