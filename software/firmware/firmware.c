#include "system.h"
#include "periphs.h"
#include "printf.h"
#include "iob-uart.h"
#include "iob-im.h"
#include "iob-timer.h"
#include "CtrlUtils.h"
#include "GameUtils.h"
#include "Utils.h"

struct ObjInfo ball_info = {0};
struct ObjInfo barl_info = {0};
struct ObjInfo barr_info = {0};

int main() {
	uart_init(UART_BASE, FREQ/BAUD);
	uart_puts("//------------------------\\\\\n");

	im_init(IM_BASE);
	timer_init(TIMER_BASE);

	prepareObjs(&ball_info, &barl_info, &barr_info);

	int prev_sw_state = im_get_sw_input();

	while (true) {
		if (prev_sw_state != im_get_sw_input()) {
			prev_sw_state = im_get_sw_input();

			setCoords(&ball_info, ball_info.x+1, ball_info.y+1);
			setCoords(&barl_info, barl_info.x+1, barl_info.y+1);
			setCoords(&barr_info, barr_info.x+1, barr_info.y+1);
		}

		int ctrl1_data = iob_im_get_ctrl1_data();
		if (ctrl1_data & BTN_UP != 0) {
			setCoords(&barl_info, barl_info.x, barl_info.y+1);
		} else if (ctrl1_data & BTN_DOWN != 0) {
			setCoords(&barl_info, barl_info.x, barl_info.y-1);
		}

		int ctrl2_data = iob_im_get_ctrl2_data();
		if (ctrl2_data & BTN_UP != 0) {
			setCoords(&barr_info, barr_info.x, barr_info.y+1);
		} else if (ctrl2_data & BTN_DOWN != 0) {
			setCoords(&barr_info, barr_info.x, barr_info.y-1);
		}

		sleep(1);
	}
	
	/*int color = 0;
	while (true) {
		for (int addr = 0; addr < 614400; addr++) {
			
			im_set_ball_loc(color);
			//im_set_barl_loc(i);
			//im_set_barr_loc(i);
			
			if (4096 == color) {
				color = 0;
			} else {
				color++;
			}
		}
	}*/


	uart_puts("\\\\------------------------//\n");

	uart_finish();
}
