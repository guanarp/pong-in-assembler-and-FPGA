.data
	dirVGA:		.word 	0xFFFFA000
	dir7seg:	.word 	0xFFFFE000
	dirLEDS:	.word 	0xFFFF8000
	dirEntradas:	.word 	0xFFFFD000
	dirMillis:	.word 	0xFFFFB000
	platform:	.word	0x0001F000	## 0x100100014
	platformReset:	.word	0x0001F000	## 0x100100018
	ballReset:	.word	0x00004000
	posBall:	.word	88		## starting ball position
	xVel:		.word	0	  	## x velocity starts at 0 (right=1, left=-1)
	yVel:		.word	-1	  	## y velocity starts at -1 (up=-1, down=1)
	
.text
	jal	data
	jal	initialValues
	j	resetLoop
	

	
sleep:
	## Sleep()
	lw 	$t1, dirMillis
	sw 	$t0, 0($t1)	 ## Se escribe algo en el millis para resetear la cuenta
	addi 	$s0, $zero, 16   ## 33 ms gets us 30fps
	sleepLoop:
	lw 	$t0, 0($t1)		##Se lee el valor del contador de millis
	bne 	$t0, $s0,sleepLoop	##Se espera hasta que los millis sean 1 segundo
	sw 	$t0, 0($t1)		##Se escribe algo en el millis para resetear la cuenta
	jr	$ra
	
check_keypress:
	lw	$t9, dirEntradas
	lw	$t9, ($t9)
	## SW_1	
	andi	$t8, $t9, 1
	bne	$t8, $zero, move_left
	## SW_2
	andi	$t8, $t9, 2
	bne	$t8, $zero, move_right
	## SW_3 RESET
	andi	$t8, $t9, 4
	bne	$t8, $zero, reset
	
	j	gameUpdateLoop
	
gameUpdateLoop:
	## Leer la entrada y mover la plataforma accordingly
	## Se actualiza las posiciones
	## 92($t1) es la direccion de la ultima linea de la pantalla
	
	beqz	$s5, gameOver	# Si no hay mas bloques termina el juego
	beq	$k0, 1, updateLifeCounter
	exitUpdateLifeCounter:
	jal	sleep
	## Update Platform
	jal	updatePlatform
	## Move Ball
	jal	moveBall	
	j	check_keypress
	
updateLifeCounter:
	li	$k0, 0
	lw 	$t1, dirLEDS
	sw 	$k1, 0($t1)
	j	updateScore
	
updateScore:
	lw	$t1, dir7seg
	sw	$s4, 0($t1)
	j	exitUpdateLifeCounter
	
updatePlatform:
	lw	$t0, platform
	lw 	$t1, dirVGA
	sw 	$t0, 92($t1)
	jr	$ra


move_left:
	lw	$t0, platform
	beq	$t0, 0xf8000000, gameUpdateLoop	
	sll	$t1, $t0, 1	
	sw	$t1, platform
	j	gameUpdateLoop
	

move_right:
	lw	$t0, platform
	beq	$t0, 0x0000001f, gameUpdateLoop	
	srl	$t1, $t0, 1	
	sw	$t1, platform
	j	gameUpdateLoop
	
