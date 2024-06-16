#!/bin/bash
# Please run first: sudo apt-get -qq install rename

if [ "$1" != "-noprep" ];
then
	rm -rf ./work
	/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vlib ./work
fi

/home/dominik/intelFPGA/20.1/modelsim_ase/bin/vcom -explicit -93 $(dirname  ${BASH_SOURCE[0]})/src/pulse_gen.vhd     -work ./work

#if [ "$1" = "-tb" ];
#then
#fi

#if [ "$1" = "-DE10_LITE" ];
#then
#fi
