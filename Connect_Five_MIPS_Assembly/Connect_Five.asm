.data
	board:			.asciiz	"C", "o", "o", "o", "o", "o", "o", "o", "C"
					.asciiz	"H", "o", "o", "o", "o", "o", "o", "o", "H"
					.asciiz	"C", "o", "o", "o", "o", "o", "o", "o", "C"
					.asciiz	"H", "o", "o", "o", "o", "o", "o", "o", "H"
					.asciiz	"C", "o", "o", "o", "o", "o", "o", "o", "C"
					.asciiz	"H", "o", "o", "o", "o", "o", "o", "o", "H"
	DATA_SIZE:		.word 	2
	board_rows:		.word 	6
	board_cols:		.word 	9
	empty:			.asciiz	"o"
	m_w:			.word	123
	m_z:			.word	456
	gameWon:		.word	3
	player:			.asciiz "HUMAN", "COMPUTER"
	chipType:		.asciiz "H", "C"
	playerTurn:		.word	0
	computersCol:	.word	0
	
	# string for printBoard()
	printBoardP1:	.asciiz "    1  2  3  4  5  6  7\n ---+--+--+--+--+--+--+---\n"
	
	# string for int user_input()
	userIP:			.asciiz "Enter a column to insert chip: "
	invalidIP:		.asciiz "Enter a VALID column to insert chip: "
	colFullP:		.asciiz "That column is full.\n"
	
	# string for int main()
	mainMSGpt1:		.asciiz "Enter two positive numbers to initialize the random number generator.\n"
	mainMSGpt2:		.asciiz "Number 1: "
	mainMSGpt3:		.asciiz "Number 2: "
	mainMSGpt4:		.asciiz "Coin toss ... "
	mainMSGpt5:		.asciiz " goes first.\n"
	mainMSGpt6:		.asciiz "Human won the game.\n"
	mainMSGpt7:		.asciiz "Computer won the game.\n"
	mainMSGpt8:		.asciiz "Board is filled. Tie!\n"
	
	
	
	# general purpose string
	newLine:		.asciiz "\n"
	space:			.asciiz " "
	
	# temporary
	variable:		.asciiz "  dasfsadfa  "
	humanChip: 		.asciiz "H"
	computerChip:	.asciiz "C"
	checkPoint:		.asciiz "Check point reached!!\n"
.text
#------------------------------------------------------------------------
	.globl main
	main:
			lw $s6, gameWon
			#/*
			#	Initializing random number generator.
			#*/
			# print("Enter two positive numbers to initialize the random number generator.\n")
				li $v0, 4
				la $a0, mainMSGpt1
				syscall
			
			# print("Number 1: ")
				li $v0, 4
				la $a0, mainMSGpt2
				syscall
			
			# getUserInput scanf("%d", &m_w);
				li $v0, 5
				syscall
				sw $v0, m_w 						
			
			# print("Number 2: ")
				li $v0, 4
				la $a0, mainMSGpt3
				syscall
			
			# getUserInput scanf("%d", &m_z);
				li $v0, 5
				syscall
				sw $v0, m_z	
				
			#/*
			#	Deciding which player goes first.
			#*/
			
			# print("Coin toss ... ")
				li $v0, 4
				la $a0, mainMSGpt4
				syscall
				
				#acquire get_random()%2
				li $s5, 2
				jal get_random
				div $v0, $s5
				mfhi $s5			
				
				mul $s3, $s5, 2
				la $s4, player
				add $s3, $s3, $s4		# player[get_random()%2]
				
			# print("%s", player[get_random()%2])
				li $v0, 4
				add $a0, $zero, $s3
				syscall
				
				# print(" goes first.\n")
				li $v0, 4
				la $a0, mainMSGpt5
				syscall
				
				
#WHILE LOOP
		forLop:	bne $s6, 3, gameOver
				#print board
				jal printBoard 		# printsBoard()
				
				#// Player inserts chip
		ifHumansTurn:
				bne $s5, 0, notHumansTurn
				#get user_input
				jal user_input		# int getUserInput()
				add $s0, $zero, $v0	# what user inputted is saved in $s0
				#insert human chip
				la $a0, humanChip
				add $a1, $zero, $s0
				jal insertChip		# void insertChip(char *chip, int whereToInsertPiece)
		notHumansTurn:
				
		ifComputersTurn:
				bne $s5, 1, notComputersTurn
				#insert computers chip
				#acquire get_random()%7
				li $s7, 7
				jal get_random
				div $v0, $s7
				mfhi $s7			# get_random()%7
				add $s7, $s7, 1		# get_random()%7 + 1
		
		whle:
				# get *board[0][computersCol]
				la $t0, board
				mul $s8, $s7, 2
				add $s8, $s8, $t0	# get &board[0][computersCol]
				lb $s8, ($s8)		# get *board[0][computersCol]
				lb $t1, empty
				beq $s8, $t1, endWhle
				#acquire get_random()%7
				li $s7, 7
				jal get_random
				div $v0, $s7
				mfhi $s7			# get_random()%7
				add $s7, $s7, 1		# get_random()%7 + 1
				j whle
		endWhle:
				
				la $a0, computerChip
				add $a1, $zero, $s7
				jal insertChip		# void insertChip(char *chip, int whereToInsertPiece)

		notComputersTurn:
				
				#checkBoard
				jal checkBoard		# int checkBoard()
				add $s6, $zero, $v0
				

				add $s5, $s5, 1
				li $t5, 2
				div $s5, $t5
				mfhi $s5
				j forLop
		gameOver:


