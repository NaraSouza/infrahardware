.data 

A: .word 1
B: .word 6
result: .word 0

.text

lw $t0, A
lw $t1, B
lw $t2, result

bgt $t0, $t1, exception  	# Se A > B logo no começo, vá para o caso exepcional
jal increment		 	# Senão, chamar a função recursiva
j exit

increment:
 add $t2, $t2, $t0 	 	# t2 = t2 + t0
 addi $sp, $sp, -4		# aloca espaço para ra
 sw $ra, 0($sp)		 	# guarda o endereço de ra em sp
 addi $t0, $t0, 1 	 	# incrementa t2(vai para o proximo valor no conjunto)	
 jal recursive_condition   	# vai para a etapa que checa se deve-se ou não ir para a proxima etapa da recursao
 
recursive_condition:
 ble $t0, $t1, increment 	# volta para a etapa de incrementação de t2 caso a condiçao de recursao ainda for satisfeita
 lw $ra, 0($sp)			# carrega o ultimo valor da pilha
 addi $sp, $sp, 4		# ajusta a posição da pilha
 jr $ra			 	# volta para o ultimo ra

exception:
 addi $t2, $t2, 1	 	# Retorna 1 

exit: