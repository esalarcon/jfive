def leer_word(fname):
	opcodes = []
	f = open(fname,'rb')
	while True:
		data = f.read(4)
		if len(data)<4:
			return opcodes
		else:
			i_data = 0
			for i,v in enumerate(data):
				i_data += v<<(i*8)
			opcodes.append('{:08x}'.format(i_data))
	f.close()

def imprimir_codigo(programa):
	print('library IEEE;')
	print('use IEEE.STD_LOGIC_1164.ALL;')
	print('use IEEE.NUMERIC_STD.ALL;')
	print('entity programa is')
	print('   Port ( clk  : in    STD_LOGIC;')
	print('          addr : in    STD_LOGIC_VECTOR ( 7 downto 0);')
	print('          dout : out   STD_LOGIC_VECTOR (31 downto 0));')
	print('   end programa;')
	print('')
	print('architecture Behavioral of programa is')
	print('begin')
	print('   process(clk)')
	print('   begin')
	print('      if(rising_edge(clk)) then')
	print('         case addr is')
	for i,v in enumerate(programa):
		print('            when x"{0:02x}"  => dout <= x"{1}";'.format(i,v))
	print('            when others => dout <= x"000"&"00000"&"000"&"00000"&"0010011"; --ADDI R0, R0, 0')
	print('         end case;')
	print('      end if;')
	print('   end process;')
	print('end Behavioral;')

import sys

archivo = sys.argv[1]
imprimir_codigo(leer_word(archivo))

