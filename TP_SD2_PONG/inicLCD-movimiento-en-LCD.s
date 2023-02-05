# Programa que implementa un corrimiento de un bit en los 8 bits del LED
# y muestra en el LCD "*MICRO 2*" que se puede mover por la pantalla, en la
# línea en la que se encuentra, de izquierda a derecha y viceversa, utilizando 
# los pulsadores south y north.
	.data
	# primera posición de la pila, es una posición válida, la pila crece a posiciones
	# más bajas de memoria.
	.eqv	DIR_MEM_PILA	0x100101FC

mensaje:
	.space	40	# 10*4 bytes, para la cadena *MICRO 2* más el NULL al final
espacios:
	.space	28	# lugar para siete espacios (ASCII 0x20)
teclaAnteriorSouth:	
	.word	0	# estado anterior de la tecla south
teclaAnteriorNorth:	
	.word	0	# estado anterior de la tecla north
posicionMensaje:
	.word	0	# posición actual del mensaje en la pantalla
banderaTeclaSouth:
	.word	0	# bandera que indica que la tecla south se apretó
banderaTeclaNorth:
	.word	0	# bandera que indica que la tecla north se apretó
	
	.text
main:
	# inicializamos la pila del sistema al final de la RAM y crece hacia posiciones inferiores
	# el SP apunta a la primera posición libre de la pila
	la	$sp, DIR_MEM_PILA

	######################################################
	# inicializamos las variables globales
	# inicializamos posicionMensaje
	la	$t0, posicionMensaje	# inicializamos posición del mensaje a cero. Todo a la izquierda.
	sw	$0, 0($t0)
	
	# inicializamos el mensaje
	la	$a0, mensaje	# posición de memoria para el mensaje *MICRO 2*
	jal	cargaCadena	# carga la cadena constante a la RAM

	# inicializamos los espacios
	la	$a0, espacios	# posición de memoria para los espacios
	li	$a1, 7		# cantidad de posiciones (32 bits)
	li	$a2, ' '	# valor a ser escrito
	jal	memset32
	
	# inicializamos los estados anteriores de las teclas
	la	$t0, banderaTeclaSouth
	sw	$0, 0($t0)
	la	$t0, banderaTeclaNorth
	sw	$0, 0($t0)

	# fin de la inicialización de las variables globales
	######################################################
	
	############################################################
	# inicializamos la máquina de estados del corrimiento
	li	$s0, 0xFFFF8000	# inicializamos en $s0 la dirección del puerto de salida paralelo (LEDs)
	li	$s1, 1		# $s1 contiene el estado del LED. Variable global.
	li	$s2, 100	# $s2 contiene el contador de espera. Variable global.
	sw	$s1, 0($s0)	# mostramos estado inicial.
	############################################################
	############################################################
	# inicializamos la máquina de estados de las teclas y el display
	jal	inicLCD		# inicializa el display
	
	la	$a0, mensaje
	jal	imprimeCadena	# mostramos el mensaje inicial
	add	$s3, $0, $0	# $s3 es la variable de estados tecla south. Variable global.
	add	$s4, $0, $0	# $s4 es la variable de estados tecla north. Variable global.
	############################################################
	
mainMientras:
	jal	MECorrimiento	# máquina de estados del LED prendido (corriendo hacia la izquierda).
	jal	METeclaSouth	# máquina de estados de filtrado y detección de flanco tecla south.
	jal	METeclaNorth	# máquina de estados de filtrado y detección de flanco tecla north.
	jal	actualizaDisplay	# muestra el mensaje en el display en la posición correcta.

	# esperamos ~10 ms. Retardo de la ejecución de cada máquina de estados
	li	$a0, 0x00013880	# constante de espera
	jal 	esperaNCiclos
	
	j	mainMientras
	
# Implementa la máquina de estados del corrimiento de los LEDs
# Parámetros: Ninguno
# Retorno: Ninguno
# Registros utilizados: $at, $s0, $s1, $s2 y $ra
# Función hoja
MECorrimiento:
	addi	$s2, $s2, -1	# incrementamos contador
	bne	$s2, $0, MECorrimientoFinsi1	# alcanzamos tiempo de espera?
	# alcanzamos el valor de la espera
	addi	$s2, $0, 100	# ponemos al valor inicial el contador para la próxima espera
	sll	$s1, $s1, 1	# corremos un bit a la izquierda
	addi	$at, $0, 0x100	# salimos de los 8 bits?
	bne	$at, $s1, MECorrimientoFinsi2
	# salimos de los 8 bits
	addi	$s1, $0, 1	# ponemos en el primer bit otra vez
