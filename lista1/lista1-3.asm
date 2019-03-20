.data

x: .word -9
y: .word -9
result: .word 0

.text

lw $t0, x
lw $t1, y
lw $t2, result

#verificando casos triviais
beqz $t0, resultzero #result == 0
beqz $t1, resultzero #result == 0
beq $t0, 1, trivial0 #result == y
beq $t1, 1, trivial1 #result == x

#verificando operandos negativos
slt $t3, $t0, $zero
beq $t3, 1, secondverif0 #se x eh negativo, verifica se y tambem eh
slt $t3, $t1, $zero
beq $t3, 1, secondverif1 #se y eh negativo, verifica se x tambem eh

#realizando multiplicacao com operandos positivos ou ambos negativos
multi: beqz $t0, exit
add $t2, $t1, $t2
addi $t0, $t0, -1
j multi

#verifica se y tambem eh negativo
secondverif0: slt $t3, $t1, $zero
beq $t3, 1, premulti
sub $t0, $zero, $t0 #se nao for, torna x positivo (sinal sera colocado novamente ao final)
beq $t0, 1, trivial2
j negativeresult

#verifica se x tambem eh negativo
secondverif1: slt $t3, $t0, $zero
beq $t3, 1, premulti
sub $t1, $zero, $t1 #se nao for, torna y positivo (sinal sera colocado novamente ao final)
beq $t1, 1, trivial3
j negativeresult

#torna x e y positivos
premulti: sub $t0, $zero, $t0
sub $t1, $zero, $t1
beq $t0, 1, trivial0 #result == y
beq $t1, 1, trivial1 #result == x
j multi

#realizando multiplicacao que tera resultado negativo
negativeresult: beqz $t0, convertresult
add $t2, $t1, $t2
addi $t0, $t0, -1
j negativeresult

#tornando resultado negativo
convertresult: sub $t2, $zero, $t2
j exit

#resultado igual a 0
resultzero: j exit

#resultado igual a y
trivial0: addi $t2, $t1, 0
j exit

#resultado igual a x
trivial1: addi $t2, $t0, 0
j exit

#resultado igual a -y
trivial2: addi $t2, $t1, 0
j convertresult

#resultado igual a -x
trivial3: addi $t2, $t0, 0
j convertresult

exit: