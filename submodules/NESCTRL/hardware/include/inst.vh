   //
   // NESCTRL
   //

   iob_nesctrl nesctrl
     (
      .clk     (clk),
      .rst     (rst),

      // Registers interface
      .nesctrl_ctrl1_q7     (nesctrl_ctrl1_q7),
      .nesctrl_ctrl2_q7     (nesctrl_ctrl2_q7),
      .nesctrl_pl1          (nesctrl_pl1),
      .nesctrl_pl2          (nesctrl_pl2),
      .nesctrl_clk1         (nesctrl_clk1),
      .nesctrl_clk2         (nesctrl_clk2),
      .nesctrl_ctrl1_data   (nesctrl_ctrl1_data),
      .nesctrl_ctrl2_data   (nesctrl_ctrl2_data),

      // CPU interface
      .valid   (slaves_req[`valid(`NESCTRL)]),
      .address (slaves_req[`address(`NESCTRL,`iob_nesctrl_swreg_ADDR_W+2)-2]),
      .wdata   (slaves_req[`wdata(`NESCTRL)]),
      .wstrb   (slaves_req[`wstrb(`NESCTRL)]),
      .rdata   (slaves_resp[`rdata(`NESCTRL)]),
      .ready   (slaves_resp[`ready(`NESCTRL)])
      );
