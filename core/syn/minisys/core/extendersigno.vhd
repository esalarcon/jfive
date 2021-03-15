library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity extendersigno is
    Port ( ain    : in  STD_LOGIC_VECTOR (31 downto 0);
           noext  : in  STD_LOGIC;                          --En 1 no extiende.
           usext  : in  STD_LOGIC;                          --En 1 sin signo.
           ext16  : in  STD_LOGIC;                          --En 1 16 bits.
           bout   : out STD_LOGIC_VECTOR (31 downto 0));
end extendersigno;

architecture Behavioral of extendersigno is
   signal se      :  std_logic;
   signal msb     :  std_logic;
   signal ctrl    :  std_logic_vector(1 downto 0);
begin
   bout(7 downto 0) <= ain(7 downto 0);
   msb   <= ain(15) when ext16 = '1' else ain(7); 
   se    <= (not usext) and msb;
   ctrl  <= noext&ext16;

   with ctrl select
      bout(31 downto 8) <=    (others => se)                                     when "00", --extiende 8 bits.
                              (15 => ain(15),
                               14 => ain(14),
                               13 => ain(13),
                               12 => ain(12),
                               11 => ain(11),
                               10 => ain(10),
                                9 => ain(9),
                                8 => ain(8),
                              others => se)                                      when "01", --extiende 16 bits.
                              ain(31 downto 8)                                   when others;
end Behavioral;

