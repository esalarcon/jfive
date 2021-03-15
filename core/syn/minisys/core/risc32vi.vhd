library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity risc32vi is
    Generic(ENTRY_POINT : std_logic_vector(31 downto 0) := x"00000000");
    Port ( clk          : in     STD_LOGIC;
           rst          : in     STD_LOGIC;
           data_in      : in     STD_LOGIC_VECTOR (31 downto 0);
           data_out     : out    STD_LOGIC_VECTOR (31 downto 0);
           addr         : out    STD_LOGIC_VECTOR (31 downto 0);
           wr           : out    STD_LOGIC_VECTOR ( 3 downto 0));   
end risc32vi;

architecture Behavioral of risc32vi is
   --Fases del procesador.
   signal phases     :  std_logic_vector(4   downto 0);
   
   --Registro IR señales.
   signal ir         :  std_logic_vector(31 downto 0);
   signal opcode     :  std_logic_vector(6 downto 0);
   signal ir_en      :  std_logic;
   
   --Banco de registros, señales.
   signal sel_rdin   :  std_logic_vector( 2 downto 0);
   signal rd_din     :  std_logic_vector(31 downto 0);
   signal rs1_dout   :  std_logic_vector(31 downto 0);
   signal rs2_dout   :  std_logic_vector(31 downto 0);
   signal wr_reg     :  std_logic;
   
   
   --Extendedor de signo LD
   signal din_sext   :  std_logic_vector(31 downto 0);
   
   
   --Contador de programa (IP)
   signal pcout      :  std_logic_vector(31 downto 0);
   signal pc_inc     :  std_logic;
   signal pc_en      :  std_logic;
   
   --ALU
   signal alu_out    :  std_logic_vector(31 downto 0);
   signal alu_op1    :  std_logic_vector(31 downto 0);
   signal alu_op2    :  std_logic_vector(31 downto 0);
   signal alu_inm    :  std_logic_vector(11 downto 0);
   signal alu_cmd    :  std_logic_vector( 2 downto 0);
   signal alu_sinm   :  std_logic;
   signal alu_param  :  std_logic;
   signal sel_op2    :  std_logic_vector( 1 downto 0);
   
   --Generador de saltos.
   signal branch     :  std_logic;
   signal jump_ok    :  std_logic;
   
   
   --Generador de Address.
   signal sel_addr   :  std_logic;
   
   -- Generador de escrituras.
   signal wr_pulse   :  std_logic;
   signal byte_wr    :  std_logic_vector(3 downto 0);
   signal half_wr    :  std_logic_vector(3 downto 0);
   signal word_wr    :  std_logic_vector(3 downto 0);
 
