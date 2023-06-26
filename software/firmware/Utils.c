#include "iob-timer.h"

void sleep(uint64_t ms) {
	uint64_t init_time = timer_time_ms();
	while (timer_time_ms() - init_time < ms) {
		// Do nothing
	}
}
