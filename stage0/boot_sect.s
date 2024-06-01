.code16
.global _start



.equ STAGE2_BASE,	0x7E00




_start:
	cli
	cld

	// Preserve drive number
	mov %di, %ax
	mov $boot_drv, %bx
	mov %ax, 0(%bx)

	// Initialize segment registers
	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss

	// Initialize stack and data segment
	mov $0x7C00, %ax
	mov %ax, %sp
	sti

	mov $boot_drv, %bx

halt:
	cli
	hlt
	jmp halt

boot_drv:
	.byte 0x00


.fill 510 - (. - _start), 1, 0
.word 0xAA55
