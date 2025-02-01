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

    ;register initializations
    mov r11, rcx ; r11 has the true n value count
    xor r10, r10
    xorpd xmm2, xmm2
    shr rcx, 1

    cmp r11, 0 ; to check for negative or non values
    jle done

    cmp r11, 1 ; check if only one
    je BUT_THE_ONE_IN_FRONT_OF_THE_GUN_LIVES_FOREVER

ADD_LOOP_XMM:
    vmovupd xmm0, [rdx+r10*8]
    vmovupd xmm1, [r8+r10*8]
    mulpd xmm0, xmm1
    vhaddpd xmm0, xmm0
    addsd xmm2, xmm0
    add r10, 2
    sub r11, 2
    LOOP ADD_LOOP_XMM

BUT_THE_ONE_IN_FRONT_OF_THE_GUN_LIVES_FOREVER:
    cmp r11, 0
    jle done    ; if there is remaining, add the last
    movsd xmm0, [rdx+r10*8]
    movsd xmm1, [r8+r10*8]
    mulsd xmm0, xmm1
    addsd xmm2, xmm0

done:
    movq [r9], xmm2        
    ret