begin
   -- Señales de control
   ir_en    <=  phases(1);
   pc_en    <=  phases(4) and jump_ok;
   pc_inc   <=  phases(4) and (not jump_ok);
   wr_pulse <=  phases(4) when ir(6 downto 2) = "01000" else '0';
   wr_reg   <= '0' when ir(5 downto 2)="1000" else phases(4); 
   jump_ok  <= (branch or ir(2)) when ir(6 downto 4) = "110" else '0';
   opcode   <= ir(6 downto 0); 
   
   -- Genero las señales de escritura.
   with ir(14 downto 12) select
      wr <= byte_wr              when "000", --SB
            half_wr              when "001", --SH
            word_wr              when "010", --SW
            (others => '0')      when others;

   with alu_out(1 downto 0) select
      byte_wr  <= "000"&wr_pulse       when "00",
                  "00"&wr_pulse&"0"    when "01",
                  "0"&wr_pulse&"00"    when "10",
                  wr_pulse&"000"       when "11",
                  (others => '0')      when others;
 
   half_wr(3)  <= wr_pulse and (    alu_out(1)); 
   half_wr(2)  <= wr_pulse and (    alu_out(1));
   half_wr(1)  <= wr_pulse and (not alu_out(1)); 
   half_wr(0)  <= wr_pulse and (not alu_out(1));
   
   word_wr     <= wr_pulse&wr_pulse&wr_pulse&wr_pulse;
   
      
   --Las fases son 4 y se ejecutan en el siguiente orden.
   --    * 0. Busqueda      
   --    * 1. Registro IR   
   --    * 2. Decodificación      
   --    * 4. Actualización de registros.
   
   cmp_pha: entity work.ring_counter(Behavioral)
            generic map(N        => 5)
            port map(   clk      => clk,
                        rst      => rst,
                        en       => '1',
                        q        => phases);
 
   -- Registro IR. 
   -- Es un registro interno y retiene la instrucción
   -- actual
   cmp_ir:  entity work.cnt(Behavioral)
            generic map(N        => 32)
            port map(   clk      => clk,
                        rst      => rst,
                        din      => data_in,
                        load     => ir_en,
                        plus_4   => '0',
                        dout     => ir);

   --Contador de programa PC.
   cmp_pc:  entity work.cnt(Behavioral)
            generic map(N        => 32,
                        VDEF     => to_integer(unsigned(ENTRY_POINT)))
            port map(   clk      => clk,
                        rst      => rst,
                        din      => alu_out,
                        load     => pc_en,
                        plus_4   => pc_inc,
                        dout     => pcout);


   -- Registros del procesador.
   -- el registro 0 siempre queda en cero.
   cmp_rg:  entity work.regs(Behavioral)
            port map(   clk      => clk,
                        wr       => wr_reg,
                        rd_addr  => ir(11 downto 7),
                        rs1_addr => ir(19 downto 15),
                        rs2_addr => ir(24 downto 20),
                        rd_din   => rd_din,
                        rs1_dout => rs1_dout,
                        rs2_dout => rs2_dout);
                        
   -- Bloque de extensión de signo. Funciona con LOAD.
   cmp_ex:  entity work.extendersigno(Behavioral)
            port map(   ain      => data_in,
                        noext    => ir(13),
                        usext    => ir(14),
                        ext16    => ir(12),
                        bout     => din_sext);

   -- Bloque que genera las comparaciones para los saltos.
   cmp_br:  entity work.genb(Behavioral)
            port map(   rs1      => rs1_dout,
                        rs2      => rs2_dout,
                        cmd      => ir(14 downto 12),
                        bok      => branch);
 
   -- ALU
   cmp_alu: entity work.alu(Behavioral)
            generic map(N        => 32)
            port map(   cmd      => alu_cmd,
                        param    => alu_param,
                        selinm   => alu_sinm,
                        inm      => alu_inm,
                        rs1      => alu_op1,
                        rs2      => alu_op2,
                        rd       => alu_out);
 
   --Discrimino si es un inmediato o Sx
   alu_inm(11 downto 5) <= ir(31 downto 25);
   alu_inm(4 downto 0)  <= ir(11 downto 7) when ir(5) = '1' else ir(24 downto 20);
 
   --Parámetro de la ALU para saber si suma o resta
   --o si desplaza a derecha con o sin signo.
   alu_param <= ir(30) when opcode(6)&opcode(4 downto 2) = "0100" else '0';
 
   --Cmd de la ALU
   alu_cmd  <= ir(14 downto 12) when ir(4 downto 2) = "100" else "000";
   alu_sinm <= '1' when    opcode(6 downto 2) = "11001" or
                           opcode(6 downto 2) = "00000" or
                           opcode(6 downto 2) = "01000" or
                           opcode(6 downto 2) = "00100" else '0';  
   
   --Elijo el op_1 de la ALU (AUIPC)
   with opcode(6 downto 2) select
   
   alu_op1 <=  pcout       when  "00101",  
               pcout       when  "11011",
               pcout       when  "11000",
               rs1_dout    when others;
 
   --Elijo el op_2 de la ALU.
   sel_op2 <= ir(4)&ir(2);
   with sel_op2 select
      alu_op2    <=  std_logic_vector(resize(signed(
                     ir(31)&ir(7)&ir(30 downto 25)&ir(11 downto 8)&"0"
                     ),32))                              when "00",     --Bxx
                     
                     std_logic_vector(resize(signed(
                     ir(31)&ir(19 downto 12)&ir(20)&ir(30 downto 21)&"0"
                     ),32))                              when "01",     --JAL
                     
                     rs2_dout                            when "10",     --RS2
                     ir(31 downto 12)&x"000"             when others;   --AUIPC
                     
   
   -- Elijo que guardo en RD 
   sel_rdin <= ir(5)&ir(4)&ir(2);
   with sel_rdin select
      rd_din     <=  din_sext                            when "000",    --LD
                     std_logic_vector(unsigned(pcout)+4) when "101",    --JALR
                     ir(31 downto 12) & x"000"           when "111",    --LUI
                     alu_out                             when others;   --OPs.
 
   -- Genero el address.
   sel_addr <= '1'  when ir(6)&ir(4 downto 2) = "0000" else '0';
   addr <= alu_out  when sel_addr = '1' and phases(0) = '0' and phases(1) = '0' else pcout;
   
   -- Datos que guardo en memoria
   data_out <= rs2_dout;
   
end Behavioral;
