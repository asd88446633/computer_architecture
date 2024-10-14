    .data
fibarray: .half 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0  #
n:.word 14
    .text
    .globl main
main:
    #рarray竚更register
    la t0,fibarray
    #р皚玡ㄢ癘拘砰い 
    li t1,0x3F80
    li t2,0x4000
    sh t1, 0(t0)
    sh t2, 2(t0)
    
    addi t3,t0,4 #魁皚竚 fibarray+4
    #眔n
    la t4,n 
    lw t5,0(t4)
    
    #﹍てi癘魁癹伴Ω计
    li t6,2
loop:
    bge t6,t5, End
    #璸衡fib(n-1)+fib(n-2)
    lh t1,-2(t3)
    lh t2,-4(t3)
    j bf16_add
    #add a0,t1,t2 
    #纗璸衡挡狦
after_add:
    sw a0,0(t3)
    #i++籔秸俱皚竚
    addi t6,t6,1
    addi t3,t3,2
    j loop
    
End: 
    li a7, 10         # 砞﹚ a7  10 (╰参㊣ 10 ノㄓ挡祘Α)
    ecall             # ㊣╰参挡祘Α
    
bf16_add:
# 计㎝Ю计
slli s4, t1, 17
srli s4, s4, 24  

slli s5, t2, 17
srli s5, s5, 24  

li s6, 0x007F     # 眔Ю计 mask
and s7, t1, s6   
and s8, t2, s6   

# 留 1  
li s9, 0x80      
or s7, s7, s9       # Ю计 a 留
or s8, s8, s9       # Ю计 b 留

# ゑ耕计癸霍
bge s4, s5, align_exp0
    mv s9, t1        # a ㎝ b ユ传絋玂 t1(a) 计耕
    mv t1, t2
    mv t2, s9
    mv s9, s4        # ユ传计
    mv s4, s5
    mv s5, s9
    mv s9, s7        # ユ传Ю计
    mv s7, s8
    mv s8, s9

align_exp0:
    sub s11, s4, s5       # 璸衡计畉
    srl s8, s8, s11       # 盢Ю计簿癸霍计

# Ю计
add s7, s7, s8
li s11, 0x100
bge s7, s11, carry   # Ю计 > 0x100 祇ネ秈
j finish_add

carry:
    # 矪瞶Ю计秈
    addi s4, s4, 1     # 计 + 1
    srli s7, s7, 1     # Ю计簿 1
    j finish_add

finish_add:
    slli s9, s4, 7
    slli s7, s7, 25
    srli s7, s7, 25
    or   a0, s9, s7
    j after_add