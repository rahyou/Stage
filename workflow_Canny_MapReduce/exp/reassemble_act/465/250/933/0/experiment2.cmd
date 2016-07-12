echo "ID;TOTALTIME" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - 1468333236.94)" | bc -l) 
echo "1;$I" >> ERelation.txt 

