#include <stdbool.h>
#include "printf.h"
#include "iob-timer.h"
#include "iob-pmem.h"
#include "iob-nesctrl.h"
#include "GameUtils.h"
#include "Utils.h"

// Must be the same as in iob-pmem.v (HL == Half Length)
#define BALL_X_HLEN 3
#define BALL_Y_HLEN BALL_X_HLEN
#define BAR_X_HLEN 1
#define BAR_Y_HLEN 20

#define BALL_Y_LEN (BALL_Y_HLEN*2+1)
#define BAR_Y_LEN (BAR_Y_HLEN*2+1)

static void setObjCoords(struct ObjInfo *obj_info, int x, int y);
static void setLOCRegister(struct ObjInfo *obj_info);

void prepareGame(struct ObjInfo *objs_info, struct PlayerBarInfo *players_bars_info) {
	// Set the object types
    objs_info[OBJ_BALL].what_obj = OBJ_BALL;
	objs_info[OBJ_BARL].what_obj = OBJ_BARL;
	objs_info[OBJ_BARR].what_obj = OBJ_BARR;
	objs_info[OBJ_BALL].vx = SPEED_NORMAL;

	// Set the initial bar colors
	objs_info[OBJ_BARL].rgb = 0xF00; // Red
	objs_info[OBJ_BARR].rgb = 0x0F0; // Green

    setLOCRegister(&objs_info[OBJ_BALL]);
    setLOCRegister(&objs_info[OBJ_BARL]);
    setLOCRegister(&objs_info[OBJ_BARR]);

	players_bars_info[PLAYER_1].player_num = PLAYER_1;
    players_bars_info[PLAYER_1].bar_info = &objs_info[OBJ_BARL];
	players_bars_info[PLAYER_1].get_ctrl_data = &nesctrl_get_ctrl1_data;
	players_bars_info[PLAYER_2].player_num = PLAYER_2;
    players_bars_info[PLAYER_2].bar_info = &objs_info[OBJ_BARR];
	players_bars_info[PLAYER_2].get_ctrl_data = &nesctrl_get_ctrl2_data;

	// Set the initial bars coordinates (on the sides)
	setObjCoords(&objs_info[OBJ_BARL], 20, 239);
	setObjCoords(&objs_info[OBJ_BARR], 620, 239);

	resetBall(objs_info);
}

void resetBall(struct ObjInfo *ball_info) {
	// Set the initial ball color
	ball_info->rgb = 0xFFF; // White
	setLOCRegister(ball_info);

	// Set the initial ball velocity directions and Y speed randomly
	ball_info->vy = timer_time_ms() % 2 == 0 ? SPEED_NORMAL : SPEED_NONE;
	ball_info->vx_direction = timer_time_ms() % 3 == 0 ? X_SPEED_RIGHT : X_SPEED_LEFT;
	ball_info->vy_direction = timer_time_ms() % 5 == 0 ? Y_SPEED_UP : Y_SPEED_DOWN;

	// Set the initial ball coordinates (in the center)
	// todo Set the ball's coordinates randomly! (in part - with a margin from the edges)
	setObjCoords(ball_info, 320, 239);
}

