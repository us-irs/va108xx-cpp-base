/******************************************************************************
 * This linker file was developed from the example file included in the GCC download.
 *  <..>\GCC_install\gcc-arm-none-eabi-7-2017-q4-major-win32\share\gcc-arm-none-eabi\samples\ldscripts
 * 
 * The author is not responsible for any
 * damage or liability that this file might cause.
******************************************************************************/
 
 /*   Modified for VA108xx MCU: 
            Cortex M0 based  
            128k byte of Instruction space RAM at 0x0000:0000  
            32k byte of Data space RAM at 0x1000:0000
            
            Part boots from external SPI NVM.  
            For code development the debugger loads RAM directly. 
*/
 
/* Entry Point */
ENTRY(Reset_Handler)
 
/* Specify the memory areas */
MEMORY
{
	ROM (rx)      : ORIGIN = 0x00002000, LENGTH = 0xEFFD /* 61437 bytes*/
	RAM (xrw)     : ORIGIN = 0x10000000, LENGTH = 0x08000 /*32K*/
}
 
/* define stack size and heap size here */
stack_size = 1024;  
heap_size = 512;
 
/* define beginning and ending of stack */
_stack_start = ORIGIN(RAM) + LENGTH(RAM) - 4;
_stack_end = _stack_start - stack_size;
 
/* Define output sections */
SECTIONS
{
 	.text :
	{
		. = ALIGN(4); 
		KEEP(*(.isr_vector))
		*(.text*)
		
		
		KEEP(*(.init))
		KEEP(*(.fini))
		
		*(.rodata)         /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
		KEEP(*(.eh_frame*))
	} > ROM

	.preinit_array ALIGN(4): {
        __preinit_array_start = .;
        KEEP(*(.preinit_array))
        __preinit_array_end = .;
    	} >ROM

    .init_array ALIGN(4): {
        __init_array_start = .;
        KEEP(*(.init_array))
        __init_array_end = .;
    } >ROM

    .fini_array ALIGN(4): {
        __fini_array_start = .;
        KEEP(*(.fini_array))
        __fini_array_end = .;
    } >ROM
    
 	/* used for unwinding, can be useful for debugging  */  
   .ARM.extab   :   
   { 
		*(.ARM.extab* .gnu.linkonce.armextab.*) 
   } >ROM
   
   /* used for unwinding, can be useful for debugging  */  
	__exidx_start = .;
    .ARM.exidx (NOLOAD) : 
    {
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} >ROM
    __exidx_end = .;

 
 	__etext = .  ;  
 
  /* can be used by the startup to initialize data */
 
	_sidata = .;   

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data : AT ( _sidata )
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
 
    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM
 
  /* Uninitialized data section */
  . = ALIGN(4);
  .bss :  /*  basic service set:  used for statically-allocated variables  */  
  {
    /*  Used by the startup in order to initialize the .bss section */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)
 
    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM
 
    . = ALIGN(4);
    .heap :
    {
    	 _heap_start = .;
    	 end = _heap_start;
    	 _end = end;
    	 __end = end; 
    	 . = . + heap_size;
    } > RAM
 

    . = _stack_end;
    .stack :
    {
        . = . + stack_size;
    } > RAM
 
    /* Remove information from the standard libraries */

 
    /DISCARD/ :
    {
        libc.a ( * )
        libm.a ( * )
        libgcc.a ( * )
    }
   
 
    .ARM.attributes 0 : { *(.ARM.attributes) }
}