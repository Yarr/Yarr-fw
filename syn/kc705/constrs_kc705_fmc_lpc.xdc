##################################################################################################
## Target Device : Kintex-7 KC705 Evaluation Platform
##################################################################################################

## FMC LPC

# FMC LPC MISC

# set_property PACKAGE_PIN J22 [get_ports FMC_LPC_PRSNT_M2C_B_LS]
# set_property IOSTANDARD LVCMOS25 [get_ports FMC_LPC_PRSNT_M2C_B_LS]

# FMC LPC CLK

# set_property PACKAGE_PIN AG23 [get_ports FMC_LPC_CLK0_M2C_N]
# set_property IOSTANDARD LVCMOS25 [get_ports FMC_LPC_CLK0_M2C_N]

# set_property PACKAGE_PIN AF22 [get_ports FMC_LPC_CLK0_M2C_P]
# set_property IOSTANDARD LVCMOS25 [get_ports FMC_LPC_CLK0_M2C_P]

# set_property PACKAGE_PIN AH29 [get_ports FMC_LPC_CLK1_M2C_N]
# set_property IOSTANDARD LVCMOS25 [get_ports FMC_LPC_CLK1_M2C_N]

# set_property PACKAGE_PIN AG29 [get_ports FMC_LPC_CLK1_M2C_P]
# set_property IOSTANDARD LVCMOS25 [get_ports FMC_LPC_CLK1_M2C_P]

# FMC LPC GBTCLK

# set_property PACKAGE_PIN N7 [get_ports FMC_LPC_GBTCLK0_M2C_C_N]
# set_property PACKAGE_PIN N8 [get_ports FMC_LPC_GBTCLK0_M2C_C_P]

# FMC LPC DP

# set_property PACKAGE_PIN F1 [get_ports FMC_LPC_DP0_C2M_N]
# set_property PACKAGE_PIN F2 [get_ports FMC_LPC_DP0_C2M_P]

# set_property PACKAGE_PIN F5 [get_ports FMC_LPC_DP0_M2C_N]
# set_property PACKAGE_PIN F6 [get_ports FMC_LPC_DP0_M2C_P]

# FMC LPC LA

set_property PACKAGE_PIN AE24 [get_ports ext_trig_o]
set_property IOSTANDARD LVCMOS25 [get_ports ext_trig_o]

set_property PACKAGE_PIN AD23 [get_ports {pwdn_l[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {pwdn_l[0]}]

set_property PACKAGE_PIN AF23 [get_ports {pwdn_l[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {pwdn_l[1]}]

set_property PACKAGE_PIN AE23 [get_ports {pwdn_l[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {pwdn_l[2]}]

set_property PACKAGE_PIN AF20 [get_ports {fe_clk_p[7]}]
set_property PACKAGE_PIN AG20 [get_ports {fe_clk_p[6]}]
set_property PACKAGE_PIN AH21 [get_ports {fe_clk_p[5]}]
set_property PACKAGE_PIN AG22 [get_ports {fe_clk_p[4]}]
set_property PACKAGE_PIN AK20 [get_ports {fe_clk_p[3]}]
set_property PACKAGE_PIN AG25 [get_ports {fe_clk_p[2]}]
set_property PACKAGE_PIN AJ22 [get_ports {fe_clk_p[1]}]
set_property PACKAGE_PIN AK23 [get_ports {fe_clk_p[0]}]

set_property PACKAGE_PIN AJ24 [get_ports {fe_cmd_p[7]}]
set_property PACKAGE_PIN AE25 [get_ports {fe_cmd_p[6]}]
set_property PACKAGE_PIN AA20 [get_ports {fe_cmd_p[5]}]
set_property PACKAGE_PIN AB24 [get_ports {fe_cmd_p[4]}]
set_property PACKAGE_PIN AD21 [get_ports {fe_cmd_p[3]}]
set_property PACKAGE_PIN AC24 [get_ports {fe_cmd_p[2]}]
set_property PACKAGE_PIN AC22 [get_ports {fe_cmd_p[1]}]
set_property PACKAGE_PIN AB27 [get_ports {fe_cmd_p[0]}]

set_property PACKAGE_PIN AD27 [get_ports {fe_data_p[7]}]
set_property PACKAGE_PIN AJ26 [get_ports {fe_data_p[6]}]
set_property PACKAGE_PIN AF26 [get_ports {fe_data_p[5]}]
set_property PACKAGE_PIN AG27 [get_ports {fe_data_p[4]}]
set_property PACKAGE_PIN AJ27 [get_ports {fe_data_p[3]}]
set_property PACKAGE_PIN AH26 [get_ports {fe_data_p[2]}]
set_property PACKAGE_PIN AG30 [get_ports {fe_data_p[1]}]
set_property PACKAGE_PIN AC26 [get_ports {fe_data_p[0]}]

set_property PACKAGE_PIN AJ28 [get_ports {io[2]}]
set_property PACKAGE_PIN AF30 [get_ports {io[1]}]
set_property PACKAGE_PIN AE30 [get_ports {io[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {io[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {io[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {io[0]}]

set_property PACKAGE_PIN AB30 [get_ports scl_io]
set_property PACKAGE_PIN AB29 [get_ports sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports sda_io]