# END HERER
				
				
				
				
				
			
			#print board
				jal printBoard 		# printsBoard()
				
				bne $s6, 0, firstif
				# print("Human won the game.\n")
				li $v0, 4
				la $a0, mainMSGpt6
				syscall
		firstif:
				bne $s6, 1, secondif
				# print("Computer won the game.\n")
				li $v0, 4
				la $a0, mainMSGpt7
				syscall
		secondif:
				bne $s6, 2, thirdif
				# print("Board is filled. Tie!\n")
				li $v0, 4
				la $a0, mainMSGpt8
				syscall
		thirdif:
				
				
				
					
				# Tell the OS that this is the end of the program.
				li $v0, 10
				syscall
#------------------------------------------------------------------------
.globl function
function: 
	# saves s registers by pushing it into the stack
	subu $sp, $sp, 68
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $t0, 36($sp)
	sw $t1, 40($sp)
	sw $t2, 44($sp)
	sw $t3, 48($sp)
	sw $t4, 52($sp)
	sw $t5, 56($sp)
	sw $t6, 60($sp)
	sw $t7, 64($sp)
		
	# algorithm goes here
		
	# puts data from stack back to register (POP)
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	lw $t0, 36($sp)
	lw $t1, 40($sp)
	lw $t2, 44($sp)
	lw $t3, 48($sp)
	lw $t4, 52($sp)
	lw $t5, 56($sp)
	lw $t6, 60($sp)
	lw $t7, 64($sp)
	addu $sp, $sp, 68 
	jr $ra
#------------------------------------------------------------------------
.globl printCheckPoint
printCheckPoint: 
	# saves s registers by pushing it into the stack
	subu $sp, $sp, 84
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $t0, 36($sp)
	sw $t1, 40($sp)
	sw $t2, 44($sp)
	sw $t3, 48($sp)
	sw $t4, 52($sp)
	sw $t5, 56($sp)
	sw $t6, 60($sp)
	sw $t7, 64($sp)
	sw $a0, 68($sp)
	sw $a1, 72($sp)
	sw $v0, 76($sp)
	sw $v1, 80($sp)
		
	# algorithm goes here
	# print("Check point reached!!\n")
	li $v0, 4
	la $a0, checkPoint
	syscall
		
	# puts data from stack back to register (POP)
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	lw $t0, 36($sp)
	lw $t1, 40($sp)
	lw $t2, 44($sp)
	lw $t3, 48($sp)
	lw $t4, 52($sp)
	lw $t5, 56($sp)
	lw $t6, 60($sp)
	lw $t7, 64($sp)
	lw $a0, 68($sp)
	lw $a1, 72($sp)
	lw $v0, 76($sp)
	lw $v1, 80($sp)
	addu $sp, $sp, 84 
	jr $ra
#------------------------------------------------------------------------
#getRandom number
.globl get_random
get_random: # get_random()
	li $t0, 36969
	li $t1, 18000
	li $t2, 65535
	
	lw $t7, m_z
	lw $t6, m_w
	
	and $t3, $t7, $t2 
	mul $t3, $t0, $t3
	srl $t4, $t7, 16
	addu $t7, $t3, $t4
	sw $t7, m_z
	
	and $t3, $t6, $t2
	mul $t3, $t1, $t3
	srl $t4, $t6, 16
	addu $t6, $t3, $t4
	sw $t6, m_w
	
	sll $t3, $t7, 16
	addu $t3, $t3, $t6
	
	bgt $t3, $zero, endIfGR
	mul $t3, $t3, -1
	endIfGR:
	
	addu $v0, $t3,  $zero
	j $ra
