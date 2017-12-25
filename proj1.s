	.data
	n: .word 0
	k: .word 0
	prime: .word 0
	
	.text
main:	li $v0, 5		# scan an int
	syscall
	move $t0, $v0		# store scanned int in a register
	sw $t0, 12($sp)		# store n in the stack

	bge $t0, 2, else	# if n >= 2
	li $t0, 0		# prime = 0
	sw $t0, 8($sp)

else:	li $t0, 2		# k = 2
	sw $t0, 4($sp)
	li $t0, 1		# prime = 1
	sw $t0, 8($sp)

	lw $t0, 4($sp)		# $t0 gets k
	lw $t1, 8($sp)		# $t1 gets prime
	lw $t2, 12($sp)		# $t2 gets n
	div $t2, $t2, 2		# n / 2
	add $t2, $t2, 1		# n + 1

while:	bge $t0, $t2, print	# if k >= n - short circuiting
	beqz $t1, print		# if !prime
	rem $t2, $t2, $t0	# n % k
	bnez $t2, else2		# if n % k != 0
	li $t1, 0		# prime = 0
	sw $t1, 8($sp)
	j while			# go through loop again

else2:	add $t0, $t0, 1		# k++
	sw $t0 4($sp)
	j while			# go through loop again
	
	li $v0, 10 		# return 0
	syscall
	
print:	li $v0, 10		# print prime
	move $a0, 8($sp)
	syscall

	li $v0, 11		# print char
	li $a0, 10		# print '\n'
	syscall

