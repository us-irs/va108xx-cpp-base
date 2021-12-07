#include "led.h"
#include "va108xx.h"

void initAllBuiltinLeds() {
    enableLedClock();
    initLed(LED_D2);
    initLed(LED_D3);
    initLed(LED_D4);
}

void enableLedClock() {
    /* Enable LED peripheral clock */
    VOR_SYSCONFIG->PERIPHERAL_CLK_ENABLE |= ( CLK_ENABLE_PORTA | CLK_ENABLE_GPIO );
}

void initLed(Leds led) {
    VOR_GPIO->BANK[0].DIR |= led;
}

void clearLed(Leds led) {
    VOR_GPIO->BANK[0].CLROUT = led;
}

void toggleLed(Leds led) {
    VOR_GPIO->BANK[0].TOGOUT = led;
}

void setLed(Leds led) {
    VOR_GPIO->BANK[0].SETOUT = led;
}
