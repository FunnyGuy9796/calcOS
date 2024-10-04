#ifndef MMAP_H
#define MMAP_H

#include <stdint.h>

#define MMAP_BASE_ADDRESS 0xd000
#define MMAP_COUNT_ADDRESS 0xcfff

struct mmap_entry {
    uint64_t base_addr;
    uint64_t length;
    uint32_t type;
    uint32_t acpi;
};

uint16_t get_mmap_count();

struct mmap_entry* get_mmap();

#endif