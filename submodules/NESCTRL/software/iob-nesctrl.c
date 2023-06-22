#include <stdint.h>

#include "iob-nesctrl.h"

//NESCTRL functions

//Set NESCTRL base address
void nesctrl_init(int base_address) {
	IOB_NESCTRL_INIT_BASEADDR(base_address);
}

//Set values on outputs

// Get values from inputs
uint8_t nesctrl_get_ctrl1_data() {
	return IOB_NESCTRL_GET_CTRL1_DATA();
}
uint8_t nesctrl_get_ctrl2_data() {
	return IOB_NESCTRL_GET_CTRL2_DATA();
}
