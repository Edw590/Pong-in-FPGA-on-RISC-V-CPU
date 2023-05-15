#include <stdbool.h>
#include "system.h"
#include "periphs.h"
#include "printf.h"
#include "iob-uart.h"
#include "iob-im.h"
#include "iob-timer.h"
#include "iob-nesctrl.h"
#include "CtrlUtils.h"
#include "GameUtils.h"
#include "Utils.h"

struct ObjInfo objs_info[3] = {0};

struct PlayerBarInfo players_bars_info[2] = {0};

int main() {
	struct ObjInfo *ball_info = &objs_info[OBJ_BALL];
	struct ObjInfo *barl_info = &objs_info[OBJ_BARL];
	struct ObjInfo *barr_info = &objs_info[OBJ_BARR];
	//struct PlayerBarInfo *player_1_bar = &players_bars_info[0];
	//struct PlayerBarInfo *player_2_bar = &players_bars_info[1];

	uart_init(UART_BASE, FREQ/BAUD);
	uart_puts("//------------------------\\\\\n");


	im_init(IM_BASE);
	timer_init(TIMER_BASE);

	resetGame(objs_info, players_bars_info);

	//int prev_sw_state = (int) im_get_sw_input();

	while (true) {
		if (im_get_sw_input() != 0) {
			//prev_sw_state = im_get_sw_input();

			setCoords(ball_info, ball_info->x+1, ball_info->y+1);
			setCoords(barl_info, barl_info->x+1, barl_info->y+1);
			setCoords(barr_info, barr_info->x+1, barr_info->y+1);
		}

		for (int i = 0; i < 2; i++) {
			unsigned short ctrl_data = (unsigned short) players_bars_info[i].get_ctrl_data();
			if ((ctrl_data & READY) != 0 && ((ctrl_data & BTN_DOWN) != 0 || (ctrl_data & BTN_UP) != 0)) {
				struct ObjInfo *bar_info = players_bars_info[i].bar_info;
				int ctrl_speed = (ctrl_data & BTN_AA) != 0 ? FAST_SPEED : NORMAL_SPEED;
				if ((ctrl_data & BTN_DOWN) != 0) {
					ctrl_speed = -ctrl_speed;
				}
				setCoords(bar_info, bar_info->x, bar_info->y + ctrl_speed);
			}
		}

		sleep(5);
	}


	uart_puts("\\\\------------------------//\n");
	uart_finish();
}
