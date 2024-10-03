#include "kernel.h"
#include "vga.h"

boot_info_t *boot_info;

void __attribute__((section(".text.entry"))) kmain(void) {
    boot_info = (boot_info_t*)BOOT_INFO_ADDRESS;

    vga_bg = VGA_COLOR_BLUE;

    vga_clear();

    if (boot_info->magic != 0xf00d) {
        vga_bg = VGA_COLOR_RED;

        printf("ERROR: Invalid boot information\n");

        while (1) {}
    }

    printf("\n----------------------------------calcOS, v%0.1f----------------------------------\n", 1.0);
    printf("calcOS is a simple x86 operating system that uses a custom bootloader that is currently a work in progress. The goal of this project is to learn how operating systems and bootloaders work as well as to have fun.\n");

    printf("\n\n\n----------------------------------SYSTEM INFO:----------------------------------\n");
    printf("Kernel address: %#x\n", boot_info->kernel_address);

    if (boot_info->kernel_address == 0x10000) {
        printf("SUCCESS");
    }

    while (1) {}
}