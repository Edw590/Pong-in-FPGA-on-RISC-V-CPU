#define MAX_COORD_X 639
#define MAX_COORD_Y 479

struct ObjInfo {
	unsigned int x:10;
	unsigned int y:10;
	unsigned int what_obj:2;
	unsigned int unused:10;
} __attribute__((packed));

void prepareObjs(struct ObjInfo *ball_info, struct ObjInfo *balr_info, struct ObjInfo *barr_info);
void setCoords(struct ObjInfo *obj, int x, int y);
