.text   

    la      $s1,    msg                             #char* msg = "Max="
    la      $s0,    a
    li      $t0,    8                               #int n = 8
    li      $t1,    0                               #int    max

    li      $t2,    0                               #for(int i = 0
loop1:  
    beq     $t2,    $t0,    endloop1                #,i < n,
    sll     $t3,    $t2,    2                       # $3 = $2 << 2
    add     $t3,    $t3,    $s0
    lw      $t3,    0($t3)                          # execute
    addi    $v0,    $0,     1                       # system call #1 - print int
    add     $a0,    $0,     $t3
    syscall                                         # execute
    addi    $v0,    $0,     4                       # system call #4 - print string
    la      $a0,    endl
    syscall 

    addi    $t2,    $t2,    1                       #i++)
    j       loop1
endloop1:

    lw      $t1,    0($s0)
    li      $t2,    0
loop2:  
    beq     $t2,    $t0,    endloop2

    sll     $t3,    $t2,    2                       # $3 = $2 << 2
    add     $t3,    $t3,    $s0
    lw      $t3,    0($t3)
    blt     $t3,    $t1,    tail
    move    $t1,    $t3
tail:   
    add     $t2,    $t2,    1
    j       loop2
endloop2:

    addi    $v0,    $0,     4                       # system call #4 - print string
    move    $a0,    $s1
    syscall                                         # execute
    addi    $v0,    $0,     1                       # system call #1 - print int
    add     $a0,    $0,     $t1
    syscall                                         # execute
    addi    $v0,    $0,     4                       # system call #4 - print string
    la      $a0,    endl
    syscall                                         # execute

.data   
a:      .word   1, 10, 23, 33, 5, 20, 77, 13, 28
msg:    .asciiz "max="
endl:   .asciiz "\n"