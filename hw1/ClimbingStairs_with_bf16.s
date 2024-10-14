    .data
fibarray: .half 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0  #
n:.word 14
    .text
    .globl main
main:
    #����array��m���Jregister
    la t0,fibarray
    #��}�C�e��ӭȩ�J�O���餤 
    li t1,0x3F80
    li t2,0x4000
    sh t1, 0(t0)
    sh t2, 2(t0)
    
    addi t3,t0,4 #�����}�C����m fibarray+4
    #���on����
    la t4,n 
    lw t5,0(t4)
    
    #��l��i���ȰO���j�馸��
    li t6,2
loop:
    bge t6,t5, End
    #�p��fib(n-1)+fib(n-2)
    lh t1,-2(t3)
    lh t2,-4(t3)
    j bf16_add
    #add a0,t1,t2 
    #�x�s�p�⵲�G
after_add:
    sw a0,0(t3)
    #i++�P�վ�}�C��m
    addi t6,t6,1
    addi t3,t3,2
    j loop
    
End: 
    li a7, 10         # �]�w a7 �� 10 (�t�ΩI�s 10 �Ψӵ����{��)
    ecall             # �I�s�t�ε����{��
    
bf16_add:
# ���X���ƩM����
slli s4, t1, 17
srli s4, s4, 24  

slli s5, t2, 17
srli s5, s5, 24  

li s6, 0x007F     # �o����ƪ� mask
and s7, t1, s6   
and s8, t2, s6   

# �[�J���t�� 1 �� 
li s9, 0x80      
or s7, s7, s9       # ���� a �[�J���t��
or s8, s8, s9       # ���� b �[�J���t��

# ������Ƥj�p�ù��
bge s4, s5, align_exp0
    mv s9, t1        # a �M b �洫�A�T�O t1(a) �����Ƹ��j
    mv t1, t2
    mv t2, s9
    mv s9, s4        # �洫����
    mv s4, s5
    mv s5, s9
    mv s9, s7        # �洫����
    mv s7, s8
    mv s8, s9

align_exp0:
    sub s11, s4, s5       # �p����Ʈt
    srl s8, s8, s11       # �N���ƥk���A�������

# ���Ƭۥ[
add s7, s7, s8
li s11, 0x100
bge s7, s11, carry   # ���� > 0x100 �o�Ͷi��
j finish_add

carry:
    # �B�z���ƶi��
    addi s4, s4, 1     # ���� + 1
    srli s7, s7, 1     # ���ƥk�� 1
    j finish_add

finish_add:
    slli s9, s4, 7
    slli s7, s7, 25
    srli s7, s7, 25
    or   a0, s9, s7
    j after_add