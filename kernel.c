#include <stdint.h>

#define VGA_ADDRESS 0xB8000
#define WHITE_ON_BLACK 0x07

uint16_t *vga_buffer = (uint16_t *)VGA_ADDRESS;

uint16_t vga_entry(char ch, uint8_t color) {
    return (uint16_t)ch | (uint16_t)color << 8;
}

/* Add .text.entry before all other sections in linker script
 * and ensure that kmain is the first code in kernel.bin
 * at 0x10000 */
void __attribute__((section(".text.entry"))) kmain(void) {
    vga_buffer[0] = vga_entry('A', WHITE_ON_BLACK);

    while (1) {}
}
