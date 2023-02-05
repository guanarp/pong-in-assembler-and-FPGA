.data
	#Stack
	#stack_beg:
       	#			.word   0 : 80
	#stack_end:
	.eqv stack_end 	 0x10011000
	
	#Colores
	#colores:		.word	0x000000	#Black
	#			.word	0x0000ff	#Blue
	#			.word	0x00ff00	#Green
	#			.word	0xff0000	#Red
	#			.word	0x00ffff	#Blue-Green
	#			.word	0xff00ff	#Blue-Red
	#			.word	0xffff00	#Green-Red
	#			.word	0xffffff	#White

	#Caracteres			
	#tablaCaracteres:
        #.byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        #.byte   '0', 0x3f,0x7f,0x61,0x61,0x61,0x61,0x61,0x61,0x61,0x61,0x7f,0x3f
        #.byte   '1', 0x1c,0x3c,0x7c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c
        #.byte   '2', 0x3f,0x7f,0x41,0x03,0x0c,0x0c,0x18,0x30,0x60,0x61,0x7f,0x3f
        #.byte   '3', 0x3f,0x7f,0x41,0x03,0x03,0x0f,0x0f,0x03,0x03,0x41,0x7f,0x3f
        #.byte   '4', 0x61,0x61,0x61,0x61,0x61,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        #.byte   'W', 0x00,0x63,0x63,0x63,0x63,0x6b,0x6b,0x36,0x36,0x36,0x00,0x00	
        #.byte   'I', 0x00,0x3c,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x3c,0x00,0x00	
        #.byte	'N', 0x00,0x63,0x63,0x73,0x7b,0x7f,0x6f,0x67,0x63,0x63,0x00,0x00
        #.byte	'L', 0x00,0x78,0x30,0x30,0x30,0x30,0x31,0x33,0x33,0x7f,0x00,0x00
        #.byte	'O', 0x00,0x1c,0x36,0x63,0x63,0x63,0x63,0x63,0x36,0x1c,0x00,0x00
        #.byte	'S', 0x00,0x3c,0x66,0x66,0x60,0x38,0x0c,0x66,0x66,0x3c,0x00,0x00
       	#.byte	'E', 0x00,0x3f98,0x30,0x32,0x7C,0x32,0x1818,0x7f,0x00,0x00
        
        #Win
        win:			.asciiz "WIN"
        lose:			.asciiz "LOSE"
        
        #Digitos
        digito0:			.asciiz "0"
        digito1:			.asciiz "1"
	digito2:			.asciiz "2"
	digito3:			.asciiz "3"
	digito4:			.asciiz "4"
	
	#Pelota
	#direccionX:		.word 	1	
	#direccionY:		.word 	0	
	#colision:		.word	0
	#xOffset:		.word	1
	#yOffset:		.word	0
	
	#Jugadores
	#jugador1X:		.word	0
	#jugador1Y:		.word	0 #aca podria hacer player 1 y player 2
	#jugador2X:		.word	0
	#jugador2Y:		.word	0
	#aiPaddleCenter:		.word  	0
	
	#.eqv jugador1X $s0
	.eqv jugador1Y $s1
	#.eqv jugador2X $s2
	#.eqv jugador2Y $s3
	#.eqv aiPaddleCenter $s4
	#.eqv direccionX $s5
	#.eqv direccionY $s6
	#.eqv colision $s7
	
	.eqv xOffset 0x10010000
	.eqv yOffset 0x10010004
	
	
	#Puntaje
	#puntajeJugador1:		.word	0
	#puntajeJugador2:		.word	0
	
	.eqv puntajeJugador1 0x10010018
	.eqv puntajeJugador2 0x10010038
	
	#.eqv counterPaddle 0x10010010
	.eqv jugador1X 0x1001003c
	
	#.eqv counterInput 0x10010014
	.eqv jugador2X 0x1001004c
	
	#.eqv movementCounter 0x10010018
	.eqv jugador2Y 0x10010048
	
	#.eqv aiPaddleCenter 0x1001001C
	
	.eqv colision 0x10010060
	
	.eqv direccionY 0x10010064
	
	.eqv direccionX 0x10010068
	
	#Pausas
	#.eqv pausa80ms 2000000
	.eqv pausa50ms	 12500
	#.eqv pausa50ms 2500000
	.eqv pausa200ms 5000000
	.eqv pausa1000ms 25000000
	.eqv pausa2000ms 50000000
	.eqv pausa500ms 12500000
	
