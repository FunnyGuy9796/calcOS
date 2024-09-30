[bits 16]
[org 0x7c00]

.start:
    ; Bootloader should set segments it intends to use to the expected
    ; value.
    ;
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00             ; Set initial stack (SS:SP) somehwere we know we
                               ;     we won't write on top with a disk read like
                               ;     placing it at 0x0000:0x7c00 grows down
                               ;     below the bootloader and won't be
                               ;     clobbered by by our disk reads

    cld                        ; Ensure string processing is forward (DF=0)
                               ;     for isntructions like LODS, MOVS, CMPS
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
