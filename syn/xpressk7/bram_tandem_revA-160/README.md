# Tandem configuration

There is only one version of the tandem firmware with only a BRAM memory. The top level is unfortunately written in verilog. The difference with the previous is the PCIe core settings.

Some informations are provided by Xilinx: <https://www.xilinx.com/support/answers/51950.html>

## Synthesis

Simple synthesis 
```bash
cd syn/xpressk7/bram_tandem_revA-160/
hdl-make
make
```


## Xilinx driver compiling

Since the 3.4 kernel version, the driver provided by Xilinx doesn't work anymore because of library upgrades. (<https://forums.xilinx.com/t5/PCI-Express/PCIE-Tandem-Configuration-with-a-kintex7-board/m-p/792630/highlight/true#M9089>)

So a git repository with the change was created: <https://github.com/cretingame/FpcDriverLinux>

```bash
git clone git@github.com:cretingame/FpcDriverLinux.git
cd FpcDriverLinux/linux_driver
make
```

```bash
cd FpcDriverLinux/linux_text_app
make
```

## Write the first stage bitfile to the flash memory

Launch the flash.py script and choose the yarr_tandem1.bit file.

```bash
$ python flash.py
Several bit files found: 
...
16: /home/***/Yarr-fw/syn/xpressk7/bram_tandem_revA-160/yarr.runs/impl_1/yarr_tandem1.bit
17: /home/***/Yarr-fw/syn/xpressk7/bram_tandem_revA-160/yarr.runs/impl_1/yarr_tandem2.bit
Choose a file by typing a number:
```

## Send the second stage through the PCI-express

Stop the spec driver and start the FPC driver.
```bash
$ sudo rmmod specDriver
$ cd FpcDriverLinux/linux_driver
$ sudo insmod xilinx_pci_fpc_main.ko
```
Then use the test app to send the stage 2.
```bash
$ cd FpcDriverLinux/linux_test_app
$ sudo ./test_fpc file=/home/***/Yarr-fw/syn/xpressk7/bram_tandem_revA-160/yarr.runs/impl_1/yarr_tandem2.bit
```

## Test the firmware

The firmware can be tested with the simple test application