.text
main:
	#Stack
	#la		$sp, stack_end
	#li direccionX, 1
	sw $0, direccionY
	sw $0, colision
	
	li $t7, 0
	sw $t7, puntajeJugador1
	sw $t7, puntajeJugador2
	sw $t7, yOffset
	addi $t7,$t7,1
	sw $t7, xOffset
	sw $t7, direccionX
	
	la $sp, stack_end
	#addi $sp, $0, stack_end
########################################## Config inicial	
	#Renderiza jugador 1
	li		$a0, 1
	sw		$a0, jugador1X
	#li 		jugador1X, 1
	li		$a1, 16
	#sw		$a1, jugador1Y
	li 		jugador1Y, 16
	li		$a2, 7 
	li		$a3, 7
	jal		drawVertLine
	
	#Draw Paddle 2
	li		$a0, 30
	sw		$a0, jugador2X
	#li 		jugador2X, 30
	li		$a1, 16
	sw		$a1, jugador2Y
	#li jugador2Y, 16
	li		$a2, 7
	li		$a3, 7
	jal		drawVertLine
	
	#Get Paddle Center AI
	#addi		$a1, $a1, -7
	#sw		$a1, aiPaddleCenter
	#add aiPaddleCenter, $a1, $0
	#Draw Walls
	li		$a0, 0
	li		$a1, 8
	li		$a2, 7
	li		$a3, 32
	jal		drawHorzLine

	#Draw Walls
	li		$a0, 0
	li		$a1, 7
	li		$a2, 7
	li		$a3, 32
	jal		drawHorzLine
	
	#Draw Walls
	li		$a0, 0
	li		$a1, 31
	li		$a2, 7
	li		$a3, 32
	jal		drawHorzLine
	
	#Draw Walls
	li		$a0, 0
	li		$a1, 30
	li		$a2, 7
	li		$a3, 32
	jal		drawHorzLine
	
	#Draw Score
	jal		drawScore

########################################## SETUP	

########################################## Inicio
	#Spawn de la pelota
	jal		spawnPelota
	jal		getInput

########################################## START GAME

	#EXIT
	#exit:
	#li		$v0, 17			#Load exit call
	#syscall					#Execute

#Procedure: drawScore:
#Draw the score for the players
drawScore:
	#Stack
	addi		$sp, $sp, -4		#Make room on stack for 1 wo
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack
	
	#Score Branches
	lw		$t0, puntajeJugador1
	li		$a0, 1
	li		$a1, 2
	
	beq		$t0, 0, drawdigit0
	beq		$t0, 1, drawdigit1
	beq		$t0, 2, drawdigit2
	beq		$t0, 3, drawdigit3
	beq		$t0, 4, drawdigit4
	
	#Draw Score P1
	drawdigit0:
	la		$a2, digito0
	
	#lw $a2, 0(digito0)
	jal		outText
	j		aiDrawScore
	
	drawdigit1:
	la		$a2, digito1
	#add $a2, $0, digito1
	jal		outText
	j		aiDrawScore
	
	drawdigit2:
	la		$a2, digito2
	#add $a2, $0, digito2
	jal		outText
	j		aiDrawScore
	
	drawdigit3:
	la		$a2, digito3
	#add $a2, $0, digito3
	jal		outText
	j		aiDrawScore
	
	drawdigit4:
	la		$a2, digito4
	#add $a2, $0, digito4
	jal		outText
	j		aiDrawScore
	
	#Draw Score AI
	aiDrawScore:
	lw		$t1, puntajeJugador2
	li		$a0, 26
	li		$a1, 1
	beq		$t1, 0, drawaidigit0
	beq		$t1, 1, drawaidigit1
	beq		$t1, 2, drawaidigit2
	beq		$t1, 3, drawaidigit3
	beq		$t1, 4, drawaidigit4
	
	drawaidigit0:
	la		$a2, digito0
	#add $a2, $0, digito0
	jal		outText
	j		doneScore
	
	drawaidigit1:
	la		$a2, digito1
	#add $a2, $0, digito1
	jal		outText
	j		doneScore
	
	drawaidigit2:
	la		$a2, digito2
	#add $a2, $0, digito2
	jal		outText
	j		doneScore
	
	drawaidigit3:
	la		$a2, digito3
	#add $a2, $0, digito3
	jal		outText
	j		doneScore
	
	drawaidigit4:
	la		$a2, digito4
	#add $a2, $0, digito4
	jal		outText
	j		doneScore
	
	doneScore:
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra			#Return

