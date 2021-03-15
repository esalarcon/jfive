library IEEE;
use IEEE.std_logic_1164.all;

entity genclk is 
	port (	CLKIN		:	IN	std_logic;
		CLKOUT		:	OUT	std_logic;
		RST_OUT		:	OUT	std_logic);
end entity;

architecture Behavioral of genclk is
		component SB_GB is 
		port(	USER_SIGNAL_TO_GLOBAL_BUFFER	: in  std_logic;
			GLOBAL_BUFFER_OUTPUT		: out std_logic);
		end component;
		
		signal locked	:	std_logic;
		signal pll_in	:	std_logic;
begin
	gb: SB_GB 
	port map(
		USER_SIGNAL_TO_GLOBAL_BUFFER 	=> CLKIN,
		GLOBAL_BUFFER_OUTPUT		=> pll_in);

	pll_inst: entity work.pll_ice40(BEHAVIOR)
	port map(
          REFERENCECLK 	=> pll_in,
          PLLOUTCORE 	=> open,
          PLLOUTGLOBAL 	=> CLKOUT,
          RESET 	=> '1',
          LOCK 		=> locked);
	RST_OUT <= not locked;
end architecture;