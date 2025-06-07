.macro getint(%target)
li $v0, 5
syscall
move %target $v0
.end_macro 

.macro end
li $v0, 10
syscall
.end_macro

.macro off(%tar,%n,%i,%j)
mult %i,%n
mflo %tar
add %tar, %tar, %j
sll %tar, %tar, 2
.end_macro

.data 
matrix1: .space 256
matrix2: .space 256
space: .asciiz " "
enter: .asciiz "\n"

.text
getint($s0) #get n
li $t0, 0 # $t0 = i
li $t1, 0 # $t1 = j
la $s1, matrix1
la $s2, matrix2
rowloop1:
	li $t0, 0 # reset i = 0
colloop1:
	beq $t0, $s0, endread1 # if i == n jump to end
	li $t1, 0 # reset j = 0
read1:
	beq $t1, $s0, endrow1 # if j == n a col has been read over
	
	getint($t2) #get one number
	sw $t2, 0($s1) # save the number
	addi $s1, $s1, 4
	addi $t1, $t1, 1 # j++
	j read1
endrow1:
	addi $t0, $t0, 1 # i++
	j colloop1

endread1:
	li $t0, 0 # $t0 = i
	li $t1, 0 # $t1 = j

rowloop2:
	li $t0, 0
colloop2:
	beq $t0, $s0, endread2
	li $t1, 0
read2:
	beq $t1, $s0, endrow2
	
	getint($t2) #get one number
	sw $t2, 0($s2)
	addi $s2, $s2, 4 # save the word
	addi $t1, $t1, 1 # j++
	j read2
endrow2:
	addi $t0, $t0, 1 # i++
	j colloop2
	
endread2: # begin to mult
	li $t0, 0 # reset i = 0
	li $t1, 0 # reset j = 0
	li $t3, 0 # set k = 0
	la $s1, matrix1
	la $s2, matrix2
	li $s4, 0 # set sum = 0
output:
	li $t0, 0
outputrow:
	beq $t0, $s0, end # if i == n jump to end
	li $t1, 0
outputcol:
	beq $t1, $s0, outputendrow
	li $t3, 0 # reset k = 0
	li $s4, 0 # reset sum = 0
multi:
	beq $t3, $s0, endmulti
	
	off($s3, $s0, $t0, $t3) # $s3 = offset
	add $s3, $s3, $s1
	lw $t4 0($s3) # $t4 = a[i][k]
	off($s3, $s0, $t3, $t1)
	add $s3, $s3, $s2
	lw $t5 0($s3) # $s5 = b[k][j]
	mult $t4, $t5
	mflo $t6
	add $s4, $s4, $t6 # sum += a[i][k] * b[k][j]
	addi $t3, $t3, 1 # k++
	j multi
endmulti: # k == n is true
	li $v0, 1
	move $a0, $s4
	syscall # output c[i][j]
	li $v0, 4
	la $a0, space
	syscall # output " "
	addi $t1, $t1, 1 #j++
	j outputcol
outputendrow: # j == n is true
	li $v0, 4
	la $a0, enter
	syscall # output "\n"
	addi $t0, $t0, 1 #i++
	j outputrow
end: # i == n is true
	li $v0, 10
	syscall