MECorrimientoFinsi2:
	sw	$s1, 0($s0)	# mostramos el valor en los LEDs
MECorrimientoFinsi1:
	jr	$ra
	
# Máquina de estados de la tecla south. Activa la banderaTeclaSouth cuando se produce una 
# flanco de subida. No pone a cero nunca.
# Parámetros: Ninguno
# Retorno: Ninguno
# Registros utilizados: $s3, $v0, $at, $t0 y $t1
# Llama a la función: leeTeclaSouth
METeclaSouth:	
	# salvamos temporalmente valor de retorno
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4
	
METeclaSouthE0:	# estado 0
	bne	$s3, $0, METeclaSouthE1		# es estado 0?
	# ESTADO 0
	jal	leeTeclaSouth	# lee la tecla
	beq	$v0, $0, METeclaSouthFinsi2	# está apretada?
	# está apretada
	addi	$s3, $0, 1	# pasamos al estado 1
METeclaSouthFinsi2:
	j	METeclaSouthFinsi1
METeclaSouthE1:	# estado 1
	addi	$at, $0, 1
	bne	$s3, $at, METeclaSouthE2	# es estado 1?
	# ESTADO 1
	jal	leeTeclaSouth	# lee la tecla
	beq	$v0, $0, METeclaSouthFinsi3	# está apretada?
	# está apretada
	addi	$s3, $0, 2	# pasamos al estado 2
	# aquí se confirma la tecla
	la	$t0, banderaTeclaSouth
	addi	$t1, $0, 1
	sw	$t1, 0($t0)	# ponemos en uno la bandera
METeclaSouthFinsi3:	
	j	METeclaSouthFinsi1	
METeclaSouthE2:	# estado 2
	addi	$at, $0, 2
	bne	$s3, $at, METeclaSouthE3	# es estado 2?
	# ESTADO 2
	jal	leeTeclaSouth	# lee la tecla
	bne	$v0, $0, METeclaSouthFinsi4	# está apretada?
	# no está apretada
	addi	$s3, $0, 3	# pasamos al estado 3
METeclaSouthFinsi4:
	j	METeclaSouthFinsi1	
METeclaSouthE3:	# estado 3
	addi	$at, $0, 3
	bne	$s3, $at, METeclaSouthDefault	# es estado 3?
	# ESTADO 3
	jal	leeTeclaSouth	# lee la tecla
	bne	$v0, $0, METeclaSouthFinsi5	# está apretada?
	# no está apretada
	addi	$s3, $0, 0	# pasamos al estado 0
METeclaSouthFinsi5:	
	j	METeclaSouthFinsi1
METeclaSouthDefault:	# default
	addi	$s3, $0, 0	# ponemos en el estado inicial

METeclaSouthFinsi1:
	# recuperamos la dirección de retorno
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	jr	$ra
	
# Máquina de estados de la tecla north. Activa la banderaTeclaNorth cuando se produce una 
# flanco de subida. No pone a cero nunca.
# Parámetros: Ninguno
# Retorno: Ninguno
# Registros utilizados: $s4, $v0, $at, $t0 y $t1
# Llama a la función: leeTeclaNorth
METeclaNorth:
	# salvamos temporalmente valor de retorno
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4

METeclaNorthE0: # estado 0
	bne	$s4, $0, METeclaNorthE1		# es estado 0?
	# ESTADO 0
	jal	leeTeclaNorth	# lee la tecla
	beq	$v0, $0, METeclaNorthFinsi2	# está apretada?
	# está apretada
	addi	$s4, $0, 1	# pasamos al estado 1
METeclaNorthFinsi2:
	j	METeclaNorthFinsi1
METeclaNorthE1:	# estado 1
	addi	$at, $0, 1
	bne	$s4, $at, METeclaNorthE2	# es estado 1?
	# ESTADO 1
	jal	leeTeclaNorth	# lee la tecla
	beq	$v0, $0, METeclaNorthFinsi3	# está apretada?
	# está apretada
	addi	$s4, $0, 2	# pasamos al estado 2
	# aquí se confirma la tecla
	la	$t0, banderaTeclaNorth
	addi	$t1, $0, 1
	sw	$t1, 0($t0)	# ponemos en uno la bandera
