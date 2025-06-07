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
G: .space 256
book: .space 32

.text

main:
	getint($s0) # $s0 = n
	getint($s1) # $s1 = m
	la $s2, G
	la $s3, book
	li $s4, 0 # $s4 = ans
	li $t0, 0 #$t0 = i
	loop:
		beq $t0, $s1, endloop # if i == m end the loop
		nop
		getint($t1) # $t1 = x
		getint($t2) # $t2 = y
		subi $t1, $t1, 1 # $t1 = x - 1
		subi $t2, $t2, 1 # $t2 = y - 1
		sll $t3, $t1, 3 # (x - 1) * 8
		add $t3, $t3, $t2
		sll $t3, $t3, 2 # offset of G[x-1][y-1]
		add $t3, $t3, $s2
		li $t4, 1
		sw $t4, 0($t3) # G[x-1][y-1] = 1
		sll $t3, $t2, 3 # (y - i) * 8
		add $t3, $t3, $t1 # (y - i) * 8 + (x - 1)
		sll $t3, $t3, 2 # [(y - i) * 8 + (x - 1)] * 4 offset of G[y-1][x-1]
		add $t3, $t3, $s2
		li $t4, 1
		sw $t4, 0($t3)
		addi $t0, $t0, 1
		j loop
	endloop:
		move $a0, $zero
		jal dfs
		li $v0, 1
		move $a0, $s4
		syscall
		li $v0, 10
		syscall
		
dfs:
	push($ra)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($t5)
	push($t6)
	move $t0, $a0 # $t0 = x
	sll $t1, $t0, 2
	add $t1, $t1, $s3
	li $t2, 1
	sw $t2, 0($t1)
	li $t2, 1 # $t2 = flag
	li $t3, 0 # $t3 = i
	loop_up:
		beq $t3, $s0, loop_up_end
		nop
		
		sll $t4, $t3, 2
		add $t4, $t4, $s3 # $t4 = the address of book[i]
		lw $t5, 0($t4) # $t5 = book[i]
		and $t2, $t2, $t5
		addi $t3, $t3, 1
		j loop_up
	loop_up_end:
		li $t4, 1
		beq $t2, $t4, one_yes
		nop
		j for_down1
	one_yes:
		li $t4, 1
		sll $t5, $t0, 5 # $t5 = x * 8 * 4
		add $t5, $t5, $s2
		lw $t6, 0($t5) # $t6 = G[x][0]
		beq $t6, $t4, all_yes
		nop
		j for_down1
	all_yes:
		li $s4, 1
		j end
	for_down1:
		li $t3, 0
	for_down:
		beq $t3, $s0, end
		sll $t4, $t3, 2
		add $t4, $t4, $s3 # $t4 = the address of book[i]
		lw $t5, 0($t4) # $t5 = book[i]
		li $t6, 0
		beq $t6, $t5, yes_one
		nop
		j next
	yes_one:
		sll $t4, $t0, 3 # x * 8
		add $t4, $t4, $t3 # x* 8 + i
		add $t4, $t4, $s2
		sll $t4, $t4, 2
		lw $t5, 0($t4)
		li $t6, 1
		beq $t6, $t5, yes_all
		nop
		j next
	yes_all:
		move $a0, $t3
		jal dfs
	next:
		addi $t3, $t3, 1
		j for_down
	end:
		sll $t4, $t0, 2
		add $t4, $t4, $s3
		li $t6, 0
		sw $t6, 0($t4)
		pop($t6)
		pop($t5)
		pop($t4)
		pop($t3)
		pop($t2)
		pop($t1)
		pop($t0)
		pop($ra)
		jr $ra