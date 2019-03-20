.data

x: .word 2
y: .word 1
z: .word 3

.text

lw $t0, x 
lw $t1, y
lw $t2, z

addi $t2, $t0, 0 #m = a
slt $t3, $t1, $t2 #verifica se b < m
beq $t3, $zero, else #caso seja falso, vai para else
addi $t2, $t1, 0 #sendo verdadeiro, m = b
j exit 

else: addi $t2, $zero, 0 #m = 0
exit: