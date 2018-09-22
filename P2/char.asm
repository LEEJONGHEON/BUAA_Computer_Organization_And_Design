#s0=n
.data
char: .space 100

.text
li $v0,5
syscall
move $s0,$v0

li $t0,0
for_1_begin:
	slt $t1,$t0,$s0
	beq $t1,$zero,for_1_end
	
	li $v0,12
	syscall
	sll $t0,$t0,2
	sw $v0,char($t0)
	srl $t0,$t0,2
	
	addi $t0,$t0,1
	j for_1_begin
for_1_end:


li $t0,0
move $t2,$s0 #t0从前往后,t2从后往前
subi $t2,$t2,1
sll $t2,$t2,2
srl $s0,$s0,1
for_2_begin:
	slt $t1,$t0,$s0
	beq $t1,$zero,for_2_end
	
	sll $t0,$t0,2
	lw $t4,char($t0)
	lw $t5,char($t2)
	bne $t4,$t5,no
	
	srl $t0,$t0,2
	addi $t0,$t0,1
	subi $t2,$t2,4
	j for_2_begin
for_2_end:
	la $a0,1
	li $v0,1
	syscall 
	li $v0,10
	syscall

no:
	la $a0,0
	li $v0,1
	syscall