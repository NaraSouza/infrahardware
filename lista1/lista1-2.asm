.data

x: .word -1
y: .word -2
z: .word 0

.text

lw $t0, x
lw $t1, y
lw $t2, z

slt $t3, $zero, $t0 #verifica se 0 > a (a>=0)
beq $t3, $zero, elseif #se for falso, vai para elseif
slt $t3, $t0, $t1 #sendo verdadeiro, verifica se a < b
beq $t3, $zero, else #se for falso, vai para else
addi $t0, $zero, 1 #sendo verdadeiro, x = 1
j exit

elseif: 
sgt $t3, $t0, $t1 #verifica se a > b
beq $t3, $zero, else #se for falso, vai para else
addi $t0, $zero, 2 #sendo verdadeiro, x = 2
j exit

else:
addi $t0, $zero, 3 #x = 3
exit: