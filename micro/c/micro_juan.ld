ENTRY(_start)

SECTIONS
{
 	. = 0x00000;			/* Ubicación de la RAM*/
	.data 	: { *(.data) 	}
	.bss 	: { *(.bss) 	} 
	. = 0x30000;			/* Ubicación de la memoria de programa*/
	.text 	: { *(.text) 	}	 
}
