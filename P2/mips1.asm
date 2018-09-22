#s0=n.t0=i,t1=j
.data
da: .ascii
array1: .space 400
array2: .space 400
space: .asciiz " "
enter: .asciiz "\n"
.text
li $v0,5
syscall
move $s0,$v0

li $t0,0
li $t1,0
loop1:
	li $v0,5
	syscall 
	mult $s0,$t0
	mflo $t2
	add $t2,$t2,$t1
	sll $t2,$t2,2
	sw $v0,array1($t2)
	
	addi $t1,$t1,1
	bne $t1,$s0,loop1 #######
	
	addi $t0,$t0,1
	li $t1,0
	bne $t0,$s0,loop1 #######
	
li $t0,0
li $t1,0
loop2:
	li $v0,5
	syscall 
	mult $s0,$t0
	mflo $t2
	add $t2,$t2,$t1
	sll $t2,$t2,2
	sw $v0,array2($t2)
	
	addi $t1,$t1,1
	bne $t1,$s0,loop2 #######
	
	addi $t0,$t0,1
	li $t1,0
	bne $t0,$s0,loop2 #######

li $t0,0 #t0=i
li $t1,0 #t1=j
li $t2,0 #t2=k
li $t3,0 #t3=sum
for_1_begin:
	slt $t4,$t0,$s0
	beq $t4,$zero,for_1_end
	
	li $t1,0
	for_2_begin:
		slt $t4,$t1,$s0
		beq $t4,$zero,for_2_end
		
		li $t2,0
		li $t3,0
		for_3_begin:
			slt $t4,$t2,$s0
			beq $t4,$zero,for_3_end
			
			mult $s0,$t0
			mflo $t4
			add $t4,$t4,$t2
			sll $t4,$t4,2
			lw $t8,array1($t4)
			
			mult $s0,$t2
			mflo $t4
			add $t4,$t4,$t1
			sll $t4,$t4,2
			lw $t9,array2($t4)
			
			mult $t8,$t9
			mflo $t4
			add $t3,$t3,$t4
			addi $t2,$t2,1
			j for_3_begin
		for_3_end:
			move $a0,$t3
			li $v0,1
			syscall
			la $a0,space
			li $v0,4
			syscall
					
			addi $t1,$t1,1
			j for_2_begin
	for_2_end:
		addi $t0,$t0,1
		j for_1_begin
for_1_end:
