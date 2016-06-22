#!/bin/bash

# GPU command line
%=WFDIR%/bin/Gaussian/Gaussian.byte %=id% %lena.ppm% %lena1.ppm%

cat %=WFDIR%/bin/Gaussian/Erelation.txt > ERelation.txt

