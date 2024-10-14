    .data
fibarray: .word 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0  # 宣告一個包含5個元素的整數陣列，初始值為0
n:.word 14
str: 
    .string "輸出n為7,10,14的結果\n"                              # 換行符號
newline: 
    .string "\n"                              # 換行符號
    .text
    .globl main

main:
    #先把array位置載入register
    la t0,fibarray
    #把陣列前兩個值放入記憶體中 
    li t1,1
    li t2,2
    sw t1, 0(t0)
    sw t2, 4(t0)
    
    addi t3,t0,8 #紀錄陣列的位置 fibarray+8
    #取得n的值
    la t4,n 
    lw t5,0(t4)
    
    #初始化i的值記錄迴圈次數
    li t6,2
loop:
    bge t6,t5, End
    #計算fib(n-1)+fib(n-2)
    lw t1,-4(t3)
    lw t2,-8(t3)
    add a0,t1,t2 
    #儲存計算結果
    sw a0,0(t3)
    #i++與調整陣列位置
    addi t6,t6,1
    addi t3,t3,4
    j loop
    
    
End:
    # 輸出 結果
    la t0, fibarray   # 重新載入 fibarray 基址
    la a0, str          
    li a7, 4                 
    ecall        
    #調整陣列位置來輸出答案
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