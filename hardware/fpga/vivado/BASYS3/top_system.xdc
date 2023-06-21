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


## VGA Connector
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


## PMEM
set_property PACKAGE_PIN U18 [get_ports {pmem_sw_input}]
  set_property IOSTANDARD LVCMOS33 [get_ports {pmem_sw_input}]


## NES Controllers

# Controller 1
set_property PACKAGE_PIN P18 [get_ports {nesctrl_clk1}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_clk1}]
set_property PACKAGE_PIN N17 [get_ports {nesctrl_pl1}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_pl1}]
set_property PACKAGE_PIN M18 [get_ports {nesctrl_ctrl1_q7}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl1_q7}]

# Controller 2
set_property PACKAGE_PIN B16 [get_ports {nesctrl_clk2}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_clk2}]
set_property PACKAGE_PIN B15 [get_ports {nesctrl_pl2}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_pl2}]
set_property PACKAGE_PIN A16 [get_ports {nesctrl_ctrl2_q7}]
  set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_q7}]

set_property PACKAGE_PIN U16 [get_ports {nesctrl_ctrl2_data[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[0]}]
set_property PACKAGE_PIN E19 [get_ports {nesctrl_ctrl2_data[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[1]}]
set_property PACKAGE_PIN U19 [get_ports {nesctrl_ctrl2_data[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[2]}]
set_property PACKAGE_PIN V19 [get_ports {nesctrl_ctrl2_data[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[3]}]
set_property PACKAGE_PIN W18 [get_ports {nesctrl_ctrl2_data[4]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[4]}]
set_property PACKAGE_PIN U15 [get_ports {nesctrl_ctrl2_data[5]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[5]}]
set_property PACKAGE_PIN U14 [get_ports {nesctrl_ctrl2_data[6]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[6]}]
set_property PACKAGE_PIN V14 [get_ports {nesctrl_ctrl2_data[7]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {nesctrl_ctrl2_data[7]}]
