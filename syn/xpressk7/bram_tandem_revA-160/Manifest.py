# To list file
# ls -1 | xargs -I % echo \"%\",


library = "work"

modules = {
"local" : ["../../../rtl/common","../../../rtl/kintex7","../../../rtl/","../../../ip-cores/kintex7"],
}

files = [
#TOP
"../tandem_yarr.v",
"../app_pkg.vhd",
"../app.vhd",
"../xpressk7.xdc",
#"../xpressk7-ddr3.xdc",
#"../xpressk7-fmc-quad.xdc",
"../xpressk7-timing.xdc",
"../xilinx_tandem.xdc",
]




target = "xilinx" 
action = "synthesis" 

syn_device = "xc7k160" 
syn_grade = "-2" 
syn_package = "tfbg676" 
syn_top = "yarr" 
syn_project = "yarr"
syn_tool = "vivado"
