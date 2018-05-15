##################################################################################################
## Controller 0
## Memory Device: DDR3_SDRAM->SODIMMs->MT8JTF12864HZ-1G6
## Data Width: 64
## Time Period: 1250
## Data Mask: 1
##################################################################################################

set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type2 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-2 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CONFIG_MODE BPI16 [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

# Set DCI_CASCADE
set_property DCI_CASCADE {32 34} [get_iobanks 33]
############## NET - IOSTANDARD ##################

# PadFunction: IO_L20P_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[0]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN AA15 [get_ports {ddr3_dq[0]}]

# PadFunction: IO_L23N_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[1]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN AA16 [get_ports {ddr3_dq[1]}]

# PadFunction: IO_L22P_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[2]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN AC14 [get_ports {ddr3_dq[2]}]

# PadFunction: IO_L22N_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[3]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN AD14 [get_ports {ddr3_dq[3]}]

# PadFunction: IO_L23P_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[4]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN AA17 [get_ports {ddr3_dq[4]}]

# PadFunction: IO_L20N_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[5]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN AB15 [get_ports {ddr3_dq[5]}]

# PadFunction: IO_L19P_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[6]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN AE15 [get_ports {ddr3_dq[6]}]

# PadFunction: IO_L24N_T3_32
set_property SLEW FAST [get_ports {ddr3_dq[7]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN Y15 [get_ports {ddr3_dq[7]}]

# PadFunction: IO_L17P_T2_32
set_property SLEW FAST [get_ports {ddr3_dq[8]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN AB19 [get_ports {ddr3_dq[8]}]

# PadFunction: IO_L14N_T2_SRCC_32
set_property SLEW FAST [get_ports {ddr3_dq[9]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN AD16 [get_ports {ddr3_dq[9]}]

# PadFunction: IO_L17N_T2_32
set_property SLEW FAST [get_ports {ddr3_dq[10]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN AC19 [get_ports {ddr3_dq[10]}]

# PadFunction: IO_L14P_T2_SRCC_32
set_property SLEW FAST [get_ports {ddr3_dq[11]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN AD17 [get_ports {ddr3_dq[11]}]

# PadFunction: IO_L16P_T2_32
set_property SLEW FAST [get_ports {ddr3_dq[12]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN AA18 [get_ports {ddr3_dq[12]}]

# PadFunction: IO_L16N_T2_32
set_property SLEW FAST [get_ports {ddr3_dq[13]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN AB18 [get_ports {ddr3_dq[13]}]

# PadFunction: IO_L13N_T2_MRCC_32
set_property SLEW FAST [get_ports {ddr3_dq[14]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN AE18 [get_ports {ddr3_dq[14]}]

# PadFunction: IO_L13P_T2_MRCC_32
set_property SLEW FAST [get_ports {ddr3_dq[15]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[15]}]
set_property PACKAGE_PIN AD18 [get_ports {ddr3_dq[15]}]

# PadFunction: IO_L8P_T1_32
set_property SLEW FAST [get_ports {ddr3_dq[16]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[16]}]
set_property PACKAGE_PIN AG19 [get_ports {ddr3_dq[16]}]

# PadFunction: IO_L7N_T1_32
set_property SLEW FAST [get_ports {ddr3_dq[17]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[17]}]
set_property PACKAGE_PIN AK19 [get_ports {ddr3_dq[17]}]

# PadFunction: IO_L11N_T1_SRCC_32
set_property SLEW FAST [get_ports {ddr3_dq[18]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[18]}]
set_property PACKAGE_PIN AG18 [get_ports {ddr3_dq[18]}]

# PadFunction: IO_L11P_T1_SRCC_32
set_property SLEW FAST [get_ports {ddr3_dq[19]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[19]}]
set_property PACKAGE_PIN AF18 [get_ports {ddr3_dq[19]}]

# PadFunction: IO_L8N_T1_32
set_property SLEW FAST [get_ports {ddr3_dq[20]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[20]}]
set_property PACKAGE_PIN AH19 [get_ports {ddr3_dq[20]}]

# PadFunction: IO_L7P_T1_32
set_property SLEW FAST [get_ports {ddr3_dq[21]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[21]}]
set_property PACKAGE_PIN AJ19 [get_ports {ddr3_dq[21]}]

# PadFunction: IO_L10N_T1_32
set_property SLEW FAST [get_ports {ddr3_dq[22]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[22]}]
set_property PACKAGE_PIN AE19 [get_ports {ddr3_dq[22]}]

# PadFunction: IO_L10P_T1_32
set_property SLEW FAST [get_ports {ddr3_dq[23]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[23]}]
set_property PACKAGE_PIN AD19 [get_ports {ddr3_dq[23]}]

# PadFunction: IO_L1P_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[24]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[24]}]
set_property PACKAGE_PIN AK16 [get_ports {ddr3_dq[24]}]

# PadFunction: IO_L5N_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[25]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[25]}]
set_property PACKAGE_PIN AJ17 [get_ports {ddr3_dq[25]}]

# PadFunction: IO_L2P_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[26]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[26]}]
set_property PACKAGE_PIN AG15 [get_ports {ddr3_dq[26]}]

# PadFunction: IO_L4P_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[27]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[27]}]
set_property PACKAGE_PIN AF15 [get_ports {ddr3_dq[27]}]

# PadFunction: IO_L5P_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[28]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[28]}]
set_property PACKAGE_PIN AH17 [get_ports {ddr3_dq[28]}]

# PadFunction: IO_L4N_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[29]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[29]}]
set_property PACKAGE_PIN AG14 [get_ports {ddr3_dq[29]}]

# PadFunction: IO_L2N_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[30]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[30]}]
set_property PACKAGE_PIN AH15 [get_ports {ddr3_dq[30]}]

# PadFunction: IO_L1N_T0_32
set_property SLEW FAST [get_ports {ddr3_dq[31]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[31]}]
set_property PACKAGE_PIN AK15 [get_ports {ddr3_dq[31]}]

# PadFunction: IO_L23N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[32]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[32]}]
set_property PACKAGE_PIN AK8 [get_ports {ddr3_dq[32]}]

# PadFunction: IO_L22N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[33]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[33]}]
set_property PACKAGE_PIN AK6 [get_ports {ddr3_dq[33]}]

# PadFunction: IO_L20N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[34]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[34]}]
set_property PACKAGE_PIN AG7 [get_ports {ddr3_dq[34]}]

# PadFunction: IO_L20P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[35]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[35]}]
set_property PACKAGE_PIN AF7 [get_ports {ddr3_dq[35]}]

# PadFunction: IO_L19P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[36]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[36]}]
set_property PACKAGE_PIN AF8 [get_ports {ddr3_dq[36]}]

# PadFunction: IO_L24N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[37]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[37]}]
set_property PACKAGE_PIN AK4 [get_ports {ddr3_dq[37]}]

# PadFunction: IO_L23P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[38]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[38]}]
set_property PACKAGE_PIN AJ8 [get_ports {ddr3_dq[38]}]

# PadFunction: IO_L22P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[39]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[39]}]
set_property PACKAGE_PIN AJ6 [get_ports {ddr3_dq[39]}]

# PadFunction: IO_L14N_T2_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[40]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[40]}]
set_property PACKAGE_PIN AH5 [get_ports {ddr3_dq[40]}]

# PadFunction: IO_L14P_T2_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[41]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[41]}]
set_property PACKAGE_PIN AH6 [get_ports {ddr3_dq[41]}]

# PadFunction: IO_L16N_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[42]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[42]}]
set_property PACKAGE_PIN AJ2 [get_ports {ddr3_dq[42]}]

# PadFunction: IO_L16P_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[43]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[43]}]
set_property PACKAGE_PIN AH2 [get_ports {ddr3_dq[43]}]

# PadFunction: IO_L13P_T2_MRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[44]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[44]}]
set_property PACKAGE_PIN AH4 [get_ports {ddr3_dq[44]}]

# PadFunction: IO_L13N_T2_MRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[45]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[45]}]
set_property PACKAGE_PIN AJ4 [get_ports {ddr3_dq[45]}]

# PadFunction: IO_L17N_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[46]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[46]}]
set_property PACKAGE_PIN AK1 [get_ports {ddr3_dq[46]}]

# PadFunction: IO_L17P_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[47]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[47]}]
set_property PACKAGE_PIN AJ1 [get_ports {ddr3_dq[47]}]

# PadFunction: IO_L8N_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[48]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[48]}]
set_property PACKAGE_PIN AF1 [get_ports {ddr3_dq[48]}]

# PadFunction: IO_L7N_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[49]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[49]}]
set_property PACKAGE_PIN AF2 [get_ports {ddr3_dq[49]}]

# PadFunction: IO_L10P_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[50]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[50]}]
set_property PACKAGE_PIN AE4 [get_ports {ddr3_dq[50]}]

# PadFunction: IO_L10N_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[51]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[51]}]
set_property PACKAGE_PIN AE3 [get_ports {ddr3_dq[51]}]

# PadFunction: IO_L7P_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[52]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[52]}]
set_property PACKAGE_PIN AF3 [get_ports {ddr3_dq[52]}]

# PadFunction: IO_L11N_T1_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[53]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[53]}]
set_property PACKAGE_PIN AF5 [get_ports {ddr3_dq[53]}]

# PadFunction: IO_L8P_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[54]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[54]}]
set_property PACKAGE_PIN AE1 [get_ports {ddr3_dq[54]}]

# PadFunction: IO_L11P_T1_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[55]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[55]}]
set_property PACKAGE_PIN AE5 [get_ports {ddr3_dq[55]}]

# PadFunction: IO_L2N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[56]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[56]}]
set_property PACKAGE_PIN AC1 [get_ports {ddr3_dq[56]}]

# PadFunction: IO_L1N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[57]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[57]}]
set_property PACKAGE_PIN AD3 [get_ports {ddr3_dq[57]}]

# PadFunction: IO_L4N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[58]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[58]}]
set_property PACKAGE_PIN AC4 [get_ports {ddr3_dq[58]}]

# PadFunction: IO_L4P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[59]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[59]}]
set_property PACKAGE_PIN AC5 [get_ports {ddr3_dq[59]}]

# PadFunction: IO_L5N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[60]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[60]}]
set_property PACKAGE_PIN AE6 [get_ports {ddr3_dq[60]}]

# PadFunction: IO_L5P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[61]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[61]}]
set_property PACKAGE_PIN AD6 [get_ports {ddr3_dq[61]}]

# PadFunction: IO_L2P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[62]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[62]}]
set_property PACKAGE_PIN AC2 [get_ports {ddr3_dq[62]}]

# PadFunction: IO_L1P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[63]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[63]}]
set_property PACKAGE_PIN AD4 [get_ports {ddr3_dq[63]}]

# PadFunction: IO_L18P_T2_33
set_property SLEW FAST [get_ports {ddr3_addr[13]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[13]}]
set_property PACKAGE_PIN AH11 [get_ports {ddr3_addr[13]}]

# PadFunction: IO_L18N_T2_33
set_property SLEW FAST [get_ports {ddr3_addr[12]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN AJ11 [get_ports {ddr3_addr[12]}]

# PadFunction: IO_L19P_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[11]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN AE13 [get_ports {ddr3_addr[11]}]

# PadFunction: IO_L19N_T3_VREF_33
set_property SLEW FAST [get_ports {ddr3_addr[10]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN AF13 [get_ports {ddr3_addr[10]}]

# PadFunction: IO_L20P_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[9]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN AK14 [get_ports {ddr3_addr[9]}]

# PadFunction: IO_L20N_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[8]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN AK13 [get_ports {ddr3_addr[8]}]

# PadFunction: IO_L21P_T3_DQS_33
set_property SLEW FAST [get_ports {ddr3_addr[7]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN AH14 [get_ports {ddr3_addr[7]}]

# PadFunction: IO_L21N_T3_DQS_33
set_property SLEW FAST [get_ports {ddr3_addr[6]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN AJ14 [get_ports {ddr3_addr[6]}]

# PadFunction: IO_L22P_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[5]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN AJ13 [get_ports {ddr3_addr[5]}]

# PadFunction: IO_L22N_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[4]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN AJ12 [get_ports {ddr3_addr[4]}]

# PadFunction: IO_L23P_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN AF12 [get_ports {ddr3_addr[3]}]

# PadFunction: IO_L23N_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN AG12 [get_ports {ddr3_addr[2]}]

# PadFunction: IO_L24P_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN AG13 [get_ports {ddr3_addr[1]}]

# PadFunction: IO_L24N_T3_33
set_property SLEW FAST [get_ports {ddr3_addr[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN AH12 [get_ports {ddr3_addr[0]}]

# PadFunction: IO_L15N_T2_DQS_33
set_property SLEW FAST [get_ports {ddr3_ba[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[2]}]
set_property PACKAGE_PIN AK9 [get_ports {ddr3_ba[2]}]

# PadFunction: IO_L16P_T2_33
set_property SLEW FAST [get_ports {ddr3_ba[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN AG9 [get_ports {ddr3_ba[1]}]

# PadFunction: IO_L16N_T2_33
set_property SLEW FAST [get_ports {ddr3_ba[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN AH9 [get_ports {ddr3_ba[0]}]

# PadFunction: IO_L10P_T1_33
set_property SLEW FAST [get_ports ddr3_ras_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_ras_n]
set_property PACKAGE_PIN AD9 [get_ports ddr3_ras_n]

# PadFunction: IO_L9N_T1_DQS_33
set_property SLEW FAST [get_ports ddr3_cas_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_cas_n]
set_property PACKAGE_PIN AC11 [get_ports ddr3_cas_n]

# PadFunction: IO_L10N_T1_33
set_property SLEW FAST [get_ports ddr3_we_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_we_n]
set_property PACKAGE_PIN AE9 [get_ports ddr3_we_n]

# PadFunction: IO_L18N_T2_34
set_property SLEW FAST [get_ports ddr3_reset_n]
set_property IOSTANDARD LVCMOS15 [get_ports ddr3_reset_n]
set_property PACKAGE_PIN AK3 [get_ports ddr3_reset_n]

# PadFunction: IO_L14N_T2_SRCC_33
set_property SLEW FAST [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cke[0]}]
set_property PACKAGE_PIN AF10 [get_ports {ddr3_cke[0]}]

# PadFunction: IO_L8P_T1_33
set_property SLEW FAST [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_odt[0]}]
set_property PACKAGE_PIN AD8 [get_ports {ddr3_odt[0]}]

# PadFunction: IO_L9P_T1_DQS_33
set_property SLEW FAST [get_ports {ddr3_cs_n[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cs_n[0]}]
set_property PACKAGE_PIN AC12 [get_ports {ddr3_cs_n[0]}]

# PadFunction: IO_L24P_T3_32
set_property SLEW FAST [get_ports {ddr3_dm[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN Y16 [get_ports {ddr3_dm[0]}]

# PadFunction: IO_L18P_T2_32
set_property SLEW FAST [get_ports {ddr3_dm[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[1]}]
set_property PACKAGE_PIN AB17 [get_ports {ddr3_dm[1]}]

# PadFunction: IO_L12P_T1_MRCC_32
set_property SLEW FAST [get_ports {ddr3_dm[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[2]}]
set_property PACKAGE_PIN AF17 [get_ports {ddr3_dm[2]}]

# PadFunction: IO_L6P_T0_32
set_property SLEW FAST [get_ports {ddr3_dm[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[3]}]
set_property PACKAGE_PIN AE16 [get_ports {ddr3_dm[3]}]

# PadFunction: IO_L24P_T3_34
set_property SLEW FAST [get_ports {ddr3_dm[4]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[4]}]
set_property PACKAGE_PIN AK5 [get_ports {ddr3_dm[4]}]

# PadFunction: IO_L18P_T2_34
set_property SLEW FAST [get_ports {ddr3_dm[5]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[5]}]
set_property PACKAGE_PIN AJ3 [get_ports {ddr3_dm[5]}]

# PadFunction: IO_L12P_T1_MRCC_34
set_property SLEW FAST [get_ports {ddr3_dm[6]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[6]}]
set_property PACKAGE_PIN AF6 [get_ports {ddr3_dm[6]}]

# PadFunction: IO_L6P_T0_34
set_property SLEW FAST [get_ports {ddr3_dm[7]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[7]}]
set_property PACKAGE_PIN AC7 [get_ports {ddr3_dm[7]}]

# PadFunction: IO_L21P_T3_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_p[0]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L21N_T3_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_n[0]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN AC15 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN AC16 [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L15P_T2_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_p[1]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L15N_T2_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_n[1]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[1]}]
set_property PACKAGE_PIN Y18 [get_ports {ddr3_dqs_n[1]}]
set_property PACKAGE_PIN Y19 [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L9P_T1_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_p[2]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[2]}]

# PadFunction: IO_L9N_T1_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_n[2]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[2]}]
set_property PACKAGE_PIN AK18 [get_ports {ddr3_dqs_n[2]}]
set_property PACKAGE_PIN AJ18 [get_ports {ddr3_dqs_p[2]}]

# PadFunction: IO_L3P_T0_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_p[3]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[3]}]

# PadFunction: IO_L3N_T0_DQS_32
set_property SLEW FAST [get_ports {ddr3_dqs_n[3]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[3]}]
set_property PACKAGE_PIN AJ16 [get_ports {ddr3_dqs_n[3]}]
set_property PACKAGE_PIN AH16 [get_ports {ddr3_dqs_p[3]}]

# PadFunction: IO_L21P_T3_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[4]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[4]}]

# PadFunction: IO_L21N_T3_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[4]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[4]}]
set_property PACKAGE_PIN AJ7 [get_ports {ddr3_dqs_n[4]}]
set_property PACKAGE_PIN AH7 [get_ports {ddr3_dqs_p[4]}]

# PadFunction: IO_L15P_T2_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[5]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[5]}]

# PadFunction: IO_L15N_T2_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[5]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[5]}]
set_property PACKAGE_PIN AH1 [get_ports {ddr3_dqs_n[5]}]
set_property PACKAGE_PIN AG2 [get_ports {ddr3_dqs_p[5]}]

# PadFunction: IO_L9P_T1_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[6]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[6]}]

# PadFunction: IO_L9N_T1_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[6]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[6]}]
set_property PACKAGE_PIN AG3 [get_ports {ddr3_dqs_n[6]}]
set_property PACKAGE_PIN AG4 [get_ports {ddr3_dqs_p[6]}]

# PadFunction: IO_L3P_T0_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[7]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[7]}]

# PadFunction: IO_L3N_T0_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[7]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[7]}]
set_property PACKAGE_PIN AD2 [get_ports {ddr3_dqs_p[7]}]
set_property PACKAGE_PIN AD1 [get_ports {ddr3_dqs_n[7]}]

# PadFunction: IO_L13P_T2_MRCC_33
set_property SLEW FAST [get_ports {ddr3_ck_p[0]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_ck_p[0]}]

# PadFunction: IO_L13N_T2_MRCC_33
set_property SLEW FAST [get_ports {ddr3_ck_n[0]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_ck_n[0]}]
set_property PACKAGE_PIN AG10 [get_ports {ddr3_ck_p[0]}]
set_property PACKAGE_PIN AH10 [get_ports {ddr3_ck_n[0]}]



