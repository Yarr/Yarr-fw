# To list file
# ls -1 | xargs -I % echo \"%\",
files = [
# Common
"rtl/common/bcf_bram32.vhd",
"rtl/common/common_pkg.vhd",
"rtl/common/gn4124_core_pkg.vhd",
"rtl/common/k_bram.vhd",
"rtl/common/simple_counter.vhd",
#TOP
"syn/xpressk7/top_level.vhd",
"rtl/app_package.vhd",
"rtl/app.vhd",
"syn/xpressk7/xpressk7.xdc",
# Wishbone express
"rtl/wshexp-core/bcf_bram_wbs.vhd",
"rtl/wshexp-core/debugregisters.vhd",
"rtl/wshexp-core/dma_controller.vhd",
"rtl/wshexp-core/dma_controller_wb_slave.vhd",
"rtl/wshexp-core/fifo_32x512.vhd",
"rtl/wshexp-core/generic_async_fifo_wrapper.vhd",
"rtl/wshexp-core/l2p_arbiter.vhd",
"rtl/wshexp-core/l2p_dma_bench.vhd",
"rtl/wshexp-core/l2p_dma_master.vhd",
"rtl/wshexp-core/l2p_fifo.vhd",
"rtl/wshexp-core/p2l_decoder_bench.vhd",
"rtl/wshexp-core/p2l_decoder.vhd",
"rtl/wshexp-core/p2l_dma_bench.vhd",
"rtl/wshexp-core/p2l_dma_master.vhd",
"rtl/wshexp-core/top_bench.vhd",
"rtl/wshexp-core/wbmaster32.vhd",
# DDR3 CTRL
"rtl/ddr3-core/ddr3_ctrl_pkg.vhd",
"rtl/ddr3-core/ddr3_ctrl_wb.vhd",
"syn/xpressk7/xpressk7-ddr3.xdc",
# IP cores
"ip-cores/fifo_256x16/fifo_256x16.xci",
"ip-cores/fifo_27x16/fifo_27x16.xci",
"ip-cores/fifo_315x16/fifo_315x16.xci",
"ip-cores/fifo_32x512/fifo_32x512.xci",
"ip-cores/fifo_4x16/fifo_4x16.xci",
"ip-cores/fifo_64x512/fifo_64x512.xci",
"ip-cores/fifo_96x512_1/fifo_96x512.xci",
"ip-cores/ila_axis/ila_axis.xci",
"ip-cores/ila_ddr/ila_ddr.xci",
"ip-cores/ila_dma_ctrl_reg/ila_dma_ctrl_reg.xci",
"ip-cores/ila_l2p_dma/ila_l2p_dma.xci",
"ip-cores/ila_pd_pdm/ila_pd_pdm.xci",
"ip-cores/ila_wsh_pipe/ila_wsh_pipe.xci",
"ip-cores/l2p_fifo64/l2p_fifo64.xci",
"ip-cores/mig_7series_0/mig_7series_0.xci",
"ip-cores/mig_7series_0/mig_a.prj",
"ip-cores/mig_7series_0/mig_b.prj",
"ip-cores/pcie_7x_0/pcie_7x_0.xci",
]

library = "work"


target = "xilinx" 
action = "synthesis" 

syn_device = "xc7k160" 
syn_grade = "-2" 
syn_package = "tfbg676" 
syn_top = "top_level" 
syn_project = "yarr"
syn_tool = "vivado"
