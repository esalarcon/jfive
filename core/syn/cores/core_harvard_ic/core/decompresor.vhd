library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity decompresor is
    Port (  c        : in  STD_LOGIC_VECTOR (15 downto 0);
            i        : out STD_LOGIC_VECTOR (31 downto 0);
            c_jalr   : out STD_LOGIC);
end decompresor;
--Me copio lo que hizo:
--https://github.com/djzenma/RV32IC-CPU/blob/master/RTL/decompression.v
--Le agrego la salida c_jalr ya que tengo que hacer PC+2 en vez de PC+4 
--cuando es jalr comprimida.

-- Instrucciones soportadas (26):
-- -------------------------
   --c.addi4spn
   --c.nop
   --c.addi
   --c.slli
   --c.jal
   --c.lw
   --c.li
   --c.lwsp
   --c.addi16sp
   --c.lui
   --c.sub
   --c.xor
   --c.or
   --c.and
   --c.andi
   --c.srli
   --c.srai
   --c.jalr
   --c.jr
   --c.mv
   --c.add
   --c.j
   --c.sw
   --c.beqz
   --c.swsp
   --c.bnez

architecture Behavioral of decompresor is
begin
   process(c)
      variable tmp      : std_logic_vector(4 downto 0);
      variable chk_jalr : std_logic;
      
   begin
      tmp := c(15 downto 13)&c(1 downto 0) ;
      chk_jalr := '0';
      
      case tmp is
         when "00000"=> 
                        --c.addi4spn
                        i <=  "00"&c(10 downto 7)&c(12 downto 11)&c(5)&c(6)&
                              "00"&"00010"&"000"&"01"&c(4 downto 2)&"0010011";
         when "00001"=>
                        if unsigned(c(12 downto 2)) = to_unsigned(0,11) then
                           --c.nop
                           i <= x"000000"&"00010011";
                        else
                           --c.addi
                           i <= c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&
                                c(6 downto 2)& c(11 downto 7)& "000"& c(11 downto 7)&
                                "0010011";
                        end if;        
         when "00010"=>
                        --c.slli
                        i <= "0000000"&c(6 downto 2)&c(11 downto 7)&"001"&
                              c(11 downto 7)&"0010011";
         --when "00011"=>
         --when "00100"=>
         when "00101"=>
                        --c.jal
                        i <= c(12)&c(8)&c(10 downto 9)&c(6)&c(7)&c(2)&c(11)&
                             c(5 downto 3)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&
                             c(12)&c(12)&c(12)&"00001"&"1101111";   
         --when "00110"=>
         --when "00111"=>
         when "01000"=>
                        --c.lw
                        i <= "00000"&c(5)&c(12 downto 10)&c(6)&"00"&"01"&c(9 downto 7)&
                             "010"&"01"&c(4 downto 2)&"0000011";
         when "01001"=>
                        --c.li
                        i <= c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&
                             c(6 downto 2)&"00000"&"000"&c(11 downto 7)&
                             "0010011";
         when "01010"=>
                        --c.lwsp
                        i <= "0000"&c(3 downto 2)&c(12)&c(6 downto 4)&"00"&
                             "00010"&"010"&c(11 downto 7)&"0000011";
         
         --when "01011"=>
         --when "01100"=>
         when "01101"=>
                        if c(11 downto 7) = "00010" then
                           --c.addi16sp
                           i <= c(12)&c(12)&c(12)&c(4)&c(3)&c(5)&c(2)&c(6)&
                                "0000"&"00010"&"000"&"00010"&"0010011";
                        else
                           --c.lui
                           i <= c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&
                                c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&
                                c(6 downto 2)&c(11 downto 7)&"0110111";
                        end if;
         --when "01110"=>
         --when "01111"=>
         --when "10000"=>
         when "10001"=>
                     if c(12 downto 10) = "011" then
                        case c(6 downto 5) is
                           when "00"   =>
                                          --c.sub
                                          i <= "0100000"&"01"&c(4 downto 2)&"01"&
                                               c(9 downto 7)&"000"&"01"&c(9 downto 7)&
                                               "0110011";
                           when "01"   =>
                                          --c.xor
                                          i <= "0000000"&"01"&c(4 downto 2)&"01"&
                                               c(9 downto 7)&"100"&"01"&c(9 downto 7)&
                                               "0110011";
                           when "10"   =>
                                          --c.or
                                          i <= "0000000"&"01"&c(4 downto 2)&"01"&
                                               c(9 downto 7)&"110"&"01"&c(9 downto 7)&
                                               "0110011";
                           when "11"   =>
                                          --c.and
                                          i <= "0000000"&"01"&c(4 downto 2)&"01"&
                                               c(9 downto 7)&"111"&"01"&c(9 downto 7)&
                                               "0110011";
                           when others => 
                                          i <= (others => '0'); 
                        end case;
                     elsif c(11 downto 10) = "10" then
                        --c.andi
                        i <= c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&
                             c(6 downto 2)&"01"&c(9 downto 7)&"111"&"01"&
                             c(9 downto 7)&"0010011";
                     elsif c(12) = '0' and c(6 downto 2) = "00000" then
                        --Skip instruction
                        i <= (others => '0');
                     elsif c(11 downto 10) = "00" then
                        --c.srli
                        i <= "0000000"&c(6 downto 2)&"01"&c(9 downto 7)&
                             "101"&"01"&c(9 downto 7)&"0010011";
                     else
                        --c.srai
                        i <= "0100000"&c(6 downto 2)&"01"&c(9 downto 7)&
                             "101"&"01"&c(9 downto 7)&"0010011";
                     end if;
         when "10010"=>
                     if c(6 downto 2) = "00000" then
                        if c(12)='1' and c(11 downto 7)/="00000" then
                           --c.jalr
                           i <= x"000"&c(11 downto 7)&"000"&"00001"&"1100111";
                           chk_jalr := '1';
                        else
                           --c.jr
                           i <= x"000"&c(11 downto 7)&"000"&"00000"&"1100111";
                        end if;
                     elsif c(11 downto 7) /= "00000" then   
                        if c(12) = '0' then
                           --c.mv
                           i <= "0000000"&c(6 downto 2)&"00000"&"000"&
                                c(11 downto 7)&"0110011";
                        else
                           --c.add
                           i <= "0000000"&c(6 downto 2)&c(11 downto 7)&"000"&
                                c(11 downto 7)&"0110011";
                        end if;
                     else
                        i <= (others => '0');
                     end if;
         --when "10011"=>
         --when "10100"=>
         when "10101" =>
            --c.j
            i <= c(12)&c(8)&c(10 downto 9)&c(6)&c(7)&c(2)&c(11)&c(5 downto 3)&
                 c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&c(12)&"00000"&
                 "1101111";
         --when "10110"=>
         --when "10111"=>
         when "11000"=>
            --c.sw
            i <= "00000"&c(5)&c(12)&"01"&c(4 downto 2)&"01"&c(9 downto 7)&
                 "010"&c(11 downto 10)&c(6)&"00"&"0100011";
         when "11001"=>
            --c.beqz
            i <= c(12)&c(12)&c(12)&c(12)&c(6)&c(5)&c(2)&"00000"&
                 "01"&c(9 downto 7)&"000"&c(11)&c(10)&c(4)&c(3)&
                 c(12)&"1100011";
         when "11010"=>
            --c.swsp
            i <= "0000"&c(8 downto 7)&c(12)&c(6 downto 2)&"00010"&
                 "010"&c(11 downto 9)&"00"&"0100011";
         --when "11011"=>
         --when "11100"=>
         when "11101"=>
            --c.bnez
            i <= c(12)&c(12)&c(12)&c(12)&c(6)&c(5)&c(2)&"00000"&
                 "01"&c(9 downto 7)&"001"&c(11)&c(10)&c(4)&c(3)&
                 c(12)&"1100011";
         --when "11110"=>
         --when "11111"=>
         when others => i <= (others => '0');   -- Falla;
      end case;
      c_jalr <= chk_jalr;
   end process;
end Behavioral;

