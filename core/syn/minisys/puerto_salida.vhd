library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity puerto_salida is
    Generic(N  : natural := 8);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en  : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (N-1 downto 0);
           dout: out STD_LOGIC_VECTOR (N-1 downto 0));
end puerto_salida;

architecture Behavioral of puerto_salida is
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            dout <= (others => '0');
         elsif(en = '1') then
            dout <= din;
         end if;
      end if;
   end process;
end Behavioral;

