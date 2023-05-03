   //
   // IM
   //

   iob_im im
     (
      .clk     (clk),
      .rst     (rst),

      // Registers interface
      .im_sw_input (im_sw_input),
      .im_pixel_x (im_pixel_x),
      .im_pixel_y (im_pixel_y),
      .im_rgb (im_rgb),      

      // CPU interface
      .valid   (slaves_req[`valid(`IM)]),
      .address (slaves_req[`address(`IM,`iob_im_swreg_ADDR_W+2)-2]),
      .wdata   (slaves_req[`wdata(`IM)]),
      .wstrb   (slaves_req[`wstrb(`IM)]),
      .rdata   (slaves_resp[`rdata(`IM)]),
      .ready   (slaves_resp[`ready(`IM)])
      );
