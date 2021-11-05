.section .data
x: .skip 1
y: .skip 1
l: .skip 1
c: .skip 1
cmax: .skip 1
print: .skip 4
linha: .skip 64
string: .ascii "POS: "
espaco: .byte 32
fimprint: .asciz "\n"
 
.section .text
.globl _start

DeclararVariavel:
    li t0, 1
    li t1, 1
    li t2, 0
    li s9, 32
    li s8, 10
    while:
    addi sp, sp, -4 # sp = sp - 4
    li a0, 0 #stdin
    lw a1, 0(sp)# topo da pilha
    li a2, 1 # 1 byte
    li a7, 63 # syscall read
    ecall
    lbu a1, 0(a1)
    sb a1, 0(sp)
    beq a1, s9, quit # if a1 == espaco then quit
    beq a1, s8, quit # if a1 == \n then quit
    addi t2, t2, 1 # t2 = t2 + 1
    beq t0, t1, while # loop infinito
    quit:
    addi sp, sp, 4
    li t1, 1
    blt t2, t1, quebra
    li t0, 10
    li a0, 0
    li a3, 0
    lup:
    lw a1, 0(sp)
    addi sp, sp, 4
    addi a1, a1, -48
    mul a1, a1, t1
    add a0, a0, a1
    mul t1, t1, t0
    addi a3, a3, 1
    blt a3, t2, lup # if a3 < t2 then target
    quebra:
    ret

ColetarLinha:
    li s10, 0
    la s11, c
    addi sp, sp, -4
    sw ra, 0(sp)
    wle:
    lb t2, 0(s11)    #t2 vai ter o tamanho de uma linha
    testi:
    bge s10, t2, saida #se s10 for maior ou igual que t2 para o loop
    jal DeclararVariavel
    la t1, linha
    add t1, t1, s10
    sb a0, 0(t1)
    teste:
    addi s10, s10, 1  #soma 1 em s10
    j wle   #faz o loop
    saida:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

Distancia:
    add a5, s5, a1
    li t0, 100
    li a4, 0
    f:
    lb t1, 0(a5)
    bgeu t1, t0, sai # if t1 >= 100 then sai
    addi a4, a4, 1
    add a5, a5, a1
    j:
    j f
    sai:
    ret

PrintarVar:
    lb t0, 0(a5)
    la s8, print
    li t1, 10
    rem t2, t0, t1
    addi t2, t2, 48
    sb t2, 0(s8)
    addi s8, s8, 1
    div t0, t0, t1
    rem t2, t0, t1
    addi t2, t2, 48
    sb t2, 0(s8)
    addi s8, s8, 1
    div t0, t0, t1
    rem t2, t0, t1
    addi t2, t2, 48
    sb t2, 0(s8)
    addi s8, s8, 1
    div t0, t0, t1
    rem t2, t0, t1
    addi t2, t2, 48
    sb t2, 0(s8)
    li s10, 0
    li s11, 4
    for:
    li a0, 1 # file descriptor = 1 (stdout)
    mv a1, s8 #  buffer
    li a2, 1 # size
    li a7, 64 # syscall write (64)
    ecall
    lw a1, 0(a1)
    addi s10, s10, 1
    addi s8, s8, -1
    par:
    blt s10, s11, for # if s10 < s11 then for
    ret
    
Printar:
    li a0, 1 # file descriptor = 1 (stdout)
    la a1, string #  buffer
    li a2, 5 # size
    li a7, 64 # syscall write (64)
    ecall
    la a5, x
    addi sp, sp, -4
    sw ra, 0(sp)
    jal PrintarVar
    li a0, 1 # file descriptor = 1 (stdout)
    la a1, espaco #  buffer
    li a2, 1 # size
    li a7, 64 # syscall write (64)
    ecall
    la a5, y
    jal PrintarVar
    li a0, 1 # file descriptor = 1 (stdout)
    la a1, fimprint #  buffer
    li a2, 1 # size
    li a7, 64 # syscall write (64)
    ecall
    j loop

_start:
    jal DeclararVariavel
    la t1, x
    sb a0, 0(t1)
    parante:
    jal DeclararVariavel
    la t1, y
    sb a0, 0(t1)
    testinho:
    jal DeclararVariavel
    jal DeclararVariavel
    la t1, c
    pare:
    sb a0, 0(t1)
    jal DeclararVariavel
    wut:
    la t1, l
    sb a0, 0(t1)
    jal DeclararVariavel
    la t1, cmax
    sb a0, 0(t1)
    la t1,c
    lb a0, 0(t1)
    final:
    jal ColetarLinha
    li s4, 1
    loop:
    la t2, l    #t2 vai ser o numero de linhas
    lb t2, 0(t2)
    bge s4, t2, fim #se s4 for maior ou igual que t2 para o loop
    addi s4, s4, 1
    jal ColetarLinha
    la s6, y
    lb s5, 0(s6)
    addi s5, s5, 1
    sb s5, 0(s6)
    la s5, linha
    la s6, x
    lb s6, 0(s6)
    add s5, s5, s6
    addi s5, s5, -1
    li s3, 1
    li s2, -1
    mv a1, s3
    jal Distancia
    mv a3, a4
    mv a1, s2
    jal Distancia
    mv a2, a4
    beq a2, a3, igual # if a2 == a3 then igual
    blt a2, a3, positivo # if a2 < a3 then positivo
    negativo:
    la s6, x
    lb s7, 0(s6)
    add s7, s7, s2
    sb s7, 0(s6)
    j Printar
    positivo:
    la s6, x
    lb s7, 0(s6)
    add s7, s7, s3
    sb s7, 0(s6)
    j Printar
    igual:
    j Printar
    
fim:
    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall
