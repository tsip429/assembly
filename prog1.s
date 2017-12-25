	# Tsipora Stone, UID 114110213, tstone97, 0305
	# takes in one integer prints 1 if prime, 0 if not if the number is
	# less than 2 print 0
	.data
	n: .word 0
	k: .word 0
	prime: .word 0
	
	.text
main:	li $v0, 5		# scan an int
	syscall
	move $t0, $v0		# store scanned int in a register
	sw $t0, n		# store n in the stack

	bge $t0, 2, else	# if n >= 2
	li $t1, 0		# prime = 0
	sw $t1, prime
	j print

else:	li $t0, 2		# k = 2
	sw $t0, k
	li $t0, 1		# prime = 1
	sw $t0, prime

	lw $t0, k		# $t0 gets k
	lw $t1, prime		# $t1 gets prime
	lw $t2, n		# $t2 gets n
	div $t3, $t2, 2		# n / 2
	add $t3, $t3, 1		# n + 1

while:	bge $t0, $t2, print	# if k >= n - short circuiting
	beqz $t1, print		# if !prime
	rem $t4, $t2, $t0	# n % k
	bnez $t4, else2		# if n % k != 0
	li $t1, 0		# prime = 0
	sw $t1, prime
	j while			# go through loop again

else2:	add $t0, $t0, 1		# k++
	sw $t0, k
	j while			# go through loop again
	
print:	li $v0, 1		# print prime
	lw $a0, prime
	syscall

	li $v0, 11		# print char
	li $a0, 10		# print '\n'
	syscall

	li $v0, 10 		# return 0
	syscall
