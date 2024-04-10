
.text   
        .globlmain
main:   
    la      $t0,    tree
    la      $t5,    output

input:  
    addi    $v0,    $0,         5           # system call #6 - input float
    syscall                                 # execute1
    bltz    $v0,    endinput
    sw      $v0,    0($t0)
    addi    $t0,    $t0,        4           # $t0 = $t0 + 4
    j       input

endinput:
    la      $t2,    tree
    li      $t1,    1
    lw      $t4,    0($t2)
    beq     $t2,    $t0,        endprintree
    addi    $v0,    $0,         1           # system call #1 - print int
    add     $a0,    $0,         $t4
    syscall                                 # execute
printtree:
    li      $t3,    0
    addi    $v0,    $0,         4           # system call #4 - print string
    la      $a0,    endl
    syscall                                 # execute
    add     $t1,    $t1,        $t1
ptloop: 
    addi    $t2,    $t2,        4
    beq     $t2,    $t0,        endprintree
    lw      $t4,    0($t2)
    addi    $v0,    $0,         1           # system call #1 - print int
    add     $a0,    $0,         $t4
    syscall                                 # execute
    addi    $t3,    $t3,        1
    beq     $t3,    $t1,        printtree
    j       ptloop

endprintree:
    addi    $v0,    $0,         4           # system call #4 - print string
    la      $a0,    endl
    syscall                                 # execute


    la      $t0,    tree

    move    $t1,    $t0                     # $t1 = $t2
    jal     search
    la      $t0,    output

print:  
    lw      $t1,    0($t0)
    addi    $v0,    $0,         1           # system call #1 - print int
    add     $a0,    $0,         $t1
    syscall                                 # execute

    addi    $v0,    $0,         4           # system call #4 - print string
    la      $a0,    split
    syscall                                 # execute
    addi    $t0,    $t0,        4
    blt     $t0,    $t5,        print       # if $t0 != $t5 then goto print

endprint:

    # 宣告主程序结束
    li      $v0,    10
    syscall 

search: 
    sub     $t2,    $t1,        $t0         # $t1 = $t0 - $t2
    addi    $t2,    $t2,        4           # $t2 = $t2 + 1

    add     $t2,    $t2,        $t2         # $t2, *, $t1, =, Hi, and, Lo, registers
    addi    $t2,    $t2,        -4          # $t3 = $t3 - 4

    add     $t2,    $t2,        $t0


    lw      $t4,    0($t2)
    beqz    $t4,    re
    addi    $sp,    $sp,        -12
    sw      $t1,    0($sp)
    sw      $ra,    4($sp)
    sw      $t2,    8($sp)
    move    $t1,    $t2
    jal     search                          # jump to search and save position to $ra
    lw      $t1,    0($sp)
    lw      $ra,    4($sp)
    lw      $t2,    8($sp)
    addi    $sp,    $sp,        12          # $sp = $sp + 4

re:     
    lw      $t4,    0($t1)
    sw      $t4,    0($t5)
    addi    $t5,    $t5,        4

    lw      $t4,    4($t2)
    beqz    $t4,    ret
    addi    $sp,    $sp,        -8
    sw      $t1,    0($sp)
    sw      $ra,    4($sp)
    addi    $t1,    $t2,        4
    jal     search                          # jump to search and save position to $ra
    lw      $t1,    0($sp)
    lw      $ra,    4($sp)
    addi    $sp,    $sp,        8           # $sp = $sp + 4

ret:    
    jr      $ra                             # jump to $ra

endsearch:

.data   

tree:   .space  256

output: .space  256

split:  .asciiz "\\/"
leave:  .asciiz "|\\"
endl:   .asciiz "\n"