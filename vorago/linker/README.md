### Linker scripts for the Cortex-M0 core

The va108xx_linker.ld is the generic linker to load the binary into the program RAM directly.

If two binaries are located inside the program memory for failure tolerance,  separate linker
files are needed to achieve correct ARM vectors.

The va108xx_linker_nvm_pos1.ld is used to generate a binary which is written to the non-volatile
memory of the Vorago at position 1. The code start address and IVT starts at 0x2000 instead of 0x0000.
