PWD= 'pwd'
cd ~/Documents/SPOC/Chiron_work/build/Bytecode 
rm *.csv
 ./Add1_Chiron_vecteurs.byte "%=ID%" "%=FILE1%" "%=FILE2%" 
cp *.csv ~/Documents/stage/Spoc_Workflows/Files_Workflow/Output
cp *.csv $OLDPWD
cat Erelation.txt > $OLDPWD/ERelation.txt
