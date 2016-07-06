#!/bin/bash


cd ~/Documents/stage/workflow_Canny_MapReduce/bin/divide
 ./divide.byte "%=ID%" "%=IMG1%" 

cat Erelation.txt > $OLDPWD/ERelation.txt

