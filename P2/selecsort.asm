#s0=n
.data
array: .space 500
space: .asciiz " "
.text
li $v0,5
syscall
move $s0,$v0

li $t0,0
init:
	sll $t0,$t0,2
	li $v0,5
	syscall
	sw $v0,array($t0)
	srl $t0,$t0,2
	addi $t0,$t0,1
	bne $t0,$s0,init

li $t0,0 #t0=i
li $t1,0 #t1=j
li $t2,0 #t2=index
li $t3,0 #t3=tmp
li $t5,0 #t5=array[index]
li $t6,0 #t6=array[j]
for_1_begin:
	slt $t4,$t0,$s0
	beq $t4,$zero,for_1_end
	
	move $t2,$t0
	move $t1,$t0
	for_2_begin:
		addi $t1,$t1,1
		slt $t4,$t1,$s0
		beq $t4,$zero,for_2_end	
		
		sll $t1,$t1,2
		lw $t6,array($t1)
		srl $t1,$t1,2
		sll $t2,$t2,2
		lw $t5,array($t2)
		srl $t2,$t2,2
		
		slt $t4,$t6,$t5
		beq $t4,$zero,for_2_begin
		move $t2,$t1
		j for_2_begin
	for_2_end:
	sll $t0,$t0,2
	lw $t6,array($t0) #array[i]
	sll $t2,$t2,2
	lw $t5,array($t2) #array[index]
	sw $t5,array($t0)
	sw $t6,array($t2)
	srl $t0,$t0,2
	srl $t2,$t2,2
	addi $t0,$t0,1
	j for_1_begin
for_1_end:

li $t0,0
output:
	slt $t1,$t0,$s0
	beq $t1,$zero,end
	
	sll $t0,$t0,2
	lw $a0,,array($t0)
	srl $t0,$t0,2
	li $v0,1
	syscall
	
	la $a0,space
	li $v0,4
	syscall
	
	addi $t0,$t0,1
	j output
end:
li $v0,10
syscall
	
