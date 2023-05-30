#include <stdint.h>

#define MAX_X 639
#define MAX_Y 479

#define OBJ_BALL 0
#define OBJ_BARL 1
#define OBJ_BARR 2

#define NORMAL_SPEED 1
#define FAST_SPEED 2

#define PLAYER_1 0
#define PLAYER_2 1

/**
 * Struct with the format of the *_LOC software-accessible registers, containing the information of the ball and the 2
 * bars. Easier with bit fields than with shifts. The size of the registers is 32 bits, and so is this struct's.
 */
struct ObjInfo {
    // X coordinate
	unsigned int x:10;
    // Y coordinate
	unsigned int y:10;
    // What object the instance represents (one of the OBJ_* macros)
	unsigned int what_obj:2;
	// Velocity in the X axis (0 for no movement, 1 for movement)
    unsigned int vx:1;
	// Velocity in the Y axis (0 for no movement, 1 for movement)
    unsigned int vy:1;
	// Sign of the velocity in the X axis (1 for positive, 0 for negative)
    unsigned int vx_sign:1;
	// Sign of the velocity in the Y axis (1 for positive, 0 for negative)
    unsigned int vy_sign:1;
    // (Currently) unused bits
	unsigned int unused:6;
};

/**
 * Struct with the information of a player's controlled bar.
 */
struct PlayerBarInfo {
	// Player number (one of the PLAYER_* macros)
    int player_num;
	// What bar the player controls (one of the OBJ_BAR* macros)
    int what_bar;
	// Pointer to the bar's struct
    struct ObjInfo *bar_info;
	// Pointer to the function that gets the controller data (one of the nesctrl_get_ctrl* functions)
    uint16_t (*get_ctrl_data)();
};

/**
 * Prepare and reset the entire game.
 *
 * @param objs_info pointer to the objects array
 * @param players_bars_info pointer to the players' bars array
 */
void resetGame(struct ObjInfo *objs_info, struct PlayerBarInfo *players_bars_info);
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
void setCoords(struct ObjInfo *obj_info, unsigned x, unsigned y);

/**	
 * Moves the ball across the screen while simulating its physics.
 * 
 * The ball will bounce off the bars and the screen's borders.
 * 
 * @param ball_info pointer to the ball's struct
*/
void moveBall(struct ObjInfo *ball_info);