#Procedure: drawDot:
#Draw a dot on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)	
#$a2 = colour number (0-7)
drawDot:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -8		#Make room on stack for 2 words
	sw		$a2, 0($sp)		#Store $a2 on element 0 of stack
	sw		$ra, 4($sp)		#Store $ra on element 1 of stack

	
	#CALCULATE ADDRESS
	jal		calculateAddress	#returns address of pixel in $v0
	lw		$a2, 0($sp)		#Restore $a2 from stack
	sw		$v0, 0($sp)		#Save $v0 on element 0 of stack
	
	#GET COLOR
	jal		getColour		#Returns colour in $v1
	lw		$v0, 0($sp)		#Restores $v0 from stack
	
	#MAKE DOT AND RESTORE $RA
	sw		$v1, 0($v0)		#Make dot
	lw		$ra, 4($sp)		#Restore $ra from stack
	addi		$sp, $sp, 8		#Readjust stack
	
	jr		$ra			#Return
	
#Procedure: calculateAddress:
#Convert x and y coordinate to address
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$v0 = memory address
calculateAddress:
	#Stack
	addi		$sp, $sp, -4		#Make room on stack for 1 wo
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack

	#CALCULATIONS
	sll		$a0, $a0, 2		#Multiply $a0 by 4
	sll		$a1, $a1, 7		#Multiply $a1 by 256 # columna es x,y == columna , fila
	#sll		$a1, $a1, 2		#Multiply $a1 by 4
	add		$a0, $a0, $a1		#Add $a1 to $a0
	addi		$v0, $a0, 0x10008000	#Add base address for display + $a0 to $v0
	
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra			#Return
	
#Procedure: getColour:
#Get the colour based on $a2
#$a2 = colour number (0-7)
getColour:
	#GET COLOUR	
	#la		$a0, colores	#Load Base
	#sll		$a2, $a2, 2		#Index x4 is offset
	#add		$a2, $a2, $a0		#Address is base + offset
	beq $a2, $0, cargarNegro
	
	addi $a2, $0, 0xffffff
	#lw		$v1, 0($a2)		#Get actual color from memory
	add $v1, $a2, $0
	
	jr		$ra			#Return
	
	cargarNegro:
	addi $a2, $0, 0x000000
	#lw		$v1, 0($a2)		#Get actual color from memory
	add $v1, $a2, $0

	jr		$ra			#Return
	
#Procedure: drawHorzLine:
#Draw a horizontal line on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = length of the line
drawHorzLine:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -16		#Make room on stack for 4 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	
	#HORIZONTAL LOOP
	horzLoop:
	jal		drawDot			#Jump and Link to drawDot
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	
	#INCREMENT VALUES
	addi		$a0, $a0, 1		#Increment x by 1
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	addi		$a3, $a3, -1		#Decrement length of line
	bne		$a3, $0, horzLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 16		#Readjust stack
	
	jr		$ra			#Return
	
#Procedure: drawVertLine:
#Draw a vertical line on the bitmap display
#$a0 = x coordinate (0-64) #antes decia 32 pero creo que son 64
#$a1 = y coordinate (0-64)
#$a2 = colour number (0-1)
#$a3 = length of the line (1-32)
drawVertLine:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -16		#Make room on stack for 4 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 1 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 2 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 3 of stack
	
	#Vert LOOP
	vertLoop:
	jal		drawDot			#Jump and Link to drawDot
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	
	#INCREMENT VALUES
	addi		$a1, $a1, 1		#Increment y by 1
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	addi		$a3, $a3, -1		#Decrement length of line
	bne		$a3, $0, vertLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 16		#Readjust stack
	
	jr		$ra			#Return
	
