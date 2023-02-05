# Prueba la memoria utilizando las instrucciones LB y SB

	.data
	.eqv 	POSICIONES_MEMORIA 	128	# Cantidad de posiciones de memoria (128 * 2)
	.eqv	CONSTANTE		0xFFFFAA55	# constante a escribir para probar
	.eqv	DIR_LEDS		0xFFFF8000	# dirección de los LEDs
	.eqv	PRIMERA_POS_MEM		0x10010000
	
	.text
	li	$t0, CONSTANTE 
	li	$t1, DIR_LEDS
	sw	$t0, 0($t1)	# escribimos en los LEDs
	
	li	$t0, PRIMERA_POS_MEM	# primera posición de memoria: 0x10010000
	li	$t1, POSICIONES_MEMORIA	# cantidad de posiciones de memoria
	li	$t2, CONSTANTE	# constante a escribir en la memoria
	
	# escribimos en toda la memoria
	add	$t4, $0, $t1	# Contador auxiliar
	add	$t5, $0, $t0	# dirección para escribir
mientras1:
	beq	$t4, $0, fin_mientras1	# repentimos la cantidad de posiciones que hayan
	
	sw	$t2, 0($t5)	# escribimos en memoria
	
	addi	$t5, $t5,  4	# siguiente posición
	addi	$t4, $t4, -1	# decrementamos cantidad
	j	mientras1
fin_mientras1:

	# leemos cada posición y verificamos
	add	$t4, $0, $t1	# Contador auxiliar
	add	$t5, $0, $t0	# dirección para escribir
mientras2:
	beq	$t4, $0, fin_mientras2	# repentimos la cantidad de posiciones que hayan
	
	lw	$t6, 0($t5)	# leemos el valor
	beq	$t6, $t2, fin_si1	# vemos si coincide
	# ocurrió un error
	li	$t0, DIR_LEDS
	li	$t1, 0x01	# valor a mostra en los LEDs
	sw	$t1, 0($t0)	# escribimos en los LEDs
	jal	exit		# termina el programa
	
fin_si1:
	addi	$t5, $t5, 4	# siguiente posición
	addi	$t4, $t4, -1	# decrementamos cantidad
	j	mientras2
fin_mientras2:

	li	$t0, DIR_LEDS
	li	$t1, 0x55	# valos a mostrar en los LEDs, todos uno significa éxito
	sw	$t1, 0($t0)	# escribimos en los LEDs
	jal	exit		# termina el programa
	
# Función que termina el programa ejecutando un loop infinito
# Parámetros: Ninguno
# Retorno: Ninguno
exit:
exit_infinito:
	j	exit_infinito	#ciclo infinito
		
