#I=$((3+3)) 
#[ "3" -gt "0" ] && I=$((3+3)) 
 echo "IDENT;ID;T1;T2" >> ERelation.txt 
 echo "%=IDENT%;$((3*3));2000;2002" >> ERelation.txt
I=$((3*3)) 
 echo "%=IDENT%;$((I+1));2000;2002" >> ERelation.txt 
I=$((I+1)) 
 echo "%=IDENT%;$((I+2));2000;2002" >> ERelation.txt 
