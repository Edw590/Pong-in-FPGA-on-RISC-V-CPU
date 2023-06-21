#include <stdbool.h>
#include "system.h"
#include "periphs.h"
#include "printf.h"
#include "iob-uart.h"
#include "iob-pmem.h"
#include "iob-timer.h"
#include "iob-nesctrl.h"
#include "CtrlUtils.h"
#include "GameUtils.h"
#include "Utils.h"

struct ObjInfo objs_info[3] = {0};

struct PlayerBarInfo players_bars_info[2] = {0};

int main(void) {
	uart_init(UART_BASE, FREQ/BAUD);
	pmem_init(PMEM_BASE);
	timer_init(TIMER_BASE);
	nesctrl_init(NESCTRL_BASE);
	uart_puts("//------------------------\\\\\n");
	/////////////////////////////////////////////////////////////

	resetGame(objs_info, players_bars_info);

	//goto skip;

	while (true) {
		// todo Explcar Pull down - porque é que os bits ficam a 0 quando o comando é desligado?
		if (pmem_get_sw_input() != 0) {
			// If the button U18 is pressed, reset the game
			// For tests only (doesn't work for some reason. The screen just gets black)
		
			resetGame(objs_info, players_bars_info);
		}

		for (int i = 0; i < NUM_PLAYERS; ++i) {
			uint8_t ctrl_data = players_bars_info[i].get_ctrl_data();
			if (!isCtrlConnected(ctrl_data)) {
				continue;
			}

			struct ObjInfo *bar_info = players_bars_info[i].bar_info;
			if (isBtnPressed(ctrl_data, BTN_DOWN) || isBtnPressed(ctrl_data, BTN_UP)) {
				unsigned ctrl_speed = isBtnPressed(ctrl_data, BTN_A) ? SPEED_FAST : SPEED_NORMAL;
				bar_info->vy_sign = isBtnPressed(ctrl_data, BTN_UP) ? Y_SPEED_UP : Y_SPEED_DOWN;
				bar_info->vy = ctrl_speed;
			} else {
				bar_info->vy = SPEED_NONE;
			}
		}

		moveObjs(objs_info);

		sleep(5);
	}

	//skip:


	uart_puts("\\\\------------------------//\n");
	uart_finish();

	return 0;
}
