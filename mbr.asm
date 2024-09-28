bits 16
org 0x7c00

start:
    mov ah, 0x0e
    mov al, 'S'
    int 0x10
    mov al, '1'
    int 0x10

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov dl, 0x80
    mov bx, 0x8000
    int 0x13

    jc read_error

    jmp 0x8000

read_error:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'E'
    int 0x10
    hlt
    
times 510 - ($ - $$) db 0
dw 0xaa55