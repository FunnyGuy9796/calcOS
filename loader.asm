bits 16
org 0x8000

start:
    cli
    xor ax, ax
    mov ss, ax
    mov sp, 0x7c00
    mov ax, 0x8000
    mov ds, ax
    sti

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
    mov dl, 0x80
    mov bx, 0x7e00
    int 0x13

    jc read_error

    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'R'
    int 0x10
    mov al, 'e'
    int 0x10

    jmp 0x7e00

read_error:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'K'
    int 0x10
    hlt

times 510 - ($ - $$) db 0
dw 0xaa55