METeclaNorthFinsi3:	
	j	METeclaNorthFinsi1	
METeclaNorthE2:	# estado 2
	addi	$at, $0, 2
	bne	$s4, $at, METeclaNorthE3	# es estado 2?
	# ESTADO 2
	jal	leeTeclaNorth	# lee la tecla
	bne	$v0, $0, METeclaNorthFinsi4	# está apretada?
	# no está apretada
	addi	$s4, $0, 3	# pasamos al estado 3
METeclaNorthFinsi4:
	j	METeclaNorthFinsi1	
METeclaNorthE3:	# estado 3
	addi	$at, $0, 3
	bne	$s4, $at, METeclaNorthDefault	# es estado 3?
	# ESTADO 3
	jal	leeTeclaNorth	# lee la tecla
	bne	$v0, $0, METeclaNorthFinsi5	# está apretada?
	# no está apretada
	addi	$s4, $0, 0	# pasamos al estado 0
METeclaNorthFinsi5:	
	j	METeclaNorthFinsi1
METeclaNorthDefault:	# default
	addi	$s4, $0, 0	# ponemos en el estado inicial

METeclaNorthFinsi1:
	# recuperamos la dirección de retorno
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	jr	$ra

# Función que actualiza el display según las banderas de los botones south y north.
# Pone a cero las banderas de los botones cuando están en uno.
# Parámetros: Ninguno
# Retorno: Ninguno
# Registros utilizados: $t0, $t1 y $t2
# Llama a las funciones: limpiaDisplay, imprimeNBytes e imprimeCadena
actualizaDisplay:
	# salvamos temporalmente valor de retorno
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4

	la	$t0, banderaTeclaSouth
	lw	$t1, 0($t0)
	beq	$t1, $0, actualizaDisplayFinsi1	# south está apretado?
	# botón south apretado
	la	$t0, banderaTeclaSouth
	sw	$0, 0($t0)	# ponemos a cero la bandera south
	
	la	$t0, banderaTeclaNorth
	lw	$t1, 0($t0)
	bne	$t1, $0, actualizaDisplayFinsi2	# north está apretado?
	# botón north no apretado
	###############################################
	# Movemos hacia la izquierda ##################
	###############################################
	la	$t0, posicionMensaje
	lw	$t1, 0($t0)	# leemos posicionMensaje
	beq	$t1, $0, actualizaDisplayFinsi2_1	# es cero?
	# no es cero
	addi	$t1, $t1, -1	# decrementamos posicionMensaje
	sw	$t1, 0($t0)	# guardamos nuevo valor
actualizaDisplayFinsi2_1:
	jal	limpiaDisplay
	
	la	$a0, espacios
	la	$t0, posicionMensaje
	lw	$a1, 0($t0)	# leemos posicionMensaje
	jal	imprimeNBytes	# imprimimos posicionMensaje espacios
	
	la	$a0, mensaje
	jal	imprimeCadena	# mostramos la cadena
	
	j	actualizaDisplayFinsi1
actualizaDisplayFinsi2:
	la	$t0, banderaTeclaNorth
	sw	$0, 0($t0)	# ponemos a cero la bandera north

actualizaDisplayFinsi1:	

	la	$t0, banderaTeclaNorth
	lw	$t1, 0($t0)
	beq	$t1, $0, actualizaDisplayFinsi3	# north está apretado?
	# botón north apretado
	la	$t0, banderaTeclaNorth
	sw	$0, 0($t0)	# ponemos a cero la bandera north

	la	$t0, banderaTeclaSouth
	lw	$t1, 0($t0)
	bne	$t1, $0, actualizaDisplayFinsi4	# south está apretado?
	# botón south no apretado
	###############################################
	# Movemos hacia la derecha ####################
	###############################################
	la	$t0, posicionMensaje
	lw	$t1, 0($t0)	# leemos posicionMensaje
	addi	$at, $0, 7
	beq	$t1, $at, actualizaDisplayFinsi4_1	# es el máximo (7)?
	# no es siete
	addi	$t1, $t1, 1	# incrementamos posicionMensaje
	sw	$t1, 0($t0)	# guardamos nuevo valor
actualizaDisplayFinsi4_1:
	jal	limpiaDisplay
	
	la	$a0, espacios
	la	$t0, posicionMensaje
	lw	$a1, 0($t0)	# leemos posicionMensaje
	jal	imprimeNBytes	# imprimimos posicionMensaje espacios
	
	la	$a0, mensaje
	jal	imprimeCadena	# mostramos la cadena

	j	actualizaDisplayFinsi3
