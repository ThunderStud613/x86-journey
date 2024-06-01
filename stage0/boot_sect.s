.code16
.global _start



.equ COM1,	0x3F8
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

	mov $boot_msg, %si
	mov $boot_msg_size, %cx
	call puts

	jmp halt









putc:
	pusha

	mov $COM1, %dx
	out %al, %dx
	
	popa
	ret

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

halt:
	cli
	hlt
	jmp halt

boot_drv:
	.byte 0x00


boot_msg:
	.asciz "\r\nHelixBoot v0.0.1\n"

boot_msg_size = . - boot_msg


.fill 510 - (. - _start), 1, 0
.word 0xAA55
