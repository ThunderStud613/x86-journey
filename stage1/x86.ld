ENTRY(stage2_start)




SECTIONS
{
	. = 0x7E00;

	.text : {
		*(.text*)
	}

	.data : {
		*(.data*)
	}

	.rodata : {
		*(.rodata*)
	}

	.bss (NOLOAD) : {
		*(.bss*)
		*(COMMON)
	}
}
