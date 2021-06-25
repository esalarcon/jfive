library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regs is
    Port ( clk       : in  STD_LOGIC;
           wr        : in  STD_LOGIC;
           rd_addr   : in  STD_LOGIC_VECTOR (4  downto 0);
           rs1_addr  : in  STD_LOGIC_VECTOR (4  downto 0);
           rs2_addr  : in  STD_LOGIC_VECTOR (4  downto 0);
           rd_din    : in  STD_LOGIC_VECTOR (31 downto 0);     
           rs1_dout  : out STD_LOGIC_VECTOR (31 downto 0);
           rs2_dout  : out STD_LOGIC_VECTOR (31 downto 0));
end regs;

architecture Behavioral of regs is
   type t_ram is array (natural range <>) of std_logic_vector(31 downto 0);
   signal ram  : t_ram(0 to 31) := (others => (others => '0'));
   signal rd_i :  natural  range 0 to 31;
   signal rs1_i:  natural  range 0 to 31;
   signal rs2_i:  natural  range 0 to 31;
begin
   rd_i  <= to_integer(unsigned(rd_addr));
   rs1_i <= to_integer(unsigned(rs1_addr));
   rs2_i <= to_integer(unsigned(rs2_addr));
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(wr = '1' and rd_i /= 0) then         
            ram(rd_i) <= rd_din;
         end if;
         rs1_dout <= ram(rs1_i);
         rs2_dout <= ram(rs2_i);
      end if;
   end process;
end Behavioral;
