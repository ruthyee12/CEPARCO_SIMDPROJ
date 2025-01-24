section .text
    default rel
    global x86
    extern printf

x86:
    ; Parameters:
    ; rdi - n (size of the vector)
    ; rsi - A (pointer to vector A)
    ; rdx - B (pointer to vector B)
    ; rcx - result (pointer to store result)

    xor r8, r8            
    xor r9, r9            

L1:
    cmp r9, rdi           
    jge done

    movsd xmm0, [rsi + r9*8]  
    movsd xmm1, [rdx + r9*8]  
    mulsd xmm0, xmm1         
    addsd r8, xmm0           

    inc r9                 
    jmp L1

done:
    movsd [rcx], r8         
    ret