#------------------------------------------------------------------------
.globl printBoard
printBoard: 
		# saves s registers by pushing it into the stack
		subu $sp, $sp, 68
		sw $ra, ($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		sw $s4, 20($sp)
		sw $s5, 24($sp)
		sw $s6, 28($sp)
		sw $s7, 32($sp)
		sw $t0, 36($sp)
		sw $t1, 40($sp)
		sw $t2, 44($sp)
		sw $t3, 48($sp)
		sw $t4, 52($sp)
		sw $t5, 56($sp)
		sw $t6, 60($sp)
		sw $t7, 64($sp)
			
	# set registers values
		lw $s1, board_rows				# board_rows
		lw $s3, board_cols				# board_cols
		la $s6, board					# address of board[][]
		lw $s7, DATA_SIZE
		
	# print("    1  2  3  4  5  6  7\n ---+--+--+--+--+--+--+---\n");
		li $v0, 4
		la $a0, printBoardP1
		syscall
		
	# start for-loop for(int r=0; r<board_rows; r++)
	li $s0, 0							# int r = 0
	startForLoopRow:
		bge $s0, $s1, endForLoopRow		# if!(r<board_rows)
		
	# start for-loop for(int c=0; c<board_cols; c++)
	li $s2, 0							# int c = 0
	startForLoopCol:
		bge $s2, $s3, endForLoopCol		# c<board_cols
		
	# print(" ")
		li $v0, 4
		la $a0, space
		syscall
		
	# print(board[r][c])	
		mul $s4, $s0, $s3	# rowIndex * colSize
		add $s4, $s4, $s2	# + colIndex
		mul $s4, $s4, $s7	# * DATA_SIZE
		add $s4, $s4, $s6	# + baseAddress
		
	# print letter
		li $v0, 4
		la $a0, ($s4)
		syscall
		
		
	# print(" ")
		li $v0, 4
		la $a0, space
		syscall
		
		addi $s2, $s2, 1				# c++
		j startForLoopCol
	endForLoopCol:
	
	# print("\n")
		li $v0, 4
		la $a0, newLine
		syscall
		
		addi $s0, $s0, 1				# r++
		j startForLoopRow
	endForLoopRow:
	# print("\n")
		li $v0, 4
		la $a0, newLine
		syscall
	
	
	
			
		# puts data from stack back to register (POP)
		lw $ra, ($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		lw $t0, 36($sp)
		lw $t1, 40($sp)
		lw $t2, 44($sp)
		lw $t3, 48($sp)
		lw $t4, 52($sp)
		lw $t5, 56($sp)
		lw $t6, 60($sp)
		lw $t7, 64($sp)
		addu $sp, $sp, 68 
		jr $ra
#------------------------------------------------------------------------
.globl user_input
user_input: 
		# saves s registers by pushing it into the stack
		subu $sp, $sp, 68
		sw $ra, ($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		sw $s4, 20($sp)
		sw $s5, 24($sp)
		sw $s6, 28($sp)
		sw $s7, 32($sp)
		sw $t0, 36($sp)
		sw $t1, 40($sp)
		sw $t2, 44($sp)
		sw $t3, 48($sp)
		sw $t4, 52($sp)
		sw $t5, 56($sp)
		sw $t6, 60($sp)
		sw $t7, 64($sp)
			
		li $s0, 99999						# s0 = 99999
		lw $s1, board_rows				# board_rows
		lw $s3, board_cols				# board_cols
		la $s6, board					# address of board[][]
		lw $s7, DATA_SIZE				# data size of elements in array
		lb $s2, empty					# "o"
		
	# print("Enter a column to insert chip: ")
		li $v0, 4
		la $a0, userIP
		syscall
		
	# getUserInput scanf("%d", &columnToInsertChipIn);
		li $v0, 5
		syscall
		move $s1, $v0 						# store result in $s1
		
	
	checkWhileConditionIP:
		blt $s1, 1, startWhileLoopIP		# !(columnToInsertChipIn < 1)
		bgt $s1, 7, startWhileLoopIP		# !(7 < columnToInsertChipIn)
		j endWhileLoopIP
		
	startWhileLoopIP:					# while(columnToInsertChipIn < 1 || 7 < columnToInsertChipIn)
	# print("Enter a VALID column to insert chip: ")
		li $v0, 4
		la $a0, invalidIP
		syscall
		
	# getUserInput scanf("%d", &columnToInsertChipIn);
		li $v0, 5
		syscall
		add $s1, $zero, $v0 					# store result in $s1
		j checkWhileConditionIP
	endWhileLoopIP:
	
	# if(*board[0][columnToInsertChipIn] != *empty)
		mul $s4, $zero, $s3	# rowIndex * colSize
		add $s4, $s4, $s1	# + colIndex
		mul $s4, $s4, $s7	# * DATA_SIZE
		add $s4, $s4, $s6	# + baseAddress
		lb $s5, ($s4)	
	
		beq $s2, $s5, endIfIP
		
	# print("That column is full.\n")
		li $v0, 4
		la $a0, colFullP
		syscall
		jal user_input
		add $s1, $zero, $v0	
	endIfIP:
	
		add $v0, $zero, $s1
			
		# puts data from stack back to register (POP)
		lw $ra, ($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		lw $t0, 36($sp)
		lw $t1, 40($sp)
		lw $t2, 44($sp)
		lw $t3, 48($sp)
		lw $t4, 52($sp)
		lw $t5, 56($sp)
		lw $t6, 60($sp)
		lw $t7, 64($sp)
		addu $sp, $sp, 68 
		jr $ra
#------------------------------------------------------------------------
.globl insertChip
insertChip: 
		# saves s registers by pushing it into the stack
		subu $sp, $sp, 68
		sw $ra, ($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		sw $s4, 20($sp)
		sw $s5, 24($sp)
		sw $s6, 28($sp)
		sw $s7, 32($sp)
		sw $t0, 36($sp)
		sw $t1, 40($sp)
		sw $t2, 44($sp)
		sw $t3, 48($sp)
		sw $t4, 52($sp)
		sw $t5, 56($sp)
		sw $t6, 60($sp)
		sw $t7, 64($sp)
		
	# initializing variables
		lb $s0, ($a0)					# $s0 = *chip
		add $s1, $zero, $a1				# $s1 = int whereToInsertPiece
		la $s2, board					# $s2 = &board
		lw $s3, board_rows				# $s3 = int board_rows
		lw $s4, board_cols				# $s4 = int board_cols
		add $s5, $zero, 0				# $s5 = int droppedPiece = 0
		lb $s6, empty					# $s6 = "o"
		lw $s7, DATA_SIZE				# $s7 = int DATA_SIZE = 2
		
	# *board[droppedPiece][whereToInsertPiece]
		mul $t0, $s5, $s4				# rowIndex * colSize
		add $t0, $t0, $s1				# + colIndex
		mul $t0, $t0, $s7				# * DATA_SIZE
		add $t0, $t0, $s2				# + baseAddress
		lb $t1, ($t0)					# $t1 = *board[droppedPiece][whereToInsertPiece]
		
	ifIC:
		bne $t1, $s6, endIfIC			# if!(*board[droppedPiece][whereToInsertPiece] == *empty)
		sb $s0, ($t0)					# board[droppedPiece][whereToInsertPiece] = chip
	whileIC:
	# *board[droppedPiece][whereToInsertPiece]
		mul $t0, $s5, $s4				# rowIndex * colSize
		add $t0, $t0, $s1				# + colIndex
		mul $t0, $t0, $s7				# * DATA_SIZE
		add $t0, $t0, $s2				# + baseAddress
		lb $t1, ($t0)					# $t1 = *board[droppedPiece][whereToInsertPiece]
		
		add $t2, $s5, 1					# $t2 = droppedPiece+1
		mul $t5, $s4, 2
		add $t3, $t0, $t5				# $t3 = &board[droppedPiece+1][whereToInsertPiece]
		lb $t4, ($t3)					# $t4 = *board[droppedPiece+1][whereToInsertPiece]
		
		bge $t2, $s3, endWhileIC		# !(droppedPiece+1<board_rows)
		bne $t4, $s6, endWhileIC		# !(*board[droppedPiece+1][whereToInsertPiece] == *empty)
		# *board[droppedPiece][whereToInsertPiece]
		mul $t0, $s5, $s4				# rowIndex * colSize
		add $t0, $t0, $s1				# + colIndex
		mul $t0, $t0, $s7				# * DATA_SIZE
		add $t0, $t0, $s2				# + baseAddress = &board[droppedPiece][whereToInsertPiece]
		sb $s6, ($t0)

		add $t2, $s5, 1					# $t2 = droppedPiece+1
		mul $t5, $s4, 2
		add $t3, $t0, $t5				# $t3 = &board[droppedPiece+1][whereToInsertPiece]
		lb $t4, ($t3)					# $t4 = *board[droppedPiece+1][whereToInsertPiece]
		sb $s0, ($t3)					# board[droppedPiece+1][whereToInsertPiece] = chip;
		
		add $s5, $s5, 1					# droppedPiece++
	
	
	
		j whileIC
	endWhileIC:
		li $s5, 0						# droppedPiece = 0
	endIfIC:
		
			
		# puts data from stack back to register (POP)
		lw $ra, ($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		lw $t0, 36($sp)
		lw $t1, 40($sp)
		lw $t2, 44($sp)
		lw $t3, 48($sp)
		lw $t4, 52($sp)
		lw $t5, 56($sp)
		lw $t6, 60($sp)
		lw $t7, 64($sp)
		addu $sp, $sp, 68 
		jr $ra
#------------------------------------------------------------------------
.globl checkBoard
checkBoard: 
			# saves s registers by pushing it into the stack
			subu $sp, $sp, 80
			sw $ra, ($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s3, 16($sp)
			sw $s4, 20($sp)
			sw $s5, 24($sp)
			sw $s6, 28($sp)
			sw $s7, 32($sp)
			sw $s8, 36($sp)
			sw $t0, 40($sp)
			sw $t1, 44($sp)
			sw $t2, 48($sp)
			sw $t3, 52($sp)
			sw $t4, 56($sp)
			sw $t5, 60($sp)
			sw $t6, 64($sp)
			sw $t7, 68($sp)
			sw $t8, 72($sp)
			sw $t9, 76($sp)
			
			# declare variables
			lw $t0, board_rows
			lw $t1, board_cols
			lb $t2, empty
			lw $t3, DATA_SIZE
			la $t4, board
			li $s0, 0						# $s0 = int nonEmptySlots 	= 0
			li $s1, 0						# $s1 = int state 			= 0
			
			li $s2, 0						# $s2 = int i				= 0
	forLoopCBI:
			bge $s2, 2, endForLoopCBI		# !(i < 2)
	
			li $s3, 0						# $s3 = int r				= 0
	forLoopCBR:
			bge $s3, $t0, endForLoopCBR		# !(r<board_rows)
			
			li $s4, 0						# $s4 = int c			= 0
	forLoopCBC:
			bge $s4, $t1, endForLoopCBC		# !(c<board_cols)
			
# start
	ifFull:
		# &board[r][c]	
			mul $s5, $s3, $t1				# rowIndex * colSize
			add $s5, $s5, $s4				# + colIndex
			mul $s5, $s5, $t3				# * DATA_SIZE
			add $s5, $s5, $t4				# + baseAddress
			lb $s6, ($s5)					# *board[r][c]
	
			beq $s6, $t2, endIfEmpty		# !(*board[r][c] != *empty)
			add $s0, $s0, 1					# nonEmptySlots++
	endIfEmpty:
			
			jal checkHorizontal
			add $s1, $zero, $v0
	ifH:
			beq $s1, 3, endIfH				# !(state != 3)
			add $v0, $zero, $s1				# return state
			j return
	endIfH:
	
			jal checkVertical
			add $s1, $zero, $v0
	ifC:
			beq $s1, 3, endIfC				# !(state != 3)
			add $v0, $zero, $s1				# return state
			j return
	endIfC:
	
			jal checkDiagnalUp
			add $s1, $zero, $v0
	ifDU:
			beq $s1, 3, endIfDU				# !(state != 3)
			add $v0, $zero, $s1				# return state
			j return
	endIfDU:
		
			jal checkDiagnalDown
			add $s1, $zero, $v0
	ifDD:
			beq $s1, 3, endIfDD				# !(state != 3)
			add $v0, $zero, $s1				# return state
			j return
	endIfDD:
			
# finish			
			
			add $s4, $s4, 1					# c++
			j forLoopCBC
	endForLoopCBC:
	
			add $s3, $s3, 1					# r++
			j forLoopCBR
	endForLoopCBR:
	
			add $s2, $s2, 1					# i++
			j forLoopCBI
	endForLoopCBI:

	
			add $v0, $zero, 3				# return 3
				
	return:
			# puts data from stack back to register (POP)
			lw $ra, ($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			lw $s6, 28($sp)
			lw $s7, 32($sp)
			lw $s8, 36($sp)
			lw $t0, 40($sp)
			lw $t1, 44($sp)
			lw $t2, 48($sp)
			lw $t3, 52($sp)
			lw $t4, 56($sp)
			lw $t5, 60($sp)
			lw $t6, 64($sp)
			lw $t7, 68($sp)
			lw $t8, 72($sp)
			lw $t9, 76($sp)
			addu $sp, $sp, 80 
			jr $ra
#------------------------------------------------------------------------
.globl checkHorizontal
checkHorizontal: 
			# saves s registers by pushing it into the stack
			subu $sp, $sp, 80
			sw $ra, ($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s3, 16($sp)
			sw $s4, 20($sp)
			sw $s5, 24($sp)
			sw $s6, 28($sp)
			sw $s7, 32($sp)
			sw $s8, 36($sp)
			sw $t0, 40($sp)
			sw $t1, 44($sp)
			sw $t2, 48($sp)
			sw $t3, 52($sp)
			sw $t4, 56($sp)
			sw $t5, 60($sp)
			sw $t6, 64($sp)
			sw $t7, 68($sp)
			sw $t8, 72($sp)
			sw $t9, 76($sp)
				
			# initializing variables
			li $s0, 0						# $s0 = int chipsConnected = 0
			li $s1, 0						# $s1 = int addHori = 0
			li $s2, 0						# $s2 = int addVert = 0
			lw $t0, board_rows
			lw $t1, board_cols
			lb $t2, empty
			lw $t3, DATA_SIZE
			la $t4, board
			
						
			li $s5, 0						# $s5 = int i				= 0
	forLoopCHI:
			bge $s5, 2, endForLoopCHI		# !(i < 2)
	
			li $s3, 0						# $s3 = int r				= 0
	forLoopCHR:
			bge $s3, $t0, endForLoopCHR		# !(r<board_rows)
			
			li $s4, 0						# $s4 = int c			= 0
	forLoopCHC:
			bge $s4, $t1, endForLoopCHC		# !(c<board_cols)
			
# start
	
	whileLoopCH:
			bge $s3, $t0, endWhileLoopCH	# !(r<board_rows)
			add $t5, $s4, $s1				# c+addHori
			bge $t5, $t1, endWhileLoopCH	# !(c+addHori<board_cols)
		# &board[r][c]	
			mul $s6, $s3, $t1				# rowIndex * colSize
			add $t8, $s4, $s1
			add $s6, $s6, $t8				# + colIndex
			mul $s6, $s6, $t3				# * DATA_SIZE
			add $s6, $s6, $t4				# + baseAddress
			lb $s7, ($s6)					# *board[r][c+addHori]
			
			mul $t6, $s5, $t3				# i * DATA_SIZE
			la $t7, chipType				# &chipType
			add $t6, $t7, $t6				# &chipType + index
			lb $s8, ($t6)					# chipType[index]
			
			bne $s7, $s8, endWhileLoopCH	# !(*board[r][c+addHori] == *chipType[i])
			
			add $s0, $s0, 1					# chipsConnected++
	ifCH:
			bne $s0, 5, endIfCH				# !(chipsConnected == 5)
			add $v0, $zero, $s5				# return i
			j returnCH
			
	endIfCH:
			add $s1, $s1, 1					# addHori++;
	
			j whileLoopCH
	endWhileLoopCH:
	
			li $s0, 0						# $s0 = chipsConnected = 0
			li $s1, 0						# $s1 = addHori = 0
			li $s2, 0						# $s2 = addVert = 0
			
# finish				
			add $s4, $s4, 1					# c++
			j forLoopCHC
	endForLoopCHC:
		
			add $s3, $s3, 1					# r++
			j forLoopCHR
	endForLoopCHR:
	
			add $s5, $s5, 1					# i++
			j forLoopCHI
	endForLoopCHI:
			
			li $v0, 3						# return 3
	returnCH:
				
			# puts data from stack back to register (POP)
			lw $ra, ($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			lw $s6, 28($sp)
			lw $s7, 32($sp)
			lw $s8, 36($sp)
			lw $t0, 40($sp)
			lw $t1, 44($sp)
			lw $t2, 48($sp)
			lw $t3, 52($sp)
			lw $t4, 56($sp)
			lw $t5, 60($sp)
			lw $t6, 64($sp)
			lw $t7, 68($sp)
			lw $t8, 72($sp)
			lw $t9, 76($sp)
			addu $sp, $sp, 80 
			jr $ra
#------------------------------------------------------------------------
.globl checkVertical
checkVertical: 
			# saves s registers by pushing it into the stack
			subu $sp, $sp, 80
			sw $ra, ($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s3, 16($sp)
			sw $s4, 20($sp)
			sw $s5, 24($sp)
			sw $s6, 28($sp)
			sw $s7, 32($sp)
			sw $s8, 36($sp)
			sw $t0, 40($sp)
			sw $t1, 44($sp)
			sw $t2, 48($sp)
			sw $t3, 52($sp)
			sw $t4, 56($sp)
			sw $t5, 60($sp)
			sw $t6, 64($sp)
			sw $t7, 68($sp)
			sw $t8, 72($sp)
			sw $t9, 76($sp)
				
			# initializing variables
			li $s0, 0						# $s0 = int chipsConnected = 0
			li $s1, 0						# $s1 = int addHori = 0
			li $s2, 0						# $s2 = int addVert = 0
			lw $t0, board_rows
			lw $t1, board_cols
			la $t2, board
			lw $t3, DATA_SIZE
			
			
						
			li $s5, 0						# $s5 = int i				= 0
	forLoopCVI:
			bge $s5, 2, endForLoopCVI		# !(i < 2)
	
			li $s3, 0						# $s3 = int r				= 0
	forLoopCVR:
			bge $s3, $t0, endForLoopCVR		# !(r<board_rows)
			
			li $s4, 0						# $s4 = int c			= 0
	forLoopCVC:
			bge $s4, $t1, endForLoopCVC		# !(c<board_cols)
			
# start
	
	whileLoopCV:
			add $t4, $s3, $s2				# r+addVert
			bge $t4, $t0, endWhileLoopCV	# !(r+addVert<board_rows)
			bge $s4, $t1, endWhileLoopCV	# !(c<board_cols)
		# &board[r][c]	
			mul $s6, $t4, $t1				# rowIndex * colSize
			add $s6, $s6, $s4				# + colIndex
			mul $s6, $s6, $t3				# * DATA_SIZE
			add $s6, $s6, $t2				# + baseAddress
			lb $s7, ($s6)					# *board[r+addVert][c]
			
			mul $t6, $s5, $t3				# i * DATA_SIZE
			la $t7, chipType				# &chipType
			add $t6, $t7, $t6				# &chipType + index
			lb $s8, ($t6)					# chipType[index]
			
			bne $s7, $s8, endWhileLoopCV	# !(*board[r+addVert][c] == *chipType[i])
			
			add $s0, $s0, 1					# chipsConnected++
	ifCV:
			bne $s0, 5, endIfCV				# !(chipsConnected == 5)
			add $v0, $zero, $s5				# return i
			j returnCV
			
	endIfCV:
			add $s2, $s2, 1					# addVert++;
	
			j whileLoopCV
	endWhileLoopCV:
	
			li $s0, 0						# $s0 = chipsConnected = 0
			li $s1, 0						# $s1 = addHori = 0
			li $s2, 0						# $s2 = addVert = 0
			
# finish				
			add $s4, $s4, 1					# c++
			j forLoopCVC
	endForLoopCVC:
		
			add $s3, $s3, 1					# r++
			j forLoopCVR
	endForLoopCVR:
	
			add $s5, $s5, 1					# i++
			j forLoopCVI
	endForLoopCVI:
			
			li $v0, 3						# return 3
	returnCV:
				
			# puts data from stack back to register (POP)
			lw $ra, ($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			lw $s6, 28($sp)
			lw $s7, 32($sp)
			lw $s8, 36($sp)
			lw $t0, 40($sp)
			lw $t1, 44($sp)
			lw $t2, 48($sp)
			lw $t3, 52($sp)
			lw $t4, 56($sp)
			lw $t5, 60($sp)
			lw $t6, 64($sp)
			lw $t7, 68($sp)
			lw $t8, 72($sp)
			lw $t9, 76($sp)
			addu $sp, $sp, 80 
			jr $ra
#------------------------------------------------------------------------
.globl checkDiagnalUp
checkDiagnalUp: 
			# saves s registers by pushing it into the stack
			subu $sp, $sp, 80
			sw $ra, ($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s3, 16($sp)
			sw $s4, 20($sp)
			sw $s5, 24($sp)
			sw $s6, 28($sp)
			sw $s7, 32($sp)
			sw $s8, 36($sp)
			sw $t0, 40($sp)
			sw $t1, 44($sp)
			sw $t2, 48($sp)
			sw $t3, 52($sp)
			sw $t4, 56($sp)
			sw $t5, 60($sp)
			sw $t6, 64($sp)
			sw $t7, 68($sp)
			sw $t8, 72($sp)
			sw $t9, 76($sp)
				
			# initializing variables
			li $s0, 0						# $s0 = int chipsConnected = 0
			li $s1, 0						# $s1 = int addHori = 0
			li $s2, 0						# $s2 = int addVert = 0
			lw $t0, board_rows
			lw $t1, board_cols
			la $t2, board
			lw $t3, DATA_SIZE
			
			
						
			li $s5, 0						# $s5 = int i				= 0
	forLoopCDUI:
			bge $s5, 2, endForLoopCDUI		# !(i < 2)
	
			li $s3, 0						# $s3 = int r				= 0
	forLoopCDUR:
			bge $s3, $t0, endForLoopCDUR		# !(r<board_rows)
			
			li $s4, 0						# $s4 = int c			= 0
	forLoopCDUC:
			bge $s4, $t1, endForLoopCDUC		# !(c<board_cols)
			
# start
	
	whileLoopCDU:
			add $t4, $s3, $s2				# r+addVert
			blt $t4, $zero, endWhileLoopCDU	# !(r+addVert>=0)
			add $t5, $s4, $s1				# c+addHori
			bge $t5, $t1, endWhileLoopCDU	# !(c+addHori<board_cols)
		# &board[r][c]	
			mul $s6, $t4, $t1				# rowIndex * colSize
			add $s6, $s6, $t5				# + colIndex
			mul $s6, $s6, $t3				# * DATA_SIZE
			add $s6, $s6, $t2				# + baseAddress
			lb $s7, ($s6)					# *board[r+addVert][c+addHori]
			
			mul $t6, $s5, $t3				# i * DATA_SIZE
			la $t7, chipType				# &chipType
			add $t6, $t7, $t6				# &chipType + index
			lb $s8, ($t6)					# chipType[index]
			
			bne $s7, $s8, endWhileLoopCDU	# !(*board[r+addVert][c+addHori] == *chipType[i])
			
			add $s0, $s0, 1					# chipsConnected++
	ifCDU:
			bne $s0, 5, endIfCDU				# !(chipsConnected == 5)
			add $v0, $zero, $s5				# return i
			j returnCDU
			
	endIfCDU:
			add $s2, $s2, -1				# addVert--;
			add $s1, $s1, 1					# addHori++;
	
			j whileLoopCDU
	endWhileLoopCDU:
	
			li $s0, 0						# $s0 = chipsConnected = 0
			li $s1, 0						# $s1 = addHori = 0
			li $s2, 0						# $s2 = addVert = 0
			
# finish				
			add $s4, $s4, 1					# c++
			j forLoopCDUC
	endForLoopCDUC:
		
			add $s3, $s3, 1					# r++
			j forLoopCDUR
	endForLoopCDUR:
	
			add $s5, $s5, 1					# i++
			j forLoopCDUI
	endForLoopCDUI:
			
			li $v0, 3						# return 3
	returnCDU:
				
			# puts data from stack back to register (POP)
			lw $ra, ($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			lw $s6, 28($sp)
			lw $s7, 32($sp)
			lw $s8, 36($sp)
			lw $t0, 40($sp)
			lw $t1, 44($sp)
			lw $t2, 48($sp)
			lw $t3, 52($sp)
			lw $t4, 56($sp)
			lw $t5, 60($sp)
			lw $t6, 64($sp)
			lw $t7, 68($sp)
			lw $t8, 72($sp)
			lw $t9, 76($sp)
			addu $sp, $sp, 80 
			jr $ra
#------------------------------------------------------------------------
.globl checkDiagnalDown
checkDiagnalDown: 
			# saves s registers by pushing it into the stack
			subu $sp, $sp, 80
			sw $ra, ($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s3, 16($sp)
			sw $s4, 20($sp)
			sw $s5, 24($sp)
			sw $s6, 28($sp)
			sw $s7, 32($sp)
			sw $s8, 36($sp)
			sw $t0, 40($sp)
			sw $t1, 44($sp)
			sw $t2, 48($sp)
			sw $t3, 52($sp)
			sw $t4, 56($sp)
			sw $t5, 60($sp)
			sw $t6, 64($sp)
			sw $t7, 68($sp)
			sw $t8, 72($sp)
			sw $t9, 76($sp)
				
			# initializing variables
			li $s0, 0						# $s0 = int chipsConnected = 0
			li $s1, 0						# $s1 = int addHori = 0
			li $s2, 0						# $s2 = int addVert = 0
			lw $t0, board_rows
			lw $t1, board_cols
			la $t2, board
			lw $t3, DATA_SIZE
			
			
						
			li $s5, 0						# $s5 = int i = 0
	forLoopCDDI:
			bge $s5, 2, endForLoopCDDI		# !(i < 2)
	
			li $s3, 0						# $s3 = int r = 0
	forLoopCDDR:
			bge $s3, $t0, endForLoopCDDR		# !(r<board_rows)
			
			li $s4, 0						# $s4 = int c = 0
	forLoopCDDC:
			bge $s4, $t1, endForLoopCDDC		# !(c<board_cols)
			
# start
	
	whileLoopCDD:
			add $t4, $s3, $s2				# r+addVert
			blt $t4, $zero, endWhileLoopCDD	# !(r+addVert>=0)
			add $t5, $s4, $s1				# c+addHori
			blt $t5, $zero, endWhileLoopCDD	# !(c+addHori>=0)
		# &board[r][c]	
			mul $s6, $t4, $t1				# rowIndex * colSize
			add $s6, $s6, $t5				# + colIndex
			mul $s6, $s6, $t3				# * DATA_SIZE
			add $s6, $s6, $t2				# + baseAddress
			lb $s7, ($s6)					# *board[r+addVert][c+addHori]
			
			mul $t6, $s5, $t3				# i * DATA_SIZE
			la $t7, chipType				# &chipType
			add $t6, $t7, $t6				# &chipType + index
			lb $s8, ($t6)					# chipType[index]
			
			bne $s7, $s8, endWhileLoopCDD	# !(*board[r+addVert][c+addHori] == *chipType[i])
			
			add $s0, $s0, 1					# chipsConnected++
	ifCDD:
			bne $s0, 5, endIfCDD				# !(chipsConnected == 5)
			add $v0, $zero, $s5				# return i
			j returnCDD
			
	endIfCDD:
			add $s2, $s2, -1				# addVert--;
			add $s1, $s1, -1				# addHori--;
	
			j whileLoopCDD
	endWhileLoopCDD:
	
			li $s0, 0						# $s0 = chipsConnected = 0
			li $s1, 0						# $s1 = addHori = 0
			li $s2, 0						# $s2 = addVert = 0
			
# finish				
			add $s4, $s4, 1					# c++
			j forLoopCDDC
	endForLoopCDDC:
		
			add $s3, $s3, 1					# r++
			j forLoopCDDR
	endForLoopCDDR:
	
			add $s5, $s5, 1					# i++
			j forLoopCDDI
	endForLoopCDDI:
			
			li $v0, 3						# return 3
	returnCDD:
				
			# puts data from stack back to register (POP)
			lw $ra, ($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			lw $s6, 28($sp)
			lw $s7, 32($sp)
			lw $s8, 36($sp)
			lw $t0, 40($sp)
			lw $t1, 44($sp)
			lw $t2, 48($sp)
			lw $t3, 52($sp)
			lw $t4, 56($sp)
			lw $t5, 60($sp)
			lw $t6, 64($sp)
			lw $t7, 68($sp)
			lw $t8, 72($sp)
			lw $t9, 76($sp)
			addu $sp, $sp, 80 
			jr $ra