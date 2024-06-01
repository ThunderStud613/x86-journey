ENTRY(_start)




SECTIONS
{
	. = 0x7C00;

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
