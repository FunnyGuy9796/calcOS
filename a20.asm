enable_a20_fast:
    in al, 0x92
    or al, 0x02
    out 0x92, al

    call test_a20

    ret

test_a20:
    mov ax, [0x0000]
    push ax

    mov ax, 0x1234
    mov [0x0000], ax

    mov ax, 0xffff
    mov es, ax
    mov di, 0x0010
    mov word [es:di], 0xabcd

    mov ax, [0x0000]
    cmp ax, 0x1234
    jne a20_error

    jmp a20_enabled

    ret

a20_error:
    pop ax
    mov [0x0000], ax

    mov si, a20_e_msg
    call print_string

    jmp hang

a20_enabled:
    pop ax
    mov [0x0000], ax

    mov si, a20_s_msg
    call print_string

    ret