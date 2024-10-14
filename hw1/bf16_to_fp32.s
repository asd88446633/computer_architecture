
.text
    .globl main
    .data
input_data: 
    .half 0x3f80, 0xc120, 0x7fc0   # ���ո�� 1,-10,NaN
answer: 
    .word 0x3f800000, 0xc1200000, 0x7fc00000  # ���T����
newline: 
    .string "\n"                   # ����Ÿ�
correct: 
    .string "the conversion is right\n"  # ���T
wrong: 
    .string "the conversion is wrong\n"  # ���~

    .text
main:
    la t0, input_data           # ���J input_data ����}
    la t1, answer               # ���J answer ����}
    li t2, 3                    # �]�w�j�馸�� 
    li a0, 1             
loop:
    lh t3, 0(t0)               
    jal ra, bf16_to_fp32        

    lw t5, 0(t1)             
    beq t4, t5, correct_output  # �p�G t4 == t5, �h���� correct_output

    # �p�G�ഫ���~�A��X���~�T��
    la a0, wrong                
    li a7, 4                    
    ecall                      
    j continue_loop             # �~��U�@�Ӱj��

correct_output:
    la a0, correct              
    li a7, 4                    
    ecall                      

continue_loop:
    # ��X����Ÿ�
    la a0, newline          
    li a7, 4                 
    ecall                   

    addi t0, t0, 2              # ����U�@�� 16-bit
    addi t1, t1, 4              # ����U�@�� 32-bit
    addi t2, t2, -1             # �j��� 1
    bnez t2, loop               # �Y t2 != 0 �~��

    # �����{��
    li a7, 10          
    ecall

bf16_to_fp32:
    slli t4, t3, 16             # �N bf16 ���Ʋ��ʨ� fp32 �����T��m (16�쥪��)
    ret                         # ��^���G (t4)