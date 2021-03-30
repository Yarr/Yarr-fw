# Channel Bonding 

## Introduction

Yarr firmware makes use of an Aurora protocol in rx-core which implements up to four Aurora channels, each with up to four Aurora lanes. High speed serial data is received by channels and transformed to frames using 64/66b Aurora encoding (data frames of 64b + 2b header). 
![functional diagram](https://github.com/LaurenChoquer/Yarr-fw/blob/chan-bonding/doc/channel_lanes_diagram.JPG)

Due to the method of encoding each lane of a channel, data frames can become mismatched or out of sync between lanes:
![functional diagram](https://github.com/LaurenChoquer/Yarr-fw/blob/chan-bonding/doc/nonbonded_channels.png)
When this happens, logic is needed to bond the channel so data on the output contains synchronized data from all active lanes. In this diagram, the 'cb' frame represents a channel bonding command frame. According to the Aurora protocol documentation, these are periodically sent on all lanes simultaneously and can be used for channel bonding purposes. 

## Implementation Details

### Detecting Channel Bonding Command Frames

Channel bonding command frames include:
- a command header
- idle command flag on bits 63 downto 56
- bits 53 downto 50 = "0100" (bit 52 is channel bonding flag)

### Early Lanes

Once channel bonding frames are detected in one or more lanes, we are able to deduce which lanes are early. An early lane is any lane where a channel bonding frame occurs a clock cycle before other lanes. Once these lanes are detected, their data is passed to a delay register so that it is shifted to one clock cycle later. This shifted data is then outputted. If a lane is not early, data from that lane is passed directly to the output. 

![functional diagram](https://github.com/LaurenChoquer/Yarr-fw/blob/chan-bonding/doc/channel_bonding.jpg)