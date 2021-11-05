.text
main:
  lui   a0, %hi(.destination)
  addi  a0, a0, %lo(.destination)
  lui   a1, %hi(.source)
  addi  a1, a1, %lo(.source)
  li    t0, 0
  mv    t1, a1
  mv    t2, a0
for:
  lbu t3, 0(t1)
  sb t3, 0(t2)
  beq t3, t0, fim
  addi t1, t1, 1
  addi t2, t2, 1
  j for
fim:
  
.data
.destination:
  .word 0xFFFFFFFF
  .word 0xFFFFFFFF
  .word 0xFFFFFFFF
  .word 0xFFFFFFFF
.source:
  .word 0x3337434d
  .word 0x73692032
  .word 0x66696c20
  .word 0x00002e65