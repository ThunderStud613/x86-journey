.code16
.global _start



.equ COM1,	0x3F8
.equ STAGE2_BASE,	0x7E00



_start:
	cli
	cld

	// Initialize segment registers
	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss

	// Initialize stack and data segment
	mov $0x7C00, %ax
	mov %ax, %sp
	sti

	// Print boot message
	mov $boot_msg, %si
	mov $boot_msg_size, %cx
	call puts

	// Load stage2
	call stage2_load

	// Jump to stage2 bootloader
	//jmp 0x7E00

boot_fail:
	// If we reach here assume somthing got fucked
	// up and halt the system
	jmp halt




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


stage2_load:
	pusha
	push %dx

	mov $0x02, %ah	/* Read function */
	mov $0x01, %al	/* Number of sectors to read */
	mov $0x00, %ch	/* Cylinder */
	mov $0x02, %cl	/* Sector */
	mov $0x00, %dh	/* Head */
	mov $0x00, %dl	/* Drive number */

	// Read to 0x7E00
	movw $0x0000, %bx
	mov %bx, %es
	movw $0x7E00, %bx

	// Read sector
	int $0x13
	jc stage2_err

	pop %dx
	popa
	ret


stage2_err:
	mov $disk_err, %si
	mov $disk_err_size, %cx
	jmp puts

	jmp halt


halt:
	cli
	hlt
	jmp halt



boot_msg:
	.asciz "\r\nHelixBoot v0.0.1\n"

boot_msg_size = . - boot_msg

disk_err:
	.asciz "\r\nDisk error!\n"

disk_err_size = . - disk_err


.fill 510 - (. - _start), 1, 0
.word 0xAA55
