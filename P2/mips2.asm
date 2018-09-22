#s0=n
.data
array: .space 100
.text
li $v0,5
syscall
move $s0,$v0

li $t0,0
for_1_begin:
	slt $t1,$t0,$s0
	beq $t1,$zero,for_1_end
	
	li $v0,5
	syscall
	sll $t0,$t0,2
	sw $v0,array($t0)
	srl $t0,$t0,2
	
	addi $t0,$t0,1
	j for_1_begin
for_1_end:

li $t0,0 # t0=i,t1=j,t2=a[i],t3=a[j]
for_2_begin:
	slt $t1,$t0,$s0
	beq $t1,$zero,for_2_end
	
	move $t1,$t0
	for_3_begin:
		slt $t4,$t1,$s0
		beq $t4,$zero,for_3_end
		
		sll $t0,$t0,2
		lw $t2,array($t0)
		srl $t0,$t0,2
		sll $t1,$t1,2
		lw $t3,array($t1)
		srl $t1,$t1,2
		
		slt $t4,$t3,$t2
		beq $t4,$zero,continue
		
		sll $t0,$t0,2
		sw $t3,array($t0)
		srl $t0,$t0,2
		sll $t1,$t1,2
		sw $t2,array($t1)
		srl $t1,$t1,2
		
		continue:
		addi $t1,$t1,1
		j for_3_begin
	for_3_end:
	addi $t0,$t0,1
	j for_2_begin
for_2_end:

li $v0,10
syscall
