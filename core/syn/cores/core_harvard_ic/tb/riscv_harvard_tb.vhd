LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY riscv_harvard_tb IS
END riscv_harvard_tb;
 
ARCHITECTURE behavior OF riscv_harvard_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rv32ic
    GENERIC(ENTRY_POINT : std_logic_vector(31 downto 0) := x"10000000");
    PORT(
         clk            : IN  std_logic;
         rst            : IN  std_logic;
         program_in     : IN  std_logic_vector(15 downto 0);
         data_in        : IN  std_logic_vector(31 downto 0);
         data_out       : OUT std_logic_vector(31 downto 0);
         addr           : OUT std_logic_vector(31 downto 0);
         program_addr   : OUT std_logic_vector(31 downto 0);
         wr             : OUT std_logic_vector(3 downto 0));
    END COMPONENT;
    
    component ram_256x32 is
    Port ( clk       : in  STD_LOGIC;
           address   : in  STD_LOGIC_VECTOR (9 downto 0);
           din       : in  STD_LOGIC_VECTOR (31 downto 0);
           dout      : out STD_LOGIC_VECTOR (31 downto 0);
           wr        : in  STD_LOGIC_VECTOR (3 downto 0));
    end component;

   --Inputs
   signal clk           : std_logic := '0';
   signal rst           : std_logic := '0';
   signal program_in    : std_logic_vector(15 downto 0) := (others => '0');
   signal data_in       : std_logic_vector(31 downto 0) := (others => '0');
 	--Outputs
   signal data_out      : std_logic_vector(31 downto 0);
   signal addr          : std_logic_vector(31 downto 0);
   signal program_addr  : std_logic_vector(31 downto 0);
   signal wr            : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rv32ic
   GENERIC MAP(ENTRY_POINT =>x"00001000")
   PORT MAP (
          clk              => clk,
          rst              => rst,
          program_in       => program_in,
          data_in          => data_in,
          data_out         => data_out,
          addr             => addr,
          program_addr     => program_addr,
          wr               => wr);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 
   process
   begin
      wait until rising_edge(clk);
      case program_addr is
         --lui   r1, 0x12345
         when x"00001000" => program_in <= x"5"&"00001"&"0110111";                          
         when x"00001002" => program_in <= x"1234";                  
         
         --auipc r2, 0x00001
         when x"00001004" => program_in <= x"1"&"00010"&"0010111";
         when x"00001006" => program_in <= x"0000";
         
         --sw    r2, 0x04(r0)
         when x"00001008" => program_in <= "0"&"010"&"00100"&"0100011";      
         when x"0000100A" => program_in <= "0000000"&"00010"&"0000";
         
         --lw    r4, 0x04(r0)
         when x"0000100C" => program_in <= "0"&"010"&"00100"&"0000011";
         when x"0000100E" => program_in <= x"004"&"0000";
         
         --addi  r5, r4, 1
         when x"00001010" => program_in <= "0"&"000"&"00101"&"0010011";              
         when x"00001012" => program_in <= x"001"&"0010";
         
         --c.li r9, "111111"
         when x"00001014" => program_in <= x"5"&"01001"&"11111"&"01";
         
         --c.nop         
         when others => program_in <= x"0001";                       
      end case;
   end process;
   
   --Memoria RAM
   myram: ram_256x32 
   port map(   clk       => clk,
               address   => addr(9 downto 0),
               din       => data_out,
               dout      => data_in,
               wr        => wr);

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for clk_period*2;
      rst <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
