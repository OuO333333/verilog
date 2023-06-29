        .data
N:      .word 0
S:      .word 0
I:      .word 0
        .text
main:
li $v0,5
syscall
la $t0,N
sw $v0,0($t0)
la $t0,N
lw $t0,0($t0)
li $t1,0
blt $t0,$t1,L1
b L2
L1:
li $t0,1
neg $t0,$t0
move $a0,$t0
li $v0,1
syscall
b L3
L2:
li $t0,0
la $t1,S
sw $t0,0($t1)
L3:
li $t0,1
la $t1,I
sw $t0,0($t1)
L4:
la $t0,I
lw $t0,0($t0)
la $t1,N
lw $t1,0($t1)
ble $t0,$t1,L5
b L6
L5:
la $t0,S
lw $t0,0($t0)
la $t1,I
lw $t1,0($t1)
add $t0,$t0,$t1
la $t1,S
sw $t0,0($t1)
la $t0,I
lw $t0,0($t0)
li $t1,1
add $t0,$t0,$t1
la $t1,I
sw $t0,0($t1)
b L4
L6:
la $t0,S
lw $t0,0($t0)
move $a0,$t0
li $v0,1
syscall
