echo "ID;TOTALTIME" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - %=START%)" | bc -l) 
echo "%=ID%;$I" >> ERelation.txt 