moveBall:
	#BALL
	lw	$t0, yVel
	beq	$t0, -1, ballUp
	beq	$t0, 1, ballDown
	endMoveY:
	lw	$t0, xVel
	beq	$t0, 1, ballRight
	beq	$t0, -1, ballLeft
	endMoveX:
	jr	$ra
	
		
		
	ballUp:
		lw	$t0, dirVGA	
		lw	$t1, posBall	## Posicion actual
		lw	$v0, posBall	## Posicion actual auxiliar por si halla choque
		### branch para irse hacia abajo si choca con el borde		
		### function setVelocity Down
		beq	$t1, $zero, setVelocityDown
		
		addi	$t2, $t1, -4	## Posicion nueva
		sw	$t2, posBall	## Guardar posicion nueva
	
		add	$t3, $t0, $t1	## Posicion actual ADDRESS
		add	$t4, $t0, $t2	## Posicion nueva ADDRESS
	
		### branch si choca contra bloques

		lw	$t0, ($t3)	## Linea de screen actual $t0
		lw	$t1, ($t4)	## Linea siguiente	
		
		and	$t2, $t0, $t1
		bnez	$t2, collisionGoingUp
		
		### Si no hay colision la nueva linea es or de la nueva y de la pelota [USAR $s2]				
		### Actualizacion de lineas sin choque
		xor	$v0, $s2, $t0
		sw	$v0, ($t3)	## linea actual -> $s4 xor $t0
		
		or	$v0, $s2, $t1
		sw	$v0, ($t4)	## Pelota a la linea siguiente -> $s4 or $t1
	
		j	endMoveY
		
			collisionGoingUp:
				addi	$s5, $s5, -1	# block count - 1
				sw	$t0, ($t3)	# linea actual -> $t0
				sw	$zero, ($t4)	# linea siguiente -> $zero
				addi	$s4, $s4, 10	# score + 10
				addi	$k0, $zero, 1	# update Score and Life
				sw	$v0, posBall	# posBall a actual
				j	setVelocityDown
		
	ballDown:
		lw	$t0, dirVGA	
		lw	$t1, posBall	## Posicion actual
		lw	$v0, posBall	## Posicion actual auxiliar por si halla choque
		### branch para irse hacia arriba si choca con la plataforma		
		### function setVelocityUp
		add	$a0, $t0, $t1	## Posicion nueva como argumento
		li	$t5, 88
		beq	$t5, $t1, checkColissionPlatform
		
		addi	$t2, $t1, 4	## Posicion nueva
		sw	$t2, posBall	## Guardar posicion nueva
	
		add	$t3, $t0, $t1	## Posicion actual ADDRESS
		add	$t4, $t0, $t2	## Posicion nueva ADDRESS
			
		### branch si choca contra bloques

		lw	$t0, ($t3)	## Linea de screen actual
		lw	$t1, ($t4)	## Linea siguiente	
		
		and	$t2, $t0, $t1
		bnez	$t2, collisionGoingDown
			
		### Si no hay colision la nueva linea es or de la nueva y de la pelota [USAR $s2]				
		### Actualizacion de lineas sin choque
		xor	$v0, $s2, $t0
		sw	$v0, ($t3)	## linea actual -> $s4 xor $t0
		
		or	$v0, $s2, $t1
		sw	$v0, ($t4)	## Pelota a la linea siguiente -> $s4 or $t1
	
		j	endMoveY
		
			collisionGoingDown:
				addi	$s5, $s5, -1	# block count - 1
				sw	$t0, ($t3)	# linea actual -> $t0
				sw	$zero, ($t4)	# linea siguiente -> $zero
				addi	$s4, $s4, 10	# score + 10
				addi	$k0, $zero, 1	# update Score and Life
				sw	$v0, posBall	# posBall a actual
				j	setVelocityUp
		
		checkColissionPlatform:
			lw	$t0, ($a0)	## pelota
			lw	$t1, platform	## plataforma
			and	$t2, $t0, $t1
			beq	$t2, $zero, loseLife
		
			## XOR
			xor	$t2, $t0, $t1
			sll	$t3, $t1, 3	#...11011...#
			srl	$t4, $t1, 3
			and	$t5, $t1, $t3
			and	$t6, $t1, $t4	#...11011...#
			or	$t1, $t5, $t6
			
			
			blt	$t2, $t1, setVelocityLeftPlatform
			bgt	$t2, $t1, setVelocityRightPlatform
			beq	$t2, $t1, setVelocityZeroX
			donePlatformX:
			j	setVelocityUp
		
		
ballRight:
	lw	$t0, dirVGA	
	lw	$t1, posBall
	add	$t2, $t0, $t1
	lw	$t0, ($t2)	## Linea de screen actual pelota
	xor	$v0, $s2, $t0	## Borrar pelota de linea actual
	
	srl	$a0, $s2, 1	## Mover pelota a la derecha aux
	beq	$a0, $zero, setVelocityLeft	## Margen derecho
	
	srl	$s2, $s2, 1	## Posicion absoluta de la pelota en x para ustilizar en colisiones
	or	$v0, $v0, $s2	## Nueva linea contando bloque y solo srl la pelota
	sw	$v0, ($t2)
	doneSVL:
	j	endMoveX
