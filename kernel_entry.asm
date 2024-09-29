section .entry progbits alloc exec nowrite align=1

extern kmain
global kernel_entry

kernel_entry:
    cld                        ; Ensure string processing is forward (DF=0)
                               ; The 32-bit calling convention requires this
    call kmain

; Infinite loop if kmain returns here
.hltloop:
    hlt
    jmp .hltloop
