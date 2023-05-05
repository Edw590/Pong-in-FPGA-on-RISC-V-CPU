#include "system.h"
#include "periphs.h"
#include "iob-uart.h"
#include "iob-im.h"
#include "printf.h"
#include "GameUtils.h"

struct ObjInfo ball_info = {0};
struct ObjInfo balr_info = {0};
struct ObjInfo barr_info = {0};

int main() {
	uart_init(UART_BASE,FREQ/BAUD);
	uart_puts("//------------------------\\\\\n");

	im_init(IM_BASE);

	prepareObjs(&ball_info, &balr_info, &barr_info);
	
	int prev_sw_state = im_get_sw_input();
  
	while (true) {
		if (prev_sw_state != im_get_sw_input()) {
			prev_sw_state = im_get_sw_input();

			setCoords(&ball_info, ball_info.x+1, ball_info.y+1);
			setCoords(&balr_info, balr_info.x+1, balr_info.y+1);
			setCoords(&barr_info, barr_info.x+1, barr_info.y+1);
		}
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
