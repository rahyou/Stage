
cd ~/Documents/stage/workflow_Canny_Reduce/bin/Sobel
 ./Sobel.byte "%=ID%" "%=IMG1%" 
cp ~/Documents/stage/workflow_Canny_Reduce/Output/theta.csv $OLDPWD
cat Erelation.txt > $OLDPWD/ERelation.txt

