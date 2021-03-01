# jfive

Implementación en VHDL simple, sencilla (no tiene FSM sólo un contador en anillo), de arquitectura Von Neumann y de propósito educacional del ISA RISC-V 32I sin interrupciones, instrucciones privilegiadas ni los contadores que la arquitectura necesita. Es compatible con RISC-V 32E. 
Fue probado en FPGA, usando la EDU-FPGA [https://github.com/ciaa/Hardware/tree/master/PCB/EDU-FPGA]
El principal objetivo de este software es explicar al funcionamiento de un microcontrolador a través de un ISA real, el hardware necesario para implementarlo y que se necesita agregar al procesador para hacer un embebido mínimo.

La cantidad de recursos utilizados y rendimiento fue:

|FPGA                         | Slices usadas       | Bloques de memoria | Freq. reloj Máx [MHz]|
|-----------------------------|---------------------|--------------------|----------------------|
|Xilinx Spartan 6 - XC6SLX9-3 | 238 (16%)           | 3 (3%)             | 101                  |
|Xilinx Spartan 3 - XC3S200-5 | 585 (28%)           | 3 (25%)            | 63                   |
|Lattice - iCE40HX4K          | 1018 (LUTS) - (28%) | 4 (20%)            | 32                   |

Queda mucho por hacer a mi criterio. En la medida que pueda y haré:
1. Diagrama en RTL del procesador
2. documentar y "lintear" y embellecer el código
3. buscar un toolchain para programar con el GCC
4. hacer periféricos (timer, pwm, etc...)
5. Agregar soporte para interrupciones e instrucciones comprimidas (C)


