#include <stdint.h>

#define MAX_X 639
#define MAX_Y 479

#define OBJ_BALL 0
#define OBJ_BARL 1
#define OBJ_BARR 2

#define SPEED_NONE 0
#define SPEED_NORMAL 1
#define SPEED_FAST 2

#define Y_SPEED_UP 0
#define Y_SPEED_DOWN 1
#define X_SPEED_LEFT 0
#define X_SPEED_RIGHT 1

#define NUM_PLAYERS 2
#define PLAYER_1 0
#define PLAYER_2 1

/**
 * Struct with the format of the _LOC software-accessible registers on the first 32 bits (the size of the registers),
 * containing the information of the ball and the 2 bars. Easier with bit fields than with shifts.
 *
 * On the 2nd 32 bits, the information is not used by the hardware, but it's used by the software to keep track of the
 * objects' positions and velocities.
 */
struct ObjInfo {
    ///////////////////////////////////////////
    // Hardware-accessible information
    // X coordinate
	unsigned int x:10;
    // Y coordinate
	unsigned int y:10;
    // Color of the object (12 bits, 4 per color)
    unsigned int rgb:12;

    ///////////////////////////////////////////
    // Software-only information
    // What object the instance represents (one of the OBJ_* macros)
	unsigned int what_obj:2;
	// Velocity (pixels/frame) in the X axis
    unsigned int vx:2;
	// Velocity (pixels/frame) in the Y axis
    unsigned int vy:2;
	// Sign of the velocity in the X axis (1 for positive, 0 for negative)
    unsigned int vx_direction:1;
	// Sign of the velocity in the Y axis (1 for positive, 0 for negative)
    unsigned int vy_direction:1;
    // (Currently?) unused bits - keep the struct size at a multiple of 32 bits for correct alignment because of the
    // cast to uint32_t (try to prevent UB)
    unsigned int unused:24;
};

/**
 * Struct with the information of a player's controlled bar.
 */
struct PlayerBarInfo {
	// Player number (one of the PLAYER_* macros)
    int player_num;
	// Pointer to the bar's struct
    struct ObjInfo *bar_info;
	// Pointer to the function that gets the controller data (one of the nesctrl_get_ctrl* functions)
    uint8_t (*get_ctrl_data)();
};

/**
 * Prepares/resets the game.
 *
 * @param objs_info pointer to the objects array
 * @param players_bars_info pointer to the players' bars array
 */
void prepareGame(struct ObjInfo *objs_info, struct PlayerBarInfo *players_bars_info);


/**
 * Reset the ball with initial positions, random directions and original color.
 *
 * @param ball_info pointer to the ball's struct
 */
void resetBall(struct ObjInfo *ball_info);

/**
 * Moves the ball and the 2 bars across the screen while simulating their physics.
 *
 * No object can go past the borders and the ball will bounce off the bars and the screen's borders and will get the
 * color of the bar of the player that scored a point.
 *
 * @param ball_info pointer to the ball's struct
*/
void moveObjs(struct ObjInfo *objs_info);