ballLeft:
	lw	$t0, dirVGA	
	lw	$t1, posBall
	add	$t2, $t0, $t1
	lw	$t0, ($t2)	## Linea de screen actual pelota
	xor	$v0, $s2, $t0	## Borrar pelota de linea actual
	
	sll	$a0, $s2, 1	## Mover pelota a la izquierda aux
	beq	$a0, $zero, setVelocityRight	## Margen izquierdo
	
	sll	$s2, $s2, 1	## Posicion absoluta de la pelota en x para ustilizar en colisiones
	or	$v0, $v0, $s2	## Nueva linea contando bloque y solo sll la pelota
	sw	$v0, ($t2)
	doneSVR:
	j	endMoveX
	
		
			
setVelocityDown:
	li	$t0, 1
	sw	$t0, yVel
	j	gameUpdateLoop
	
setVelocityUp:
	li	$t0, -1
	sw	$t0, yVel
	j	gameUpdateLoop

setVelocityRightPlatform:
	li	$t9, 1
	sw	$t9, xVel
	j	donePlatformX

setVelocityLeftPlatform:
	li	$t9, -1
	sw	$t9, xVel
	j	donePlatformX
	
setVelocityRight:
	li	$t9, 1
	sw	$t9, xVel
	j	doneSVR

setVelocityLeft:
	li	$t9, -1
	sw	$t9, xVel
	j	doneSVL
	
setVelocityZeroX:
	li	$t0, 0
	sw	$t0, xVel
	j	donePlatformX
	
loseLife:
	addi	$s4, $s4, -10
	addi	$k0, $zero, 1
	srl	$k1, $k1, 1
	lw 	$t1, dirLEDS
	sw 	$k1, 0($t1)
	beq	$k1, $zero, gameOver
	j	softReset
	
gameOver:
	lw	$t1, dir7seg
	sw	$s4, 0($t1)
	lw	$t9, dirEntradas
	lw	$t9, ($t9)
	## SW_3 RESET
	andi	$t8, $t9, 4
	bne	$t8, $zero, reset
	j	gameOver
	
	
softReset:
	jal	sleep
	## ball:	.word	0x00004000 REGISTER $s2
	lui 	$s2, 0x0000
	ori 	$s2, $s2, 0x4000 
	
	lw 	$t0, dirVGA
	##Platform
	lw	$t1, platformReset
	sw 	$t1, platform
	
	lw	$t1, platform
	sw	$t1, 92($t0)
	
	#posBall, yVel, Ball
	lw	$t1, posBall
	add	$t1, $t1, $t0
	sw	$zero, ($t1)  
	
	li	$t1, -1
	sw	$t1, yVel

	sw 	$s2, 88($t0)
	
	# PosBall
	li	$t1, 88
	sw 	$t1, posBall
	
	## xVel
	sw	$zero, xVel
	j	resetLoop
reset:	
	
	jal	initialValues
	lw 	$t0, dirVGA
	
	#posBall, yVel, Ball
	lw	$t1, posBall
	add	$t1, $t1, $t0
	sw	$zero, ($t1)  ## 0 linea actual [ATENCION] puede borrar los bloques que esten en la misma linea
	
	li	$t1, -1
	sw	$t1, yVel

	sw 	$s2, 88($t0)
	
	# PosBall
	li	$t1, 88
	sw 	$t1, posBall
	
	## xVel
	sw	$zero, xVel
			
	j	resetLoop
	
resetLoop:

	loop:
	
	# loop until keypress SW4:0x0008
	lw	$t9, dirEntradas
	lw	$t9, ($t9)
	## SW_4
	andi	$t8, $t9, 8
	bne	$t8, $zero, gameUpdateLoop
	j loop

	
	
