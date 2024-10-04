[bits 16]

MMAP_BUFFER equ 0xd000
MMAP_COUNT equ 0xcfff

get_mmap:
    push es
    push di
    push bp

    mov ax, 0x0
    mov es, ax
    mov di, MMAP_BUFFER
    xor ebx, ebx
    xor bp, bp

next_entry:
    mov eax, 0xe820
    mov edx, 0x534D4150
    mov ecx, 24
    int 0x15

    jc mmap_done
    cmp eax, 0x534D4150
    jne mmap_done

    mov cx, [es:di + 8]
    or cx, [es:di + 12]
    jz skip_entry

    inc bp
    add di, 24

skip_entry:
    test ebx, ebx
    jne next_entry

mmap_done:
    mov [es:MMAP_COUNT], bp

    pop bp
    pop di
    pop es
    ret