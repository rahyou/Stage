#!/bin/bash


cd ~/Documents/stage/workflow_Canny/bin/gray
 ./gray.byte "%=ID%" "%=IMG1%" 

sleep 3

cat Erelation.txt > $OLDPWD/ERelation.txt

