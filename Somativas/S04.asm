.data
	txt1: .asciiz "O modulo nao eh primo\n"
	txt2: .asciiz "Entradas invalidas\n"
	txt3: .asciiz "inverso = "
	array: .space 400
	debug: .asciiz "ainda dentro\n"
	fimLinha: .asciiz "\n"
.text
main:
	li $v0, 5 			#ler inteiro
	syscall
	add $s0, $zero, $v0 #p armazenado em s0
	li $v0, 5 			#ler inteiro
	syscall
	add $s1, $zero, $v0 #a armazenado em s1
	
	jal maior1 			#verifica se a e p sao maior que 1
	addi $a1, $zero, 2 	#a1 = 2
	jal primo 			#verifica se p eh primo
	jal mod 			#mod(a,p)
	bne $v0, 1, saida2 	#saida 2 se a e p nao sao coprimos
	jal calcInv			#faz o calculo do inverso
	add $s5, $zero, $v0 #salva em s5 o inverso modular
	la $a0, txt3		#carrega o txt 3 em a0
	li $v0, 4			#imprime a0
	syscall
	add $a0, $zero, $s5 #carrega inverso modular em a0
	li $v0, 1			#imprime a0
	syscall
	la $a0, fimLinha 	#carrega quebra de linha em a0
	li $v0, 4			#imprime quebra de linha
	syscall
	
fimPrograma:
	li $v0, 10 #fim do programa
	syscall
	
saida1:
	la $a0, txt1 	# a0 = txt1
	li $v0, 4 		# printa a0
	syscall
	j fimPrograma 	# vai pro fim do programa
saida2:
	la $a0, txt2 	# a0 = txt2
	li $v0, 4 		# printa a0
	syscall
	j fimPrograma 	# vai pro fim do programa
maior1:
	li $t0, 2 				#t0 = 2
	li $t3, 1 				#t3 = 1
	slt $t1, $s0, $t0 		#t1 = 1 se p < 2
	slt $t2, $s1, $t0 		#t2 = 1 se a < 2
	beq $t1, $t3, saida2 	#vai pra saida 2 se p < 2
	beq $t2, $t3, saida2 	#vai pra saida 2 se a < 2
	jr $ra 					#retorna
primo:
	mul $t1, $a1, $a1 		#t1 = a1*a1
	slt $t2, $s0, $t1 		#set t2 se a1*a1 >= s0
	bne $t2, $zero saiPrimo #sai se a1 >= p
	div $s0, $a1 			#divide p por a1
	mfhi $t0 				# t0 = p%a0
	beq $t0, $zero, saida1 	#vai pra saida 1 se p nao eh primo
	addi $a1, $a1, 1 		#incrementa a1
	j primo
saiPrimo:
	jr $ra # retorna
mod:
	li $s4, 0 				#s4 = tam array
	add $t0, $zero, $s0 	#t0 = p
	add $t1, $zero, $s1 	#t1 = a
loopMod:
	div $t0, $t1 				#divide t0 por t1
	mfhi $t2 					#resto da divisao movido pra  t2
	mflo $t3 					#resultado da divisao movido para t3
	beq $t2, $zero exitLoopMod 	#sai do loop se o resto for zero
	sb $t3, array($s4)		 	#armazena t3 no array
	addi $s4, $s4, 4 			#incrementa o tam do array
	add $t0, $zero, $t1 		# t0 = t1
	add $t1, $zero, $t2 		# t1 = resto da div
	j loopMod
exitLoopMod:
	add $v0, $zero, $t1 #result do mdc passado pra v0
	jr $ra
calcInv:
	add $t0, $s4, -4 	#t0 = ultimo indice do vetor
	li $t2, 0 			#t2 = 0
	li $t3, 1 			#t3 = 1
loopCalcInv:
	slt $t1, $t0, $zero 			#set t1 se indice do vetor for menor que 0
	bne $t1, $zero, exitLoopCalcInv #sai do loop se o indice for negativo
	lb $t4, array($t0) 				#ler indice t0 no vetor
	mul $t5, $t4, $t3 				# t5 = item do vetor * t3
	add $t5, $t5, $t2 				# t5 += t2
	add $t2, $zero, $t3				# t2 = t3
	add $t3, $zero, $t5 			# t3 = t5
	
	addi $t0, $t0, -4
	j loopCalcInv
exitLoopCalcInv:
	addi $t0, $zero, 2 	#t0 = 2
	srl $t1, $s4, 2 	#t1 = tam do vetor
	div $t1, $t0 		# div tam do vetor por 2
	mfhi $t1 			#resto da div para t1
	beq $t1, $zero, par #se resto for 0 pular para par
	sub $v0, $s0, $t3 	#v0 = p - t3
	jr $ra 				#retorna
par:
	add $v0, $zero, $t3 #v0 = t3
	jr $ra 				#retorna
