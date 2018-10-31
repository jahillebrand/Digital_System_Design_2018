#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2018.2.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Tue Oct 16 13:23:06 CDT 2018
# SW Build 2288692 on Thu Jul 26 18:23:50 MDT 2018
#
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep xelab -wto df29c51d9e8b44c289770f770df5b6c4 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot simple_logic_circuit_testbench_behav xil_defaultlib.simple_logic_circuit_testbench xil_defaultlib.glbl -log elaborate.log
