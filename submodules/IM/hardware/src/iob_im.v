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

   assign rgb = 12'b101010101010;

   // Read Switch
   assign IM_SW_INPUT_rdata = im_sw_input;

   // Outputs
   assign im_rgb = rgb;

endmodule // iob_im
