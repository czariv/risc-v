.section .text
.globl _start

_start:
    li a0, 4500 #quatro segundos
    li a1, 1 #para frente
    li a2, 0 #reto
    li a7, 2100 # chamada do carro
    ecall
    li a0, 2000 #dois segundos
    li a1, -1 #para tras
    li a2, 0 #reto
    ecall
    li a0, 1075 #1,075 segundo
    li a1, 1 #para frente
    li a2, -1000 #esquerda
    ecall
    li a0, 5000 #cinco segundos
    li a1, 1 #para frente
    li a2, 0 #reto
    ecall
    j fim

fim:
    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall

    
