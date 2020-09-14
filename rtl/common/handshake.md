# Handshake Documentation

## Introduction

This handshake protocol was written to combat timing failures in the Yarr firmware due to signals crossing to and from the wishbone clock domain. It is generalized using a generic signal width value, and implemented in the following modules:

- kintex7/rx_core/wb_rx_core.vhd
- spartan6/rx_core/wb_rx_core.vhd
- wb_tx_core.vhd
- wb_trigger_logic.vhd

These files can be thought of as the top-levels for their respective directories. Handshake instantiations were made here to directly synchronize the wishbone data (aka 'wb_dat') bus. 

## Implementation Details

This handshake protocol was modified for multi-bit signals so that data is passed to a transfer bus at the beginning of the handshake, and the acknowledge flag is not raised until the transfer data is successfully passed to the destination clock domain. 
