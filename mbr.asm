[bits 16]
[org 0x7c00]

.start:
    mov si, msg
    call print_string

    mov bx, 0x9000
    call load_second

    jmp 0x9000

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

load_second:
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, error_msg
    call print_string
    jmp hang

msg db 'B:S1 ', 0
error_msg db 'E:DR ', 0

times 510 - ($ - $$) db 0
db 0x55, 0xaa