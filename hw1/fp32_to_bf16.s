.text
    .globl main
    .data
input_data: 
    .word 0x411FFFFF, 0xBF800000, 0x7FC00000  # ���ո�� 9.999999,-1,NaN
answer: 
    .word 0x4120, 0xBF80, 0x7FC0              # ���T����
newline: 
    .string "\n"                              # ����Ÿ�
correct: 
    .string "the conversion is right\n"       # ���T��X
wrong: 
    .string "the conversion is wrong\n"       # ���~��X

    .text
main:
    la t0, input_data           # ���J input_data ����}
    la t1, answer               # ���J answer ����}
    li t2, 3                    # �]�w�j�馸�� (3��fp32���)
    li a0, 1                 

loop:
    lw t3, 0(t0)             
    jal ra, fp32_to_bf16        # �I�s fp32_to_bf16 ����ഫ t3 �� bf16, ���G�s�J a1
back:
    lw t4, 0(t1)                # �q t1 �a�}Ū�����T�� 16-bit (bf16) ����
    beq a1, t4, correct_output  # �p�G a1 == t4, �h���� correct_output
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

    addi t0, t0, 4              # ����U�@�� 32-bit
    addi t1, t1, 4           
    addi t2, t2, -1             # �j��� 1
    bnez t2, loop               # �Y t2 != 0 �~��

    # �����{��
    li a7, 10                
    ecall
    
fp32_to_bf16:    
    li s3, 0          
    li s0, 0x7fffffff  
    and s1, t3, s0         
    
    li s2, 0x7f800000       
    slt s3, s1, s2         #�ˬd�O�_��NaN
    beq s3, x0, NaN  
    jal ra, NotNaN  
NotNaN:
    srli s2, t3, 16  
    andi s2, s2, 1           # ���o�̧C���Ħ줸 
    li s3, 0x00007fff        # �B�z�|�ˤ��J
    add s2, s2, s3       
    add t3, t3, s2       
    srli a1, t3, 16          # ���� 16 ��@�� bfloat16
    j back             
NaN:
    srli t3, t3, 16   
    li s3, 0x0040       
    or a1, t3, s3            # NaN�B�z
    j back
