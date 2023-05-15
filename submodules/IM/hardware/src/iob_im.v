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
	
	// HLEN == Half Length (total length desired divided by 2)
	localparam BALL_X_HLEN = 7;
	localparam BALL_Y_HLEN = BALL_X_HLEN;
	localparam BAR_X_HLEN = 3;
	localparam BAR_Y_HLEN = 20;
	
	// To know the format of the _LOC registers, check the ObjInfo struct in GameUtils.h
	localparam MASK_X = 32'b00000000000000000000001111111111;
	localparam MASK_Y = 32'b00000000000011111111110000000000;

	reg [12-1:0] rgb;
	reg [32-1:0] ball_x;
	reg [32-1:0] ball_y;
	reg [32-1:0] barl_x;
	reg [32-1:0] barl_y;
	reg [32-1:0] barr_x;
	reg [32-1:0] barr_y;

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

	assign ball_x =  IM_BALL_LOC & MASK_X;
	assign ball_y = (IM_BALL_LOC & MASK_Y) >> 10;
	
	assign barl_x =  IM_BARL_LOC & MASK_X;
	assign barl_y = (IM_BARL_LOC & MASK_Y) >> 10;
	
	assign barr_x =  IM_BARR_LOC & MASK_X;
	assign barr_y = (IM_BARR_LOC & MASK_Y) >> 10;

	// White when pixel is in the ball or bars, black otherwise.
	assign rgb = (im_pixel_x >= ball_x - BALL_X_HLEN && im_pixel_x <= ball_x + BALL_X_HLEN) && (im_pixel_y >= ball_y - BALL_Y_HLEN && im_pixel_y <= ball_y + BALL_Y_HLEN) ||
				 (im_pixel_x >= barr_x - BAR_X_HLEN && im_pixel_x <= barr_x + BAR_X_HLEN) && (im_pixel_y >= barr_y - BAR_Y_HLEN && im_pixel_y <= barr_y + BAR_Y_HLEN) ||
				 (im_pixel_x >= barl_x - BAR_X_HLEN && im_pixel_x <= barl_x + BAR_X_HLEN) && (im_pixel_y >= barl_y - BAR_Y_HLEN && im_pixel_y <= barl_y + BAR_Y_HLEN)
				 ? 12'b111111111111 : 12'b0;

	// Read Switch
	assign IM_SW_INPUT_rdata = im_sw_input;

	// Outputs
	assign im_rgb = rgb;

endmodule // iob_im
