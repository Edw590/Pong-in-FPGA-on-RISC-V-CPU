#include <stdbool.h>

#include "iob_pmem_swreg.h"

//PMEM functions

//Set PMEM base address
void pmem_init(int base_address);

// Set values
void pmem_set_ball_loc(uint32_t value);
void pmem_set_barl_loc(uint32_t value);
void pmem_set_barr_loc(uint32_t value);

// Get values from inputs
uint32_t pmem_get_rst_btn();
