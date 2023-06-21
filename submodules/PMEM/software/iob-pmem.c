#include <stdint.h>

#include "iob-pmem.h"

//PMEM functions

//Set PMEM base address
void pmem_init(int base_address) {
	IOB_PMEM_INIT_BASEADDR(base_address);
}

//Set values on outputs
void pmem_set_ball_loc(uint32_t value) {
	IOB_PMEM_SET_BALL_LOC(value);
}
void pmem_set_barl_loc(uint32_t value) {
	IOB_PMEM_SET_BARL_LOC(value);
}
void pmem_set_barr_loc(uint32_t value) {
	IOB_PMEM_SET_BARR_LOC(value);
}

// Get values from inputs
uint32_t pmem_get_sw_input() {
	return IOB_PMEM_GET_SW_INPUT();
}
