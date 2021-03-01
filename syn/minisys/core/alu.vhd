library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Generic(N     : natural := 32);
    Port ( cmd    : in  STD_LOGIC_VECTOR (2 downto 0);
           param  : in  STD_LOGIC;
           selinm : in  STD_LOGIC;
           inm    : in  STD_LOGIC_VECTOR (11 downto 0);
           rs1    : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rs2    : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rd     : out STD_LOGIC_VECTOR (N-1 downto 0));
end alu;

architecture Behavioral of alu is
   signal rd_add_sub :  std_logic_vector(N-1 downto 0);
   signal rd_sll     :  std_logic_vector(N-1 downto 0);
   signal rd_sll_i   :  natural range 0 to N-1;
   signal add_param  :  std_logic;
   signal rd_slt     :  std_logic;
   signal srla_msb   :  std_logic;
   signal srla       :  std_logic_vector(N-1 downto 0);
   signal op2        :  std_logic_vector(N-1 downto 0);
begin
   
   rd_sll_i    <= to_integer(unsigned(op2(4 downto 0)));
   rd_sll      <= std_logic_vector(unsigned(rs1) sll rd_sll_i);
   srla_msb    <= rs1(N-1) and param;
   add_param   <= param and (not selinm);
   op2         <= rs2 when selinm = '0' else std_logic_vector(resize(signed(inm),N));
   
   as:   entity work.addsub(Behavioral)
         generic map(N     => N)
         port map(   ans   => add_param,
                     rs1   => rs1,
                     rs2   => op2,
                     rd    => rd_add_sub);
   
   slt:  entity work.cmp(Behavioral)
         generic map(N     => N)
         port map   (rs1   => rs1,
                     rs2   => op2,
                     uns   => cmd(0),
                     eq    => open,
                     lt    => rd_slt);

   srx:  entity work.srax(Behavioral)
         port map(   ri    => srla_msb,
                     rdes  => op2(4 downto 0),
                     rs1   => rs1,
                     rd    => srla);
                        
   with cmd select
      rd <= rd_add_sub                    when "000", --ADD/SUB
            rd_sll                        when "001", --SLL
            (0 => rd_slt, others => '0')  when "010", --SLT
            (0 => rd_slt, others => '0')  when "011", --SLTU
             rs1 xor op2                  when "100", --XOR
             srla                         when "101", --SRL/SRA                           
             rs1  or op2                  when "110", --OR
             rs1 and op2                  when "111", --AND
            (others =>'0')                when others;
end Behavioral;
