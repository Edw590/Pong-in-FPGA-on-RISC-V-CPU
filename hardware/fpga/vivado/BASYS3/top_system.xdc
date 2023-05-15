# ----------------------------------------------------------------------------
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/
# ----------------------------------------------------------------------------
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2009 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------

## System Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# System Reset
set_property PACKAGE_PIN T17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

create_clock -period 10.000 [get_ports clk]

## USB-UART Interface
set_property PACKAGE_PIN B18 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_property PACKAGE_PIN A18 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]


##VGA Connector
set_property PACKAGE_PIN G19 [get_ports {Red[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Red[0]}]
set_property PACKAGE_PIN H19 [get_ports {Red[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Red[1]}]
set_property PACKAGE_PIN J19 [get_ports {Red[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Red[2]}]
set_property PACKAGE_PIN N19 [get_ports {Red[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Red[3]}]
set_property PACKAGE_PIN N18 [get_ports {Blue[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Blue[0]}]
set_property PACKAGE_PIN L18 [get_ports {Blue[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Blue[1]}]
set_property PACKAGE_PIN K18 [get_ports {Blue[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Blue[2]}]
set_property PACKAGE_PIN J18 [get_ports {Blue[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Blue[3]}]
set_property PACKAGE_PIN J17 [get_ports {Green[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Green[0]}]
set_property PACKAGE_PIN H17 [get_ports {Green[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Green[1]}]
set_property PACKAGE_PIN G17 [get_ports {Green[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Green[2]}]
set_property PACKAGE_PIN D17 [get_ports {Green[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {Green[3]}]
set_property PACKAGE_PIN P19 [get_ports h_sync]						
	set_property IOSTANDARD LVCMOS33 [get_ports h_sync]
set_property PACKAGE_PIN R19 [get_ports v_sync]						
	set_property IOSTANDARD LVCMOS33 [get_ports v_sync]

## IM
set_property PACKAGE_PIN U18 [get_ports {im_sw_input}]
  set_property IOSTANDARD LVCMOS33 [get_ports {im_sw_input}]

set_property PACKAGE_PIN G2 [get_ports {clk_out}]
  set_property IOSTANDARD LVCMOS33 [get_ports {clk_out}]
set_property PACKAGE_PIN J2 [get_ports {nesctrl_pl}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_pl}]
set_property PACKAGE_PIN L2 [get_ports {nesctrl_ctrl1_q7}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl1_q7}]

set_property PACKAGE_PIN N2 [get_ports {clk_out}]
  set_property IOSTANDARD LVCMOS33 [get_ports {clk_out}]
set_property PACKAGE_PIN M2 [get_ports {nesctrl_pl}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_pl}]
set_property PACKAGE_PIN L3 [get_ports {nesctrl_ctrl2_q7}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_q7}]
