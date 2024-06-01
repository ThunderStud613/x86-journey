.code16
.global _start



.equ STAGE2_BASE,	0x7E00




_start:
	// Initialize segment registers
	cli
	cld

	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %gs
	mov %ax, %fs
	mov %ax, %ss

	// Initialize stack and data segment
	mov $0x7C00, %ax
	mov %ax, %sp
	sti

halt:
	cli
	hlt
	jmp halt



.fill 510 - (. - _start), 1, 0
.word 0xAA55
