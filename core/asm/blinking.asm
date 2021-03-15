# Programa de ejemplo para hacer
# un efecto con 4 leds.

# Escribo en la posición de 
# memoria 0x1000 (puerto de salida)
# Considero una Fclk = 12MHz y cada 
# instrucción necesita 5 ciclos de reloj.

Inicio:
	addi t0,zero,1
	addi s0,zero,16
Actualizar:		
	lui  t1,1
	addi t1,t1,0
	sb t0,(t1)		
Demora:
	lui t2,300
	#addi t2,zero,4
Lazo:
	addi t2,t2,-1
	bne t2,zero, Lazo
	slli t0,t0,1
	bne  s0,t0 Actualizar	
	addi t0,zero,1
	jal zero,Actualizar