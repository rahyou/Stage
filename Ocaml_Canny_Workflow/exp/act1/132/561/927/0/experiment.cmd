#!/bin/bash


cd ~/Documents/stage/Ocaml_Canny_Workflow/bin/gray
 ./gray.byte "2" "/home/racha/Documents/stage/Ocaml_Canny_Workflow/images/moto.ppm" 

#sleep 3

cat Erelation.txt > $OLDPWD/ERelation.txt

