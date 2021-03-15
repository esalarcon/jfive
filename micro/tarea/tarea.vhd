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
            when x"02"  => dout <= x"0640006f";
            when x"03"  => dout <= x"fe010113";
            when x"04"  => dout <= x"00812e23";
            when x"05"  => dout <= x"02010413";
            when x"06"  => dout <= x"fea42623";
            when x"07"  => dout <= x"fec42783";
            when x"08"  => dout <= x"00d79793";
            when x"09"  => dout <= x"fec42703";
            when x"0a"  => dout <= x"00f747b3";
            when x"0b"  => dout <= x"fef42623";
            when x"0c"  => dout <= x"fec42783";
            when x"0d"  => dout <= x"0117d793";
            when x"0e"  => dout <= x"fec42703";
            when x"0f"  => dout <= x"00f747b3";
            when x"10"  => dout <= x"fef42623";
            when x"11"  => dout <= x"fec42783";
            when x"12"  => dout <= x"00579793";
            when x"13"  => dout <= x"fec42703";
            when x"14"  => dout <= x"00f747b3";
            when x"15"  => dout <= x"fef42623";
            when x"16"  => dout <= x"fec42783";
            when x"17"  => dout <= x"00078513";
            when x"18"  => dout <= x"01c12403";
            when x"19"  => dout <= x"02010113";
            when x"1a"  => dout <= x"00008067";
            when x"1b"  => dout <= x"fe010113";
            when x"1c"  => dout <= x"00112e23";
            when x"1d"  => dout <= x"00812c23";
            when x"1e"  => dout <= x"02010413";
            when x"1f"  => dout <= x"fe042623";
            when x"20"  => dout <= x"92d697b7";
            when x"21"  => dout <= x"ca278793";
            when x"22"  => dout <= x"fef42423";
            when x"23"  => dout <= x"000207b7";
            when x"24"  => dout <= x"fef42223";
            when x"25"  => dout <= x"000107b7";
            when x"26"  => dout <= x"fef42023";
            when x"27"  => dout <= x"fe442783";
            when x"28"  => dout <= x"0007a783";
            when x"29"  => dout <= x"00f7f713";
            when x"2a"  => dout <= x"00f00793";
            when x"2b"  => dout <= x"fef718e3";
            when x"2c"  => dout <= x"fe842503";
            when x"2d"  => dout <= x"f59ff0ef";
            when x"2e"  => dout <= x"fea42423";
            when x"2f"  => dout <= x"fe842703";
            when x"30"  => dout <= x"fe042783";
            when x"31"  => dout <= x"00e7a023";
            when x"32"  => dout <= x"fe042623";
            when x"33"  => dout <= x"0100006f";
            when x"34"  => dout <= x"fec42783";
            when x"35"  => dout <= x"00178793";
            when x"36"  => dout <= x"fef42623";
            when x"37"  => dout <= x"fec42703";
            when x"38"  => dout <= x"000497b7";
            when x"39"  => dout <= x"3df78793";
            when x"3a"  => dout <= x"fee7d4e3";
            when x"3b"  => dout <= x"fb1ff06f";
            when others => dout <= x"000"&"00000"&"000"&"00000"&"0010011"; --ADDI R0, R0, 0
         end case;
      end if;
   end process;
end Behavioral;
