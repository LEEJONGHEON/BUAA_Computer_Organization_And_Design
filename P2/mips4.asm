#s0=n,t0=i,a0=index
.data
path: .space 16
bool: .space 16 
space: .asciiz " "
enter: .asciiz "\n"
.text

li $v0,5
syscall
move $s0,$v0

li $a0,0
jal full #########
li $v0,10
syscall

full:
	bne $a0,$s0,work
	li $t0,0
	print_begin:
		slt $t1,$t0,$s0
		beq $t1,$zero,print_end
		lb $a0,path($t0)
		li $v0,1
		syscall
		la $a0,space
		li $v0,4
		syscall
		
		addi $t0,$t0,1
		j print_begin
	print_end:
		la $a0,enter
		li $v0,4
		syscall
		jr $ra
work:
	li $t0,-1
	for_1_begin:
		addi $t0,$t0,1
		slt $t1,$t0,$s0
		beq $t1,$zero,for_1_end
		lb $t1,bool($t0)
		bnez $t1,for_1_begin
		
		move $t1,$t0
		addi $t1,$t1,1
		sb $t1,path($a0)
		li $t1,1
		sb $t1,bool($t0)
		
		sw $ra,0($sp)
		subi $sp,$sp,4
		sw $t0,0($sp)
		subi $sp,$sp,4
		sw $a0,0($sp)
		subi $sp,$sp,4
		
		addi $a0,$a0,1
		jal full
		
		addi $sp,$sp,4
		lw $a0,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		
		sb $zero,bool($t0)
		j for_1_begin
	for_1_end:
		jr $ra
