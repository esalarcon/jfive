library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor32 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en  : in  STD_LOGIC;
           dout: out STD_LOGIC_VECTOR (31 downto 0));
end xor32;

architecture Behavioral of xor32 is
   signal y          :  std_logic_vector(31 downto 0);
begin
   process(clk)
      variable a, b, c  :  std_logic_vector(31 downto 0);
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            y <= x"92d68ca2";
         elsif(en = '1') then
            a := y xor (y(31-13 downto 0) & "0000000000000");
            b := a xor ("00000000000000000"&a(31 downto 17));
            c := b xor (b(31-5 downto 0)) & "00000";
            y <= c;
         end if;
      end if;
   end process;
   dout <= y;
end Behavioral;

