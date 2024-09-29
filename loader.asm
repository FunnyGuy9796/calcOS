bits 16
org 0x7e00

start:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'S'
    int 0x10
    mov al, '2'
    int 0x10

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov cl, 3
;   mov dl, 0x80              ; Use value in DL passed from mbr.asm
    mov bx, 0x8000
    int 0x13

    jc read_error

    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'R'
    int 0x10
    mov al, 'e'
    int 0x10

    ; Enter 32-bit mode (we start in 16-bit real mode)
    cli
    lgdt [gdt.gdtr]            ; Load our GDTR
    mov eax, cr0
    or eax, 0x1                ; Set protected mode (bit 0)
    mov cr0, eax               ; Enable protected mode

    jmp CODE32_PL0_SEL:pm32_enter
                               ; Enter 32-bit protected mode. Set CS

read_error:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'K'
    int 0x10
    hlt

bits 32
pm32_enter:
    mov eax, DATA32_PL0_SEL
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov ss, eax
    movzx esp, sp              ; Zero extend 16-bit stack pointer to 32-bits

    jmp 0x8000                 ; Jump to kernel

; Macro to build a GDT descriptor entry
%define MAKE_GDT_DESC(base, limit, access, flags)  \
    dq (((base & 0x00FFFFFF) << 16) |  \
       ((base & 0xFF000000) << 32) |  \
       (limit & 0x0000FFFF) |      \
       ((limit & 0x000F0000) << 32) |  \
       ((access & 0xFF) << 40) |  \
       ((flags & 0x0F) << 52))

; GDT structure
align 8
gdt:
.start:
.null:       MAKE_GDT_DESC(0, 0, 0, 0)
                               ; Null descriptor
.code32_pl0: MAKE_GDT_DESC(0, 0x000FFFFF, 10011011b, 1100b)
                               ; 32-bit code, PL0, gran=page, acc=1, r/x
                               ; Lim=0xffffffff
.data32_pl0: MAKE_GDT_DESC(0, 0x000FFFFF, 10010011b, 1100b)
                               ; 32-bit data, PL0, gran=page, acc=1, r/w
                               ; Lim=0xffffffff
.end:

; GDT record
align 4
    dw 0                       ; Padding align dd GDT in gdtr on 4 byte boundary
.gdtr:
    dw .end - .start - 1       ; limit (Size of GDT - 1)
    dd .start                  ; base of GDT

CODE32_PL0_SEL EQU gdt.code32_pl0 - gdt.start
DATA32_PL0_SEL EQU gdt.data32_pl0 - gdt.start


times 510 - ($ - $$) db 0
dw 0xaa55
