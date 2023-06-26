#include "iob-timer.h"

void sleep(unsigned ms) {
	unsigned init_time = timer_time_ms();
	while (timer_time_ms() - init_time < ms) {
		// Do nothing
	}
}
