I="2"
[ "2" -gt "0" ] && I=$((2+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((I));3000;3001" >> ERelation.txt
I=$((I+1)) 
 echo "%=IDENT%;$((I));3000;3001" >> ERelation.txt 
I=$((I+1)) 
 echo "%=IDENT%;$((I));3000;3001" >> ERelation.txt 