actualizaDisplayFinsi4:
	la	$t0, banderaTeclaSouth
	sw	$0, 0($t0)	# ponemos a cero la bandera south

actualizaDisplayFinsi3:	
	# recuperamos la dirección de retorno
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	jr	$ra
	
# función memset, que escribe valores de 32 bits y no 8 bits como en la función de biblioteca C real.
# Parámetro: 
#	$a0 -> posición de memoria donde se cargan los valores
#	$a1 -> cantidad de posiciones (32 bits) a escribir
#	$a2 -> valor a escribir
# Retorno:
# 	Ninguno
# Registros utilizados: $a0, $a1 y $a2.
# Función hoja
memset32:
memset32Mientras:
	beq	$a1, $0, memset32Finsi	
	sw	$a2, 0($a0)
	addi	$a0, $a0, 4
	addi	$a1, $a1, -1
	j	memset32Mientras
memset32Finsi:
	jr	$ra
	
# Carga la cadena "*MICRO 2*" en memoria.
# Parámetro: 
#	$a0 -> posición de memoria donde se carga la cadena
# Retorno:
# 	Ninguno
# Utiliza los registros $t0 y $a0
# Función hoja
cargaCadena:
	addi	$t0, $0, '*'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente
	
	addi	$t0, $0, 'M'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente

	addi	$t0, $0, 'I'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente

	addi	$t0, $0, 'C'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente
	
	addi	$t0, $0, 'R'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente
	
	addi	$t0, $0, 'O'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente
	
	addi	$t0, $0, ' '	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente

	addi	$t0, $0, '2'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente

	addi	$t0, $0, '*'	# valor a salvar
	sw	$t0, 0($a0)
	addi	$a0, $a0, 4	# siguiente

	sw	$0, 0($a0)
	jr	$ra

# Espera N ciclos. Función hoja.
# Parámetro: 
#	$a0 -> ciclos a esperar
# Retorno:
# 	Ninguno
# Registros utilizados: $a0 y $ra.
# Función hoja
esperaNCiclos:
	beq	$a0, $zero, esperaNCiclosFin
	addi	$a0, $a0, -1
	j	esperaNCiclos
esperaNCiclosFin:
	jr	$ra

# Rutina que inicializa el LCD según indicado el manual correspondiente.
# Parámetros y Retorno: ninguno
# Utiliza los registros $t0 y $a0.
# Utiliza la función: esperaNCiclos
inicLCD:
	# salvamos temporalmente registros utilizados
	sw	$s0, 0($sp)
	sw	$ra, -4($sp)
	addi	$sp, $sp, -8
	
	# cargamos dirección del dispositivo
	li	$s0, 0xFFFFC000
	# esperamos 750.000 (0x000B 71B0) ciclos 
	li	$a0, 0x0B71B0
	jal	esperaNCiclos
	
	# configuramos Function Set
	li	$t0, 0x0038
	sw	$t0, 0($s0)
	# esperamos 1850 (0x0000 073A) ciclos 
	li	$a0, 0x073A
	jal	esperaNCiclos

	# configuramos Entry Mode Set
	li	$t0, 0x0006
	sw	$t0, 0($s0)
	# esperamos 1850 (0x0000 073A) ciclos 
	li	$a0, 0x073A
	jal	esperaNCiclos

	# configuramos Display On/Off
	li	$t0, 0x000C
	sw	$t0, 0($s0)
	# esperamos 1850 (0x0000 073A) ciclos 
	li	$a0, 0x073A
	jal	esperaNCiclos
	
	# Clear Display
	li	$t0, 0x0001
	sw	$t0, 0($s0)
	# esperamos 82000 (0x0001 4050) ciclos 
	li	$a0, 0x00014050
	jal	esperaNCiclos
	
	# recuperamos registros
	addi	$sp, $sp, 8
	lw	$ra, -4($sp)
	lw	$s0, 0($sp)
	jr	$ra

