library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity programa is
   Port ( clk  : in    STD_LOGIC;
          addr : in    STD_LOGIC_VECTOR ( 7 downto 0);
          dout : out   STD_LOGIC_VECTOR (31 downto 0));
   end programa;

architecture Behavioral of programa is
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         case addr is
            when x"00"  => dout <= x"00000137";
            when x"01"  => dout <= x"40010113";
            when x"02"  => dout <= x"0040006f";
            when x"03"  => dout <= x"fe010113";
            when x"04"  => dout <= x"00812e23";
            when x"05"  => dout <= x"02010413";
            when x"06"  => dout <= x"000207b7";
            when x"07"  => dout <= x"fef42623";
            when x"08"  => dout <= x"000107b7";
            when x"09"  => dout <= x"fef42423";
            when x"0a"  => dout <= x"fec42783";
            when x"0b"  => dout <= x"0007c783";
            when x"0c"  => dout <= x"0ff7f793";
            when x"0d"  => dout <= x"fff7c793";
            when x"0e"  => dout <= x"0ff7f713";
            when x"0f"  => dout <= x"fe842783";
            when x"10"  => dout <= x"00e78023";
            when x"11"  => dout <= x"fe5ff06f";
            when others => dout <= x"000"&"00000"&"000"&"00000"&"0010011"; --ADDI R0, R0, 0
         end case;
      end if;
   end process;
end Behavioral;
