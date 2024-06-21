.code16
.org 0x00, 0x00
.global _start



_start:
    jmp main


/* BIOS parameter block taken from:
 * https://github.com/lattera/freebsd/blob/master/sys/boot/i386/boot2/boot1.S
 */

.org 0x03, 0x00
start_bpb:
    .byte 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41
    .word 512       /* Bytes per sector */
    .byte 1 		/* Sectors per cluster */
	.word 1	    	/* Number of sectors */
	.byte 2		    /* Number of FATS */
	.word 224	    /* Root entries */
	.word 2880	    /* Small sectors */
	.byte 0xF0	    /* Media type */
	.word 9		    /* Sectors per FAT */
	.word 18		/* Sectors per track */
	.word 2		    /* Number of heads */
	.long 0		    /* Hidden sectors */
	.long 0		    /* Large sectors */
    .byte 0         /* Drive number */ 
    .byte 0         /* Unused */
    .word 0         /* Serial number */
    .byte 0         /* Label */
    .byte 0x46, 0x41, 0x54, 0x31, 0x32  /* FS type */
end_bpb:




main:
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

	// Load stage2
	call stage2_load

	// Jump to stage2 bootloader
	jmp 0x7E00

boot_fail:
	// If we reach here assume somthing got fucked
	// up and halt the system
	jmp halt



stage2_load:
	pusha
	push %dx

	mov $0x02, %ah	/* Read function */
	mov $4, %al	    /* Number of sectors to read */
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
	jc halt

	pop %dx
	popa
	ret


halt:
	cli
	hlt
	jmp halt



.fill 510 - (. - _start), 1, 0
.word 0xAA55
