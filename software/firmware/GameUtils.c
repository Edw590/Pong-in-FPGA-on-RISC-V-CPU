#include <stdbool.h>
#include "printf.h"	// todo Remove this
#include "iob-im.h"
#include "iob-nesctrl.h"
#include "GameUtils.h"

// Must be the same as in iob-im.v (HL == Half Length)
#define BALL_X_HLEN 3
#define BALL_Y_HLEN BALL_X_HLEN
#define BAR_X_HLEN 1
#define BAR_Y_HLEN 20

#define BALL_VELOCITY 1

#define MAX_BOUNCE_ANGLE 75

void resetGame(struct ObjInfo *objs_info, struct PlayerBarInfo *players_bars_info) {
	// Set the object types
    objs_info[OBJ_BALL].what_obj = OBJ_BALL;
	objs_info[OBJ_BARL].what_obj = OBJ_BARL;
	objs_info[OBJ_BARR].what_obj = OBJ_BARR;
	objs_info[OBJ_BALL].vx = BALL_VELOCITY;

	// todo Set these randomly!
	objs_info[OBJ_BALL].vy = BALL_VELOCITY;
	objs_info[OBJ_BALL].vx_sign = 0;
	objs_info[OBJ_BALL].vy_sign = 0;
	
	uint32_t obj_info_raw = *((uint32_t *) objs_info[OBJ_BALL]);
	im_set_ball_loc(obj_info_raw);
	uint32_t obj_info_raw = *((uint32_t *) objs_info[OBJ_BARL]);
	im_set_barl_loc(obj_info_raw);
	uint32_t obj_info_raw = *((uint32_t *) objs_info[OBJ_BARR]);
	im_set_barr_loc(obj_info_raw);

	players_bars_info[PLAYER_1].player_num = PLAYER_1;
	players_bars_info[PLAYER_1].what_bar = OBJ_BARL;
    players_bars_info[PLAYER_1].bar_info = &objs_info[OBJ_BARL];
	players_bars_info[PLAYER_1].get_ctrl_data = &nesctrl_get_ctrl1_data;
	players_bars_info[PLAYER_2].player_num = PLAYER_2;
	players_bars_info[PLAYER_2].what_bar = OBJ_BARR;
    players_bars_info[PLAYER_2].bar_info = &objs_info[OBJ_BARR];
	players_bars_info[PLAYER_2].get_ctrl_data = &nesctrl_get_ctrl2_data;

	// Set the initial coordinates (ball in the middle, bars on the sides)
	// todo Set the ball's coordinates randomly! (in part - with a margin from the edges)
	setCoords(&objs_info[OBJ_BALL], 320, 239);
	setCoords(&objs_info[OBJ_BARL], 20, 239);
	setCoords(&objs_info[OBJ_BARR], 620, 239);
}

void moveBall(struct ObjInfo *objs_info) {
	struct ObjInfo *ball_info = &objs_info[OBJ_BALL];

	int vx_sign_real = (ball_info->vx_sign > 0) ? 1 : -1;
	int vy_sign_real = (ball_info->vy_sign > 0) ? 1 : -1;
	int x = ball_info->x;
	int y = ball_info->y;

    // Update location
	x += vx_sign_real*ball_info->vx;
	y += vy_sign_real*ball_info->vy;

	setCoords(ball_info, x, y);

    if ((y - BALL_Y_HLEN < 0) | (y + BALL_Y_HLEN > MAX_Y)) {
		// Invert the sign of the Y velocity
		ball_info->vy_sign = vy_sign_real > 0 ? 0 : 1;
	}

	// fixme Goal on player. Ball is not supposed to bounce off the side walls.
    if ((x - BALL_X_HLEN < 0) | (x + BALL_X_HLEN > MAX_X)) {
		// Invert the sign of the X velocity
		ball_info->vx_sign = vx_sign_real > 0 ? 0 : 1;
    }

	// Check if the ball hits the paddles
	int bar_hit = -1;
	for (int i = OBJ_BARL; i <= OBJ_BARR; ++i) {
		if ((x-BALL_X_HLEN == objs_info[i].x+BAR_X_HLEN || x+BALL_X_HLEN == objs_info[i].x-BAR_X_HLEN) &&
				y-BALL_Y_HLEN <= objs_info[i].y+BAR_Y_HLEN && y+BALL_Y_HLEN >= objs_info[i].y-BAR_Y_HLEN) {
			bar_hit = i;

			break;
		}
	}

	if (bar_hit != -1) {
		int min_bar_y = objs_info[bar_hit].y - BAR_Y_HLEN;
		int max_bar_y = objs_info[bar_hit].y + BAR_Y_HLEN;
		int one_third_bar_y = min_bar_y + BAR_Y_HLEN/3;
		int two_third_bar_y = min_bar_y + 2*(BAR_Y_HLEN/3);

		if (OBJ_BARL == bar_hit) {
			ball_info->vx_sign = 1;
		} else {
			ball_info->vx_sign = 0;
		}

		if (y >= min_bar_y && y < one_third_bar_y) {
			ball_info->vy_sign = 0;
		} else if (y >= one_third_bar_y && y < two_third_bar_y) {
			ball_info->vy = 0;
		} else if (y >= two_third_bar_y && y <= max_bar_y) {
			ball_info->vy_sign = 1;
		}
	}
	
	uint32_t ball_info_raw = *((uint32_t *) ball_info);
	im_set_ball_loc(ball_info_raw);
}

void setCoords(struct ObjInfo *obj_info, unsigned x, unsigned y) {
    unsigned what_obj = obj_info->what_obj;
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

	obj_info->x = new_x;
	obj_info->y = new_y;

	uint32_t obj_info_raw = *((uint32_t *) obj_info);
	if (OBJ_BALL == what_obj) {
		im_set_ball_loc(obj_info_raw);
	} else if (OBJ_BARL == what_obj) {
		im_set_barl_loc(obj_info_raw);
	} else if (OBJ_BARR == what_obj) {
		im_set_barr_loc(obj_info_raw);
	}
}