#Procedure: spawnPelota
#Spawns the ball in the middle of the playfield
spawnPelota:
	#Ball Coordinates
	li		$a0, 15			#X
	li		$a1, 19			#Y
	li		$t0, 0
	sw		$t0, yOffset		#Reset yOffset
	
	#Stack
	addi		$sp, $sp, -12		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	sw		$a0, 4($sp)		#Store $a0 on element 4 of stack
	sw		$a1, 8($sp)		#Store $a1 on element 8 of stack
	
	#Draw Ball
	li		$a2, 7			#Color
	jal		drawDot			#Jump
	
	#Start Ball Movement
	ballLoop:
	
	#Delete Old Ball Position
	lw		$a0, 4($sp)		#X
	lw		$a1, 8($sp)		#Y
	li		$a2, 0			#Color
	jal		drawDot
	
	#Check Collision
	lw		$a0, 4($sp)		#X
	lw		$a1, 8($sp)		#Y
	jal		getNextX
	jal		calculateAddress	#Get ball position address
	addi $t0, $v0, 0
	jal		checkCollision
	
	#Check X Collision
	lw		$t0, colision		#Load colision
	#add $t0, colision, $0
	beq 		$t0,$0, noCollisionX	#If collision, calculate new Y
	
	#Reset Collision
	li		$t0, 0
	sw		$t0, colision
	#add colision, $t0, $0


	#Calculate Y Offset
	lw		$a0, 4($sp)		#X
	lw		$a1, 8($sp)		#Y
	jal		getNextX
	jal		getNextY
	jal		calcY
	
	#Flip Sign of offset and X Direction
	lw		$t0, xOffset
	lw		$t1, direccionX
	#add $t1, direccionX, $0
	#mul		$t0, $t0, -1
	nor 		$t0, $t0, $t0
	addi 		$t0, $t0, 1
	#mul		$t1, $t1, -1 #reemplazamos por puertas que si estan mplementadas
	nor 		$t1, $t1, $t1
	addi		$t1, $t1, 1
	sw		$t0, xOffset
	sw		$t1, direccionX
	#add direccionX, $t0, $0
	j		moveBall		#Jump to move ball
	
	#No Collision, Continue
	noCollisionX:
	lw		$a0, 4($sp)		#X
	lw		$a1, 8($sp)		#Y
	
	#Check Twice
	jal		getNextY
	jal		calculateAddress	#Get ball position address
	jal		checkCollision
	
	#Check Y Collision
	lw		$t0, colision		#Load collision
	#add $t0, colision, $0
	beq 		$t0, $0, moveBall		#If collision, calculate new Y
	jal		calcYWall

	moveBall:
	#Move
	lw		$a0, 4($sp)		#X
	lw		$a1, 8($sp)		#Y
	lw		$t0, xOffset		#Load offset
	add		$a0, $a0, $t0		#Add
	lw		$t0, yOffset		#Load offset
	add		$a1, $a1, $t0		#Add
	li		$a2, 7			#Color
	sw		$a0, 4($sp)		#Store $ra on element 4 of stack
	sw		$a1, 8($sp)		#Store $ra on element 4 of stack
	jal		drawDot
	
	#Do AI Action
	#bne 		$s5, 5, skipAIAction	#Counter
	#lw		$a0, 4($sp)		#X
	#lw		$a1, 8($sp)		#X
	#jal		aiAction		
	#li		$s5, 0
	
	#skipAIAction:
	#addi		$s5, $s5, 1
	#Pause
	#li		$a0, 50			#Sleep for 500ms
	#li		$v0, 32			#Load syscall for sleep
	#syscall					#Execute
	li $a0, pausa50ms # Wait - sleep vale 80
	jal pauseMs
	
	
	#Check Input
	jal		getInput	
	beq		$v0,$0, skipInput
	beq		$v0, 119, moveUp	#If input is w, move paddle up
	beq		$v0, 115, moveDown	#If input is s, move paddle up
	beq		$v0, 105, moveUp2 #jugador2
	beq 		$v0, 107, moveDown2
	j		skipInput

	#Move Paddle Up
	moveUp:
	#PRINT INTRO
	li		$a0, 0			#Set $a0 to move up
	jal		movePaddle
	j		skipInput
	
	#Move Paddle Down
	moveDown:
	li		$a0, 1			#Set $a0 to move down
	jal		movePaddle
	j		skipInput
	
	moveUp2:
	#PRINT INTRO
	li		$a0, 0			#Set $a0 to move up
	jal		movePaddle2
	j		skipInput
	
	#Move Paddle Down
	moveDown2:
	li		$a0, 1			#Set $a0 to move down
	jal		movePaddle2
	j		skipInput
	
	skipInput:
	#Loop
	j		ballLoop
	
	#RESTORE $RA creeria que no tiene que llegar aca
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	
	#Return
	jr		$ra
	
#Procedure: calcYWall
#Calculates Y reflection of wall
#$a0 = x
#$a1 = y		
calcYWall:
	#Check Direction
	lw		$t0, direccionY
	#add $t0, direccionY, $0
	beq		$t0, 1, reflectUp
	beq		$t0, -1, reflectDown

	#Up
	reflectUp:
	#Change Direction
	li		$t0, -1
	sw		$t0, direccionY
	#add direccionY, $t0, $0
	#Flip Sign of offset
	lw		$t0, yOffset
	#mul		$t0, $t0, -1
	nor $t0, $t0, $t0
	addi $t0, $t0,1
	sw		$t0, yOffset
	
	#Reset Collision
	li		$t1, 0				#Collision
	sw		$t1, colision			#Store collision
	#add colision, $t1, $0
	
	#Return
	jr		$ra
	
	reflectDown:
	#Change Direction
	li		$t0, 1
	sw		$t0, direccionY
	#add direccionY, $t0, $0
	#Flip Sign of offset
	lw		$t0, yOffset
	#mul		$t0, $t0, -1
	nor $t0, $t0, $t0
	addi $t0,$t0,1
	sw		$t0, yOffset
	
	#Reset Collision
	li		$t1, 0				#Collision
	sw		$t1, colision			#Store collision
	#add colision, $t1, $0
	
	#Return
	jr		$ra

