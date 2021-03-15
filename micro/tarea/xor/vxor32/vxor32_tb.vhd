LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY vxor32_tb IS
END vxor32_tb;
 
ARCHITECTURE behavior OF vxor32_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT xor32
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: xor32 PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          dout => dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 
   en_process :process
   begin
		en <= '1';
		wait for clk_period;
		en <= '0';
		wait for clk_period*3;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      rst   <= '1';
      wait for clk_period*2;
      rst   <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
