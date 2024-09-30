MBR_SRC = mbr.asm
SECOND_SRC = second.asm
MBR_BIN = mbr.bin
SECOND_BIN = second.bin
DISK_IMG = calcOS.img

NASM = nasm
NASM_FLAGS = -f bin

QEMU = qemu-system-x86_64

DD = dd

DISK_SIZE = 10M

$(MBR_BIN): $(MBR_SRC)
	$(NASM) $(NASM_FLAGS) $(MBR_SRC) -o $(MBR_BIN)

$(SECOND_BIN): $(SECOND_SRC)
	$(NASM) $(NASM_FLAGS) $(SECOND_SRC) -o $(SECOND_BIN)

$(DISK_IMG): $(MBR_BIN) $(SECOND_BIN)
	qemu-img create -f raw $(DISK_IMG) $(DISK_SIZE)

	$(DD) if=$(MBR_BIN) of=$(DISK_IMG) bs=512 count=1 conv=notrunc

	$(DD) if=$(SECOND_BIN) of=$(DISK_IMG) bs=512 count=1 seek=1 conv=notrunc

run: $(DISK_IMG)
	$(QEMU) -drive format=raw,file=$(DISK_IMG)

clean:
	rm -f $(MBR_BIN) $(SECOND_BIN) $(DISK_IMG)

.PHONY: run clean