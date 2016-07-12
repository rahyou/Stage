echo "ID;TOTALFLOW" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - 1468330587.44)" | bc -l) 
echo "1;$I" >> ERelation.txt 

