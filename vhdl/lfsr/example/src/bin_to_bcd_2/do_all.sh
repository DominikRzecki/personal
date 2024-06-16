#!/bin/bash
rm -rf ./work
#/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vlib ./work
/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -93 $(dirname  ${BASH_SOURCE[0]})/bin_to_bcd_2.vhd     -work ./work
#/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -93 tb_bin_to_bcd_2.vhd  -work ./work
