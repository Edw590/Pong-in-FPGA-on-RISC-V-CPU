#include <stdbool.h>

#include "iob_im_swreg.h"

//IM functions

//Set IM base address
void im_init(int base_address);

//Set image memory source
void im_set_ball_loc(uint32_t value);
void im_set_barl_loc(uint32_t value);
void im_set_barr_loc(uint32_t value);

// Get values from inputs
uint32_t im_get_sw_input();
