.code16
//.intel_syntax
.global stage2_start
.extern stage2_main


.equ COM1,	0x3F8
.equ STAGE2_BASE,	0x7E00

.equ KERNEL_LOAD_BASE,	0x10000000

.equ GDT_ACCESS_PRESENT,	0x80
.equ GDT_ACCESS_RING0,		0x00
.equ GDT_CODE_READABLE,		0x02
.equ GDT_DATA_WRITABLE,		0x02
.equ GDT_CODE_SEGMENT,		0x18
.equ GDT_DATA_SEGMENT,		0x10



stage2_start:
	mov $boot_msg, %si
	mov $boot_msg_size, %cx
	call puts

	// NOTE:
	// QEMU and some other emulators will automaticlly
	// set the A20 line as enabled. To verify that it was
	// Check for 0xAA55 at 0x7DFE and 0xFFFFE0E. If both
	// values are identical then A20 may not be enabled


halt:
	cli
	hlt





puts:
	pusha
	mov $COM1, %dx

_puts_loop:
	lodsb
	out %al, %dx
	dec %cx
	cmp $0, %cx
	jne _puts_loop
	
_puts_done:
	popa
	ret





boot_msg:
	.asciz "\r\nHelixBoot (stage2) v0.0.1\n"

boot_msg_size = . - boot_msg






gdt_start:
	// Initial NULL descriptor
	.long 0x00000000
	.long 0x00000000

gdt_code:
	.word 0xFFFF	/* Limit low (bits 0 - 15) */
	.word 0x0		/* Base low (bits 0 - 15) */
	.long 0x0		/* Base middle (bits 16 - 23) */
	.long 
	.long
	.long

gdt_data:
	.word
	.word
	.long
	.long
	.long
	.long

gdt_end:

gdt_desc:
	.word gdt_end - gdt_start - 1
	.long gdt_start
