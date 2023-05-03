`timescale 1ns / 1ps

module im_tb;
   
   parameter clk_frequency = 100e6; //100 MHz
   parameter clk_per = 1e9/clk_frequency;

   // CORE SIGNALS
   reg 			 clk;
   reg 			 rst;

   //imemory interface (frontend)
   reg [9:0] 		 im_pixel_x;
   reg [9:0] 		 im_pixel_y;
   reg [11:0] 	    im_rgb;
   			
   initial begin

      // Initialize Inputs
      clk = 1;
      rst = 1;
      

      // optional VCD
      `ifdef VCD
            $dumpfile("uut.vcd");
            $dumpvars();
      `endif

      // deassert hard reset
      #100 @(posedge clk) #1 rst = 0;
   end // initial begin

   // system clock
   always #(clk_per/2) clk = ~clk;

   // Instantiate the Unit Under Test (UUT)
   iob_im uut (
      .clk (clk),
      .isel (isel),
      .im_pixel_x (im_pixel_x),
      .im_pixel_y (im_pixel_y),
      .im_rgb (im_rgb)  
   );

endmodule // im_tb
