# ===================

	jal  minha_funcao	# ESSE EH O PONTO DE ENTRADA
	
	add $t0, $v0, $zero 	# ESSE EH O PONTO DE OBSERVACAO
	
# =================== BYE!

exit:      
      li   $v0, 10          # system call for exit
      syscall               # we are out of here.
      
      
# minha rotina      
      
minha_funcao:


	
	
	addi $sp, $sp, -8
	sw $ra, 4($sp) 
	sw $a0, 0($sp) 
	
	sltiu $t0, $a0 , 13 
	beq $t0  $zero , excecao
		
	slti $t0, $a0 , 1 
	beq $t0  $zero , meu_label	
	addi $v0, $zero, 1
	addi $sp, $sp, 8 
	jr $ra


meu_label:
	addi $a0, $a0, -1 
	jal minha_funcao 
	lw $a0, 0($sp) 
	lw $ra, 4($sp) 
	addi $sp, $sp, 8 
	mul $v0, $a0, $v0 
	jr $ra 
	
excecao:
	addi $v0, $zero, -1
	addi $sp, $sp, 8 
	jr $ra
	
main:
	jal  minha_funcao
	add $t0, $v0, $zero
	
	li $v0, 1
	la $a0, ($t0)
	syscall	
