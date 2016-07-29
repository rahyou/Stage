#!/bin/bash


cd ~/Documents/stage/workflow_Canny/bin/gray
 ./gray.byte "2" "/home/racha/Documents/stage/workflow_Canny/images/moto.ppm" 

sleep 3

cat Erelation.txt > $OLDPWD/ERelation.txt

