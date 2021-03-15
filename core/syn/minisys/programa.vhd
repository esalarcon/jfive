library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity programa is
    Port ( clk  : in    STD_LOGIC;
           addr : in    STD_LOGIC_VECTOR ( 3 downto 0);
           dout : out   STD_LOGIC_VECTOR (31 downto 0));
end programa;

architecture Behavioral of programa is

begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         case addr is
            when x"0"     => dout <= x"00100293"; -- addi x5,x0,1
            when x"1"     => dout <= x"01000413"; -- addi x8,x0,16
            when x"2"     => dout <= x"00001337"; -- lui  x6,1
            when x"3"     => dout <= x"00030313"; -- addi x6,x6,0
            when x"4"     => dout <= x"00530023"; -- sb x5,0(x6)
            when x"5"     => dout <= x"000963B7"; -- lui x7, 0x96
            --when x"5"     => dout <= x"00400393"; -- addi x7, x0, 4
            when x"6"     => dout <= x"FFF38393"; -- addi x7, x7, -1
            when x"7"     => dout <= x"FE039EE3"; -- bne x7, x0, -4
            when x"8"     => dout <= x"00129293"; -- slli x5, x5, 1
            when x"A"     => dout <= x"FE5412E3"; -- bne x8, x5, -28
            when x"B"     => dout <= x"00100293"; -- addi x5, x0, 1
            when x"C"     => dout <= x"FDDFF06F"; -- jal x0, -36
            when others   => dout <= x"000"&"00000"&"000"&"00000"&"0010011"; --ADDI R0, R0, 0
         end case;
      end if;
   end process;
end Behavioral;

