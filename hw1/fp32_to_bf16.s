.text
    .globl main
    .data
input_data: 
    .word 0x411FFFFF, 0xBF800000, 0x7FC00000  # 測試資料 9.999999,-1,NaN
answer: 
    .word 0x4120, 0xBF80, 0x7FC0              # 正確答案
newline: 
    .string "\n"                              # 換行符號
correct: 
    .string "the conversion is right\n"       # 正確輸出
wrong: 
    .string "the conversion is wrong\n"       # 錯誤輸出

    .text
main:
    la t0, input_data           # 載入 input_data 的位址
    la t1, answer               # 載入 answer 的位址
    li t2, 3                    # 設定迴圈次數 (3個fp32資料)
    li a0, 1                 

loop:
    lw t3, 0(t0)             
    jal ra, fp32_to_bf16        # 呼叫 fp32_to_bf16 函數轉換 t3 為 bf16, 結果存入 a1
back:
    lw t4, 0(t1)                # 從 t1 地址讀取正確的 16-bit (bf16) 答案
    beq a1, t4, correct_output  # 如果 a1 == t4, 則跳到 correct_output
    # 如果轉換錯誤，輸出錯誤訊息
    la a0, wrong          
    li a7, 4               
    ecall                    
    j continue_loop             # 繼續下一個迴圈

correct_output:
    la a0, correct        
    li a7, 4                
    ecall                    

continue_loop:
    # 輸出換行符號
    la a0, newline          
    li a7, 4                 
    ecall                  

    addi t0, t0, 4              # 移到下一個 32-bit
    addi t1, t1, 4           
    addi t2, t2, -1             # 迴圈減 1
    bnez t2, loop               # 若 t2 != 0 繼續

    # 結束程式
    li a7, 10                
    ecall
    
fp32_to_bf16:    
    li s3, 0          
    li s0, 0x7fffffff  
    and s1, t3, s0         
    
    li s2, 0x7f800000       
    slt s3, s1, s2         #檢查是否為NaN
    beq s3, x0, NaN  
    jal ra, NotNaN  
NotNaN:
    srli s2, t3, 16  
    andi s2, s2, 1           # 取得最低有效位元 
    li s3, 0x00007fff        # 處理四捨五入
    add s2, s2, s3       
    add t3, t3, s2       
    srli a1, t3, 16          # 取高 16 位作為 bfloat16
    j back             
NaN:
    srli t3, t3, 16   
    li s3, 0x0040       
    or a1, t3, s3            # NaN處理
    j back
