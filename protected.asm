gdt_start:
    dq 0
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    dw 0x0000

    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    dw 0x0000
gdt_end:

gdtr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

enter_protected_mode:
    cli
    lgdt [gdtr]

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9fff

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode