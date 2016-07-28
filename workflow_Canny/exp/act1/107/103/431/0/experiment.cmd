#!/bin/bash


cd ~/Documents/stage/workflow_Canny/bin/gray
 ./gray.byte "1" "/home/racha/Documents/stage/workflow_Canny/images/lena.ppm" 

sleep 3

cat Erelation.txt > $OLDPWD/ERelation.txt

