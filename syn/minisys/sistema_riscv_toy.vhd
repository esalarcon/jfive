library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sistema_riscv_toy is
    Port ( clk    : in  STD_LOGIC;
           rst    : in  STD_LOGIC;
           leds   : out  STD_LOGIC_VECTOR (3 downto 0));
end sistema_riscv_toy;

architecture Behavioral of sistema_riscv_toy is
   constant MEM_PUERTO_SALIDA       :  std_logic_vector(31 downto 0) := x"00001000";
   signal data_in, data_out, addr   :  std_logic_vector(31 downto 0);
   signal wr                        :  std_logic_vector(2 downto 0);
   signal cs_po                     :  std_logic;
begin
   cs_po <= wr(0) when addr = MEM_PUERTO_SALIDA else '0';

   cmp_core:   entity work.risc32vi(Behavioral)
               generic map(   ENTRY_POINT    => x"00000000")
               port map(      clk            => clk,
                              rst            => rst,
                              data_in        => data_in,
                              data_out       => data_out,
                              addr           => addr,
                              wr             => wr);

   cmp_out:    entity work.puerto_salida(Behavioral)
               generic map(   N              => 4)
               port map (     clk            => clk,
                              rst            => rst,
                              en             => cs_po,
                              din            => data_out(3 downto 0),
                              dout           => leds);

   cmp_mp:     entity work.programa(Behavioral)
               port map(      clk            => clk,
                              addr           => addr(5 downto 2),
                              dout           => data_in);

end Behavioral;
