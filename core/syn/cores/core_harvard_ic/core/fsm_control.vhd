library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_control is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           p_in         : in  STD_LOGIC_VECTOR (15 downto 0);
           ir           : out STD_LOGIC_VECTOR (31 downto 0);
           phases       : out STD_LOGIC_VECTOR (2 downto 0);
           pc_inc       : out STD_LOGIC);
end fsm_control;

architecture Behavioral of fsm_control is
   type estado is (S0, S1, S2, S3, S4, S5);
   signal actual, futuro:  estado;
   signal in32          :  std_logic_vector(31 downto 0);
   signal is32          :  std_logic; 
   signal sel_ir        :  std_logic;
   signal registrar     :  std_logic;
   signal parte_baja    :  std_logic_vector(15 downto 0);
   
begin
    --Me fijo si es de 32 bits.
    is32 <= '1'   when p_in(1 downto 0) = "11" else '0';
    ir   <= in32  when sel_ir = '0' else p_in&parte_baja;
    
    --Decompresor instrucciones tipo C
   cmp_dec: entity work.decompresor(Behavioral)
            port map(   c        => p_in,
                        i        => in32);
   --registro.
   process(clk)
   begin 
      if(rising_edge(clk)) then
         if(rst = '1') then
            parte_baja <= (others => '0');
         elsif(registrar = '1') then
            parte_baja <= p_in;
         end if;
      end if;
   end process;

   --FSM
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            actual <= S0;
         else
            actual <= futuro;
         end if;
      end if;
   end process;

   process(actual, is32)
   begin
      case actual is
         when S0 => --Voy a buscar. Lo tengo el que viene.
                    futuro <= S1;
         when S1 =>
                    --Si es de 32 bits voy a buscar la otra parte.
                    --Sino decodifico.
                    if(is32 = '0') then
                      futuro <= S2;
                    else
                      futuro <= S3;
                    end if;
         when S2 =>
                   --Ejecuto.
                   futuro <= S0;
         when S3 => 
                   --Voy a buscar la parte alta.
                   futuro <= S4;
         when S4 =>
                  --decodifico.
                  futuro <= S5;
         when S5 =>
                  --ejecuto.
                  futuro <= S0;
      end case;
   end process;

   process(actual, is32)
   begin
      case actual is
         when S0 =>
                     phases      <= "001";
                     pc_inc      <= '0';
                     registrar   <= '0';
                     sel_ir      <= '0';
         when S1 =>
                     if is32 = '1' then
                        phases    <= "001";
                        pc_inc    <= '1';
                        registrar <= '1';
                        sel_ir    <= '1';
                     else
                        phases    <= "010";
                        pc_inc    <= '0';
                        registrar <= '0';
                        sel_ir    <= '0';
                     end if;
        when S2 =>
                     phases      <= "100";
                     pc_inc      <= '0';
                     registrar   <= '0';
                     sel_ir      <= '0';
        when S3 =>
                     phases      <= "001";
                     pc_inc      <= '0';
                     registrar   <= '0';
                     sel_ir      <= '1';
        when S4 =>
                     phases      <= "010";
                     pc_inc      <= '0';
                     registrar   <= '0';
                     sel_ir      <= '1';
        when S5 =>
                     phases      <= "100";
                     pc_inc      <= '0';
                     registrar   <= '0';
                     sel_ir      <= '1';
      end case;
   end process;
end Behavioral;
