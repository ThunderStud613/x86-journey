.code16
.global _start



.equ COM1,	0x3F8
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
	mov %ax, %sp		// SP = 0x0000:0x7C00
	sti

	mov $'A', %al
	call putc

	jmp halt











// void putc(char ch); - print char to COM1
putc:
	pusha
	mov $COM1, %dx
	out %al, %dx
	popa
	ret

// void halt(void); - halt execution
halt:
	cli
	hlt
	jmp halt

boot_msg:
	.asciz "HelixBoot v0.0.1"

disk_load_err:
	.asciz "Disk load error!"

boot_err:
	.asciz "Boot error!"


.fill 510 - (. - _start), 1, 0
.word 0xAA55
