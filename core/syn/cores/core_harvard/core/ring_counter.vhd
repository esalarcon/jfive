library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ring_counter is
    Generic(N  : natural := 8);
    Port ( clk : in     STD_LOGIC;
           rst : in     STD_LOGIC;
           en  : in     STD_LOGIC;
           q   : out    STD_LOGIC_VECTOR (N-1 downto 0));
end ring_counter;

architecture Behavioral of ring_counter is
   signal cnt  :  std_logic_vector(q'range);
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            cnt(N-1 downto 1) <= (others => '0');
            cnt(0) <= '1';
         elsif(en = '1') then
            cnt(N-1 downto 1) <= cnt(N-2 downto 0);
            cnt(0) <= cnt(N-1);
         end if;
      end if;
   end process;
   q <= cnt;
end Behavioral;

