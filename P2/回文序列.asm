.data
char: .space 20
room: .space 20
.text
li $v0, 5
syscall
move $s0, $v0 # $s0 = n
li $t0, 0 # $t0 = i
la $s1, char # $s1 record the address of char

loop:
	beq $t0, $s0, judge
	nop
	li $v0, 12
	syscall
	move $t8, $v0
	sb $t8, 0($s1)
	addi $s1, $s1, 1 # $s1 move forword
	addi $t0, $t0, 1 # i++
	j loop
judge:
	la $s1, char
	add $s2, $s1, $t0
	subi $s2, $s2, 1
	move $t1, $s1
	move $t2, $s2
judgeloop:
	sub $t3, $t2, $t1
	blez $t3, end
	nop
	lb $t4, 0($t1) # $t4 = a[i]
	lb $t5, 0($t2) # $t5 = a[n-i]
	bne $t4, $t5, false # a[i] != a[n-i]
	nop
	addi $t1, $t1, 1
	subi $t2, $t2, 1
	j judgeloop
false:
	li $v0, 1
	li $a0, 0
	syscall
	li $v0, 10
	syscall
end:
	li $v0, 1
	li $a0, 1
	syscall
	li $v0, 10
	syscall