OUTPUT_FORMAT("binary")
ENTRY(main)

SECTIONS
{
    . = 0x7e00;

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
        *(COMMON)
    }
}
