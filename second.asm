[bits 16]
[org 0x9000]

start:
    cli
    
    mov si, msg
    call print_string

    call enable_a20_fast
    call enter_protected_mode

hang:
    jmp hang

print_string:
    mov ah, 0x0e
.print_char:
    lodsb
    cmp al, 0
    je done
    int 0x10
    jmp .print_char
done:
    ret

%include "a20.asm"
%include "protected.asm"

msg db 'B:S2 ', 0
a20_s_msg db 'A20:OK ', 0
a20_e_msg db 'E:A20 ', 0

[bits 32]

vga_buffer equ 0xb8000

protected_mode:
    mov ax, 0x10
    mov ds, ax
    
    mov si, pmode_s_msg
    call print_32_string

    jmp hang

print_32_string:
    mov ebx, vga_buffer
.next_char:
    lodsb
    cmp al, 0
    je .done
    mov [ebx], ax
    add ebx, 2
    jmp .next_char
.done:
    ret

pmode_s_msg db '32-bit:OK', 0