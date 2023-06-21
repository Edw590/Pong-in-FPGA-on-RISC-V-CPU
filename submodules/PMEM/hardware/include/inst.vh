   //
   // PMEM
   //

   iob_pmem pmem
     (
      .clk     (clk),
      .rst     (rst),

      // Registers interface
      .pmem_sw_input       (pmem_sw_input),
      .pmem_pixel_x        (pmem_pixel_x),
      .pmem_pixel_y        (pmem_pixel_y),
      .pmem_rgb            (pmem_rgb),

      // CPU interface
      .valid   (slaves_req[`valid(`PMEM)]),
      .address (slaves_req[`address(`PMEM,`iob_pmem_swreg_ADDR_W+2)-2]),
      .wdata   (slaves_req[`wdata(`PMEM)]),
      .wstrb   (slaves_req[`wstrb(`PMEM)]),
      .rdata   (slaves_resp[`rdata(`PMEM)]),
      .ready   (slaves_resp[`ready(`PMEM)])
      );
