section .text
    default rel
    global xmm
    extern printf

xmm:
    ; Parameters:
    ; rcx - n (size of the vector)
    ; rdx - A (pointer to vector A)
    ; r8 - B (pointer to vector B)
    ; r9 - result (pointer to store result)

    xor r10, r10
    shr rcx, 1
    xorpd xmm2, xmm2

ADD_LOOP_XMM:
    vmovupd xmm0, [rdx+r10*8]
    vmovupd xmm1, [r8+r10*8]
    mulpd xmm0, xmm1
    vhaddpd xmm0, xmm0
    addsd xmm2, xmm0
    add r10, 2
    LOOP ADD_LOOP_XMM

done:
    movq [r9], xmm2        
    ret
