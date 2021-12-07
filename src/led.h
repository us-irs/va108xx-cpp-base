#ifndef MISSION_UTILITY_LED_H_
#define MISSION_UTILITY_LED_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    LED_D2 = 1 << 10,
    LED_D3 = 1 << 7,
    LED_D4 = 1 << 6
} Leds;

void initAllBuiltinLeds();

void enableLedClock();

// Initiate LEDs. Does not enable PORT A clock
void initLed(Leds led);

void setLed(Leds led);
void clearLed(Leds led);
void toggleLed(Leds led);

#ifdef __cplusplus
}
#endif

#endif /* MISSION_UTILITY_LED_H_ */
