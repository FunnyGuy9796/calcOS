bits 16
org 0x7c00

start:
    ; Initialize segment registers to 0. Stack =0x0000:0x7c00 below bootloader
    cli
    xor ax, ax
    mov ss, ax
    mov sp, 0x7c00
    sti
    mov es, ax
    mov ds, ax

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
;    mov dl, 0x80              ; Use value in DL passed by BIOS to bootloader
    mov bx, 0x7E00             ; Read to ES:BX = 0x0000:0x7E00 = 0x07e00
    int 0x13

    jc read_error

    jmp 0x7E00                 ; Jump to second stage

read_error:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 'E'
    int 0x10
    hlt
    
times 510 - ($ - $$) db 0
dw 0xaa55
