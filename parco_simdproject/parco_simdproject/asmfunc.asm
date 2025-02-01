section .text
    default rel
    global x86
    extern printf

x86:
    ; Parameters:
    ; rcx - n (size of the vector)
    ; rdx - A (pointer to vector A)
    ; r8 - B (pointer to vector B)
    ; r9 - result (pointer to store result)

    xorpd xmm2, xmm2

L1:
    cmp rcx, 0
    jle wala
    movsd xmm0, [rdx]  
    movsd xmm1, [r8]  
    mulsd xmm0, xmm1         
    addsd xmm2, xmm0   
    add rdx, 8
    add r8, 8
    LOOP L1

done:
    movq [r9], xmm2        
    ret

wala:
    mov qword [r9], 0
    ret
