.data   
primes:     .space  14001
max_prime:  .half   0
msg1:       .asciiz "prime created. the last 10 primes is:"
msg2:       .asciiz "watch dog : create_prime():"
msg3:       .asciiz "size of primes is:"
msgofr:     .asciiz "out of range\n"
endl:       .asciiz "\n"
split:      .asciiz ", "
error1:     .asciiz "error input char,retry\n"
error2:     .asciiz "out of range,retry\n"

buffer:     .space  20

.text   
    #entry point
main:                                                               # entry point
    jal     create_primes                                           #call CreatePrime
    move    $t0,                $v0                                 #save return val to t0
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                msg3
    syscall                                                         # execute
    addi    $v0,                $0,                 1               # system call #1 - print int
    add     $a0,                $0,                 $t0
    syscall                                                         # execute
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                endl
    syscall                                                         # execute
    sll     $t1,                $t0,                1               # $t1 = $t0 << 1
    la      $t2,                primes
    add     $t1,                $t2,                $t1             # t1 = end of primes
    li      $t2,                9                                   # t2 = 9(while t2 > 0)'
    la      $v0,                max_prime
    sh      $v0,                2($t1)                              #max_prime = *t1
    move    $s0,                $t1
    addi    $t1,                $t1,                -20             # t1 = t1 - 10
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                msg1
    syscall                                                         # execute
print_last_ten:                                                     # print last ten primes in primes list
    lhu     $t3,                0($t1)                              #t3 = *t1
    addi    $t1,                $t1,                +2              #t1 = t1 + 1
    addi    $v0,                $0,                 1               # system call #1 - print int
    add     $a0,                $0,                 $t3

    syscall                                                         # execute
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                split
    syscall                                                         # execute
    addi    $t2,                $t2,                -1              # $t2 = $t2 - 1
    bgez    $t2,                print_last_ten                      #while(t2 > 0)

    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                endl
    syscall                                                         # execute
call_for_input:                                                     # loop and get n while n >= 1
    addi    $t1,                $t1,                -2              #t1 = t1 - 1
    jal     scanf_uint32
    andi    $v1,                $v0,                0xfffffffe      # $v0 = $v0 | 0x1
    beqz    $v1,                exit                                # n <= 1
    move    $a0,                $v0                                 # pass the param n
    move    $a2,                $s0                                 # $a2 = $s0
    jal     next_prime                                              # call next_prime(a0,a1,a2)
    move    $a0,                $v0                                 # $a0 = $v0
    move    $a1,                $v1
    jal     print_uint32                                            # call print_uint32(a0:n,a1:flag)
    j       call_for_input
exit:                                                               # quit
    li      $a0,                0                                   # set exit code
    li      $v0,                10                                  # 10 is the syscall to exit
    syscall 

    # func Check_Prime(v0:R,a0:N,a1:T)
    # N: num to check
    # T: Top of primes set
    # R: result 0 is a prime,1 not a prim
    #       
    # check if N is a prime
check_prime:                                                        #v0:C CheckPrime(a0:N,a1:S) N is num to check,T is top point of primes
    addi    $sp,                $sp,                -12             # alloc 2 world in stack
    sw      $t0,                0($sp)                              #save t0
    sw      $t1,                4($sp)                              #save t1
    sw      $t2,                8($sp)                              #save t1
    move    $t0,                $a0
    li      $t1,                2
    bltu    $t1,                $t0,                not_l           #if n < 2
    li      $v0,                0
    j       endcheck_prime
not_l:                                                              #if n == 2
    bne     $t0,                $t1,                not_two
    li      $v0,                1
    j       endcheck_prime
not_two:                                                            #if n != 2 && n is odd
    andi    $t1,                $t0,                1               # $t0 = $t0 & 1
    bnez    $t1,                not_
    li      $v0,                0
    j       endcheck_prime
not_:       
    la      $t1,                primes
    li      $v0,                1
chploop:    
    lhu     $t3,                0($t1)
    multu   $t3,                $t3
    mflo    $t2
    bltu    $t0,                $t2,                endcheck_prime
    divu    $t0,                $t3
    mfhi    $t3                                                     # $t3 = $t0 % $t3
    beqz    $t3,                endchploop                          #if(t3) then is not prime
    addiu   $t1,                $t1,                2               #else continue
    bleu    $a1,                $t1,                endcheck_prime
    j       chploop
