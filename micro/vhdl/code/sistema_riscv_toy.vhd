library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity riscv32i_micro_micro is
    Port ( clk    : in  STD_LOGIC;
           rst    : in  STD_LOGIC;
           btns   : in  STD_LOGIC_VECTOR (3 downto 0);
           leds   : out STD_LOGIC_VECTOR (3 downto 0));
end riscv32i_micro_micro;

architecture Behavioral of riscv32i_micro_micro is
   constant MEM_RAM                    :  std_logic_vector(31 downto 0) := x"00000000";
   constant MEM_PUERTO_SALIDA          :  std_logic_vector(31 downto 0) := x"00010000";
   constant MEM_PUERTO_ENTRADA         :  std_logic_vector(31 downto 0) := x"00020000";
   constant MEM_ROM                    :  std_logic_vector(31 downto 0) := x"00030000";

   signal address                      :  std_logic_vector(31 downto 0);
   signal data_in_core, data_out_core  :  std_logic_vector(31 downto 0);
   signal data_in_rom, data_in_ram     :  std_logic_vector(31 downto 0);
   signal wr                           :  std_logic_vector( 3 downto 0);
   signal data_in_btn                  :  std_logic_vector( 3 downto 0);
   signal cs_ram                       :  std_logic_vector( 3 downto 0);
   signal cs_po                        :  std_logic;   
begin

   with address(17 downto 16) select
      data_in_core   <= data_in_ram             when "00",
                        x"0000000"&data_in_btn  when "10",
                        data_in_rom             when others;
   

   cs_po    <= wr(0) when address(17 downto 16) = "01" else '0';
   cs_ram   <= wr    when address(17 downto 16) = "00" else "0000";
   
   
   cmp_core:   entity work.risc32vi(Behavioral)
               generic map(   ENTRY_POINT    => MEM_ROM)
               port map(      clk            => clk,
                              rst            => rst,
                              data_in        => data_in_core,
                              data_out       => data_out_core,
                              addr           => address,
                              wr             => wr);

   cmp_ram:    entity work.ram_256x32(Behavioral)
               port map(      clk            => clk,
                              address        => address(9 downto 0),
                              din            => data_out_core,
                              dout           => data_in_ram,
                              wr             => cs_ram);

   cmp_out:    entity work.puerto_salida(Behavioral)
               generic map(   N              => 4)
               port map (     clk            => clk,
                              rst            => rst,
                              en             => cs_po,
                              din            => data_out_core(3 downto 0),
                              dout           => leds);

   cmp_in:     entity work.puerto_entrada(Behavioral)
               generic map(   N              => 4)
               port map(      clk            => clk,
                              pin            => btns,
                              q              => data_in_btn);

   cmp_mp:     entity work.programa(Behavioral)
               port map(      clk            => clk,
                              addr           => address(9 downto 2),
                              dout           => data_in_rom);
end Behavioral;
