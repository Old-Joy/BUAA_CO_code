.data
matrix: .space 6400
row: .space 1600
col: .space 1600
str_space: .asciiz " "
str_enter: .asciiz "\n"

.text
li $v0, 5
syscall
move $s0, $v0 # $s0 = n number of row
li $v0, 5
syscall
move $s1, $v0 # $s1 = m number of col

li $t0, 0 # $t0 = i
li $t1, 0 # $t1 = j
li $s2, 0
la $s3, matrix
la $s4, row
la $s5, col
la $s6, matrix
li $t5, 0

readmatrix:
	li $t0, 0 #reset i=0
readrow:
	beq $t0, $s0, endread #if i==n matrix_reading is over
	li $t1, 0 #reset j=0
readcol:
	beq $t1, $s1, endrow #if j==m a row has been read over
	
	
	li $v0, 5
	syscall #read a number
	move $t2, $v0 # $t2 = matrix[i][j]
	beq $t2, $s2, next_element # if matrix[i][j] = 0 jump tp next element
	nop
	
	sw $t2, 0($s3) #save matrix[i][j] to matrix
	addi $s3, $s3, 4
	addi $t3, $t0, 1
	sw $t3, 0($s4)
	addi $s4, $s4, 4
	addi $t4, $t1, 1
	sw $t4, 0($s5)
	addi $s5, $s5, 4
	addi $t5, $t5, 1 #add the number of matrix[i][j] that don't equal 0
next_element:
	addi $t1, $t1, 1
	j readcol
endrow:
	addi $t0, $t0, 1
	j readrow


endread:
	la $s3, matrix
	la $s4, row
	la $s5, col
	mul $t5, $t5, 4
	add $s3, $s3, $t5
	add $s4, $s4, $t5
	add $s5, $s5, $t5
	
printf_loop:
	subi $s3, $s3, 4
	subi $s4, $s4, 4
	subi $s5, $s5, 4
	
	blt $s3, $s6, end
	
	lw $a0 0($s4)
	lw $a1 0($s5)
	lw $a2 0($s3)
	li $v0 1 #printf i
	syscall
	
	li $v0 4 #printf " "
	la $a0 str_space
	syscall
	
	li $v0 1 #printf j
	move $a0, $a1
	syscall
	
	li $v0 4 #printf " "
	la $a0 str_space
	syscall
	
	li $v0 1
	move $a0, $a2 #printf matrix[i][j]
	syscall
	
	li $v0, 4 #printf "\n"
	la $a0 str_enter
	syscall
	

	j printf_loop
	
end:
	li $v0, 10
	syscall
	
	
	
