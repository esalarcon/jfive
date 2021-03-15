library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_256x32 is
    Port ( clk       : in  STD_LOGIC;
           address   : in  STD_LOGIC_VECTOR (9 downto 0);
           din       : in  STD_LOGIC_VECTOR (31 downto 0);
           dout      : out STD_LOGIC_VECTOR (31 downto 0);
           wr        : in  STD_LOGIC_VECTOR (3 downto 0));
end ram_256x32;

architecture Behavioral of ram_256x32 is
   type t_ram is array (natural range <>) of std_logic_vector(7 downto 0);
   signal ram_00     : t_ram(0 to 255) := (others => (others => '0'));
   signal ram_01     : t_ram(0 to 255) := (others => (others => '0'));
   signal ram_02     : t_ram(0 to 255) := (others => (others => '0'));
   signal ram_03     : t_ram(0 to 255) := (others => (others => '0'));
   signal ri         :  natural  range 0 to 255;
   signal ram_00_di  : std_logic_vector(7 downto 0);
   signal ram_01_di  : std_logic_vector(7 downto 0);
   signal ram_02_di  : std_logic_vector(7 downto 0);
   signal ram_03_di  : std_logic_vector(7 downto 0);
   signal ram_00_do  : std_logic_vector(7 downto 0);
   signal ram_01_do  : std_logic_vector(7 downto 0);
   signal ram_02_do  : std_logic_vector(7 downto 0);
   signal ram_03_do  : std_logic_vector(7 downto 0);
    
    
begin 
   ram_00_di <= din(7 downto 0);
   ri        <= to_integer(unsigned(address(9 downto 2)));
   
   with address(1 downto 0) select
      dout <= ram_03_do&ram_02_do&ram_01_do&ram_00_do when "00",
              ram_00_do&ram_03_do&ram_02_do&ram_01_do when "01",
              ram_01_do&ram_00_do&ram_03_do&ram_02_do when "10",
              ram_02_do&ram_03_do&ram_00_do&ram_03_do when "11",
              (others => '0')                         when others;
   
   with address(1 downto 0) select
      ram_01_di   <=    din(15 downto 8)  when "00",
                        din( 7 downto 0)  when "01",
                        din(15 downto 8)  when "10",
                        din( 7 downto 0)  when "11",
                        (others => '0')   when others;

   with address(1 downto 0) select
      ram_02_di   <=    din(23 downto 16) when "00",
                        din( 7 downto 0)  when "01",
                        din( 7 downto 0)  when "10",
                        din( 7 downto 0)  when "11",
                        (others => '0')   when others;

   with address(1 downto 0) select
      ram_03_di   <=    din(31 downto 24) when "00",
                        din( 7 downto 0)  when "01",
                        din(15 downto 8)  when "10",
                        din( 7 downto 0)  when "11",
                        (others => '0')   when others;
                        
   process(clk)
   begin
      if(rising_edge(clk)) then
        if(wr(0) = '1') then
         ram_00(ri) <= ram_00_di;
        end if;
        if(wr(1) = '1') then
         ram_01(ri) <= ram_01_di;
        end if;
        if(wr(2) = '1') then
         ram_02(ri) <= ram_02_di;
        end if;
        if(wr(3) = '1') then
         ram_03(ri) <= ram_03_di;
        end if;
        ram_00_do <= ram_00(ri);
        ram_01_do <= ram_01(ri);
        ram_02_do <= ram_02(ri);
        ram_03_do <= ram_03(ri);
      end if;
   end process;
end Behavioral;
