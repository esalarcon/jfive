library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cnt is
    Generic(N     : natural := 32;
            VDEF  : natural := 0);
    Port ( clk    : in  STD_LOGIC;
           rst    : in  STD_LOGIC;
           din    : in  STD_LOGIC_VECTOR (N-1 downto 0);
           load   : in  STD_LOGIC;
           plus_4 : in  STD_LOGIC;
           dout   : out  STD_LOGIC_VECTOR (N-1 downto 0));
end cnt;

architecture Behavioral of cnt is
   signal cnt     :  unsigned(dout'range);
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            cnt <= to_unsigned(VDEF,N);
         elsif(load = '1') then
            cnt <= unsigned(din);
         elsif(plus_4 = '1') then
            cnt <= cnt + 4;
         end if;
      end if;
   end process;
   dout <= std_logic_vector(cnt);
end Behavioral;
