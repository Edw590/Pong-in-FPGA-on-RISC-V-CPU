#include <stdbool.h>
#include <stdint.h>

// Values to use in bitwise operations to get the status of each button on the controller.

#define BTN_A 1 << 0
#define BTN_B 1 << 1
#define BTN_START 1 << 2
#define BTN_SELECT 1 << 3
#define BTN_UP 1 << 4
#define BTN_DOWN 1 << 5
#define BTN_LEFT 1 << 6
#define BTN_RIGHT 1 << 7

/**
 * Checks if the button is being pressed on the given controller.
 *
 * @param ctrl_data the data read from the controller.
 * @param button the button to check - one of the BTN_-started constants.
 *
 * @return true if the button is being pressed, false otherwise.
*/
bool isBtnPressed(uint8_t ctrl_data, uint8_t button);

/**
 * Checks if the controller is connected.
 *
 * @param ctrl_data the data read from the controller.
 *
 * @return true if the controller is connected, false otherwise.
*/
bool isCtrlConnected(uint8_t ctrl_data);
