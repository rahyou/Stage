I="4"
[ "4" -gt "0" ] && I=$((4+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((I));3000;3002" >> ERelation.txt
I=$((I+1)) 
 echo "%=IDENT%;$((I));3000;3002" >> ERelation.txt 
I=$((I+1)) 
 echo "%=IDENT%;$((I));3000;3002" >> ERelation.txt 