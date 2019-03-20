.data 

A: .word 1
B: .word 6
result: .word 0

.text

lw $t0, A
lw $t1, B
lw $t2, result

bgt $t0, $t1, exception  	# Se A > B logo no come�o, v� para o caso exepcional
jal increment		 	# Sen�o, chamar a fun��o recursiva
j exit

increment:
 add $t2, $t2, $t0 	 	# t2 = t2 + t0
 addi $sp, $sp, -4		# aloca espa�o para ra
 sw $ra, 0($sp)		 	# guarda o endere�o de ra em sp
 addi $t0, $t0, 1 	 	# incrementa t2(vai para o proximo valor no conjunto)	
 jal recursive_condition   	# vai para a etapa que checa se deve-se ou n�o ir para a proxima etapa da recursao
 
recursive_condition:
 ble $t0, $t1, increment 	# volta para a etapa de incrementa��o de t2 caso a condi�ao de recursao ainda for satisfeita
 lw $ra, 0($sp)			# carrega o ultimo valor da pilha
 addi $sp, $sp, 4		# ajusta a posi��o da pilha
 jr $ra			 	# volta para o ultimo ra

exception:
 addi $t2, $t2, 1	 	# Retorna 1 

exit: