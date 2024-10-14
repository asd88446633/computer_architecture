
.text
    .globl main
    .data
input_data: 
    .half 0x3f80, 0xc120, 0x7fc0   # 測試資料 1,-10,NaN
answer: 
    .word 0x3f800000, 0xc1200000, 0x7fc00000  # 正確答案
newline: 
    .string "\n"                   # 換行符號
correct: 
    .string "the conversion is right\n"  # 正確
wrong: 
    .string "the conversion is wrong\n"  # 錯誤

    .text
main:
    la t0, input_data           # 載入 input_data 的位址
    la t1, answer               # 載入 answer 的位址
    li t2, 3                    # 設定迴圈次數 
    li a0, 1             
loop:
    lh t3, 0(t0)               
    jal ra, bf16_to_fp32        

    lw t5, 0(t1)             
    beq t4, t5, correct_output  # 如果 t4 == t5, 則跳到 correct_output

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

    addi t0, t0, 2              # 移到下一個 16-bit
    addi t1, t1, 4              # 移到下一個 32-bit
    addi t2, t2, -1             # 迴圈減 1
    bnez t2, loop               # 若 t2 != 0 繼續

    # 結束程式
    li a7, 10          
    ecall

bf16_to_fp32:
    slli t4, t3, 16             # 將 bf16 尾數移動到 fp32 的正確位置 (16位左移)
    ret                         # 返回結果 (t4)