#ifndef VGA_H
#define VGA_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdarg.h>

#define VGA_ADDRESS 0xB8000
#define VGA_CTRL_REGISTER 0x3D4
#define VGA_DATA_REGISTER 0x3D5

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

#define WHITE_ON_BLACK 0x07

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

extern unsigned int vga_row;
extern unsigned int vga_col;

extern enum vga_color vga_fg;
extern enum vga_color vga_bg;

uint8_t vga_color(enum vga_color fg, enum vga_color bg);

uint16_t vga_entry(char ch, uint8_t color);

void vga_clear();

void vga_puts(const char* str);

void vga_putint(int value);

void vga_putfloat(double value, int precision);

void printf(const char* format, ...);

void panic(const char* format, ...);

#endif