#Procedure: checkCollision
#Checks if collision 
checkCollision:
	#Stack
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack

	#Get Ball Address Color
	lw		$t1, 0($v0)			#Get color of ball position
	move		$t2, $t1			#Copy because broken stuff
	#add $t2, $t1, $0
	
	#Check if white or black
	beq  	 	$t2, $0, noCollision
	li		$t1, 1				#Collision
	sw		$t1, colision			#Store collision	
	#add colision, $t1, $0
	lw		$ra, 0($sp)			#Restore $ra from stack
	addi		$sp, $sp, 4			#Readjust stack
	
	
	jr		$ra
	
	noCollision:	
	#Return
	sw $0, colision 
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra	
	
#Procedure: calcY
#Calculates Y offset and direction based on paddle collision
#$a0 = x
#$a1 = y		
calcY:
	#Stack
	addi		$sp, $sp, -12		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack
	sw		$a0, 4($sp)		#Store $ra on element 4 of stack
	sw		$a1, 8($sp)		#Store $ra on element 4 of stack
	
	li		$v0, 0
	jal		calculateAddress	#Get Memory address of current position
	addi		$v0, $v0, -128		#Increment Address by 1 in y direction

	#Calculate direction of y
	li		$s0, 0			#Counter for paddles
	#sw $0, counterPaddle
	yLoop:
	addi		$s0, $s0, 1		#Increment Address by 1 in y direction
	#lw $t7, counterPaddle
	#add $t7,$t7, 1
	#sw $t7, counterPaddle
	
	
	
	#Increment Address #tal vez sea +128?
	addi		$v0, $v0, -128		#Increment Address by 1 in y direction
	lw		$t1, 0($v0)		#Get color of ball position
	move		$t2, $t1		#Copy because broken stuff
	#add $t2, $t1, $0
	beq		$t2, $0,  finishCalcLoop
	j		yLoop
	
	finishCalcLoop:
	#bgt		$s0, 5,yFarBottom
	#bgt		$s0, 3, ySlightBottom
	#beq 		$s0, 3, yStraight
	#bgt		$s0, 1, ySlightTop
	#lw $t6, counterPaddle
	beq		$s0, 5, ySlightBottom #estos eran todos $s0 los que dicen counterPaddle
	#beq 		$s0, 4, yStraight
	#beq $s0, 3, ySlightTop
	beq 		$s0, 4, ySlightBottom
	beq $s0, 3, yStraight
	beq $s0, 2, ySlightTop
	beq		$s0, 1, yFarTop
	j yFarBottom
	
	#Hit Far Top
	yFarTop:
	lw		$a1, 8($sp)		#Store $ra on element 4 of stack
	li		$t0, -2
	li		$t1, 1
	sw		$t1, direccionY
	#add direccionY, $t1, $0
	sw		$t0, yOffset
	
	
	#RESTORE $RA
	lw		$a0, 4($sp)		#Store $ra on element 4 of stack
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 12		#Readjust stack
	jr		$ra
	
	#Hit Middle
	yStraight:
	lw		$a0, 4($sp)		#Store $ra on element 4 of stack
	lw		$a1, 8($sp)		#Store $ra on element 4 of stack
	li		$t1, 0
	sw		$t1, direccionY
	#add direccionY, $t1, $0
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 12		#Readjust stack
	jr		$ra
	
	#Hit Top
	ySlightTop:
	lw		$a0, 4($sp)		#Store $ra on element 4 of stack
	lw		$a1, 8($sp)		#Store $ra on element 4 of stack
	li		$t1, 1
	sw		$t1, direccionY
	#add direccionY, $t1, $0
	li		$t0, -1
	sw		$t0, yOffset
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 12		#Readjust stack
	jr		$ra
	
	#Hit Bottom
	ySlightBottom:
	lw		$a0, 4($sp)		#Store $ra on element 4 of stack
	lw		$a1, 8($sp)		#Store $ra on element 4 of stack
	li		$t1, -1
	sw		$t1, direccionY
	#add direccionY, $t1, $0
	li		$t0, 1
	sw		$t0, yOffset
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 12		#Readjust stack
	jr		$ra
	
	#Hit Far Bottom
	yFarBottom:
	lw		$a0, 4($sp)		#Store $ra on element 4 of stack
	lw		$a1, 8($sp)		#Store $ra on element 4 of stack
	li		$t1, -1
	sw		$t1, direccionY
	#add direccionY, $t1, $0
	li		$t0, 2
	sw		$t0, yOffset
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 12		#Readjust stack
	jr		$ra

