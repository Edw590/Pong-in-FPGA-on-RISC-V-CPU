#include "iob-im.h"
#include "GameUtils.h"

// Must be the same as in iob-im.v (HL == Half Length)
#define BALL_X_HLEN 7
#define BALL_Y_HLEN BALL_X_HLEN
#define BAR_X_HLEN 3
#define BAR_Y_HLEN 20

#define OBJ_BALL 0
#define OBJ_BARL 1
#define OBJ_BARR 2

void prepareObjs(struct ObjInfo *ball_info, struct ObjInfo *balr_info, struct ObjInfo *barr_info) {
	// Set the object types
	(*ball_info).what_obj = OBJ_BALL;
	(*balr_info).what_obj = OBJ_BARL;
	(*barr_info).what_obj = OBJ_BARR;

	// Set the initial coordinates (ball in the middle, bars on the sides)
	setCoords(ball_info, 320, 239);
	setCoords(balr_info, 20, 239);
	setCoords(barr_info, 620, 239);
}

void setCoords(struct ObjInfo *obj_info, int x, int y) {
	int what_obj = (*obj_info).what_obj;
	int obj_x_hlen = 0;
	int obj_y_hlen = 0;
	
	if (OBJ_BALL == what_obj) {
		obj_x_hlen = BALL_X_HLEN;
		obj_y_hlen = BALL_Y_HLEN;
	} else {
		obj_x_hlen = BAR_X_HLEN;
		obj_y_hlen = BAR_Y_HLEN;
	}
	
	int new_x = 0;
	int new_y = 0;

	if (x - obj_x_hlen < 0) {
		new_x = 0;
	} else if (x + obj_x_hlen > MAX_COORD_X) {
		new_x = MAX_COORD_X;
	} else {
		new_x = x;
	}
	if (y - obj_y_hlen < 0) {
		new_y = 0;
	} else if (y + obj_y_hlen > MAX_COORD_Y) {
		new_y = MAX_COORD_Y;
	} else {
		new_y = y;
	}

	int new_info = new_x | (new_y << 10) | (what_obj << 20);

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
