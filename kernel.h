#ifndef KERNEL_H
#define KERNEL_H

#include <stdint.h>

#define BOOT_INFO_ADDRESS 0x9500

typedef struct {
    unsigned short magic;
    unsigned int kernel_address;
} __attribute__((packed)) boot_info_t;

extern boot_info_t *boot_info;

#endif