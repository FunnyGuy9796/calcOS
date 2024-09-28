# Paths and tools
CROSS_COMPILE = $(HOME)/opt/cross/bin/i686-elf-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
AS = nasm

# Output binaries and final image
MBR_BIN = mbr.bin
LOADER_BIN = loader.bin
KERNEL_OBJ = kernel.o
KERNEL_ELF = kernel.elf
KERNEL_BIN = kernel.bin
IMAGE = bootable.img

# NASM and GCC flags
ASFLAGS = -f bin
CFLAGS = -g -O3 -ffreestanding -fno-asynchronous-unwind-tables -fno-pic -c
LDFLAGS = -no-pie -nostdlib -T linker.ld

# Targets
all: $(IMAGE)

# Assemble the MBR
$(MBR_BIN): mbr.asm
	$(AS) $(ASFLAGS) mbr.asm -o $(MBR_BIN)

# Assemble the second-stage loader
$(LOADER_BIN): loader.asm
	$(AS) $(ASFLAGS) loader.asm -o $(LOADER_BIN)

# Compile the kernel C file
$(KERNEL_OBJ): kernel.c
	$(CC) $(CFLAGS) kernel.c -o $(KERNEL_OBJ)

# Link the kernel
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $(KERNEL_ELF) $(KERNEL_OBJ)
	$(OBJCOPY) -O binary $(KERNEL_ELF) $(KERNEL_BIN)

# Create a 1.44MiB bootable image by concatenating the MBR, loader, and kernel
$(IMAGE): $(MBR_BIN) $(LOADER_BIN) $(KERNEL_BIN)
	cat $(MBR_BIN) $(LOADER_BIN) $(KERNEL_BIN) > $(IMAGE)
	truncate -s 1440K $(IMAGE)

# Clean up generated files
clean:
	rm -f *.bin *.elf *.o $(IMAGE)
