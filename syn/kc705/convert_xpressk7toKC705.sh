#!/bin/bash

OUTPUT_BRAM="./bram_yarr_kc705.vhd"
OUTPUT_DDR3="./ddr3_yarr_kc705.vhd"

cp ../xpressk7/bram_yarr.vhd $OUTPUT_BRAM
cp ../xpressk7/ddr3_yarr.vhd $OUTPUT_DDR3

XPRESSK7="rst_s <= not rst_n_i;"
KC705="rst_s <= rst_n_i;"

sed -i -e "s/$XPRESSK7/$KC705/g" $OUTPUT_BRAM
sed -i -e "s/$XPRESSK7/$KC705/g" $OUTPUT_DDR3

XPRESSK7="arstn_s <= sys_rst_n_i or rst_n_i;"
KC705="arstn_s <= sys_rst_n_i or not rst_n_i;"

sed -i -e "s/$XPRESSK7/$KC705/g" $OUTPUT_BRAM
sed -i -e "s/$XPRESSK7/$KC705/g" $OUTPUT_DDR3

echo "Done!"