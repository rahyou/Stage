echo "ID;TOTALFLOW" >> ERelation.txt 
now=$(date +"%s")
I=$(echo "($now - 1468259706.36)" | bc -l) 
echo "1;$I" >> ERelation.txt 

