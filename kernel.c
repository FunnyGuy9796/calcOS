#include "kernel.h"
#include "vga.h"
#include "mmap.h"

boot_info_t *boot_info;

void __attribute__((section(".text.entry"))) kmain(void) {
    boot_info = (boot_info_t*)BOOT_INFO_ADDRESS;
    uint16_t mmap_count = get_mmap_count();
    struct mmap_entry* mmap = get_mmap();

    vga_bg = VGA_COLOR_BLUE;
    vga_clear();

    if (boot_info->magic != 0xf00d) {
        vga_clear();
        vga_bg = VGA_COLOR_RED;

        printf("INVALID BOOTLOADER INFORMATION: %#x\n", boot_info->magic);

        while (1) {}
    }

    if (mmap_count <= 0) {
        vga_clear();
        vga_bg = VGA_COLOR_RED;

        printf("NO MEMORY MAP ENTRIES FOUND");

        while (1) {}
    }

    printf("Kernel address: %#x\n\n", boot_info->kernel_address);

    printf("Memory Map Entry Count: %d\n\n", mmap_count);

    for (uint16_t i = 0; i < mmap_count; i++) {
        printf("Entry %d:\n", i);
        printf("Base Address: %#x\n", mmap[i].base_addr);
        printf("Length: %#x\n", mmap[i].length);
        printf("Type: %d\n", mmap[i].type);

        if (mmap[i].acpi & 0x1) {
            printf("ACPI Extended Attributes: %#x\n", mmap[i].acpi);
        }

        printf("\n");
    }

    while (1) {}
}