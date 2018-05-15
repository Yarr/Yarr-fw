create_clock -period 10.000 -name pcie_clk -waveform {0.000 5.000} [get_ports pcie_clk_p]

set_false_path -from [get_pins app_0/wb_exp_comp/cfg_interrupt_s_reg/C] -to [get_pins pcie_0/U0/inst/pcie_top_i/pcie_7x_i/pcie_block_i/CFGINTERRUPTN]
set_false_path -to [get_pins -hierarchical *pcie_id_s*D*]
set_false_path -from [get_pins app_0/wb_exp_comp/cfg_interrupt_s_reg/C]

set_false_path -from [get_ports rst_n_i]
set_false_path -from [get_ports sys_rst_n_i]
set_false_path -to [get_ports -filter NAME=~*usr_led_o*]

set_max_delay -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT1} ]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT0} ]] 4.000
set_max_delay -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT0} ]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT1} ]] 6.125
set_max_delay -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT0} ]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT3} ]] 12.250
set_max_delay -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT3} ]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT0} ]] 4.000
set_max_delay -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT3} ]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */CLKOUT1} ]] 6.125

set_property LOC IBUFDS_GTE2_X0Y1 [get_cells refclk_ibuf]
set_property PACKAGE_PIN U8 [get_ports pcie_clk_p]
set_property PACKAGE_PIN U7 [get_ports pcie_clk_n]

set_max_delay -to [get_pins app_0/wb_exp_comp/cfg_interrupt_s_reg/CLR] 8.000

