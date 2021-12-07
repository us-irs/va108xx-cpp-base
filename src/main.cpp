#include "segger_rtt.h"
#include "VORConfig.h"

#include <cstdio>
#include <cstddef>

int main(void) {
#ifdef VOR_RTT_LOG
    // Initialize Segger RTT
    SEGGER_RTT_Init();
    SEGGER_RTT_ConfigUpBuffer(0, NULL, NULL, 0, SEGGER_RTT_MODE_NO_BLOCK_TRIM);
#endif

    printf("Hello World!\n");
    for(;;) {}
}
