#!/bin/bash


cd ~/Documents/stage/workflow_Canny_MapReduce/bin/gray
 ./gray.byte "%=ID%"  "%=START%" "%=IMG1%" 

cat Erelation.txt > $OLDPWD/ERelation.txt

