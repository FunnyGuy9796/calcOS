ENTRY(kernel_entry)

SECTIONS
{
    . = 0x8000;

    .text : {
        /* Ensure the .entry section is FIRST as it calls the kernel */
        *(.entry)
        *(.text*)
    }

    .data : {
        *(.data)
    }

    .rodata : {
        *(.rodata*)
    }

    .bss : {
        *(.bss)
        *(COMMON)
    }
}
