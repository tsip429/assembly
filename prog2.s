	# Tsipora Stone, UID 114110213, tstone97, 0305
	# returns the smallest prime between two integers returns -1 if no
	# primes
	.data
	x:.word 0
	y:.word 0
	i:.word 0
	result:	.word 0

	.text
main:	li $sp, 0x7ffffffc	# init $sp
	li $v0, 5 		# scan an int
	syscall
	sw $v0, x

	li $v0, 5		# scan an int
	syscall
	sw $v0, y

	li $t0, -1		# result = -1
	sw $t0, result

	lw $t0, x		# $t0 gets x
	bge $t0, 2, endif	# x >= 2
	li $t0, 2		# x = 2
	sw $t0, x

endif:	lw $t0, x		# i = x
	sw $t0, i

	lw $t0, y		# $t0 gets y
	lw $t1, i		# $t1 gets i
	lw $t2, result		# $t2 gets result
	blez $t0, print		# y <= 0

loop:	bgt $t1, $t0, print	# i > y
	bne $t2, -1, print	# result != -1
	sw $t1, ($sp)		# push arg on to stack
	sub $sp, $sp, 4
	jal is_prime		# calls is_prime
	add $sp, $sp, 4		# pop arg
	move $t3, $v0		# store ret val
	beqz $t3, else		# !is_prime(i)
	move $t2, $t1		# result= i
	sw $t2, result
	j loop			# jump back into loop

else:	add $t1, $t1, 1		# i++
	sw $t1, i
	j loop			# jump back into loop

print:	li $v0, 1		# print result
	lw $a0, result
	syscall

	li $v0, 11		# print '\n'
	li $a0, 10
	syscall

	li $v0, 10		# return 0
	syscall

				# prologue
is_prime:sub $sp, $sp, 16	# set $sp
	sw $ra, 16($sp)		# save $ra
	sw $fp, 12($sp)		# save $fp
	add $fp, $sp, 16	# set new $fp

	li $t5, 2		# k = 2
	sw $t5, 8($sp)
	li $t6, 1		# prime = 1
	sw $t6, 4($sp)

	lw $t7, 4($fp)		# $t7 gets n

	div $t8, $t7, 2		# n / 2
	add $t8, $t8, 1		# n / 2 + 1

while:	bge $t5, $t8, return	# k >= n / 2 + 1
	beqz $t6, return	# prime = 0
	rem $t9, $t7, $t5	# n % k
	bnez $t9, else2		# n % k != 0
	li $t6, 0		# prime = 0
	sw $t6, 4($sp)	
	j while

else2:	add $t5, $t5, 1		# k++
	sw $t5, 8($sp)
	j while

return:	move $v0, $t6		# store ret val

				# epilogue
	lw $ra, 16($sp)		# restore $ra
	lw $fp, 12($sp)		# restore $fp
	add $sp, $sp, 16	# restore $sp
	jr $ra			# jump to $ra 
