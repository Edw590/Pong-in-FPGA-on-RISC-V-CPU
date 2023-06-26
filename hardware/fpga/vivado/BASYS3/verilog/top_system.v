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

            // PMEM
	          input         pmem_rst_btn,

            // NESCTRL
	          input         nesctrl_ctrl1_q7,
	          input         nesctrl_ctrl2_q7,
            //output [8-1:0]   nesctrl_ctrl1_data,
            //output [8-1:0]   nesctrl_ctrl2_data,
	          output        nesctrl_pl1,
	          output        nesctrl_pl2,
	          output        nesctrl_clk1,
	          output        nesctrl_clk2
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

      // PMEM
      .pmem_pixel_x        (pixel_x),
      .pmem_pixel_y        (pixel_y),
      .pmem_rgb            (rgb),
      .pmem_rst_btn        (pmem_rst_btn),
      
      // NESCTRL
      //.nesctrl_ctrl1_data  (nesctrl_ctrl1_data),
      //.nesctrl_ctrl2_data  (nesctrl_ctrl2_data),
      .nesctrl_ctrl1_q7    (nesctrl_ctrl1_q7),
      .nesctrl_ctrl2_q7    (nesctrl_ctrl2_q7),
      .nesctrl_pl1         (nesctrl_pl1),
      .nesctrl_pl2         (nesctrl_pl2),
      .nesctrl_clk1        (nesctrl_clk1),
      .nesctrl_clk2        (nesctrl_clk2)
      );

endmodule
