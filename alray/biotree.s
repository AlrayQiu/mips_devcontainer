
.text   
        .globlmain
main:   
    la      $t0,    tree
    la      $t5,    output

input:  
    addi    $v0,    $0,         5       # system call #6 - input float
    syscall                             # execute1
    bltz    $v0,    endinput
    sw      $v0,    0($t0)
    addi    $t0,    $t0,        4       # $t0 = $t0 + 4
    j       input

endinput:

    la      $t0,    tree

    move    $t1,    $t0                 # $t1 = $t2
    jal     search
    la      $t0,    output

print:  
    lw      $t1,    0($t0)
    addi    $v0,    $0,         1       # system call #1 - print int
    add     $a0,    $0,         $t1
    syscall                             # execute

    addi    $v0,    $0,         4       # system call #4 - print string
    la      $a0,    split
    syscall                             # execute
    addi    $t0,    $t0,        4
    ble     $t0,    $t5,        print   # if $t0 != $t5 then goto print

endprint:

    # 宣告主程序结束
    li      $v0,    10
    syscall 

search: 
    sub     $t2,    $t1,        $t0     # $t1 = $t0 - $t2
    addi    $t2,    $t2,        4       # $t2 = $t2 + 1

    add     $t3,    $t2,        $t2     # $t2, *, $t1, =, Hi, and, Lo, registers
    subi    $t2,    $t3,        4       # $t3 = $t3 - 4

    add     $t2,    $t2,        $t0
    add     $t3,    $t3,        $t0


    lw      $t4,    0($t2)
    beqz    $t4,    re
    subi    $sp,    $sp,        8
    sw      $t1,    0($sp)
    sw      $ra,    4($sp)
    move    $t1,    $t2
    jal     search                      # jump to search and save position to $ra
    lw      $t1,    0($sp)
    lw      $ra,    4($sp)
    addi    $sp,    $sp,        8       # $sp = $sp + 4

re:     
    lw      $t4,    0($t1)
    sw      $t4,    0($t5)
    addi    $t5,    $t5,        4

    lw      $t4,    4($t2)
    beqz    $t4,    ret
    subi    $sp,    $sp,        8
    sw      $t1,    0($sp)
    sw      $ra,    4($sp)
    addi    $t1,    $3,         4
    jal     search                      # jump to search and save position to $ra
    lw      $t1,    0($sp)
    lw      $ra,    4($sp)
    addi    $sp,    $sp,        8       # $sp = $sp + 4

ret:    
    jr      $ra                         # jump to $ra

endsearch:

.data   

tree:   .space  256

output: .space  256

split:  .asciiz "\\/"