#include "segger_rtt.h"
#include "VORConfig.h"
#include "va108xx.h"
#include "led.h"

#include <cstdio>
#include <cstddef>

int main(void) {
    VOR_SYSCONFIG->PERIPHERAL_CLK_ENABLE |= CLK_ENABLE_SYSTEM;
#ifdef VOR_RTT_LOG
    // Initialize Segger RTT
    SEGGER_RTT_Init();
    SEGGER_RTT_ConfigUpBuffer(0, NULL, NULL, 0, SEGGER_RTT_MODE_NO_BLOCK_TRIM);
#endif
    printf("Hello World!\n\r");
    initAllBuiltinLeds();

    for(;;) {
        for(size_t idx = 0; idx < 1000000; idx++) {}
        toggleLed(LED_D2);
        toggleLed(LED_D3);
        toggleLed(LED_D4);
    }
}
