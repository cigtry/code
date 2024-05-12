set_property PACKAGE_PIN H16 [get_ports tmds_clk_p_0]
set_property PACKAGE_PIN D19 [get_ports {tmds_data_p_0[0]}]
set_property PACKAGE_PIN C20 [get_ports {tmds_data_p_0[1]}]
set_property PACKAGE_PIN B19 [get_ports {tmds_data_p_0[2]}]

create_clock -period 2.694 -name VIRTUAL_clk_5x_zynq_clk_wiz_0_1 -waveform {0.000 1.347}
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -min -add_delay 0.000 [get_ports {tmds_data_n_0[*]}]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -max -add_delay 0.200 [get_ports {tmds_data_n_0[*]}]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -min -add_delay 0.000 [get_ports {tmds_data_p_0[*]}]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -max -add_delay 0.200 [get_ports {tmds_data_p_0[*]}]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -min -add_delay 0.000 [get_ports tmds_clk_n_0]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -max -add_delay 0.200 [get_ports tmds_clk_n_0]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -min -add_delay 0.000 [get_ports tmds_clk_p_0]
set_output_delay -clock [get_clocks VIRTUAL_clk_5x_zynq_clk_wiz_0_1] -max -add_delay 0.200 [get_ports tmds_clk_p_0]
