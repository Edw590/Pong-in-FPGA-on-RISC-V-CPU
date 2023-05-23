#include <stdbool.h>
#include "iob-im.h"
#include "iob-nesctrl.h"
#include "GameUtils.h"

// Must be the same as in iob-im.v (HL == Half Length)
#define BALL_X_HLEN 7
#define BALL_Y_HLEN BALL_X_HLEN
#define BAR_X_HLEN 3
#define BAR_Y_HLEN 20

#define VELOCITY 1

void resetGame(struct ObjInfo *objs_info, struct PlayerBarInfo *players_bars_info) {
	// Set the object types
    objs_info[OBJ_BALL].what_obj = OBJ_BALL;
	objs_info[OBJ_BARL].what_obj = OBJ_BARL;
	objs_info[OBJ_BARR].what_obj = OBJ_BARR;
	objs_info[OBJ_BALL].vx = VELOCITY;
	objs_info[OBJ_BALL].vy = VELOCITY;
	// todo Set the signs randomly!
	objs_info[OBJ_BALL].vx_sign = 0;
	objs_info[OBJ_BALL].vy_sign = 0;

	players_bars_info[PLAYER_1].player_num = PLAYER_1;
	players_bars_info[PLAYER_1].what_bar = OBJ_BARL;
    players_bars_info[PLAYER_1].bar_info = &objs_info[OBJ_BARL];
	players_bars_info[PLAYER_1].get_ctrl_data = &nesctrl_get_ctrl1_data;
	players_bars_info[PLAYER_2].player_num = PLAYER_2;
	players_bars_info[PLAYER_2].what_bar = OBJ_BARR;
    players_bars_info[PLAYER_2].bar_info = &objs_info[OBJ_BARR];
	players_bars_info[PLAYER_2].get_ctrl_data = &nesctrl_get_ctrl2_data;

	// Set the initial coordinates (ball in the middle, bars on the sides)
	setCoords(&objs_info[OBJ_BALL], 320, 239);
	setCoords(&objs_info[OBJ_BARL], 20, 239);
	setCoords(&objs_info[OBJ_BARR], 620, 239);
}

void setCoords(struct ObjInfo *obj_info, unsigned x, unsigned y) {
    unsigned what_obj = (*obj_info).what_obj;
    unsigned obj_x_hlen = 0;
    unsigned obj_y_hlen = 0;

	if (OBJ_BALL == what_obj) {
		obj_x_hlen = BALL_X_HLEN;
		obj_y_hlen = BALL_Y_HLEN;
	} else {
		obj_x_hlen = BAR_X_HLEN;
		obj_y_hlen = BAR_Y_HLEN;
	}

	unsigned new_x = 0;
    unsigned new_y = 0;

	if (x < obj_x_hlen) {
		new_x = 0 + obj_x_hlen;
	} else if (x + obj_x_hlen > MAX_X) {
		new_x = MAX_X - obj_x_hlen;
	} else {
		new_x = x;
	}
	if (y < obj_y_hlen) {
		new_y = 0 + obj_y_hlen;
	} else if (y + obj_y_hlen > MAX_Y) {
		new_y = MAX_Y - obj_y_hlen;
	} else {
		new_y = y;
	}

    unsigned new_info = new_x | (new_y << 10) | (what_obj << 20);

	if (OBJ_BALL == what_obj) {
		im_set_ball_loc(new_info);
	} else if (OBJ_BARL == what_obj) {
		im_set_barl_loc(new_info);
	} else if (OBJ_BARR == what_obj) {
		im_set_barr_loc(new_info);
	}

	(*obj_info).x = new_x;
	(*obj_info).y = new_y;
}
