echo "ID;TOTALFLOW" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - %=START%)" | bc -l) 
echo "%=ID%;$I" >> ERelation.txt 

