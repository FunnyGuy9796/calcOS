# Paths and tools
CROSS_COMPILE = $(HOME)/opt/cross/bin/i686-elf-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
AS = nasm

# Output binaries and final image
MBR_BIN = mbr.bin
LOADER_BIN = loader.bin
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
IMAGE = bootable.img

# NASM and GCC flags
ASFLAGS = -f bin
CFLAGS = -ffreestanding -c
LDFLAGS = -T linker.ld --oformat binary

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
	$(LD) $(LDFLAGS) -o $(KERNEL_BIN) $(KERNEL_OBJ)

# Create the bootable image by concatenating the MBR, loader, and kernel
$(IMAGE): $(MBR_BIN) $(LOADER_BIN) $(KERNEL_BIN)
	cat $(MBR_BIN) $(LOADER_BIN) $(KERNEL_BIN) > $(IMAGE)

# Clean up generated files
clean:
	rm -f *.bin *.o $(IMAGE)
