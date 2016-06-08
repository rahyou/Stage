sleep 1
cd ~/Documents/stage/workflow_Canny/bin/Non_max
 ./Non_max.byte "%=ID%" "%=IMG1%" 
cp output.ppm ~/Documents/stage/workflow_Canny/Output
cat Erelation.txt > $OLDPWD/ERelation.txt

