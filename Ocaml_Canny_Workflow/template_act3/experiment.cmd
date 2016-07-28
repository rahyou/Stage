
cd ~/Documents/stage/workflow_Canny/bin/Sobel
 ./Sobel.byte "%=ID%" "%=START%" "%=IMG1%" 
cp ~/Documents/stage/workflow_Canny/Output/theta.csv $OLDPWD
cat Erelation.txt > $OLDPWD/ERelation.txt

