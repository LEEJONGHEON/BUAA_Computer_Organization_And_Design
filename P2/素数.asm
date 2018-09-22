#s0=m,s1=n,t0=i,t1=j,t2=counter,t3=flag,s2=10
.data
enter: .asciiz "\n"
space: .asciiz " "
string: .ascii "The prime numbers are:\n"
.text
li $v0,5
syscall
move $s0,$v0
li $v0,5
syscall 
move $s1,$v0
addi $s1,$s1,1

la $a0,string
li $v0,4
syscall

li $s2,10
move $t0,$s0
subi $t0,$t0,1
for_1_begin:   ###########×¢Òâ
	addi $t0,$t0,1
	slt $t4,$t0,$s1
	beq $t4,$zero,for_1_end
	¡¤
	li $t1,1
	li $t3,0
	for_2_begin:
		addi $t1,$t1,1
		slt $t4,$t1,$t0
		beq $t4,$zero,for_2_end
		div $t0,$t1
		mfhi $t4
		bnez $t4,for_2_begin
		li $t3,1
	for_2_end:
		bnez $t3,for_1_begin
		move $a0,$t0
		li $v0,1
		syscall
		la $a0,space
		li $v0,4
		syscall
		addi $t2,$t2,1
		bne $t2,$s2,for_1_begin
		la $a0,enter
		li $v0,4
		syscall
		li $t2,0
		j for_1_begin		
for_1_end:

li $v0,10
syscall
	
