# Xilinx Kintex-7 FPGA KC705

<span style="display: inline-block;">

## Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [How-to-Use](#howto)
4. [Licence](#licence)

<a name="overview"></a>

## Overview

This project is the fork of YARR for testing communication using KC705 Evaluation board.

<a name="requirements"></a>

## Requirement

Target Device:
- [Kintex-7 KC705 Evaluation Platform](https://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html)
- (Future support)[Virtex-7 VC707 Evaluation Platform](https://www.xilinx.com/products/boards-and-kits/ek-v7-vc707-g.html)

Software:
- Langurage : VHDL

- Xilinx Vivado 2017.1 or later version

    Xilinx IP cores
    - [Clocking Wizard](https://japan.xilinx.com/products/intellectual-property/clocking_wizard.html)
    - [AXI4-Stream Data FIFO](https://japan.xilinx.com/products/intellectual-property/axi_fifo.html)
    - [FIFO Generator](https://japan.xilinx.com/products/intellectual-property/fifo_generator.html)
    - [Memory Interface Generator (MIG 7 Series)](https://japan.xilinx.com/products/intellectual-property/mig.html)
    - [7 Series Integrated Block for PCI Express](https://japan.xilinx.com/products/intellectual-property/7_series_pci_express_block.html)
    - [ILA (Integrated Logic Analyzer)](https://japan.xilinx.com/products/intellectual-property/ila.html)

<a name="howto"></a>

## How-to-Use

1. Configure ready_to_test/ddr3_kc705.mcs
    - FMC-LPC supports [VHDCI_to_8xRJ45_FE_I4_Rev_A](https://twiki.cern.ch/twiki/bin/view/Main/TimonHeim?forceShow=1#VHDCI_to_8xRJ45_FE_I4_Rev_A)
2. Rebuild your vivado project. 

<a name="licence"></a>

## Licence

The license conforms to the parent project.
