library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity srax is
    Port ( ri     : in  STD_LOGIC;
           rdes   : in  STD_LOGIC_VECTOR (4 downto 0);
           rs1    : in  STD_LOGIC_VECTOR (31 downto 0);
           rd     : out STD_LOGIC_VECTOR (31 downto 0));
end srax;

architecture Behavioral of srax is
   signal msb     :  std_logic_vector(30 downto 0);   
begin

   gl: for i in 0 to 30 generate
      msb(i) <= ri;
   end generate;

   with rdes select
      rd <=    rs1                                       when "00000",
               msb(0  downto  0)&rs1(31 downto  1)       when "00001",
               msb(1  downto  0)&rs1(31 downto  2)       when "00010",
               msb(2  downto  0)&rs1(31 downto  3)       when "00011",
               msb(3  downto  0)&rs1(31 downto  4)       when "00100",
               msb(4  downto  0)&rs1(31 downto  5)       when "00101",
               msb(5  downto  0)&rs1(31 downto  6)       when "00110",
               msb(6  downto  0)&rs1(31 downto  7)       when "00111",
               msb(7  downto  0)&rs1(31 downto  8)       when "01000",
               msb(8  downto  0)&rs1(31 downto  9)       when "01001",
               msb(9  downto  0)&rs1(31 downto  10)      when "01010",
               msb(10 downto  0)&rs1(31 downto  11)      when "01011",
               msb(11 downto  0)&rs1(31 downto  12)      when "01100",
               msb(12 downto  0)&rs1(31 downto  13)      when "01101",
               msb(13 downto  0)&rs1(31 downto  14)      when "01110",
               msb(14 downto  0)&rs1(31 downto  15)      when "01111",
               msb(15 downto  0)&rs1(31 downto  16)      when "10000",
               msb(16 downto  0)&rs1(31 downto  17)      when "10001",
               msb(17 downto  0)&rs1(31 downto  18)      when "10010",
               msb(18 downto  0)&rs1(31 downto  19)      when "10011",
               msb(19 downto  0)&rs1(31 downto  20)      when "10100",
               msb(20 downto  0)&rs1(31 downto  21)      when "10101",
               msb(21 downto  0)&rs1(31 downto  22)      when "10110",
               msb(22 downto  0)&rs1(31 downto  23)      when "10111",
               msb(23 downto  0)&rs1(31 downto  24)      when "11000",
               msb(24 downto  0)&rs1(31 downto  25)      when "11001",
               msb(25 downto  0)&rs1(31 downto  26)      when "11010",
               msb(26 downto  0)&rs1(31 downto  27)      when "11011",
               msb(27 downto  0)&rs1(31 downto  28)      when "11100",
               msb(28 downto  0)&rs1(31 downto  29)      when "11101",
               msb(29 downto  0)&rs1(31 downto  30)      when "11110",
               msb(30 downto  0)&rs1(31 downto  31)      when others;
end Behavioral;
