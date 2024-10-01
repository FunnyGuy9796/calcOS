[bits 16]
[org 0x9000]

start:
    cli
    
    mov si, msg
    call print_string

    call enable_a20_fast

    push 0x1000
    pop es                     ; ES=0x1000
    mov bx, 0x0                ; BX=0x0000
    ; Int13h/AH=2 disk read to ES:BX. ES:BX=0x1000:0x0000
    ; (ES<<4)+BX = (0x1000<<4)+0x0000 = phys address 0x10000
    call load_kernel

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

load_kernel:
    mov ah, 0x02
    mov al, 9
    mov ch, 0
    mov cl, 3
    mov dh, 0
    mov dl, 0x80
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, disk_e_msg
    call print_string
    jmp $

%include "a20.asm"
%include "protected.asm"

msg db 'B:S2 ', 0
a20_s_msg db 'A20:OK ', 0
a20_e_msg db 'E:A20 ', 0
disk_e_msg db 'E:DR', 0

[bits 32]

vga_buffer equ 0xb8000

hang:
    jmp hang

protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000
    
    mov esi, pmode_s_msg
    call print_32_string

    jmp 0x10000                 ; Previously set CS to 0x08
                                ;     don't need to do it again
    

print_32_string:
    mov ebx, vga_buffer
    mov ah, 0x03
.next_char:
    lodsb
    cmp al, 0
    je .done
    mov [ebx], ax
    add ebx, 2
    jmp .next_char
.done:
    ret

pmode_s_msg db 'Protected Mode... [OK] ', 0

times 510 - ($ - $$) db 0
