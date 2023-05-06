#include <stdint.h>

#include "iob-im.h"

//IM functions

//Set IM base address
void im_init(int base_address) {
	IOB_IM_INIT_BASEADDR(base_address);
}

//Set values on outputs
void im_set_ball_loc(uint32_t value) {
	IOB_IM_SET_BALL_LOC(value);
}
void im_set_barl_loc(uint32_t value) {
	IOB_IM_SET_BARL_LOC(value);
}
void im_set_barr_loc(uint32_t value) {
	IOB_IM_SET_BARR_LOC(value);
}

// Get values from inputs
uint32_t im_get_sw_input() {
	return IOB_IM_GET_SW_INPUT();
}
uint32_t im_get_ctrl1_data() {
	return IOB_IM_GET_CTRL1_DATA();
}
uint32_t im_get_ctrl2_data() {
	return IOB_IM_GET_CTRL2_DATA();
}
