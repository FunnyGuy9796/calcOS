gdt_start:
    dq 0x0000000000000000

    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00            ; DB, not DW. GDT entries are exactly 8 bytes in size

    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00            ; DB, not DW. GDT entries are exactly 8 bytes in size
gdt_end:

gdtr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

enter_protected_mode:
    cli
    lgdt [gdtr]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode
