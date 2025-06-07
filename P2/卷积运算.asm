.macro getint(%target)
li $v0, 5
syscall
move %target, $v0
.end_macro 

.data 
matrix1: .space 400
matrix2: .space 400
space: .asciiz " "
enter: .asciiz "\n"

.text
getint($s0) # $s0 = m1
getint($s1) # $s1 = n1
getint($s2) # $s2 = m2
getint($s3) # $s3 = n2
la $s4, matrix1
la $s5, matrix2
li $t0, 0 # $t0 = i
li $t1, 0 # $t1 = j
move $s7, $s1

begin1:
	li $t0, 0 #reset i = 0
colloop1:
	beq $t0, $s0, endread1 # i == m1
	nop
	li $t1, 0 # reset j = 0
read1:
	beq $t1, $s1, endcol1
	nop
	
	getint($t2)
	sw $t2, 0($s4)
	addi $s4, $s4, 4
	addi $t1, $t1, 1
	j read1
endcol1:# j == n1 is true
	addi $t0, $t0, 1 # i++
	j colloop1
endread1:
	li $t0, 0 # $t0 = i
	li $t1, 0 # $t1 = j
colloop2:
	beq $t0, $s2, endread2 # i == m2
	nop
	li $t1, 0 # reset j = 0
read2:
	beq $t1, $s3, endcol2 # j == n2
	nop
	
	getint($t2)
	sw $t2, 0($s5)
	addi $s5, $s5, 4
	addi $t1, $t1, 1
	j read2
endcol2: # j == n2 is true
	addi $t0, $t0, 1 # i++
	j colloop2
endread2:
#matrix 1 and matrix 2 have been read over

la $s4, matrix1
la $s5, matrix2
li $t0, 0
li $t1, 0
li $t3, 0 # $t3 = k
li $t4, 0 # $t4 = l
li $s6, 0 # $s6 = g[i][j]
sub $t8, $s0, $s2
addi $t8, $t8, 1
sub $t9, $s1, $s3
addi $t9, $t9, 1
move $s0, $t8 # the finishment of i is m1 - m2 + 1
move $s1, $t9 # the finishment of j is n1 - n2 + 1

outputbegin:
	li $t0, 0 # reset i = 0
output_i_loop:
	beq $t0, $s0, endi # if i == m1 - m2 + 1
	nop
	li $t1, 0 # reset j = 0
output_j_loop:
	beq $t1, $s1, endj # if j == n1 - n2 + 1
	nop
	li $t3, 0 # reset k = 0
output_k_loop:
	beq $t3, $s2, endk # if k == m2
	nop
	li $t4, 0 # reset l = 0
output:
	beq $t4, $s3, endl # if l == n2
	nop
	
	add $t5, $t0, $t3 # $t5 = i + k
	add $t6, $t1, $t4 # $t6 = j + l
	mult $t5, $s7
	mflo $t5 # $t5 =(i + k) * n1
	add $t5, $t5, $t6 # $t5 = offset
	sll $t5, $t5, 2
	add $t5, $t5, $s4
	lw $t6, 0($t5) # $t6 = f[i + k][j + l]
	mult $t3, $s3
	mflo $t7
	add $t7, $t7, $t4 # $t7 = offset
	sll $t7, $t7, 2
	add $t7, $t7, $s5 # $t7 = the address of h[k][l]
	lw $t8, 0($t7)
	mult $t6, $t8
	mflo $t9
	add $s6, $s6, $t9 # $s6 += f[i + k][j + l] * h[k][l]
	addi $t4, $t4, 1 # l++
	j output
endl: # if l == n2 is true
	addi $t3, $t3, 1 # k++
	j output_k_loop
endk: # if k == m2 is true
	li $v0, 1
	move $a0, $s6
	syscall
	li $v0, 4
	la $a0, space
	syscall
	li $s6, 0
	addi $t1, $t1, 1 # j++
	j output_j_loop
endj:
	li $v0, 4
	la $a0, enter
	syscall
	addi $t0, $t0, 1 # i++
	j output_i_loop
endi:
	li $v0, 10
	syscall
	