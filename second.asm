[bits 16]
[org 0x9000]

start:
    cli

    mov si, msg
    call print_string

    call enable_a20_fast
    call enter_protected_mode

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
    ; You need to set the protected mode selectors
    ; once you are in protected mode
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0xa000      ; For performance stack should be DWORD aligned

    mov ah, 0x0f         ; Set bright white on black
    mov esi, pmode_s_msg ; Need to set ESI not SI
                         ; now that we're in 32-bit protected mode
    call print_32_string

hang:                    ; Move the jmp hang code into the [bits32] code
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
