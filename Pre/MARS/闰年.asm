li $v0, 5
syscall
move $t0, $v0
li $s0, 400
li $s1, 4
li $s2, 0
li $s3, 100
div $t0, $s1
mfhi $t1 #set remainder to $t1
beq $t1, $s2, mode4 #  mode4==0 jump to mode4
nop
j no
nop

no:
li $v0, 1
li $a0, 0
syscall
li $v0, 10
syscall

mode4:
div $t0, $s3
mfhi $t2
beq $t2, $s2, mode400 # mode100==0 jump to mode400
nop
j yes
nop

yes:
li $v0, 1
li $a0, 1
syscall
li $v0, 10
syscall

mode400:
div $t0, $s0
mfhi $t2
beq $t2, $s2, yes # mode400==0 jump to yes
nop
j no
nop