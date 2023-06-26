/*
 * file    iob_pmem
 * date    June 2023
 * 
 * brief   VGA Pseudo-Memory (PMEM)
*/
`timescale 1ns/1ps

`include "iob_lib.vh"
`include "iob_pmem_swreg_def.vh"

module iob_pmem # (
		parameter DATA_W = 32,        //PARAM & 32 & 64 & CPU data width
		parameter ADDR_W = `iob_pmem_swreg_ADDR_W 	//CPU address section width    
	) (
		//CPU interface
		`include "iob_s_if.vh"

		//additional inputs and outputs
		`IOB_INPUT(pmem_pixel_x, 10),
		`IOB_INPUT(pmem_pixel_y, 10),
		`IOB_INPUT(pmem_rst_btn, 1),

		`IOB_OUTPUT(pmem_rgb, 12),
		
		`include "iob_gen_if.vh"
	);

	//BLOCK Register File & Configuration control and status register file.
	`include "iob_pmem_swreg_gen.vh"
	
	// HLEN == Half Length (total length desired divided by 2)
	// Must be the same as in GameUtils.h
	localparam BALL_X_HLEN = 3;
	localparam BALL_Y_HLEN = BALL_X_HLEN;
	localparam BAR_X_HLEN = 1;
	localparam BAR_Y_HLEN = 20;
	
	// Format of the _LOC registers (the ObjInfo struct in GameUtils.h)
	//struct ObjInfo {
    //	///////////////////////////////////////////
    //	// Hardware-accessible information
    //	// X coordinate
	//	unsigned int x:10;
    //	// Y coordinate
	//	unsigned int y:10;
    //	// Color of the object (12 bits, 4 per color)
    //	unsigned int rgb:12;
	//};

	wire [12-1:0] rgb;
	
	wire [32-1:0] ball_x;
	wire [32-1:0] ball_y;
	wire [32-1:0] ball_color;

	wire [32-1:0] barl_x;
	wire [32-1:0] barl_y;
	wire [32-1:0] barl_color;

	wire [32-1:0] barr_x;
	wire [32-1:0] barr_y;
	wire [32-1:0] barr_color;

	// SWRegs
	`IOB_WIRE(PMEM_BALL_LOC, 32)
	iob_reg #(.DATA_W(32))
	ball_loc (
		.clk        (clk),
		.arst       (rst),
		.rst        (rst),
		.en         (PMEM_BALL_LOC_en),
		.data_in    (PMEM_BALL_LOC_wdata),
		.data_out   (PMEM_BALL_LOC)
	);
	`IOB_WIRE(PMEM_BARL_LOC, 32)
	iob_reg #(.DATA_W(32))
	barl_loc (
		.clk        (clk),
		.arst       (rst),
		.rst        (rst),
		.en         (PMEM_BARL_LOC_en),
		.data_in    (PMEM_BARL_LOC_wdata),
		.data_out   (PMEM_BARL_LOC)
	);
	`IOB_WIRE(PMEM_BARR_LOC, 32)
	iob_reg #(.DATA_W(32))
	barr_loc (
		.clk        (clk),
		.arst       (rst),
		.rst        (rst),
		.en         (PMEM_BARR_LOC_en),
		.data_in    (PMEM_BARR_LOC_wdata),
		.data_out   (PMEM_BARR_LOC)
	);
	
	assign ball_x =     {22'b0, PMEM_BALL_LOC[9:0]};
	assign ball_y =     {22'b0, PMEM_BALL_LOC[19:10]};
	assign ball_color = {20'b0, PMEM_BALL_LOC[31:20]};

	assign barl_x =     {22'b0, PMEM_BARL_LOC[9:0]};
	assign barl_y =     {22'b0, PMEM_BARL_LOC[19:10]};
	assign barl_color = {20'b0, PMEM_BARL_LOC[31:20]};

	assign barr_x =     {22'b0, PMEM_BARR_LOC[9:0]};
	assign barr_y =     {22'b0, PMEM_BARR_LOC[19:10]};
	assign barr_color = {20'b0, PMEM_BARR_LOC[31:20]};

	// White when pixel is in the ball or bars, black otherwise.
	assign rgb = (pmem_pixel_x >= ball_x - BALL_X_HLEN && pmem_pixel_x <= ball_x + BALL_X_HLEN) && (pmem_pixel_y >= ball_y - BALL_Y_HLEN && pmem_pixel_y <= ball_y + BALL_Y_HLEN) ? ball_color :
				 (pmem_pixel_x >= barr_x - BAR_X_HLEN  && pmem_pixel_x <= barr_x + BAR_X_HLEN)  && (pmem_pixel_y >= barr_y - BAR_Y_HLEN  && pmem_pixel_y <= barr_y + BAR_Y_HLEN)  ? barr_color :
				 (pmem_pixel_x >= barl_x - BAR_X_HLEN  && pmem_pixel_x <= barl_x + BAR_X_HLEN)  && (pmem_pixel_y >= barl_y - BAR_Y_HLEN  && pmem_pixel_y <= barl_y + BAR_Y_HLEN)  ? barl_color :
				 12'b0;

	// Read Switch
	assign PMEM_RST_BTN_rdata = {7'b0, pmem_rst_btn};

	// Outputs
	assign pmem_rgb = rgb;

endmodule // iob_pmem
