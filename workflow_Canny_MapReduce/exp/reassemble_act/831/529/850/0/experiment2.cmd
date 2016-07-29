echo "ID;TOTALTIME" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - 1469823397.6)" | bc -l) 
echo "1;$I" >> ERelation.txt 

