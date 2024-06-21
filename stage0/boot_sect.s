.code16
.org 0x00, 0x00
.global _start



_start:
    jmp main
    nop


/* BIOS parameter block based off:
 * https://github.com/lattera/freebsd/blob/master/sys/boot/i386/boot2/boot1.S
 */

.org 0x03, 0x00
oemid:          .ascii "HBOOT   "
bytes_per_sect: .word 512
sect_per_clust: .byte 1
num_sect:       .word 1
num_fats:       .byte 2	
num_root_ents:  .word 224
num_small_sect: .word 2880
drive_type:     .byte 0xF0
sect_per_fat:   .word 9
sect_per_track: .word 18
num_heads:      .word 2
hidden_sect:    .long 0
large_sect:     .long 0
                .byte 0
boot_sig:       .byte 0x29
serial_number:  .word 0
volume_label:   .ascii "HelixBoot  "
fstype:         .ascii "FAT12   "






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

    

	// Jump to stage2 bootloader
	//jmp 0x7E00

boot_fail:
	jmp halt


halt:
	cli
	hlt
	jmp halt

stage2:
    .ascii "helix_boot bin"


.fill 510 - (. - _start), 1, 0
.word 0xAA55
