.data   
msg_input:          .asciiz "pls Input MIPS Mechine Code:\n"

data_R_codes:       .word   Sll_t, 0, Srl_t
                    .word   Sra_t, Sllv_t, 0
                    .word   Srlv_t, Srav_t, Jr_t
                    .word   Jalr_t, 0, 0
                    .word   Syscall_t, 0, 0
                    .word   0, Mfhi_t, Mthi_t
                    .word   Mflo_t, Mtlo_t
                    .word   0, 0, 0, 0, Mult_t
                    .word   Multu_t, Div_t
                    .word   Divu_t, 0, 0, 0, 0
                    .word   Add_t, Addu_t
                    .word   Sub_t, Sub_t, And_t, Or_t
                    .word   Xor_t, Nor_t, 0, 0, Slt_t, Sltu_t
Sll_t:              .asciiz "sll "
Srl_t:              .asciiz "srl "
Sra_t:              .asciiz "sra "
Sllv_t:             .asciiz "sllv "
Srlv_t:             .asciiz "srlv "
Srav_t:             .asciiz "srav "
Jr_t:               .asciiz "jr "
Jalr_t:             .asciiz "jalr "
Syscall_t:          .asciiz "syscall "
Mfhi_t:             .asciiz "mfhi "
Mthi_t:             .asciiz "mthi "
Mflo_t:             .asciiz "mflo "
Mtlo_t:             .asciiz "mtlo "
Mult_t:             .asciiz "mult "
Multu_t:            .asciiz "multu "
Div_t:              .asciiz "div "
Divu_t:             .asciiz "divu "
Add_t:              .asciiz "add "
Addu_t:             .asciiz "addu "
Sub_t:              .asciiz "sub "
Subu_t:             .asciiz "subu "
And_t:              .asciiz "and "
Or_t:               .asciiz "or "
Xor_t:              .asciiz "xor "
Nor_t:              .asciiz "nor "
Slt_t:              .asciiz "slt "
Sltu_t:             .asciiz "sltu "
Bgez_t:             .asciiz "bgez "
Bgezal_t:           .asciiz "bgezal "
Bltz_t:             .asciiz "bltz "
Bltzal_t:           .asciiz "bltzal "
data_bz_codes:      .word   Bltz_t, Bgez_t, Bltzal_t, Bgezal_t

J_t:                .asciiz "j "
Jal_t:              .asciiz "jal "
data_JI_codes:      .word   J_t, Jal_t

Beq_t:              .asciiz "beq "
Bne_t:              .asciiz "bne "
data_be_codes:      .word   Beq_t, Bne_t

Blez_t:             .asciiz "blez "
Bgtz_t:             .asciiz "bgtz "
data_bz2_codes:     .word   Blez_t, Bgtz_t

Addi_t:             .asciiz "addi "
Addiu_t:            .asciiz "addiu "
Slti_t:             .asciiz "slti "
Sltiu_t:            .asciiz "sltiu "
Andi_t:             .asciiz "andi "
Ori_t:              .asciiz "ori "
Xori_t:             .asciiz "xori "
Lui_t:              .asciiz "lui "
data_I_codes:       .word   Addi_t, Addiu_t, Slti_t, Sltiu_t
                    .word   Andi_t, Ori_t, Xori_t, Lui_t

Lb_t:               .asciiz "lb "
Lh_t:               .asciiz "lh "
Lwl_t:              .asciiz "lwl "
Lw_t:               .asciiz "lw "
Lbu_t:              .asciiz "lbu "
Lhu_t:              .asciiz "lhu "
Lwr_t:              .asciiz "lwr "
Sb_t:               .asciiz "sb "
Sh_t:               .asciiz "sh "
Swl_t:              .asciiz "swl "
Sw_t:               .asciiz "sw "
Swr_t:              .asciiz "swr "
data_M_codes:       .word   Lb_t, Lh_t, Lwl_t, Lw_t, Lbu_t
                    .word   Lhu_t, Lwr_t, 0, Sb_t
                    .word   Sh_t, Swl_t, Sw_t, Swr_t

error_invalid_data: .asciiz "wrong byte\n"
error_invalid_code: .asciiz " : wrong code\n"

data_input_raw:     .space  10240

