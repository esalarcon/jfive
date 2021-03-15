.section .text
.global _start

/*Pongo el Stack al fondo de la memoria y salto a main*/
_start:
	lui sp,%hi(4*256)
	addi sp,sp,(4*256)
	jal zero,main

