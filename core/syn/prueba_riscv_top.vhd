library IEEE;
use IEEE.std_logic_1164.all;

entity prueba_riscv is 
	port (	CLKIN		:	IN	std_logic;
		RSTIN_N		:	IN	std_logic;
		RX_SERIE	:	IN	std_logic;
		PULSADORES_N	:	IN	std_logic_vector(3 downto 0);
		LEDS		:	OUT	std_logic_vector(3 downto 0);
		TX_SERIE	:	OUT	std_logic);
end entity;

architecture Behavioral of prueba_riscv is
	signal clk, rst		:	std_logic;
	signal rst_core		:	std_logic;
	signal pines_in		:	std_logic;
begin
	pines_in 		<= '0' when PULSADORES_N = "1111" else '1';
	rst_core		<= pines_in or rst;	 
	TX_SERIE		<= RX_SERIE;
	
	miclk:	entity work.genclk(Behavioral) 
	port map (	CLKIN		=> CLKIN,
		    	CLKOUT		=> clk,
		    	RST_OUT		=> rst);

	riscv:	entity work.sistema_riscv_toy(Behavioral)
    	port map(	clk		=> clk,
           		rst		=> rst_core,
           		leds		=> LEDS);
end architecture;
