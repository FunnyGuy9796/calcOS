#include "vga.h"

void __attribute__((section(".text.entry"))) kmain(void) {
    vga_bg = VGA_COLOR_BLUE;
    
    vga_clear();

    printf("\n----------------------------------calcOS, v%0.1f----------------------------------\n", 1.0);
    printf("calcOS is a simple x86 operating system that uses a custom bootloader that is currently a work in progress. The goal of this project is to learn how operating systems and bootloaders work as well as to have fun.\n");

    printf("\n\n----------------------------------SYSTEM INFO:----------------------------------\n");
    printf("Kernel loaded at memory address: %x\n", 0x10000);

    while (1) {}
}