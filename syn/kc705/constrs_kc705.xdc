## Clock

# PadFunction: IO_L12P_T1_MRCC_33
set_property IOSTANDARD DIFF_SSTL15 [get_ports CLK200_P]

# PadFunction: IO_L12N_T1_MRCC_33
set_property IOSTANDARD DIFF_SSTL15 [get_ports CLK200_N]
set_property PACKAGE_PIN AD12 [get_ports CLK200_P]
set_property PACKAGE_PIN AD11 [get_ports CLK200_N]

# Bank: 115 - MGTREFCLK1N_115

# Bank: 115 - MGTREFCLK1P_115

set_property IOSTANDARD LVCMOS25 [get_ports sys_rst_n_i]
set_property PACKAGE_PIN G25 [get_ports sys_rst_n_i]

set_property LOC GTXE2_CHANNEL_X0Y7 [get_cells {pcie_0/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
set_property PACKAGE_PIN M6 [get_ports {PCIE_RXP[0]}]
set_property PACKAGE_PIN M5 [get_ports {PCIE_RXN[0]}]
set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells {pcie_0/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[1].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
set_property PACKAGE_PIN P6 [get_ports {PCIE_RXP[1]}]
set_property PACKAGE_PIN P5 [get_ports {PCIE_RXN[1]}]
set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells {pcie_0/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[2].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
set_property PACKAGE_PIN R4 [get_ports {PCIE_RXP[2]}]
set_property PACKAGE_PIN R3 [get_ports {PCIE_RXN[2]}]
set_property LOC GTXE2_CHANNEL_X0Y4 [get_cells {pcie_0/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[3].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
set_property PACKAGE_PIN T5 [get_ports {PCIE_RXN[3]}]
set_property PACKAGE_PIN T6 [get_ports {PCIE_RXP[3]}]

## GPIO PUSHBUTTON SW

# Bank: 18 - IO_0_18
# set_property PACKAGE_PIN G12 [get_ports PUSH_SW_C]
# set_property IOSTANDARD LVCMOS25 [get_ports PUSH_SW_C]
set_property PACKAGE_PIN G12 [get_ports rst_i]
set_property IOSTANDARD LVCMOS25 [get_ports rst_i]

# Bank: 34 - IO_L12N_T1_MRCC_34
# set_property PACKAGE_PIN AG5 [get_ports PUSH_SW_E]
# set_property IOSTANDARD LVCMOS15 [get_ports PUSH_SW_E]

# Bank: 33 - IO_L1P_T0_33
# set_property PACKAGE_PIN AA12 [get_ports PUSH_SW_N]
# set_property IOSTANDARD LVCMOS15 [get_ports PUSH_SW_N]

# Bank: 33 - IO_L1N_T0_33
# set_property PACKAGE_PIN AB12 [get_ports PUSH_SW_S]
# set_property IOSTANDARD LVCMOS15 [get_ports PUSH_SW_S]

# Bank: 34 - IO_0_VRN_34
# set_property PACKAGE_PIN AC6 [get_ports PUSH_SW_W]
# set_property IOSTANDARD LVCMOS15 [get_ports PUSH_SW_W]

# Bank: 34 - IO_25_VRP_34
# set_property PACKAGE_PIN AB7 [get_ports CPU_RESET]
# set_property IOSTANDARD LVCMOS15 [get_ports CPU_RESET]

## GPIO DIP_SW

# Bank: 13 - IO_L4N_T0_13
set_property PACKAGE_PIN Y29 [get_ports {DIP_SW[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {DIP_SW[0]}]

# Bank: 13 - IO_L4P_T0_13
set_property PACKAGE_PIN W29 [get_ports {DIP_SW[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {DIP_SW[1]}]

# Bank: 13 - IO_L3N_T0_DQS_13
set_property PACKAGE_PIN AA28 [get_ports {DIP_SW[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {DIP_SW[2]}]

# Bank: 13 - IO_L3P_T0_DQS_13
# set_property PACKAGE_PIN Y28 [get_ports {DIP_SW[3]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {DIP_SW[3]}]

## GPIO LEDs

# Bank: 33 - GPIO_LED_0_LS
set_property DRIVE 12 [get_ports {LEDS[0]}]
set_property SLEW SLOW [get_ports {LEDS[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN AB8 [get_ports {LEDS[0]}]

# Bank: 33 - GPIO_LED_1_LS
set_property DRIVE 12 [get_ports {LEDS[1]}]
set_property SLEW SLOW [get_ports {LEDS[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LEDS[1]}]
set_property PACKAGE_PIN AA8 [get_ports {LEDS[1]}]

# Bank: 33 - GPIO_LED_2_LS
set_property DRIVE 12 [get_ports {LEDS[2]}]
set_property SLEW SLOW [get_ports {LEDS[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LEDS[2]}]
set_property PACKAGE_PIN AC9 [get_ports {LEDS[2]}]

# Bank: 33 - GPIO_LED_3_LS
set_property DRIVE 12 [get_ports {LEDS[3]}]
set_property SLEW SLOW [get_ports {LEDS[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LEDS[3]}]
set_property PACKAGE_PIN AB9 [get_ports {LEDS[3]}]

# Bank: 13 - GPIO_LED_4_LS
set_property DRIVE 12 [get_ports {LEDS[4]}]
set_property SLEW SLOW [get_ports {LEDS[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LEDS[4]}]
set_property PACKAGE_PIN AE26 [get_ports {LEDS[4]}]

# Bank: 17 - GPIO_LED_5_LS
set_property DRIVE 12 [get_ports {LEDS[5]}]
set_property SLEW SLOW [get_ports {LEDS[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LEDS[5]}]
set_property PACKAGE_PIN G19 [get_ports {LEDS[5]}]

# Bank: 17 - GPIO_LED_6_LS
set_property DRIVE 12 [get_ports {LEDS[6]}]
set_property SLEW SLOW [get_ports {LEDS[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LEDS[6]}]
set_property PACKAGE_PIN E18 [get_ports {LEDS[6]}]

# Bank: 18 - GPIO_LED_7_LS
set_property DRIVE 12 [get_ports {LEDS[7]}]
set_property SLEW SLOW [get_ports {LEDS[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LEDS[7]}]
set_property PACKAGE_PIN F16 [get_ports {LEDS[7]}]

## GPIO USER SMA

# Bank: 12 - IO_L1P_T0_12
set_property PACKAGE_PIN Y24 [get_ports SMA_N]
set_property IOSTANDARD LVCMOS25 [get_ports SMA_N]

# Bank: 12 - IO_L1N_T0_12
set_property PACKAGE_PIN Y23 [get_ports SMA_P]
set_property IOSTANDARD LVCMOS25 [get_ports SMA_P]

set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[0].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[1].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[2].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[3].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[4].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[5].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[6].cmp_fei4_rx_channel/D[7]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[0]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[1]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[2]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[3]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[4]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[5]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[6]}]
set_property MARK_DEBUG true [get_nets {app_0/wb_dev_gen.cmp_wb_rx_core/rx_channels[7].cmp_fei4_rx_channel/D[7]}]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
