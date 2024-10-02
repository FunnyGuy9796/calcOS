#include "vga.h"
#include "util.h"

volatile uint16_t* vga_text_buffer = (uint16_t*)VGA_ADDRESS;

unsigned int vga_row = 0;
unsigned int vga_col = 0;

enum vga_color vga_fg = VGA_COLOR_WHITE;
enum vga_color vga_bg = VGA_COLOR_BLACK;

uint8_t vga_color(enum vga_color fg, enum vga_color bg) {
    return fg | bg << 4;
}

uint16_t vga_entry(char ch, uint8_t color) {
    return (uint16_t)ch | (uint16_t)color << 8;
}

void vga_update_cursor() {
    int index = vga_row * VGA_WIDTH + vga_col;

    outb(VGA_CTRL_REGISTER, 0x0e);
    outb(VGA_DATA_REGISTER, (index >> 8) & 0xff);

    outb(VGA_CTRL_REGISTER, 0x0f);
    outb(VGA_DATA_REGISTER, index & 0xff);
}

void vga_clear() {
    uint8_t color = vga_color(vga_fg, vga_bg);

    for (int row = 0; row < VGA_HEIGHT; row++) {
        for (int col = 0; col < VGA_WIDTH; col++) {
            vga_text_buffer[row * VGA_WIDTH + col] = vga_entry(' ', color);
        }
    }

    vga_row = 0;
    vga_col = 0;

    vga_update_cursor();
}

void vga_puts(const char* str) {
    uint8_t color = vga_color(vga_fg, vga_bg);

    for (int i = 0; str[i] != '\0'; i++) {
        if (vga_col >= VGA_WIDTH) {
            vga_row++;
            vga_col = 0;
        }

        if (str[i] != '\n') {
            int index = vga_row * VGA_WIDTH + vga_col;

            vga_text_buffer[index] = vga_entry(str[i], color);
            vga_col++;
        } else {
            vga_row++;
            vga_col = 0;
        }

        vga_update_cursor();
    }
}

void vga_putint(int value) {
    int index = vga_row * VGA_WIDTH + vga_col;
    uint8_t color = vga_color(vga_fg, vga_bg);

    if (value < 0) {
        vga_text_buffer[index] = vga_entry('-', color);
        value = -value;

        if (vga_col >= VGA_WIDTH) {
            vga_row++;
            vga_col = 0;
        }

        vga_col++;
    }
    
    if (value / 10) {
        vga_putint(value / 10);
    }

    if (vga_col >= VGA_WIDTH) {
        vga_row++;
        vga_col = 0;
    }

    vga_col++;

    vga_text_buffer[index] = vga_entry(value % 10 + '0', color);

    vga_update_cursor();
}

void vga_putfloat(double value, int precision) {
    uint8_t color = vga_color(vga_fg, vga_bg);

    if (value < 0) {
        int index = vga_row * VGA_WIDTH + vga_col;
        vga_text_buffer[index] = vga_entry('-', color);
        value = -value;

        if (vga_col >= VGA_WIDTH) {
            vga_row++;
            vga_col = 0;
        }

        vga_col++;
    }

    int int_part = (int)value;
    vga_putint(int_part);

    if (precision > 0) {
        if (vga_col >= VGA_WIDTH) {
            vga_row++;
            vga_col = 0;
        }

        int index = vga_row * VGA_WIDTH + vga_col;
        vga_text_buffer[index] = vga_entry('.', color);
        vga_col++;
    }

    double fractional_part = value - (double)int_part;

    for (int i = 0; i < precision; i++) {
        fractional_part *= 10;
        int digit = (int)fractional_part;
        fractional_part -= digit;

        if (vga_col >= VGA_WIDTH) {
            vga_row++;
            vga_col = 0;
        }

        int index = vga_row * VGA_WIDTH + vga_col;
        vga_text_buffer[index] = vga_entry(digit + '0', color);
        vga_col++;
    }

    vga_update_cursor();
}

void vga_puthex(unsigned int value, bool uppercase) {
    const char* hex_digits = uppercase ? "0123456789ABCDEF" : "0123456789abcdef";

    char buffer[9];
    buffer[8] = '\0';
    int index = 7;

    if (value == 0) {
        buffer[index--] = '0';
    }

    while (index >= 0) {
        buffer[index--] = hex_digits[value % 16];
        value /= 16;
    }

    vga_puts(&buffer[index + 1]);
}

void printf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    uint8_t color = vga_color(vga_fg, vga_bg);

    while (*format) {
        if (vga_col >= VGA_WIDTH) {
            vga_row++;
            vga_col = 0;
        }

        if (*format == '%') {
            format++;

            int precision = 6;

            if (*format == '0') {
                format++;

                if (*format == '.') {
                    format++;
                    precision = 0;

                    while (*format >= '0' && *format <= '9') {
                        precision = precision * 10 + (*format - '0');
                        format++;
                    }
                }
            }

            if (*format == 'd') {
                int int_value = va_arg(args, int);
                vga_putint(int_value);
            } else if (*format == 's') {
                char *str_value = va_arg(args, char*);
                vga_puts(str_value);
            } else if (*format == 'f') {
                double float_value = va_arg(args, double);
                vga_putfloat(float_value, precision);
            } else if (*format == 'x') {
                unsigned int hex_value = va_arg(args, unsigned int);
                vga_puthex(hex_value, false);
            } else if (*format == 'X') {
                unsigned int hex_value = va_arg(args, unsigned int);
                vga_puthex(hex_value, true);
            }
        } else {
            if (*format != '\n') {
                int index = vga_row * VGA_WIDTH + vga_col;
                vga_text_buffer[index] = vga_entry(*format, color);
                vga_col++;
            } else {
                vga_row++;
                vga_col = 0;
            }
        }

        format++;
    }

    vga_update_cursor();

    va_end(args);
}