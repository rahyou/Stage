echo "ID;TOTALTIME" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - 1469719004.22)" | bc -l) 
echo "1;$I" >> ERelation.txt 

