#s0=n
.data
array: .space 400
string: .ascii "String is:"
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
	slti $t1,$v0,96
	bnez $t1,continue
	subi $v0,$v0,32
	continue:
	sll $t0,$t0,2
	sw $v0,array($t0)
	srl $t0,$t0,2
	addi $t0,$t0,1
	j for_1_begin
for_1_end:


la $a0,string
li $v0,4
syscall 

li $t0,0
for_2_begin:
	slt $t1,$t0,$s0
	beq $t1,$zero,for_2_end
	sll $t0,$t0,2
	move $a0,$t0
	li $v0,4
	syscall
	srl $t0,$t0,2
	addi $t0,$t0,1
	j for_2_begin
for_2_end:
	
	