#Procedure: getNextX
#Calculates next coordinates for X
#$a0 = x
getNextX:
	#Check X Direction
	lw		$t0, xOffset
	add		$a0, $a0, $t0
	
	ble 		$a0, 0, endRound		#If ball reaches edge, end round
	bge 		$a0, 31, endRound		#If ball reaches edge, end round
	#beq 		$a0, 0, endRound		#If ball reaches edge, end round
	#beq 		$a0, -1, endRound		#If ball reaches edge, end round
	#beq 		$a0, 31, endRound		#If ball reaches edge, end round
	#beq 		$a0, 32, endRound		#If ball reaches edge, end round
	jr		$ra

#Procedure: checkNextY
#Calculates next coordinates for Y
#$a1 = y
getNextY:
	#Check Y Direction
	lw		$t0, direccionY
	#add $t0, direccionY, $0
	beq		$t0, 1, upY
	beq		$t0, 0, straightY
	beq		$t0, -1,downY
	
	upY:
	addi		$a1, $a1, -1		#Increment y by 2
	jr		$ra
	
	downY:
	addi		$a1, $a1, 1		#Decrement y by 2
	jr		$ra
	
	straightY:
	jr		$ra
	
#Procedure: endRound
#endRound and Increment Point
endRound:	
	ble 		$a0, 0, incrementAI
	#beq $a0, 0, incrementAI
	#beq $a0, -1, incrementAI
	
	#Add P Point
	#Clear Paddles
	li		$a0, 1
	li		$a1, 8
	li		$a2, 0
	li		$a3, 22
	jal		drawVertLine
	li		$a0, 30
	li		$a1, 8
	li		$a2, 0
	li		$a3, 22
	jal		drawVertLine
	
	#Reset Paddle Limits
	li		$s3, 0		#Reset Paddle Counter
	#sw $0, movementCounter
	li		$s4, 0		#Reset Paddle Counter
	
	#Increment Score
	lw		$t0, puntajeJugador1
	addi		$t0, $t0, 1
	sw		$t0, puntajeJugador1
	
	#Pause
	#li		$a0, 200		#Sleep for 500ms
	#li		$v0, 32			#Load syscall for sleep
	#syscall					#Execute
	
	li $a0, pausa200ms # Wait - sleep vale 80
	jal pauseMs
	
	
	#li		$a0, 105		#Pitch
	#li		$v0, 31			#Load syscall
	#syscall	
	
	beq  		$t0, 4, winGame
	j		main
	
	#Add Ai Point
	incrementAI:
	#Clear Paddles
	li		$a0, 1 
	li		$a1, 8
	li		$a2, 0
	li		$a3, 22
	jal		drawVertLine
	li		$a0, 31
	li		$a1, 8
	li		$a2, 0
	li		$a3, 22
	jal		drawVertLine
	
	#Reset Paddle Limits
	li		$s3, 0		#Reset Paddle Counter
	#sw $0, movementCounter
	li		$s4, 0		#Reset Paddle Counter
	
	#Increment Score
	lw		$t0, puntajeJugador2
	addi		$t0, $t0, 1
	sw		$t0, puntajeJugador2
	
	
	#Pause
	#li		$a0, 200		#Sleep for 500ms
	#li		$v0, 32			#Load syscall for sleep
	#syscall					#Execute
	
	li $a0, pausa200ms # Wait - sleep vale 80
	jal pauseMs
	
	
	#li		$a0, 105		#Pitch
	#li		$v0, 31			#Load syscall
	#syscall	
		
	beq  		$t0, 4, loseGame
	j		main
	

#Procedure: winGame
#Player wins game, display winner screen
winGame:
	#Reset Scores
	jal		drawScore
	li		$t0, 0
	sw		$t0, puntajeJugador2
	sw		$t0, puntajeJugador1
	
	#Draw Score WIN
	li		$a0, 23
	li		$a1, 14
	la		$a2, win
	jal		outText
	
	
	#Pause
	#li		$a0, 2000		#Sleep for 500ms
	#li		$v0, 32			#Load syscall for sleep
	#syscall					#Execute
	
	li $a0, pausa2000ms # Wait - sleep vale 80
	jal pauseMs
	
	#Clear Middle
	li		$a0, 5
	li		$a1, 6
	li		$a2, 0
	li		$a3, 24
	jal		drawBox
	
	#Done
	jal		drawScore
	j		main
	

	


