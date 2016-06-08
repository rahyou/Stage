#!/bin/bash

# GPU command line
/home/racha/Documents/stage/workflow_Canny/bin/gray/gray.byte 

# cp %=FILE1% ERelation.txt

cd ~/Documents/stage/workflow_Canny/bin/gray
 ./gray.byte "1" "/home/racha/Documents/stage/workflow_Canny/images/lena.ppm" 
cp output.ppm ~/Documents/stage/workflow_Canny/Output
cat Erelation.txt > $OLDPWD/ERelation.txt