.text   
main:               
    addi    $v0,            $0,                 4               # system call #4 - print string
    la      $a0,            msg_input
    syscall                                                     # execute

    la      $a0,            data_input_raw
    addi    $v0,            $0,                 8               # system call #8 - input string
    syscall                                                     # execute

    addi    $sp,            $sp,                -4
    jal     str2hexbuffer                                       # call str2hexbuffer
    addi    $sp,            $sp,                4

    # transform input string 2 hex codes
str2hexbuffer:                                                  # a0 : input_output_buffer, v0: output length
    addi    $sp,            $sp,                -16             # push stack
    sw      $t1,            0($sp)
    sw      $t2,            4($sp)
    sw      $t3,            8($sp)
    sw      $t4,            12($sp)
    move    $t1,            $a0                                 # t1 = a0
    move    $t3,            $a0                                 # t1 = a0
    li      $t4,            0
    li      $v0,            0
loop_01:            
    lb      $t2,            0($t1)                              # t2 = ++t1[0]
    addi    $t1,            $t1,                1
    beqz    $t2,            loop_01_end                         # while(t2 != 0)
    beq     $t2,            20,                 save_word       # if(t2 == space) save_word
    blt     $t2,            48,                 error_wb        # if(t2 < '0') error_wb
    bgt     $t2,            57,                 not_digital     # if(t2 > '9') not_digital
    addi    $t2,            $t2,                -48             # t2 = (t2 - '0') & 0xf
    andi    $t2,            $t2,                0xf
    j       add_buf                                             # continue
not_digital:        
    blt     $t2,            65,                 error_wb        # if(t2 < 'A') error_wb
    bgt     $t2,            70,                 not_L           # if(t2 > 'F') not_L
    addi    $t2,            $t2,                -55             # t2 = (t2 - 'A' + 10) & 0xf
    andi    $t2,            $t2,                0xf
    j       add_buf                                             # continue
not_L:              
    blt     $t2,            97,                 error_wb        # if(t2 < 'a') error_wb
    bgt     $t2,            102,                error_wb        # if(t2 > 'f') error_wb
    addi    $t2,            $t2,                -87             # t2 = (t2 - 'a' + 10) & 0xf
    andi    $t2,            $t2,                0xf
    j       add_buf                                             # continue
add_buf:            
    sll     $t4,            $t4,                4               # t4 <<= 4
    or      $t4,            $t4,                $t2             # t4 |= t2
save_word:          
    sw      $t4,            0($t3)                              # buffer[0] = t3
    li      $t4,            0                                   # t3 = 0
    addi    $t3,            $t3,                4               # buffer ++(word)
    addi    $v0,            $v0,                1               # v0 ++
    j       loop_01
loop_01_end:        
    lw      $t1,            0($sp)
    lw      $t2,            4($sp)
    lw      $t3,            8($sp)
    lw      $t4,            12($sp)
    addi    $sp,            $sp,                16              # pop stack
    jr      $ra                                                 # return
error_wb:           
    addi    $v0,            $0,                 4               # system call #4 - print string
    la      $a0,            error_invalid_data
    syscall                                                     # execute

    # decode mips mechine code
de_asm:                                                         # a0 buffer top, a1 words length
    move    $t0,            $a0                                 # $t0 = $a0
    move    $t1,            $a1                                 # $t0 = $a0
    sll     $t1,            $t1,                2               # t1 = t1 * 4
    add     $t1,            $t0,                $t1             # t4 = 0x00400000
    li      $t4,            0x00400000
loop_02:            
    lw      $t2,            0($t0)                              # t2 = ++t0[0] (word)
    addi    $t0,            $t0,                4
    andi    $t3,            $t2,                0xf8000000      # $t3 = $t2 & 0xf8000000 (put func code into $t3)
    srl     $t3,            $t3,                27
    bnez    $t3,            not_r
    #is R code

not_r:              
    bne     $t3,            1,                  not_bz
    #is bz
not_bz:             
    blt     $t3,            4,                  not_j
    #is J code
not_j:              
    blt     $t3,            6,                  not_be
    #is be code
not_be:             
    blt     $t3,            8,                  not_bz2
    #is bz2 code
not_bz2:            
    blt     $t3,            16,                 not_i
    #is I code
not_i:              
    blt     $t3,            32,                 not_m
    bgt     $t3,            46,                 not_m
    #is M code
not_m:              
output:             

end_de_asm:         


