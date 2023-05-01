#include "system.h"
#include "periphs.h"
#include "iob-uart.h"
#include "iob-im.h"
#include "printf.h"

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

struct RGB {
    int r:4;
    int g:4;
    int b:4;
} __attribute__((packed));

void setCoords(int object, int x, int y) {
    if (0 == object) {
        im_set_ball_loc(x | (y << 10));
    } else if (1 == object) {
        im_set_barl_loc(x | (y << 10));
    } else if (2 == object) {
        im_set_barr_loc(x | (y << 10));
    }
}

int main() {
    uart_init(UART_BASE,FREQ/BAUD); //init uart
    uart_puts("//------------------------\\\\\n");

    im_init(IM_BASE);

    int prev_sw_state = im_get_sw_input();

    int ball_x = 320;
    int ball_y = 239;
    setCoords(0, ball_x, ball_y);
    int barl_x = 20;
    int barl_y = 239;
    setCoords(1, barl_x, barl_y);
    int barr_x = 620;
    int barr_y = 239;
    setCoords(2, barr_x, barr_y);
    
    while (true) {
        if (prev_sw_state != im_get_sw_input()) {
            prev_sw_state = im_get_sw_input();

            ball_x++;
            ball_y++;
            setCoords(0, ball_x, ball_y);
            barl_x++;
            barl_y++;
            setCoords(1, barl_x, barl_y);
            barr_x++;
            barr_y++;
            setCoords(2, barr_x, barr_y);
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
