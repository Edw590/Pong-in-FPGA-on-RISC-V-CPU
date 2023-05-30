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
	// Must be the same as in GameUtils.h
	localparam BALL_X_HLEN = 3;
	localparam BALL_Y_HLEN = BALL_X_HLEN;
	localparam BAR_X_HLEN = 1;
	localparam BAR_Y_HLEN = 20;
	
	// Format of the _LOC registers (the ObjInfo struct in GameUtils.h)
	//struct ObjInfo {
	//	// X coordinate
	//	unsigned int x:10;
	//	// Y coordinate
	//	unsigned int y:10;
	//	// What object the instance represents (one of the OBJ_* macros)
	//	unsigned int what_obj:2;
	//	// Velocity in the X axis (0 for no movement, 1 for movement)
	//	unsigned int vx:1;
	//	// Same as for the X axis, but for the Y axis
	//	unsigned int vy:1;
	//	// Sign of the velocity in the X axis (1 for positive, 0 for negative)
	//	unsigned int vx_sign:1;
	//	// Same as for the X axis, but for the Y axis
	//	unsigned int vy_sign:1;
	//	// (Currently) unused bits
	//	unsigned int unused:6;
	//};

	wire [12-1:0] rgb;
	wire [32-1:0] ball_x;
	wire [32-1:0] ball_y;
	wire [32-1:0] barl_x;
	wire [32-1:0] barl_y;
	wire [32-1:0] barr_x;
	wire [32-1:0] barr_y;

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
	
	assign ball_x = {22'b0, IM_BALL_LOC[9:0]};
	assign ball_y = {22'b0, IM_BALL_LOC[19:10]};

	assign barl_x = {22'b0, IM_BARL_LOC[9:0]};
	assign barl_y = {22'b0, IM_BARL_LOC[19:10]};

	assign barr_x = {22'b0, IM_BARR_LOC[9:0]};
	assign barr_y = {22'b0, IM_BARR_LOC[19:10]};

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
