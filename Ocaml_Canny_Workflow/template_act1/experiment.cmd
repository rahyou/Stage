#!/bin/bash


cd ~/Documents/stage/Ocaml_Canny_Workflow/bin/gray
 ./gray.byte "%=ID%" "%=IMG1%" 

#sleep 3

cat Erelation.txt > $OLDPWD/ERelation.txt