initialValues:
	##Platform
	lw	$t1, platformReset
	sw 	$t1, platform
	
	## ball:	.word	0x00004000 REGISTER $s2
	lui 	$s2, 0x0000
	ori 	$s2, $s2, 0x4000 
	
	## loseLife: ,word 1	REGISTER $k0 [1: loseLife 0: dont loseLife]
	li 	$k0, 0
	
	# score: .word 40	REGISTER $s4
	li	$s4, 40
	
	# blockCount: .word 4	REGISTER $s5
	li	$s5, 4
	
	# lifeCount: .word 0x0015 REGISTER $k1 [4 vidas]
	addi 	$k1, $zero, 0x000f
	
	
	# Se carga en el 7 seg con el puntaje inicial extra
	lw	$t1, dir7seg
	sw	$s4, 0($t1)
	
	# Se carga en los LEDs 4 vidas
	lw 	$t1, dirLEDS
	sw 	$k1, 0($t1)
	
	## Se imprime la primera pantalla de VGA con la plataforma
	lw	$t0, platform
	lw 	$t1, dirVGA
	sw 	$t0, 92($t1) ## 92($t1) es la direccion de la ultima linea de la pantalla
	
	## Se imprime la primera pantalla de VGA con la pelota
	lw 	$t1, dirVGA
	sw 	$s2, 88($t1) ## 88($t1) es la direccion de la penultima linea de la pantalla
	
	## Se imprimen los $s5 bloques
	lw 	$t1, dirVGA
	li	$t0, 0x0000000F
	sw 	$t0, 0($t1)
	li	$t0, 0x000000F0
	sw	$t0, 4($t1)
	li	$t0, 0x000F0000
	sw	$t0, 8($t1)
	li	$t0, 0x0000F000
	sw	$t0, 12($t1)
	
	jr	$ra
		
data:
	##Segmento donde se cargan las constantes a la memoria
	lui	$t0, 0x1001
	ori 	$t0, $t0, 0x0000 ##primera direccion en la memoria de .data
	# dirVGA:		.word 0xFFFFA000
	lui 	$t1, 0xFFFF
	ori 	$t1, $t1, 0xA000 
	sw 	$t1, 0($t0)
	
	# dir7seg:	.word 0xFFFFE000
	addi	$t0,$t0,4
	lui	$t1,0xFFFF
	ori 	$t1, $t1, 0xE000 
	sw 	$t1,0($t0)
	
	# dirLEDS:	.word 0xFFFF8000
	addi 	$t0,$t0,4
	lui 	$t1,0xFFFF
	ori 	$t1, $t1, 0x8000 
	sw 	$t1,0($t0)
	
	# dirEntradas:	.word 0xFFFFD000
	addi 	$t0,$t0,4
	lui 	$t1,0xFFFF
	ori 	$t1, $t1, 0xD000 
	sw 	$t1,0($t0)
	
	# dirMillis:	.word 0xFFFFB000
	addi 	$t0,$t0,4
	lui 	$t1,0xFFFF
	ori 	$t1, $t1, 0xB000 
	sw 	$t1,0($t0)
	
	# platform:	.word	0x0003f000
	addi 	$t0,$t0,4
	lui 	$t1,0x0001
	ori 	$t1, $t1, 0xF000 
	sw 	$t1,0($t0)
	
	# platformReset:.word	0x0003f000
	addi 	$t0,$t0,4
	lui 	$t1,0x0001
	ori 	$t1, $t1, 0xF000 
	sw 	$t1,0($t0)
	
	# ballReset:	.word	0x00004000
	addi 	$t0,$t0,4
	lui 	$t1,0x0000
	ori 	$t1, $t1, 0x4000 
	sw 	$t1,0($t0)
	
	# posBall:	.word 	91 starting position of ball
	addi 	$t0,$t0,4
	addi	$t1, $zero, 88
	sw 	$t1,0($t0)
	
	# xVel:	.word	0## x velocity starts at 0 (right=1, left=-1)
	addi 	$t0,$t0,4
	addi	$t1, $zero, 0
	sw 	$t1,0($t0)
	
	# yVel:	.word	-1 ## y velocity starts at -1 (up=-1, down=1)
	addi 	$t0,$t0,4
	addi	$t1, $zero, -1
	sw 	$t1,0($t0)
	
	
	jr	$ra
