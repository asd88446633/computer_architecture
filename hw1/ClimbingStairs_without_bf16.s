    .data
fibarray: .word 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0  # �ŧi�@�ӥ]�t5�Ӥ�������ư}�C�A��l�Ȭ�0
n:.word 14
str: 
    .string "��Xn��7,10,14�����G\n"                              # ����Ÿ�
newline: 
    .string "\n"                              # ����Ÿ�
    .text
    .globl main

main:
    #����array��m���Jregister
    la t0,fibarray
    #��}�C�e��ӭȩ�J�O���餤 
    li t1,1
    li t2,2
    sw t1, 0(t0)
    sw t2, 4(t0)
    
    addi t3,t0,8 #�����}�C����m fibarray+8
    #���on����
    la t4,n 
    lw t5,0(t4)
    
    #��l��i���ȰO���j�馸��
    li t6,2
loop:
    bge t6,t5, End
    #�p��fib(n-1)+fib(n-2)
    lw t1,-4(t3)
    lw t2,-8(t3)
    add a0,t1,t2 
    #�x�s�p�⵲�G
    sw a0,0(t3)
    #i++�P�վ�}�C��m
    addi t6,t6,1
    addi t3,t3,4
    j loop
    
    
End:
    # ��X ���G
    la t0, fibarray   # ���s���J fibarray ��}
    la a0, str          
    li a7, 4                 
    ecall        
    #�վ�}�C��m�ӿ�X����
    lw a0, 24(t0)      
    li a7, 1       
    ecall      
        
    la a0, newline          
    li a7, 4                 
    ecall                  

    lw a0, 36(t0)      
    li a7, 1   
    ecall
              
    la a0, newline          
    li a7, 4                 
    ecall          
        
    lw a0, 52(t0)    
    li a7, 1     
    ecall               
    
    li a7, 10         
    ecall             