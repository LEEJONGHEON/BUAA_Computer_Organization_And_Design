#s0=n,t0和t1是当前行列,t2=k
.data
mat1: .space 400
mat2: .space 400
mat3: .space 400
space: .asciiz " "
enter: .asciiz "\n"

.text
li $v0,5
syscall	
move $s0,$v0

li $t0,0
li $t1,0
li $s1,0 #s1为存储地址
init_1:
	mult $s0,$t0
	mflo $s1
	add $s1,$s1,$t1
	sll $s1,$s1,2
	li $v0,5
	syscall
	sw $v0,mat1($s1)
	addi $t1,$t1,1
	bne $t1,$s0,init_1
	
	move $t1,$zero
	addi $t0,$t0,1
	bne $t0,$s0,init_1
	
li $t0,0
li $t1,0
li $s1,0
init_2:
	mult $s0,$t0
	mflo $s1
	add $s1,$s1,$t1
	sll $s1,$s1,2
	li $v0,5
	syscall
	sw $v0,mat2($s1)
	addi $t1,$t1,1
	bne $t1,$s0,init_2
	
	move $t1,$zero
	addi $t0,$t0,1
	bne $t0,$s0,init_2
	
li $t0,0
li $t1,0
li $s3,0
for_1_begin:
	slt $t4,$t0,$s0
	beq $t4,$zero,for_1_end
	
	li $t1,0 #j=0
	for_2_begin:
		slt $t4,$t1,$s0
		beq $t4,$zero,for_2_end
		
		li $t2,0 #k=0
		for_3_begin:
			slt $t4,$t2,$s0
			beq $t4,$zero,for_3_end
			
			mult $s0,$t0
			mflo $s1
			add $s1,$s1,$t2
			sll $s1,$s1,2
			lw $t6,mat1($s1) #t6存储第一个矩阵中的乘数
			
			mult $s0,$t2
			mflo $s2
			add $s2,$s2,$t1
			sll $s2,$s2,2
			lw $t7,mat2($s2) #t7存储第一个矩阵中的乘数
			
			mult $t6,$t7
			mflo $t6
			add $t8,$t8,$t6
			
			addi $t2,$t2,1
			j for_3_begin
		for_3_end:
		
		move $a0,$t8
		li $v0,1
		syscall
		
		la $a0,space
		li $v0,4
		syscall
		
		addi $t1,$t1,1
		j for_2_begin
	for_2_end:
	
	la $a0,enter
	li $v0,4
	syscall
	
	addi $t0,$t0,1
	j for_1_begin
for_1_end:

