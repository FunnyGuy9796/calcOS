#include "mmap.h"

uint16_t get_mmap_count() {
    return *((uint16_t*)MMAP_COUNT_ADDRESS);
}

struct mmap_entry* get_mmap() {
    return (struct mmap_entry*)MMAP_BASE_ADDRESS;
}