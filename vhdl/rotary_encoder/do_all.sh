#!/bin/bash
# Please run first: sudo apt-get -qq install rename

if [ "$1" != "-noprep" ];
then
	rm -rf ./work
	/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vlib ./work
fi

/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -2008 $(dirname  ${BASH_SOURCE[0]})/src/rotary_encoder.vhd     -work ./work

if [ "$1" = "-tb" ];
then
	/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -2008 $(dirname  ${BASH_SOURCE[0]})/test/tb_rotary_encoder.vhd     -work ./work
	
fi

if [ "$1" = "-DE10_LITE" ];
then
	/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -2008 $(dirname  ${BASH_SOURCE[0]})/example/DE10_LITE/DE10_LITE_const_pkg.vhd     -work ./work
	/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -2008 $(dirname  ${BASH_SOURCE[0]})/example/DE10_LITE/DE10_LITE.vhd     -work ./work
fi
