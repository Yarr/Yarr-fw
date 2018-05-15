##################################################################################################
## Target Device : Kintex-7 KC705 Evaluation Platform
## Adapter Card Type : VHDCI to 8xRJ45 FE-I4 Rev. A
## (https://twiki.cern.ch/twiki/bin/view/Main/TimonHeim?forceShow=1#FE_I4)
##################################################################################################

## FMC LPC

### 40MHz Reference Clocks

### LA06_P, LA06_N
set_property PACKAGE_PIN AK20 [get_ports {fe_clk_p[7]}]
set_property PACKAGE_PIN AK21 [get_ports {fe_clk_n[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[7]}]
### LA04_P, LA04_N
set_property PACKAGE_PIN AH21 [get_ports {fe_clk_p[6]}]
set_property PACKAGE_PIN AJ21 [get_ports {fe_clk_n[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[6]}]
### LA02_P, LA02_N
set_property PACKAGE_PIN AF20 [get_ports {fe_clk_p[5]}]
set_property PACKAGE_PIN AF21 [get_ports {fe_clk_n[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[5]}]
### LA00_CC_P, LA00_CC_N
set_property PACKAGE_PIN AD23 [get_ports {fe_clk_p[4]}]
set_property PACKAGE_PIN AE24 [get_ports {fe_clk_n[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[4]}]
### LA26_P, LA26_N
set_property PACKAGE_PIN AK29 [get_ports {fe_clk_p[3]}]
set_property PACKAGE_PIN AK30 [get_ports {fe_clk_n[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[3]}]
### LA28_P, LA28_N
set_property PACKAGE_PIN AE30 [get_ports {fe_clk_p[2]}]
set_property PACKAGE_PIN AF30 [get_ports {fe_clk_n[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[2]}]
### LA30_P, LA30_N
set_property PACKAGE_PIN AB29 [get_ports {fe_clk_p[1]}]
set_property PACKAGE_PIN AB30 [get_ports {fe_clk_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[1]}]
### LA32_P, LA32_N
set_property PACKAGE_PIN Y30 [get_ports {fe_clk_p[0]}]
set_property PACKAGE_PIN AA30 [get_ports {fe_clk_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_clk_n[0]}]

### 80MHz Manchester encoded command signals

### LA07_P, LA07_N
set_property PACKAGE_PIN AG25 [get_ports {fe_cmd_p[7]}]
set_property PACKAGE_PIN AH25 [get_ports {fe_cmd_n[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[7]}]
### LA05_P, LA05_N
set_property PACKAGE_PIN AG22 [get_ports {fe_cmd_p[6]}]
set_property PACKAGE_PIN AH22 [get_ports {fe_cmd_n[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[6]}]
### LA03_P, LA03_N
set_property PACKAGE_PIN AG20 [get_ports {fe_cmd_p[5]}]
set_property PACKAGE_PIN AH20 [get_ports {fe_cmd_n[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[5]}]
### LA01_CC_P, LA01_CC_N
set_property PACKAGE_PIN AE23 [get_ports {fe_cmd_p[4]}]
set_property PACKAGE_PIN AF23 [get_ports {fe_cmd_n[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[4]}]
### LA27_P, LA27_N
set_property PACKAGE_PIN AJ28 [get_ports {fe_cmd_p[3]}]
set_property PACKAGE_PIN AJ29 [get_ports {fe_cmd_n[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[3]}]
### LA29_P, LA29_N
set_property PACKAGE_PIN AE28 [get_ports {fe_cmd_p[2]}]
set_property PACKAGE_PIN AF28 [get_ports {fe_cmd_n[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[2]}]
### LA31_P, LA31_N
set_property PACKAGE_PIN AD29 [get_ports {fe_cmd_p[1]}]
set_property PACKAGE_PIN AE29 [get_ports {fe_cmd_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[1]}]
### LA33_P, LA33_N
set_property PACKAGE_PIN AC29 [get_ports {fe_cmd_p[0]}]
set_property PACKAGE_PIN AC30 [get_ports {fe_cmd_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {fe_cmd_n[0]}]

### FE-I4 Data signals

### LA09_P, LA09_N
set_property PACKAGE_PIN AK23 [get_ports {fe_data_p[7]}]
set_property PACKAGE_PIN AK24 [get_ports {fe_data_n[7]}]
### LA08_P, LA08_N
set_property PACKAGE_PIN AJ22 [get_ports {fe_data_p[6]}]
set_property PACKAGE_PIN AJ23 [get_ports {fe_data_n[6]}]
### LA22_P, LA22_N
set_property PACKAGE_PIN AJ27 [get_ports {fe_data_p[5]}]
set_property PACKAGE_PIN AK28 [get_ports {fe_data_n[5]}]
### LA21_P, LA21_N
set_property PACKAGE_PIN AG27 [get_ports {fe_data_p[4]}]
set_property PACKAGE_PIN AG28 [get_ports {fe_data_n[4]}]
### LA10_P, LA10_N
set_property PACKAGE_PIN AJ24 [get_ports {fe_data_p[3]}]
set_property PACKAGE_PIN AK25 [get_ports {fe_data_n[3]}]
### LA11_P, LA11_N
set_property PACKAGE_PIN AE25 [get_ports {fe_data_p[2]}]
set_property PACKAGE_PIN AF25 [get_ports {fe_data_n[2]}]
### LA23_P, LA23_N
set_property PACKAGE_PIN AH26 [get_ports {fe_data_p[1]}]
set_property PACKAGE_PIN AH27 [get_ports {fe_data_n[1]}]
### LA24_P, LA24_N
set_property PACKAGE_PIN AG30 [get_ports {fe_data_p[0]}]
set_property PACKAGE_PIN AH30 [get_ports {fe_data_n[0]}]

### ! FAKE PORTS ! ###

### LA18_CC_P
set_property PACKAGE_PIN AD27 [get_ports ext_trig_o]
set_property IOSTANDARD LVCMOS25 [get_ports ext_trig_o]
### LA18_CC_N
set_property PACKAGE_PIN AD28 [get_ports {pwdn_l[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {pwdn_l[0]}]
### LA19_P 
set_property PACKAGE_PIN AJ26 [get_ports {pwdn_l[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {pwdn_l[1]}]
### LA14_P
set_property PACKAGE_PIN AD21 [get_ports {pwdn_l[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {pwdn_l[2]}]
### LA16_N
set_property PACKAGE_PIN AD22 [get_ports {io[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {io[2]}]
### LA14_N
set_property PACKAGE_PIN AE21 [get_ports {io[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {io[1]}]
### LA12_N
set_property PACKAGE_PIN AB20 [get_ports {io[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {io[0]}]
### LA17_CC_P
set_property PACKAGE_PIN AB27 [get_ports scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports scl_io]
### LA17_CC_N
set_property PACKAGE_PIN AC27 [get_ports sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports sda_io]
###

###

set_property PULLUP true [get_ports {fe_clk_p[7]}]
set_property PULLDOWN true [get_ports {fe_clk_n[7]}]
set_property PULLUP true [get_ports {fe_clk_p[6]}]
set_property PULLDOWN true [get_ports {fe_clk_n[6]}]
set_property PULLUP true [get_ports {fe_clk_p[5]}]
set_property PULLDOWN true [get_ports {fe_clk_n[5]}]
set_property PULLUP true [get_ports {fe_clk_p[4]}]
set_property PULLDOWN true [get_ports {fe_clk_n[4]}]
set_property PULLUP true [get_ports {fe_clk_p[3]}]
set_property PULLDOWN true [get_ports {fe_clk_n[3]}]
set_property PULLUP true [get_ports {fe_clk_p[2]}]
set_property PULLDOWN true [get_ports {fe_clk_n[2]}]
set_property PULLUP true [get_ports {fe_clk_p[1]}]
set_property PULLDOWN true [get_ports {fe_clk_n[1]}]
set_property PULLUP true [get_ports {fe_clk_p[0]}]
set_property PULLDOWN true [get_ports {fe_clk_n[0]}]
set_property PULLUP true [get_ports {fe_cmd_p[7]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[7]}]
set_property PULLUP true [get_ports {fe_cmd_p[6]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[6]}]
set_property PULLUP true [get_ports {fe_cmd_p[5]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[5]}]
set_property PULLUP true [get_ports {fe_cmd_p[4]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[4]}]
set_property PULLUP true [get_ports {fe_cmd_p[3]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[3]}]
set_property PULLUP true [get_ports {fe_cmd_p[2]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[2]}]
set_property PULLUP true [get_ports {fe_cmd_p[1]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[1]}]
set_property PULLUP true [get_ports {fe_cmd_p[0]}]
set_property PULLDOWN true [get_ports {fe_cmd_n[0]}]
set_property PULLUP true [get_ports {fe_data_p[7]}]
set_property PULLDOWN true [get_ports {fe_data_n[7]}]
set_property PULLUP true [get_ports {fe_data_p[6]}]
set_property PULLDOWN true [get_ports {fe_data_n[6]}]
set_property PULLUP true [get_ports {fe_data_p[5]}]
set_property PULLDOWN true [get_ports {fe_data_n[5]}]
set_property PULLUP true [get_ports {fe_data_p[4]}]
set_property PULLDOWN true [get_ports {fe_data_n[4]}]
set_property PULLUP true [get_ports {fe_data_p[3]}]
set_property PULLDOWN true [get_ports {fe_data_n[3]}]
set_property PULLUP true [get_ports {fe_data_p[2]}]
set_property PULLDOWN true [get_ports {fe_data_n[2]}]
set_property PULLUP true [get_ports {fe_data_p[1]}]
set_property PULLDOWN true [get_ports {fe_data_n[1]}]
set_property PULLUP true [get_ports {fe_data_p[0]}]
set_property PULLDOWN true [get_ports {fe_data_n[0]}]
set_property PULLUP true [get_ports ext_trig_o]
set_property PULLUP true [get_ports ext_trig_o]
set_property PULLUP true [get_ports {pwdn_l[0]}]
set_property PULLUP true [get_ports {pwdn_l[1]}]
set_property PULLUP true [get_ports {pwdn_l[2]}]
set_property PULLUP true [get_ports {io[2]}]
set_property PULLUP true [get_ports {io[1]}]
set_property PULLUP true [get_ports {io[0]}]
set_property PULLUP true [get_ports scl_io]
set_property PULLUP true [get_ports sda_io]