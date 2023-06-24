#include "CtrlUtils.h"

bool isBtnPressed(uint8_t ctrl_data, uint8_t button) {
	return (ctrl_data & button) != 0;
}

bool isCtrlConnected(uint8_t ctrl_data) {
	// If all the buttons are being pressed, assume the controller is not connected (when it's not connected, it's like
	// all buttons are pressed according to the pin settings on the XDC file (pulldown) - 0xFF is returned).

	return ctrl_data != 0xFF;
}
