#include "system.h"
#include "periphs.h"
#include "iob-uart.h"
#include "iob-im.h"
#include "printf.h"

#define BALL_X_LEN 7
#define BALL_Y_LEN BALL_X_LEN
#define BAR_X_LEN 3
#define BAR_Y_LEN 20

#define BALL_INFO 0
#define BARL_INFO 1
#define BARR_INFO 2

char *send_string = "Sending this string as a file to console.\n"
                    "The file is then requested back from console.\n"
                    "The sent file is compared to the received file to confirm " 
                    "correct file transfer via UART using console.\n"
                    "Generating the file in the firmware creates an uniform "
                    "file transfer between pc-emul, simulation and fpga without"
                    " adding extra targets for file generation.\n";

// copy src to dst
// return number of copied chars (excluding '\0')
int string_copy(char *dst, char *src) {
    if (dst == NULL || src == NULL) {
        return -1;
    }
    int cnt = 0;
    while(src[cnt] != 0){
        dst[cnt] = src[cnt];
        cnt++;
    }
    dst[cnt] = '\0';
    return cnt;
}

// 0: same string
// otherwise: different
int compare_str(char *str1, char *str2, int str_size) {
    int c = 0;
    while(c < str_size) {
        if (str1[c] != str2[c]){
            return str1[c] - str2[c];
        }
        c++;
    }
    return 0;
}


struct ObjInfo {
    unsigned int x:10;
    unsigned int y:10;
    unsigned int unused:12;
} __attribute__((packed));

// Ball, BarL, BarR (indexes in macros)
struct ObjInfo objs[3] = {0};

void setCoords(int obj, int x, int y) {
    int obj_x_len = 0;
    int obj_y_len = 0;
    
    if (BALL_INFO == obj) {
        obj_x_len = BALL_X_LEN;
        obj_y_len = BALL_Y_LEN;
    } else {
        obj_x_len = BAR_X_LEN;
        obj_y_len = BAR_Y_LEN;
    }
    
    int new_x = 0;
    int new_y = 0;

    if (x - obj_x_len < 0 || x + obj_x_len > 639) {
        new_x = objs[obj].x; // Keep old x
    } else {
        new_x = x;
    }
    if (y - obj_y_len < 0 || y + obj_y_len > 479) {
        new_y = objs[obj].y; // Keep old y
    } else {
        new_y = y;
    }

    int new_info = new_x | (new_y << 10);

    if (BALL_INFO == obj) {
        im_set_ball_loc(new_info);
    } else if (BARL_INFO == obj) {
        im_set_barl_loc(new_info);
    } else if (BARR_INFO == obj) {
        im_set_barr_loc(new_info);
    }
    objs[obj].x = new_x;
    objs[obj].y = new_y;
}

int main() {
    uart_init(UART_BASE,FREQ/BAUD); //init uart
    uart_puts("//------------------------\\\\\n");

    im_init(IM_BASE);


    setCoords(BALL_INFO, 320, 239);    
    setCoords(BARL_INFO, 20, 239);
    setCoords(BARR_INFO, 620, 239);
    
    int prev_sw_state = im_get_sw_input();
  
    while (true) {
        if (prev_sw_state != im_get_sw_input()) {
            prev_sw_state = im_get_sw_input();

            ball_x++;
            ball_y++;
            setCoords(BALL_INFO, ball_x, ball_y);
            barl_x++;
            barl_y++;
            setCoords(BARL_INFO, barl_x, barl_y);
            barr_x++;
            barr_y++;
            setCoords(BARR_INFO, barr_x, barr_y);
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
