PWD= 'pwd'
cd ~/Documents/SPOC/Chiron_work/build/Bytecode && ./Add1_Chiron_vecteurs.byte "%=ID%" "%=FILE1%" "%=FILE2%" 
cp f* $OLDPWD
cat Erelation.txt > $OLDPWD/ERelation.txt
