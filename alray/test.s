    ##
    ## print “hello world”
    ##  programed by：stevie zou
    ##

.data   
save:   .asciiz "save\n"

    ##
    ############end of file

    #########################################

    #  text segment       #

    #########################################

.text   
main:   
    li      $v0,    4       # system call #4 - print string
    la      $a0,    save
    syscall                 # execute
    li      $t1,    0

    li      $a0,    0       # set exit code
    li      $v0,    10      # 10 is the syscall to exit
    syscall 

    #########################################

    #   data segment      #

    #########################################
