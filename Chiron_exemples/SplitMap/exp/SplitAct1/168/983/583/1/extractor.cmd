#I=$((1+3)) 
#[ "1" -gt "0" ] && I=$((1+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((1*3));2000;2001" >> ERelation.txt
I=$((1*3)) 
 echo "%=IDENT%;$((I+1));2000;2001" >> ERelation.txt 

 echo "%=IDENT%;$((I+2));2000;2001" >> ERelation.txt 
