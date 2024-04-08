
.text   
        .globlmain
main:   


    #########################################

    #   data segment      #

    #########################################
    #       


    la      $t1,    arr

    addi    $t2,    $t1,        4           # $t0 = $0 + 1

loop:   
    addi    $v0,    $0,         5           # system call #5 - input int
    syscall                                 # execute
    bltz    $v0,    endloop

    sw      $v0,    0($t1)

    addi    $t1,    $t1,        4           # $t1 = $t1 + 1

    beq     $t1,    $t2,        loop        # if $t1 == $t0 then goto target


    subi    $t2,    $t1,        8           # $t1 = $t1 - 1
sort:   



    lw      $t3,    0($t2)

    bgt     $t3,    $v0,        endsort     # if t3 > $v0 then goto endsort
    la      $t3,    arr

    blt     $t2,    $t3,        endsort


    lw      $t3,    4($t2)

    sw      $t3,    0($t1)

    lw      $t3,    0($t2)                  # $t6($t2) =$t6($t1)
    sw      $t3,    4($t2)                  # arr($t1) =$t3

    lw      $t3,    0($t1)
    sw      $t3,    0($t2)
    subi    $t2,    $t2,        4           # $t2 = $t2 - 4

    j       sort

endsort:

    j       loop

endloop:
    subi    $t1,    $t1,        4           # $t1 = $t1 - 4

    la      $t3,    arr,        #
print:  

    blt     $t1,    $t3,        endprint

    addi    $v0,    $0,         1           # system call #1 - print int
    lw      $t2,    0($t3)
    add     $a0,    $0,         $t2
    syscall                                 # execute
    addi    $v0,    $0,         4           # system call #4 - print string
    la      $a0,    log
    syscall                                 # execute

    addi    $t3,    $t3,        4           # $t6 = $t6 + 4

    j       print                           # jump to print
endprint:


.data   

arr:    .space  60

log:    .asciiz " >= "
    ##
    ############end of file