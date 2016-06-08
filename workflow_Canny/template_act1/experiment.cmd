#!/bin/bash

# GPU command line
%=WFDIR%/bin/gray/gray.byte 

# cp %=FILE1% ERelation.txt

cd ~/Documents/stage/workflow_Canny/bin/gray
 ./gray.byte "%=ID%" "%=IMG1%" 
cp output.ppm ~/Documents/stage/workflow_Canny/Output
cat Erelation.txt > $OLDPWD/ERelation.txt

