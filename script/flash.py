import os
import subprocess



script_path = os.getcwd() + "/" + os.path.splitext(__file__)[0] + ".tcl"
script_file = open(script_path, "w+")	

os.chdir("..")
project_path = os.getcwd()

script_file.write(
"######################################################\n" +
"# Generated file to flash the program RAM\n" +
"######################################################\n" +
"\n\n" + 
"#Run " + __file__+ " to generate this file\n\n")

bit_files = []
bit_file = None

mem_file = "mem.mcs"
prm_file = "mem.prm"


cmds_RAM=(
"open_hw\n" +
"connect_hw_server\n" +
"open_hw_target\n" +
"current_hw_device [lindex [get_hw_devices] 1]\n" +
"refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 1]\n" +
"set_property PROGRAM.FILE {}{}{} [lindex [get_hw_devices] 1]\n" +
"program_hw_devices [lindex [get_hw_devices] 1]\n"
)

#format bit_file mem_file prm_file { }
cmds_Flash=(
"open_hw\n" + 
"connect_hw_server\n" +
"open_hw_target\n" +
"current_hw_device [lindex [get_hw_devices] 1]\n" +
"refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 1]\n"
'write_cfgmem  -format mcs -size 128 -interface BPIx16 -loadbit "up 0x00000000 {0} " -checksum -force -file "{1}"\n' +
"create_hw_cfgmem -hw_device [lindex [get_hw_devices] 1] -mem_dev  [lindex [get_cfgmem_parts {3}28f00ap30b-bpi-x16{4}] 0]\n" +
"set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"refresh_hw_device [lindex [get_hw_devices] 1]\n" +
"set_property PROGRAM.ADDRESS_RANGE  {3}use_file{4} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
'set_property PROGRAM.FILES [list "{1}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1]]\n' +
"set_property PROGRAM.PRM_FILE {3}{2}{4} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1]]\n" +
"set_property PROGRAM.BPI_RS_PINS {3}none{4} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.UNUSED_PIN_TERMINATION {3}pull-none{4} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"set_property PROGRAM.CHECKSUM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" +
"startgroup\n" +
"if {3}![string equal [get_property PROGRAM.HW_CFGMEM_TYPE  [lindex [get_hw_devices] 1]] [get_property MEM_TYPE [get_property CFGMEM_PART [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]]]] {4}  {3} create_hw_bitstream -hw_device [lindex [get_hw_devices] 1] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices] 1]]; program_hw_devices [lindex [get_hw_devices] 1]; {4};\n" +
"program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 1 ]]\n" + 
"endgroup\n"
)

for root, dirs, files in os.walk(project_path):
	for file in files:
		if file.endswith(".bit"):
			bit_file =  os.path.join(root, file)
			bit_files.append(bit_file)
			print "Bitfile found : " + bit_file


if len(bit_files) == 0 :
	print("No bit file found !\n")
elif len(bit_files) == 1:
	print("Bit file found : " + bit_files[0])
	ok = input ("Will you flash the RAM with this file [Y/n] ?")
	if ok[0].lower() == 'y':
		bit_file = bit_files[0]
	else:
		bit_file = None
else:
	print("Several bit files found: ")
	i = 0
	for bit_file in bit_files:
		print (str(i) + ": " + bit_file)
		i = i + 1
	try: 
		nb = input("Choose a file by typing a number: ")
		int(nb)
	except:
		print("You didn't enter a valid number")
		bit_file = None
	else:
		if nb >= len(bit_files) or nb < 0 :
			print("You didn't enter a valid number")
			bit_file = None 




if (bit_file != None):
	resp = raw_input ("Will you flash the RAM or the Flash [R/F] ?")
	if resp[0].lower() == 'r':	
		cmds = cmds_RAM.format('{',bit_file,'}')
	elif resp[0].lower() == 'f':	
		cmds = cmds_Flash.format(bit_file,mem_file,prm_file,'{','}')
	else:
		"You didn't enter a valid answer, it shoulde be an R for RAM of F for flash"
		cmds = None
	if cmds != None:
		script_file.write(cmds)
		script_file.flush()
		subprocess.call(["vivado", "-mode", "batch","-source", script_path])
else:
	print "No bit file has been written into the FPGA !"


script_file.close()