#Procedure: loseGame
#Player loses game, display loser screen
loseGame:
	#Reset Scores
	jal		drawScore
	li		$t0, 0
	sw		$t0, puntajeJugador2
	sw		$t0, puntajeJugador1	
	
	#Draw Score LOSE
	li		$a0, 5
	li		$a1, 14
	la		$a2, lose
	jal		outText
	
	
	#Pause
	#li		$a0, 2000		#Sleep for 500ms
	#li		$v0, 32			#Load syscall for sleep
	#syscall					#Execute
	
	li $a0, pausa2000ms # Wait - sleep vale 80
	jal pauseMs
	
	#Done
	jal		drawScore
	
	#Clear Middle
	li		$a0, 5
	li		$a1, 6
	li		$a2, 0
	li		$a3, 24
	jal		drawBox
	
	j		main

#Procedure: movePaddle
#Allow player to move paddle up and down
movePaddle:
	#Stack
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack
	
	#Check which direction to move
	bne		$a0,$0, paddleDown
		
	bge 		$s3, 3, skipMove	#Max Movement Counter
	#lw $t7, movementCounter
	#beq $t7, 3, decrement
	#Up
	#Erase Old Line
	lw		$a0, jugador1X
	#add  $a0,jugador1X, $0
	#lw		$a1, jugador1Y
	add  $a1,jugador1Y, $0
	li		$a2, 0
	li		$a3, 7
	jal		drawVertLine
	
	#Draw New Line
	lw		$a0, jugador1X
	#add  $a0, jugador1X, $0
	#lw		$a1, jugador1Y
	add  $a1,jugador1Y, $0
	addi		$a1, $a1, -3		#Increment Y
	sw		$a0, jugador1X
	#add jugador1X, $a0, $0
	#sw		$a1, jugador1Y
	add jugador1Y, $a1, $0
	li		$a2, 7
	li		$a3, 7
	jal		drawVertLine
	addi		$s3, $s3, 1
	#lw $t7, movementCounter
	#addi $t7,$t7,1
	#sw $t7, movementCounter
	
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra
	
	#Down
	paddleDown:
	#lw $t7, movementCounter
	beq  		$s3, -3, increment	#Max Movement Counter
	#Erase Old Line
	lw		$a0, jugador1X
	#add $a0, jugador1X, $0
	#lw		$a1, jugador1Y
	add $a1, jugador1Y, $0
	li		$a2, 0
	li		$a3, 7
	jal		drawVertLine
	
	#Draw New Line
	lw		$a0, jugador1X
	#add $a0,jugador1X, $0
	#lw		$a1, jugador1Y
	add  $a1,jugador1Y, $0
	addi		$a1, $a1, 3		#Increment Y
	sw		$a0, jugador1X
	#add jugador1X, $a0, $0
	#sw		$a1, jugador1Y
	add jugador1Y, $a1, $0
	li		$a2, 7
	li		$a3, 7
	jal		drawVertLine
	addi		$s3, $s3, -1
	#lw $t7, movementCounter
	#addi $t7,$t7,-1
	#sw $t7, movementCounter
	
	
	skipMove:
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra
	
	decrement:
	addi $s3, $s3, -1
	#lw $t7, movementCounter
	#addi $t7,$t7,-1
	#sw $t7, movementCounter
	j skipMove
	
	increment:
	addi $s3, $s3, 1
	#lw $t7, movementCounter
	#addi $t7,$t7,1
	#sw $t7, movementCounter
	j skipMove
	
	
	
