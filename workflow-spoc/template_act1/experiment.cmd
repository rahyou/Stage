#!/bin/bash
# CPU command line
# %=WFDIR%/bin/CustomPi/CustomPi.byte -device 0

# GPU command line
%=WFDIR%/bin/CustomPi/CustomPi.byte -device 1

cp %=FILE1% ERelation.txt