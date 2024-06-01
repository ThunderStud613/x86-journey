LOCAL_PATH	:= $(shell pwd)

AS	:= i686-linux-gnu-as
CC	:= i686-linux-gnu-gcc
LD	:= i686-linux-gnu-ld
OBJCOPY	:= i686-linux-gnu-objcopy


CFLAGS	:= \
				   -Wall \
				   -Wextra \
				   -ffreestanding \
				   -fno-stack-protector

STAGE0_LDFLAGS	:= \
				   --oformat binary \
				   -e _start \
				   -Ttext 0x7C00

STAGE1_LDFLAGS	:= \
				   -T $(LOCAL_PATH)/stage1/x86.ld




STAGE0_TARGET	:= $(LOCAL_PATH)/boot0

STAGE1_TARGET	:= $(LOCAL_PATH)/boot1

STAGE0_OBJS		:= \
					   $(LOCAL_PATH)/stage0/boot_sect.o







.PHONY: all
all: clean $(STAGE0_OBJS) $(STAGE0_TARGET)




$(STAGE0_TARGET): $(STAGE0_OBJS)
	@$(LD) $^ $(STAGE0_LDFLAGS) -o $@.bin


.s.o:
	@$(AS) $< -o $@

.c.o:
	@$(CC) -c $< $(CFLAGS) -o $@




install:
	@dd if=/dev/zero of=floppy.img bs=1024 count=1440 >/dev/null 2>&1
	@dd if=$(STAGE0_TARGET).bin of=floppy.img bs=512 conv=notrunc >/dev/null 2>&1


run:
	@qemu-system-i386 -M q35 -cpu core2duo -smp 1 -m 512M -fda floppy.img -nographic


clean:
	@rm -f $(BOOT_SECT_OBJS) *.o *.d *.elf *.bin *.img