# Función que limpia el display
# Parámetros:
#	Ninguno
# Retorno:
#	Ninguno
# Registros utilizados: $t0, $t1 y $a0.
# Utiliza la función: esperaNCiclos
limpiaDisplay:
	# salvamos temporalmente valor de retorno
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4
	
	# cargamos dirección del dispositivo
	li	$t0, 0xFFFFC000
	# Clear Display
	li	$t1, 0x0001
	sw	$t1, 0($t0)
	# esperamos 82000 (0x0001 4050) ciclos 
	li	$a0, 0x00014050
	jal	esperaNCiclos
	
	# recuperamos la dirección de retorno
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	jr	$ra
	
# Imprimir una cadena en el display, a partir de la posición actual.
# El display es de dos líneas, 16 columnas.
# Parámetros:
#	$a0 -> dirección donde se encuentra la cadena
# Retorno:
#	Ninguno
# Registros utilizados: $t0, $t1 y $a0.
# Utiliza la función: esperaNCiclos
imprimeCadena:
	# salvamos temporalmente valor de retorno
	sw	$ra, 0($sp)
	sw	$s0, -4($sp)
	addi	$sp, $sp, -8

	add	$s0, $a0, $0	# salvamos el parámetro
imprimeCadenaMientras:
	lw	$t1, 0($s0)	# valor a ser escrito
	beq	$t1, $0, imprimeCadenaFinmientras
	ori	$t1, $t1, 0x0100	# agregamos el RS
	li	$t0, 0xFFFFC000	# cargamos dirección del dispositivo
	sw	$t1, 0($t0)	# enviamos al LCD
	addi	$s0, $s0, 4	# siguiente posición
	
	# espera escribir 2100 ciclos
	li	$a0, 0x0834
	jal	esperaNCiclos

	j	imprimeCadenaMientras
imprimeCadenaFinmientras:
	
	# recuperamos la dirección de retorno
	addi	$sp, $sp, 8
	lw	$s0, -4($sp)
	lw	$ra, 0($sp)
	jr	$ra

# Imprimir N bytes de una cadena en el display, a partir de la posición actual.
# El display es de dos líneas, 16 columnas.
# Parámetros:
#	$a0 -> dirección donde se encuentra la cadena
#	$a1 -> el valor de N
# Retorno:
#	Ninguno
# Registros utilizados: $t0, $t1, $a0 y $a1.
# Utiliza la función: esperaNCiclos
imprimeNBytes:
	# salvamos temporalmente valor de retorno
	sw	$ra, 0($sp)
	sw	$s0, -4($sp)
	addi	$sp, $sp, -8

	add	$s0, $a0, $0	# salvamos el parámetro
imprimeNBytesMientras:
	beq	$a1, $0, imprimeNBytesFinmientras	# es N == 0?
	lw	$t1, 0($s0)	# valor a ser escrito
	ori	$t1, $t1, 0x0100	# agregamos el RS
	li	$t0, 0xFFFFC000	# cargamos dirección del dispositivo
	sw	$t1, 0($t0)	# enviamos al LCD
	addi	$s0, $s0, 4	# siguiente posición
	addi	$a1, $a1, -1	# decrementamos N
	
	# espera escribir 2100 ciclos
	li	$a0, 0x0834
	jal	esperaNCiclos

	j	imprimeNBytesMientras
imprimeNBytesFinmientras:
	
	# recuperamos la dirección de retorno
	addi	$sp, $sp, 8
	lw	$s0, -4($sp)
	lw	$ra, 0($sp)
	jr	$ra
	
# función que lee y filtra la tecla south. Espera a que se produzca un flanco
# Parámetros: Ninguno
# Retorno: 
#	$v0 -> el bit menos significatio indica que la tecla se apretó.
# Utiliza los registros $t0, $ra y $v0
# Función hoja
leeTeclaSouth:
	li	$t0, 0xFFFFD000		# dirección de la entrada
	lw	$v0, 0($t0)		# leemos las llaves
	srl	$v0, $v0, 1		# ponemos south en el bit menos significativo
	andi	$v0, $v0, 1		# ponemos a cero los otros bits
	jr	$ra	

# función que lee y filtra la tecla north. Espera a que se produzca un flanco
# Parámetros: Ninguno
# Retorno: 
#	$v0 -> el bit menos significatio indica que la tecla se apretó.
# Utiliza los registros $t0, $ra y $v0
# Función hoja
leeTeclaNorth:
	li	$t0, 0xFFFFD000		# dirección de la entrada
	lw	$v0, 0($t0)		# leemos las llaves
	andi	$v0, $v0, 1		# la tecla north es el bit menos significativo, ponemos a cero los otros bits
	jr	$ra