endchploop: 
    li      $v0,                0
endcheck_prime:
    lw      $t0,                0($sp)                              # load t0
    lw      $t1,                4($sp)                              # load t1
    lw      $t2,                8($sp)                              # load t1
    addi    $sp,                $sp,                12              # free 2 world in stack
    jr      $ra
    #end fun CheckPrime v0 == 0 is not prime=====================

    # func CreatePrime(v0:PN)
    # PN: size of primes set
    # init the primes set ,primes < 0x10000
create_primes:                                                      #v0:PN CreatePrimes() PN is size of primes
    addi    $sp,                $sp,                -4              # $sp = $sp - 4
    sw      $ra,                0($sp)                              # push ra to stack
    li      $t2,                0x10000                             # t2 = 2^16
    li      $t0,                3                                   # primes[0] = 3
    la      $t1,                primes                              # t1 = prime
    sh      $t0,                0($t1)
    addi    $t1,                $t1,                2               # t1 = &prime[1]
    li      $t0,                5                                   # t0 = t0 + 2
cploop:     
    move    $a0,                $t0                                 # pass the param N
    move    $a1,                $t1                                 # pass the param T
    jal     check_prime                                             # jump to check_prime and save position to $ra
    beqz    $v0,                cpnotprime                          # if(!check_prime)
    sh      $t0,                0($t1)                              # then add to list
    addi    $t1,                $t1,                2
cpnotprime:                                                         # else continue
    #===watch dog
    andi    $t3,                $t0,                0xffe           # $t3 = $t0 &  0x3fe
    bnez    $t3,                notwatchdog                         # only n % 0x3ff == 0 we print it
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                msg2
    syscall                                                         # execute
    addi    $v0,                $0,                 1               # system call #1 - print int
    add     $a0,                $0,                 $t0
    syscall                                                         # execute
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                endl
    syscall                                                         # execute
notwatchdog:
    #===
    addiu   $t0,                $t0,                2
    blt     $t2,                $t0,                endcploop
    j       cploop
endcploop:  
    lw      $ra,                0($sp)                              # pop and free
    addi    $sp,                $sp,                4
    la      $v0,                primes
    sub     $v0,                $t1,                $v0             # $v0 = $t1 - $v0
    srl     $v0,                $v0,                1
    jr      $ra
    # end create_prime ================================================

    # func NextPrime(v0:PN,a0:N,a2:T
    # N: num input
    # T: top of primes list
    # PN: next prime
    #       
    # search for next prime
next_prime:                                                         #v0:PN next_prime(a0:N,a2:S) n is the input val
    addi    $sp,                $sp,                -4              # $sp = $sp - 4
    sw      $ra,                0($sp)                              # push ra to stack
    lb      $t1,                0($a2)
    bltu    $a0,                $t1,                search_in       # if $a0 < $t1 then goto search_in
    move    $a1,                $a2                                 # $a1 = $a2
    jal     increase_search                                         # call increase_search(a0:n,a1:size)
    j       endnext_prime
search_in:  
    la      $a1,                primes
    jal     bio_search                                              # execute
    li      $v1,                0                                   # $v1 = 0
endnext_prime:
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra
    # end search ====================================================

    # func BioSearch(a0:N,a1:l,a2:r,v0:PN)
    # N: num input
    # l: left point
    # r: right point
    # PN: next prime
    #       
    # search next primes when n < primes_set[T],use bio_search
bio_search:                                                         # v0:PN bio_search(a0:N,a1:l,a2:r) l is pointer of left,r is pointer of right
    li      $t1,                2
bioloop:    
    bgt     $a1,                $a2,                endbio_search   # if $a1 > $a2   then goto target
    add     $t0,                $a1,                $a2
    srl     $t0,                $t0,                1
    andi    $t0,                $t0,                0xfffffffe
    lhu     $t2,                0($t0)
    bltu    $t2,                $a0,                bioless         # if $t2 < $a0 then goto bioless
    addi    $a2,                $t0,                -2
    j       bioloop
