.global fib
fib:
    li a1,1
    li a2,1
    addi a0,a0,-2
    blez a0,c1

c2 :
    add a3,a1,a2
    mv a1,a2
    mv a2,a3
    addi a0,a0,-1
    bnez a0, c2
    mv a0,a3
    jr ra       # Return address was stored by original call
    
c1 :
    li a0,1
    jr ra       # Return address was stored by original call
