
set_false_path -from [get_pins req_reg/C]               -to [get_pins req_pipe_reg/D]
set_false_path -from [get_pins req_prev_reg/C]          -to [get_pins ack_reg/D]
set_false_path -from [get_pins transfer_data_reg*/C]    -to [get_pins transfer_data_d_reg*/D]