bioless:    
    addi    $a1,                $t0,                2               # $a1 = $t0 + 1
    j       bioloop
endbio_search:
    lhu     $v0,                0($a1)                              #  $v0 = *a1
    jr      $ra
    #end bio_search ========================================

    # func IncreaseSearch(a0:N,a1:T,v0:PN)
    # N: num input
    # T: top of primes size
    # PN: next prime
    #       
    # search next primes when n > primes_set[T]
increase_search:                                                    # v0:N v1:C increase_search(a0:N,a1:size)
    move    $v0,                $a1                                 #$v0 = $a1
    addi    $sp,                $sp,                -4              # $sp = $sp - 4
    sw      $ra,                0($sp)                              # push ra to stack
    li      $v1,                0                                   # $v1 = 1
    addiu   $t0,                $a0,                -1              # t0 = a0 -1
isloop:     
    addiu   $t0,                $t0,                1
    bltu    $t0,                $a0,                outofrange      # if $t0 < $a0 then goto
    move    $a0,                $t0                                 # pass the param N
    jal     check_prime                                             # call check_prime
    bnez    $v0,                endincrease_search
    j       isloop
outofrange: 
    li      $v1,                1
endincrease_search:
    move    $v0,                $t0
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4               # pop and free
    jr      $ra
    # end increase_search ===========================================

    # func printuint32
    # output uint32
print_uint32:                                                       # print uint32
    bnez    $a1,                printofr
    move    $t0,                $a0                                 # $t0 = $a0
    addi    $sp,                $sp,                -20             # $sp = $sp + -20
    move    $t1,                $sp
    li      $t2,                10
pu32_loop:                                                          # while(t0 > 0)
    divu    $t0,                $t2
    mflo    $t0                                                     # $t0 = floor(t0 / $t2)
    mfhi    $t3                                                     # $t3 = t0 % $t2
    sb      $t3,                0($t1)                              # push in stack
    addi    $t1,                $t1,                1               # $t1 = $t1 + 1
    bnez    $t0,                pu32_loop
printloop:  
    addi    $t1,                $t1,                -1              # $t1 = $t1 - 1
    lbu     $t2,                0($t1)
    addi    $v0,                $0,                 1               # system call #1 - print int
    add     $a0,                $0,                 $t2
    syscall                                                         # execute
    beq     $t1,                $sp,                endprint_uint32 #if print all,jump to endprint_uint32
    j       printloop                                               # jump to printloop
printofr:   
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                msgofr
    syscall                                                         # execute
endprint_uint32:
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                endl
    syscall                                                         # execute
    addi    $sp,                $sp,                20              # $sp = $sp + 20
    jr      $ra
    # end printuint32 ==================================================

    # func ScanfUint32
    # input uint32
scanf_uint32:
    li      $t2,                0x0A
    li      $t3,                9
    la      $a0,                buffer
    li      $a1,                20
    addi    $v0,                $0,                 8               # system call #8 - input string
    syscall                                                         # execute
    move    $t0,                $a0                                 # $t0 = $v0
    li      $v0,                0
    li      $v1,                0
    li      $s1,                10
input_loop: 
    lbu     $t1,                0($t0)
    beq     $t1,                $t2,                endscanf
    addi    $t0,                $t0,                1
    addi    $t1,                $t1,                -0x30
    bltz    $t1,                error                               # if t1 < 0 goto error
    bgt     $t1,                $t3,                error           # if t1 > 10 then goto error
    multu   $v0,                $s1                                 # $v0 * $s1 = Hi and Lo registers
    mflo    $v0                                                     # copy Lo to $t2

    addu    $v0,                $t1,                $v0             # v0 = v0 + t1
    bgtu    $v1,                $v0,                errorofg        # if $v1 < $v0 then goto errorofg
    move    $v1,                $v0                                 # $v1 = $v0
    j       input_loop
error:      
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                error1
    syscall                                                         # execute
    j       scanf_uint32
errorofg:   
    addi    $v0,                $0,                 4               # system call #4 - print string
    la      $a0,                error2
    syscall                                                         # execute
    j       scanf_uint32
endscanf:   
    jr      $ra
