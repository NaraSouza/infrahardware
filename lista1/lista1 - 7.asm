#suponha que o numero de fibonacci desejado esteja em A

.data
A: .word 10

.text

j main
fib:

add $s6, $s5, $s4 #proximo fibonnaci (armazena a resposta final)
addi $s4, $s5, 0 #atualiza i-2
addi $s5, $s6, 0 #atualiza i-1

addi $s3, $s3, 1 #proxima iteração
jr $ra

main:
lw $s0, A #valor de A

addi $s1, $zero, 2 #Registrador que armazena o valor para a base do fibonacci (2)
addi $s3, $s1, 0 #registrador auxiliar para contar a iteração atual
addi $s4, $zero, 0 #registrador auxiar para o fibonnaci i-2
addi $s5, $zero, 1 #registrador auxiliar para o fibonnaci i-1
ble $s0, $s1, Sai #sai da chamada quando chamado fibonacci de um numero menor que 2

fibcall:
jal fib #chama a função fibonacci
bgt $s3, $s0 Sai #Para o fibonnaci quando atingir o A-esimo valor
j fibcall

Sai:
