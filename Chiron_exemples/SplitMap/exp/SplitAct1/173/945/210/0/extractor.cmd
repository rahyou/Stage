#I=$((0+3)) 
#[ "0" -gt "0" ] && I=$((0+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$(((0*3)-1));1000;1001" >> ERelation.txt
I=$((I+1)) 
 echo "%=IDENT%;$((I));1000;1001" >> ERelation.txt 
I=$((I+1)) 
 echo "%=IDENT%;$((I));1000;1001" >> ERelation.txt 