void moveObjs(struct ObjInfo *objs_info) {
	struct ObjInfo *ball_info = &objs_info[OBJ_BALL];

	int vx_sign = 0;
	int vy_sign = 0;
    int x = 0;
    int y = 0;
	// Last object on the loop must be the ball (what's below the loop expects its values on the variables above)
	for (int i = OBJ_BARR; i >= OBJ_BALL; --i) {
		struct ObjInfo *obj_info = &objs_info[i];
		vx_sign = (X_SPEED_LEFT == obj_info->vx_direction) ? -1 : 1;
		vy_sign = (Y_SPEED_UP == obj_info->vy_direction) ? -1 : 1;
		x = obj_info->x;
		y = obj_info->y;

		// Update location
		x += vx_sign*obj_info->vx;
		y += vy_sign*obj_info->vy;
        setObjCoords(obj_info, x, y);
	}

    if ((y - BALL_Y_HLEN < 0) || (y + BALL_Y_HLEN > MAX_Y)) {
		// Invert the sign of the Y velocity
		ball_info->vy_direction = (vy_sign > 0) ? Y_SPEED_UP : Y_SPEED_DOWN;
	}

    if ((x - BALL_X_HLEN < 0) || (x + BALL_X_HLEN > MAX_X)) {
		unsigned int bar_color = 0;
		if (x - BALL_X_HLEN < 0) {
			bar_color = objs_info[OBJ_BARR].rgb;
		} else {
			bar_color = objs_info[OBJ_BARL].rgb;
		}
		objs_info[OBJ_BALL].rgb = bar_color;
    	setLOCRegister(ball_info);

		sleep(1000);

		resetBall(ball_info);
	}

	// Check if the ball hits the paddles
	int bar_hit = -1;
	for (int i = OBJ_BARL; i <= OBJ_BARR; ++i) {
		if ((x-BALL_X_HLEN <= objs_info[i].x+BAR_X_HLEN && x+BALL_X_HLEN >= objs_info[i].x-BAR_X_HLEN) &&
				(y-BALL_Y_HLEN <= objs_info[i].y+BAR_Y_HLEN && y+BALL_Y_HLEN >= objs_info[i].y-BAR_Y_HLEN)) {
			bar_hit = i;

			break;
		}
	}
	if (bar_hit != -1) {
		int min_bar_y = objs_info[bar_hit].y - BAR_Y_HLEN;
		int max_bar_y = objs_info[bar_hit].y + BAR_Y_HLEN;
		int one_third_bar_y = min_bar_y + (int) (BAR_Y_LEN/3.0) + 2;
		int two_third_bar_y = min_bar_y + (int) (2.0*(BAR_Y_LEN/3.0)) - 2;

		// Don't just invert the sign - if the ball hits in the middle of the bottom pixels of the bars, it will never
		// leave the bar unless the bar moves in the opposite direction.
		if (OBJ_BARL == bar_hit) {
            ball_info->vx_direction = X_SPEED_RIGHT;
        } else {
			ball_info->vx_direction = X_SPEED_LEFT;
		}

		if (ball_info->vy_direction == objs_info[bar_hit].vy_direction && SPEED_FAST == objs_info[bar_hit].vy) {
			ball_info->vy = SPEED_FAST;
			ball_info->vx = SPEED_FAST;
		} else {
			ball_info->vy = SPEED_NORMAL;
			ball_info->vx = SPEED_NORMAL;
		}
		if (y >= min_bar_y - BALL_Y_HLEN && y <= one_third_bar_y) {
			ball_info->vy_direction = Y_SPEED_UP;
		} else if (y >= two_third_bar_y && y <= max_bar_y + BALL_Y_HLEN) {
			ball_info->vy_direction = Y_SPEED_DOWN;
		} else {
			ball_info->vy = SPEED_NONE;
		}
	}

    setLOCRegister(ball_info);
    setLOCRegister(&objs_info[OBJ_BARL]);
    setLOCRegister(&objs_info[OBJ_BARR]);
}

/**
 * Set the coordinates of the provided object.
 *
 * If the object cannot be moved to the new coordinate (out of range - out of screen resolutions), it will be set to 0
 * or to the corresponding MAX_* macro depending on if it's lower than the minimum (0) or greater than the maximum,
 * respectively.
 *
 * @param obj_info pointer to the struct with the object to move
 * @param x the new x coordinate
 * @param y the new y coordinate
 */
static void setObjCoords(struct ObjInfo *obj_info, int x, int y) {
    unsigned what_obj = obj_info->what_obj;
    int obj_x_hlen = 0;
    int obj_y_hlen = 0;

	if (OBJ_BALL == what_obj) {
		obj_x_hlen = BALL_X_HLEN;
		obj_y_hlen = BALL_Y_HLEN;
	} else {
		obj_x_hlen = BAR_X_HLEN;
		obj_y_hlen = BAR_Y_HLEN;
	}

	int new_x = x;
    int new_y = y;

	if (x < obj_x_hlen) {
		new_x = 0 + obj_x_hlen;
	} else if (x + obj_x_hlen > MAX_X) {
		new_x = MAX_X - obj_x_hlen;
	}
	if (y < obj_y_hlen) {
		new_y = 0 + obj_y_hlen;
	} else if (y + obj_y_hlen > MAX_Y) {
		new_y = MAX_Y - obj_y_hlen;
	}

    // Safe to cast to unsigned (small numbers)
	obj_info->x = (unsigned) new_x;
	obj_info->y = (unsigned) new_y;

    setLOCRegister(obj_info);
}

/**
 * Set the _LOC register of the provided object with the provided information.
 *
 * @param obj_info pointer to the struct with the object
 */
static void setLOCRegister(struct ObjInfo *obj_info) {
    unsigned what_obj = obj_info->what_obj;
    uint32_t obj_info_raw = *((uint32_t *) obj_info); // Only the first 32 bits are used on the _LOC registers
    if (OBJ_BALL == what_obj) {
        pmem_set_ball_loc(obj_info_raw);
    } else if (OBJ_BARL == what_obj) {
        pmem_set_barl_loc(obj_info_raw);
    } else if (OBJ_BARR == what_obj) {
        pmem_set_barr_loc(obj_info_raw);
    }
}
