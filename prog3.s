	# Tsipora Stone, UID 114110213, tstone97, 0305
	# returns the smallest prime between two integers returns -1 if no
	# primes preforms recursively
	.data
	x:.word 0
	y:.word 0
	i:.word 0
	result:.word 0

	.text
main:	li $sp, 0x7ffffffc	# init $sp
	li $v0, 5		# scan x
	syscall
	sw $v0, x

	li $v0, 5		# scan y
	syscall
	sw $v0, y

	li $t0, -1		# result = -1
	sw $t0, result
	
	lw $t0, x		# $t0 gets x
	lw $t1, y		# $t1 gets y
	bge $t0, 2, endif	# if x >= 2
	li $t0, 2		# x = 2
	sw $t0, x

endif:	sw $t0, i		# i = x

	blez $t1, print		# if y <= 0
	lw $t2, result		# $t2 gets result
	lw $t3, i		# $t3 gets i

while:	bgt $t3, $t1, print	# if i > y
	bne $t2, -1, print	# if result != -1
	sw $t3, ($sp)		# push i onto stack
	sub $sp, $sp, 4
	jal is_p		# call is_p
	add $sp, $sp, 4		# pop i from stack
	move $t4, $v0		# store ret value

	beqz $t4, else		# if ret val == 0
	move $t2, $t3		# result = i
	sw $t2, result		# result = i
	j while

else:	lw $t3, i
	add $t3, $t3, 1		# i++
	sw $t3, i
	j while

print:	li $v0, 1		# print result
	lw $a0, result
	syscall

	li $v0, 11		# print '\n'
	li $a0, 10
	syscall

	li $v0, 10		# return 0
	syscall

				# prologue
is_p:	sub $sp, $sp, 8		# set $sp
	sw $ra, 8($sp)		# save $ra
	sw $fp, 4($sp)		# save $fp'
	add $fp, $sp, 8		# set new $fp

	li $t5, 2		# push k onto stack
	sw $t5, ($sp)
	sub $sp, $sp, 4
	
	lw $t6, 4($fp)		# push n onto stack
	sw $t6, ($sp)
	sub $sp, $sp, 4

	jal is_p_h		# call is_p_helper

	add $sp, $sp, 8		# pop args from stack

				# epilogue
	lw $ra, 8($sp)		# restore $ra
	lw $fp, 4($sp)		# restore $fp
	add $sp, $sp, 8		# restore $sp
	jr $ra			# jump to $ra

				# prologue
is_p_h:	sub $sp, $sp, 12	# set $sp
	sw $ra, 12($sp)		# save $ra
	sw $fp, 8($sp)		# save $fp'
	add $fp, $sp, 12	# set new $fp

	lw $t5, 4($fp)		# $t5 gets n
	lw $t6, 8($fp)		# $t6 gets k
	li $t7, 1		# int prime = 1
	sw $t7, 4($sp)

	div $t8, $t5, 2		# n / 2
	add $t8, $t8, 1		# n + 1
	bge $t6, $t8, return	# if k >= n / 2 + 1
	beqz $t7, return	# if prime == 0
	rem $t9, $t5, $t6	# n % k
	bnez $t9, else2		# if n % k != 0
	li $t7, 0		# prime = 0
	sw $t7, 4($sp)
	j return
	
else2:	add $t0, $t6, 1		# k + 1
	sw $t0, ($sp)		# push k onto stack
	sub $sp, $sp, 4
	sw $t5, ($sp)		# push n onto stack
	sub $sp, $sp, 4
	jal is_p_h		# recursively call is_p_h
	add $sp, $sp, 8		# pop args from stack

return:	move $v0, $t7		# store ret value

				# epilogue
	lw $ra, 12($sp)		# restore $ra
	lw $fp, 8($sp)		# restore $fp
	add $sp, $sp, 12	# restore $sp
	jr $ra			# jump to $ra
	

	
	
