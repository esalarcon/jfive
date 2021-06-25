LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY riscv_harvard_tb IS
END riscv_harvard_tb;
 
ARCHITECTURE behavior OF riscv_harvard_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT risc32vi
    GENERIC(ENTRY_POINT : std_logic_vector(31 downto 0) := x"10000000");
    PORT(
         clk            : IN  std_logic;
         rst            : IN  std_logic;
         program_in     : IN  std_logic_vector(31 downto 0);
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
   signal program_in    : std_logic_vector(31 downto 0) := (others => '0');
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
   uut: risc32vi 
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
         when x"00001000" => program_in <= x"12345"&"00001"&"0110111";                          --lui   r1, 0x12345
         when x"00001004" => program_in <= x"00001"&"00010"&"0010111";                          --auipc r2, 0x00001
         when x"00001008" => program_in <= x"10000"&"00011"&"1101111";                          --jal   r3, PC+0x100
         when x"00001108" => program_in <= "0000000"&"00010"&"00000"&"010"&"00100"&"0100011";   --sw    r2, 0x04(r0)   
         when x"0000110C" => program_in <= x"004"&"00000"&"010"&"00100"&"0000011";              --lw    r4, 0x04(r0)
         when x"00001110" => program_in <= x"001"&"00100"&"000"&"00101"&"0010011";              --addi  r5, r4, 1
         when others      => program_in <= x"000"&"00000"&"000"&"00000"&"0010011";              --addi r0,r0,0
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