movePaddle2:
	#Stack
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack
	
	#Check which direction to move
	bne		$a0, $0 paddleDown2
		
	#bge 		$s3, 5, skipMove2	#Max Movement Counter
	beq $s3, 3, decrement2
	#lw $t7, movementCounter
	#beq $t7, 3, decrement2
	#Up
	#Erase Old Line
	lw		$a0, jugador2X
	#add  $a0,jugador2X, $0
	lw		$a1, jugador2Y
	#add  $a1,jugador2Y, $0
	li		$a2, 0
	li		$a3, 7
	jal		drawVertLine
	
	#Draw New Line
	lw		$a0, jugador2X
	#add  $a0,jugador2X, $0
	lw		$a1, jugador2Y
	#add  $a1,jugador2Y, $0
	addi		$a1, $a1, -3		#Increment Y
	sw		$a0, jugador2X
	#add jugador2X, $a0, $0
	sw		$a1, jugador2Y
	#add jugador2Y, $a1, $0
	li		$a2, 7
	li		$a3, 7
	jal		drawVertLine
	addi		$s3, $s3, 1
	#lw $t7, movementCounter
	#addi $t7,$t7,1
	#sw $t7, movementCounter
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra
	
	#Down
	paddleDown2:
	
	#ble  		$s3, -5, skipMove2	#Max Movement Counter
	beq $s3, 3, increment2
	#lw $t7, movementCounter
	#beq $t7, -3, increment2
	#Erase Old Line
	lw		$a0, jugador2X
	#add  $a0,jugador2X, $0
	lw		$a1, jugador2Y
	#add  $a1,jugador2Y, $0
	li		$a2, 0
	li		$a3, 7
	jal		drawVertLine
	
	#Draw New Line
	lw		$a0, jugador2X
	#add  $a0,jugador2X, $0
	lw		$a1, jugador2Y
	#add  $a1,jugador2Y, $0
	addi		$a1, $a1, 3		#Increment Y
	sw		$a0, jugador2X
	#add jugador2X, $a0, $0
	sw		$a1, jugador2Y
	#add jugador2Y, $a1, $0
	li		$a2, 7
	li		$a3, 7
	jal		drawVertLine
	addi		$s3, $s3, -1
	#lw $t7, movementCounter
	#addi $t7,$t7,-1
	#sw $t7, movementCounter
	
	skipMove2:
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra
	
	decrement2:
	addi $s3, $s3, -1
	#lw $t7, movementCounter
	#addi $t7,$t7,-1
	#sw $t7, movementCounter
	j skipMove2
	
	increment2:
	addi $s3, $s3, 1
	#lw $t7, movementCounter
	#addi $t7,$t7,1
	#sw $t7, movementCounter
	j skipMove2	
	

#Procedure: drawBox:
#Draw a box on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = size of box (1-32)
drawBox:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -24		#Make room on stack for 5 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	sw		$a3, 20($sp)		#Store $a3 on element 5 of stack
	#move		$s0, $a3		#Copy $a3 to temp register
	add $s0 $a3, $0
	#sw $a3, counterPaddle
	#sw		counterPaddle, 16($sp)		#Store $s0 on element 5 of stack
	sw $a3, 16($sp)
	
	
	boxLoop:
	jal 		drawHorzLine		#Jump and link to drawHorzLine
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	lw		$a3, 20($sp)		#Restore $a3 from stack
	#lw		counterPaddle, 16($sp)		#Restore $s0 from stack
	lw $s0,16($sp)
	
	#INCREMENT VALUES
	addi		$a1, $a1, 1		#Increment y by 1
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	addi		$t7, $t7, -1		#Decrement counter
	sw		$t7, 16($sp)		#Store $s0 on element 5 of stack
	bne		$t7, $0, boxLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 24		#Readjust stack
	addi		$t7, $t7 0		#Reset $s0
	
	jr		$ra			#Return

# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-63)
# $a1 = vertical pixel co-ordinate (0-63)
# $a2 = pointer to asciiz text (to be displayed)
outText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        #la      $t9, 0x10008000 # get the memory start address
        addi $t9, $0, 0x10008000
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 6   # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        #move    $t2, $a2        # t2 = pointer to the text stri ng
        add $t2, $a2, $0
        #add $t2, $0, $0
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _text9

        #la $t3, tablaCaracteres
        #lw      $t3, 0(tablaCaracteres) # find the character in the table
        #lw $t3, tablaCaracteres
_text3:
        #lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        #lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 5          # 8 bits to go out
_text5:
        li      $t7, 0x000000
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _text6
        li      $t7, 0xffffff
_text6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 2     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra
        


#Procedure: getChar
#Poll the keypad, wait for input
#$v0 = input or nothing
getInput:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	li		$s2, 0			#Counter
	#sw $0, counterInput
	j		check			#Skip first sleep
	
	#SLEEP
	#li		$a0, 100		#1 second sleep
	#li		$v0, 32			#Load syscall for sleep
	#syscall					#Execute
	li $a0, pausa1000ms # Wait - sleep vale 80
	jal pauseMs
	
	#POLLING
	check:
	jal		isCharThere		#Jump and link to isCharThere
	
	leaveChar:
	lui		$t0, 0xffff		#Register 0xffff0000
	lw		$v0, 4($t0)		#Get control
	sw		$0, 4($t0)		#Clear
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra
	
#Procedure: isCharThere
#Poll the keypad, wait for input
#v0 = 0 (no data) or 1 (char in buffer)
isCharThere:
	lui		$t0, 0xffff		#Register 0xffff0000
	lw		$t1, 0($t0)		#Get control
	and		$v0, $t1, 1		#Look at least significent bit
	jr		$ra
	
	
pauseMs:
	addi $a0, $a0, -1
	bne	$a0, $0,	pauseMs
	jr $ra
