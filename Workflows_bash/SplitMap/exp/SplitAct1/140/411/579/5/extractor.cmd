#I=$((5+3)) 
#[ "5" -gt "0" ] && I=$((5+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((5*3));1000;1002" >> ERelation.txt
I=$((5*3)) 
 echo "%=IDENT%;$((I+1));1000;1002" >> ERelation.txt 

 echo "%=IDENT%;$((I+2));1000;1002" >> ERelation.txt 
