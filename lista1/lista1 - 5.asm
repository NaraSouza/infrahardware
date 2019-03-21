#Suponha que a base dos arrays A e B estão em $a0 e $a1

.data
A: .word 1,2,3,4,5,6,7,8,9,10
B: .word 0,0,0,0,0,0,0,0,0,0
n: .word 10

.text

la $a0, A #endereço base de A
la $a1, B #endereço base de B
lw $s0, n #tamanho dos arrays

addi $t1, $zero, 0 #int i = 0
addi $t3, $zero, 0 #registrador auxiliar para calcular posição em B
addi $t4, $zero, 1 #registrador auxiliar que armazena 1

For: beq $t1, $s0, Sai #encerra quando chega no fim de A

sll $t2,$t1,2 #como endereçamento é em bytes e eu necessito de uma word, dou shift left 2
add $t2,$t2,$a0 #posição do array equivalente a o que está em $t1
lw $s1,0($t2) #load em $s1 o que está em A[i]
addi $t1, $t1, 1 #incrementa em 1 a iteração

beq $s1, $t4, For #se s1 = 1 vai para a proxima iteração

addi $t5, $zero, 2 #armazena 2 em t5 (para calcular primalidade)
For2:  #teste de primalidade
beq $s1, $t5, putB #se s1 = t5 (ou seja se s1 for primo)
rem $t6, $s1, $t5 #armazena s1%t5 em t6
beqz $t6, For #se t6 = 0 encerra o loop (s1 não e primo)
addi $t5, $t5, 1 #proxima iteração de t5
j For2  #proxima iteração do teste de primalidade

putB: #insere s1 em B
sll $t7, $t3, 2 #calcula a proxima posição vazia de B
add $t7, $t7, $a1
sw $s1, 0($t7) #armazena s1 na proxima posição vazia de B
addi $t3, $t3, 1 #incrementa i em 1 para poder calcular a proxima posição vazia de B
j For #proxima iteração do loop principal

Sai:
