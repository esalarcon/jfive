# jfive

Implementación en VHDL simple, plano (no hay componentes específicos de ninguna FPGA en el procesador), sencilla (no tiene FSM sólo un contador en anillo), de arquitectura Von Neumann y de propósito educacional del ISA RISC-V 32I sin interrupciones, instrucciones privilegiadas, ni los contadores que la arquitectura necesita. Es compatible con RISC-V 32E. 
Fue probado en FPGA, usando la EDU-FPGA https://github.com/ciaa/Hardware/tree/master/PCB/EDU-FPGA
El principal objetivo de este software es explicar al funcionamiento de un microcontrolador a través de un ISA real, el hardware necesario para implementarlo y que se necesita agregar al procesador para hacer un embebido mínimo.
El procesador que pude escribir necesita 5 ciclos de reloj para ejecutar cualquier instrucción.

La bibliografía que usé fue:
* http://riscbook.com/spanish/ (muy recomendable para empezar, por lo menos para mí)
* https://riscv.org/
* https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf 
* https://inst.eecs.berkeley.edu//~cs61c/fa17/img/riscvcard.pdf

El sistema mínimo (procesador, memoria de 16 posiciones de 32 bits y un puerto de salida de 4 bits)
generó:

|FPGA                         | Slices usadas       | Bloques de memoria | Freq. reloj Máx [MHz]| MIPS |
|-----------------------------|---------------------|--------------------|----------------------|------|
|Xilinx Spartan 6 - XC6SLX9-3 | 238 (16%)           | 3 (3%)             | 101                  | 20.2 |
|Xilinx Spartan 3 - XC3S200-5 | 585 (28%)           | 3 (25%)            | 63                   | 12.6 |
|Lattice - iCE40HX4K          | 1018 (LUTS) - (28%) | 4 (20%)            | 32                   | 6.4  |

Queda mucho por hacer a mi criterio. En la medida que pueda, haré:
1. Diagrama en RTL del procesador
2. documentar y embellecer el código
3. buscar un toolchain para programar con el GCC
4. hacer periféricos (timer, pwm, etc...)
5. Agregar soporte para instrucciones comprimidas (C)
6. Agregar soporte para interrupciones
7. Optimizar los recursos utilizados.
