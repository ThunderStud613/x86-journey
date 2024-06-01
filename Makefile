LOCAL_PATH	:= $(shell pwd)

AS	:= i686-linux-gnu-as
CC	:= i686-linux-gnu-gcc
LD	:= i686-linux-gnu-ld


CFLAGS	:=

LDFLAGS	:= --oformat binary -e _start -Ttext 0x7C00


BOOT_SECT_TARGET	:= $(LOCAL_PATH)/boot.bin

STAGE2_TARGET		:= $(LOCAL_PATH)/sbl.bin

BOOT_SECT_OBJS		:= \
					   $(LOCAL_PATH)/stage0/boot_sect.o




.PHONY: all
all: clean $(BOOT_SECT_OBJS) $(BOOT_SECT_TARGET)




$(BOOT_SECT_TARGET): $(BOOT_SECT_OBJS)
	@$(LD) $(BOOT_SECT_OBJS) $(LDFLAGS) -o $(BOOT_SECT_TARGET)


.s.o:
	@echo " AS	$<"
	@$(AS) $< -o $@

.c.o:
	@echo " CC	$<"
	@$(CC) -c $< $(CFLAGS) -o $@




install:
	@dd if=/dev/zero of=floppy.img bs=1024 count=1440 >/dev/null 2>&1
	@dd if=$(BOOT_SECT_TARGET) of=floppy.img bs=512 conv=notrunc >/dev/null 2>&1


run:
	@qemu-system-i386 -M q35 -cpu core2duo -smp 1 -m 512M -fda floppy.img -nographic


clean:
	@rm -f $(BOOT_SECT_OBJS) *.o *.d *.elf *.bin *.img
