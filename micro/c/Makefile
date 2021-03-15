RISCV_TOOLS_DIR = ~/opt/riscv32i
RISCV_TOOLS_PREFIX = $(RISCV_TOOLS_DIR)/bin/riscv32-unknown-elf-

CC = $(RISCV_TOOLS_PREFIX)gcc
OBJCOPY = $(RISCV_TOOLS_PREFIX)objcopy
SIZE = $(RISCV_TOOLS_PREFIX)size
CCFLAGS = -g -ffreestanding -O0 -nostartfiles
LDFLAGS = -Wl,-T,micro_juan.ld
LDLIBS = -nostdlib -nodefaultlibs

ejemplo: 
	$(CC) $(CCFLAGS) $(LDFLAGS) $(LDLIBS) start_juan.s ejemplo.c -o $@.out
	$(OBJCOPY) -O binary $@.out $@.bin
	python3 generar_rom.py $@.bin > $@.vhd	
	$(SIZE) $@.out
clean:
	rm -f *.o	
	rm -f *.out
	rm -f *.bin
 
