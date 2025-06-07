.macro getint(%target)
li $v0, 5
syscall
move %target, $v0
.end_macro 

.macro end
li $v0, 10
syscall
.end_macro

.macro push(%src)
    addi    $sp, $sp, -4
    sw      %src, 0($sp)
.end_macro

.macro pop(%des)
    lw      %des, 0($sp)
    addi    $sp, $sp, 4
.end_macro

.macro printint(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro

.data
symbol: .space 32
array: .space 32
space: .asciiz " "
enter: .asciiz "\n"

.text

main:
	getint($s0) # $s0 = n
	la $s1, symbol
	la $s2, array
	la $s3, space
	la $s4, enter
	li $t0, 0
	move $a0, $t0
	jal FullArray
	li $v0, 10
	syscall
	
FullArray:
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($ra)
	move $t0, $a0 # $t0 = index
	li $t1, 0 #  $t1 = i
	sub $t2, $t0, $s0 # index - n
	bltz $t2, bfor2
	nop
	
	for1:
		beq $t1, $s0, end_for1 # if i == n
		nop
		sll $t2, $t1, 2 # $t2 = 4 * i
		add $t3, $t2, $s2 # $t3 = the address of array[i]
		lw $t4, 0($t3) # $t4 = array[i]
		printint($t4)
		li $v0, 4
		la $a0, space
		syscall
		addi $t1, $t1, 1
		j for1
	end_for1:
		li $v0, 4
		la $a0, enter
		syscall
		j end
	bfor2:
		li $t1, 0 # reset i = 0
	for2:
		beq $t1, $s0, end # if i == n
		nop
		
		sll $t2, $t1, 2 # $t2 = 4 * i
		add $t3, $t2, $s1 # $t3 = the address of symbol[i]
		lw $t4, 0($t3) # $t4 = symbol[i]
		bne $t4, $zero, next # if synbol[i] != 0
		nop
		
		sll $t2, $t0, 2 # $t2 = 4 * index
		add $t3, $t2, $s2  # $t3 = the address of array[index]
		addi $t4, $t1, 1 # $t4 = i + 1
		sw $t4, 0($t3)
		li $t4, 1
		sll $t2, $t1, 2 # $t2 = 4 * i
		add $t3, $t2, $s1 # $t3 = the address of symbol[i]
		sw $t4, 0($t3)
		addi $a0, $t0, 1 # $a0 = index + 1
		jal FullArray
		li $t4, 0
		sw $t4, 0($t3)
		next:
			addi $t1, $t1, 1
			j for2
		end:
		pop($ra)
		pop($t4)
		pop($t3)
		pop($t2)
		pop($t1)
		pop($t0)
		jr $ra