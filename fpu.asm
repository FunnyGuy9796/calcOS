[bits 32]

control_word dw 0x037F

check_fpu:
    xor eax, eax
    cpuid

    test edx, 0x00000001
    jz no_fpu

    mov eax, cr0
    and al, ~6
    mov cr0, eax

    finit
    fldcw [control_word]
    fnclex

    ret

no_fpu:
    mov esi, fpu_e_msg
    call print_32_string

    ret

fpu_e_msg db 'FPU:NP ', 0