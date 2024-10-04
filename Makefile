MBR_SRC = mbr.asm
SECOND_SRC = second.asm
KERNEL_SRC = $(wildcard *.c)

MBR_BIN = mbr.bin
SECOND_BIN = second.bin
KERNEL_BIN = kernel.bin

KERNEL_OBJ = $(KERNEL_SRC:.c=.o)

DISK_IMG = calcOS.img

NASM = nasm
NASM_FLAGS = -f bin

GCC = $(HOME)/opt/cross/bin/i686-elf-gcc
GCC_FLAGS = -ffreestanding -m32 -O0

LD = $(HOME)/opt/cross/bin/i686-elf-ld
LD_FLAGS = -Tlinker.ld -m elf_i386 --oformat binary

QEMU = qemu-system-x86_64

DD = dd

DISK_SIZE = 12M

$(MBR_BIN): $(MBR_SRC)
	$(NASM) $(NASM_FLAGS) $(MBR_SRC) -o $(MBR_BIN)

$(SECOND_BIN): $(SECOND_SRC)
	$(NASM) $(NASM_FLAGS) $(SECOND_SRC) -o $(SECOND_BIN)

%.o: %.c
	$(GCC) $(GCC_FLAGS) -c $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LD_FLAGS) $(KERNEL_OBJ) -o $(KERNEL_BIN)

$(DISK_IMG): $(MBR_BIN) $(SECOND_BIN) $(KERNEL_BIN)
	qemu-img create -f raw $(DISK_IMG) $(DISK_SIZE)

	$(DD) if=$(MBR_BIN) of=$(DISK_IMG) bs=512 count=1 conv=notrunc

	$(DD) if=$(SECOND_BIN) of=$(DISK_IMG) bs=512 count=1 seek=1 conv=notrunc

	$(DD) if=$(KERNEL_BIN) of=$(DISK_IMG) bs=512 seek=2 conv=notrunc

run: $(DISK_IMG)
	$(QEMU) -m 1024 -drive format=raw,file=$(DISK_IMG)

clean:
	rm -f $(MBR_BIN) $(SECOND_BIN) $(KERNEL_BIN) $(KERNEL_OBJ) $(DISK_IMG)

.PHONY: run clean