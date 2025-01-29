section .text
    default rel
    global ymm
    extern printf

ymm:
    ; Parameters:
    ; rcx - n (size of the vector)
    ; rdx - A (pointer to vector A)
    ; r8 - B (pointer to vector B)
    ; r9 - result (pointer to store result)

	XOR R10, R10
	VXORPD YMM2, YMM2
	
L1:
	; pack multiply ai*bi
	CMP R10, RCX
	JGE FINIS
	VMOVUPD YMM0, [RDX]
	VMOVUPD YMM1, [R8]
	VMULPD YMM0, YMM0, YMM1

	; pack add into ymm2
	VADDPD YMM2, YMM0
	
	ADD RDX, 32
	ADD R8, 32
	ADD R10, 4
	JMP L1

FINIS:
	; horizontal add the final
	VHADDPD YMM2, YMM2, YMM2
	VEXTRACTF128 XMM1, YMM2, 1
	ADDSD XMM2, XMM1

	; final result stored in xmm2
	MOVQ [R9], XMM2
	ret