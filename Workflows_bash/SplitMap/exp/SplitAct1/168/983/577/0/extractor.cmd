#I=$((0+3)) 
#[ "0" -gt "0" ] && I=$((0+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((0*3));1000;1001" >> ERelation.txt
I=$((0*3)) 
 echo "%=IDENT%;$((I+1));1000;1001" >> ERelation.txt 

 echo "%=IDENT%;$((I+2));1000;1001" >> ERelation.txt 
