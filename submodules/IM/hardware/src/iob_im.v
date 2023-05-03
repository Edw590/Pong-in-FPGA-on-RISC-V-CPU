/*
 * file    iob_im
 * date    December 2022
 * 
 * brief   Image Memory (IM) driver Wrapper.
*/
`timescale 1ns/1ps

`include "iob_lib.vh"
`include "iob_im_swreg_def.vh"

module iob_im # (
      parameter DATA_W = 32,        //PARAM & 32 & 64 & CPU data width
      parameter ADDR_W = `iob_im_swreg_ADDR_W 	//CPU address section width    
   ) (
      //CPU interface
      `include "iob_s_if.vh"

      //additional inputs and outputs
      `IOB_INPUT(im_pixel_x, 10),
      `IOB_INPUT(im_pixel_y, 10),
      `IOB_INPUT(im_sw_input, 32),

      `IOB_OUTPUT(im_rgb, 12),
      
      `include "iob_gen_if.vh"
   );

   //BLOCK Register File & Configuration control and status register file.
   `include "iob_im_swreg_gen.vh"
   
   localparam BALL_X_LEN = 7;
   localparam BALL_Y_LEN = BALL_X_LEN;
   localparam BAR_X_LEN = 3;
   localparam BAR_Y_LEN = 20;

   reg [12-1:0] rgb;
   reg [32-1:0] curr_vec_pos;
   reg [32-1:0] im_ball_x;
   reg [32-1:0] im_ball_y;
   reg [32-1:0] im_barl_x;
   reg [32-1:0] im_barl_y;
   reg [32-1:0] im_barr_x;
   reg [32-1:0] im_barr_y;

   // SWRegs   
   `IOB_WIRE(IM_BALL_LOC, 32)
   iob_reg #(.DATA_W(32))
   ball_loc (
      .clk        (clk),
      .arst       (rst),
      .rst        (rst),
      .en         (IM_BALL_LOC_en),
      .data_in    (IM_BALL_LOC_wdata),
      .data_out   (IM_BALL_LOC)
   );
   
   `IOB_WIRE(IM_BARL_LOC, 32)
   iob_reg #(.DATA_W(32))
   barl_loc (
      .clk        (clk),
      .arst       (rst),
      .rst        (rst),
      .en         (IM_BARL_LOC_en),
      .data_in    (IM_BARL_LOC_wdata),
      .data_out   (IM_BARL_LOC)
   );
   
   `IOB_WIRE(IM_BARR_LOC, 32)
   iob_reg #(.DATA_W(32))
   barr_loc (
      .clk        (clk),
      .arst       (rst),
      .rst        (rst),
      .en         (IM_BARR_LOC_en),
      .data_in    (IM_BARR_LOC_wdata),
      .data_out   (IM_BARR_LOC)
   );

   //assign IM_BARR_LOC_wdata = 154560;
   //assign IM_BALL_LOC_wdata = 154560;
   //                   32'bxxxxxxxxxx_xxxxxxxxxx;
   //assign IM_BALL_LOC = 154560;
   //assign IM_BALL_LOC = 1281;
   //assign IM_BALL_LOC = 307840;

   assign curr_vec_pos = 640*im_pixel_y + im_pixel_x;

   // X stored in the first 10 bits of _LOC registers, Y stored in the next 10 bits.
   assign im_ball_x =  IM_BALL_LOC & 32'b00000000000000000000001111111111;
   assign im_ball_y = (IM_BALL_LOC & 32'b00000000000011111111110000000000) >> 10;
   
   assign im_barl_x =  IM_BARL_LOC & 32'b00000000000000000000001111111111;
   assign im_barl_y = (IM_BARL_LOC & 32'b00000000000011111111110000000000) >> 10;
   
   assign im_barr_x =  IM_BARR_LOC & 32'b00000000000000000000001111111111;
   assign im_barr_y = (IM_BARR_LOC & 32'b00000000000011111111110000000000) >> 10;

   assign rgb = (im_pixel_x >= im_ball_x - BALL_X_LEN && im_pixel_x <= im_ball_x + BALL_X_LEN) && (im_pixel_y >= im_ball_y - BALL_Y_LEN && im_pixel_y <= im_ball_y + BALL_Y_LEN) ||
                (im_pixel_x >= im_barr_x - BAR_X_LEN && im_pixel_x <= im_barr_x + BAR_X_LEN) && (im_pixel_y >= im_barr_y - BAR_Y_LEN && im_pixel_y <= im_barr_y + BAR_Y_LEN) ||
                (im_pixel_x >= im_barl_x - BAR_X_LEN && im_pixel_x <= im_barl_x + BAR_X_LEN) && (im_pixel_y >= im_barl_y - BAR_Y_LEN && im_pixel_y <= im_barl_y + BAR_Y_LEN)
                ? 12'b111111111111 : 12'b0;
   //assign rgb = curr_vec_pos == IM_BALL_LOC ? 12'b111111111111 : 12'b0;// (curr_vec_pos >= IM_BALL_LOC-25 && curr_vec_pos <= IM_BALL_LOC+25) ? 12'b111111111111 : 12'b0;

   // Read Switch
   assign IM_SW_INPUT_rdata = im_sw_input;

   // Outputs
   assign im_rgb = rgb;

endmodule // iob_im
