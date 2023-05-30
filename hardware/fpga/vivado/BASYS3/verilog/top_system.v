`timescale 1ns / 1ps
`include "system.vh"

module top_system(
	          input         clk,
	          input         reset,

	          // UART
	          output        uart_txd,
	          input         uart_rxd,

            // VGA
            output 	     v_sync,
            output 	     h_sync,
            output [3:0] Red,
            output [3:0] Green,
            output [3:0] Blue,

            // IM
	          input         im_sw_input,

            // NESCTRL
	          input         nesctrl_ctrl1_q7,
	          input         nesctrl_ctrl2_q7,
            output [16-1:0]   nesctrl_ctrl1_data,
	          output        nesctrl_pl,
	          output        nesctrl_clk
            );
      
         wire [9:0] 	   pixel_x;
         wire [9:0] 	   pixel_y;
         wire [11:0] 	   rgb;

   //
   // RESET MANAGEMENT
   //

   //system reset
         
   wire                         sys_rst;

   reg [15:0] 			rst_cnt;
   reg                          sys_rst_int;

   always @(posedge clk, posedge reset)
     if(reset) begin
        sys_rst_int <= 1'b0;
        rst_cnt <= 16'hFFFF;
     end else begin
        if(rst_cnt != 16'h0)
          rst_cnt <= rst_cnt - 1'b1;
        sys_rst_int <= (rst_cnt != 16'h0);
     end

   assign sys_rst = sys_rst_int;

   //
   // SYSTEM
   //
   system system
     (
      .clk           (clk),
      .rst           (sys_rst),
      .trap          (trap),

      // UART
      .uart_txd      (uart_txd),
      .uart_rxd      (uart_rxd),
      .uart_rts      (),
      .uart_cts      (1'b1),

      // VGA
      .rgb           (rgb),
      .v_sync        (v_sync),
      .h_sync        (h_sync),
      .Red           (Red),
      .Green         (Green),
      .Blue          (Blue),
      .pixel_x       (pixel_x),
      .pixel_y       (pixel_y),

      // IM
      .im_pixel_x        (pixel_x),
      .im_pixel_y        (pixel_y),
      .im_rgb            (rgb),
      .im_sw_input       (im_sw_input),
      
      // NESCTRL
      .nesctrl_ctrl1_data  (nesctrl_ctrl1_data),
      .nesctrl_ctrl1_q7  (nesctrl_ctrl1_q7),
      .nesctrl_ctrl2_q7  (nesctrl_ctrl2_q7),
      .nesctrl_pl        (nesctrl_pl),
      .nesctrl_clk       (nesctrl_clk)
      );

endmodule
