#include <stdbool.h>

#include "iob_nesctrl_swreg.h"

// NESCTRL functions

//Set NESCTRL base address
void nesctrl_init(int base_address);

// Get values from inputs
uint8_t nesctrl_get_ctrl1_data();
uint8_t nesctrl_get_ctrl2_data();
