I=$((1+3)) 
#[ "1" -gt "0" ] && I=$((1+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((I));2000;2001" >> ERelation.txt
I=$((I+1)) 
 echo "%=IDENT%;$((I));2000;2001" >> ERelation.txt 
I=$((I+1)) 
 echo "%=IDENT%;$((I));2000;2001" >> ERelation.txt 
