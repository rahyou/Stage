PWD= 'pwd'
cd ~/Documents/SPOC/Chiron_work/build/Bytecode 
rm *.csv
 ./Add1_Chiron_vecteurs.byte "0" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/198/100/285/0/file-1.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/198/100/285/0/file-2.csv" 
cp *.csv $OLDPWD
cat Erelation.txt > $OLDPWD/ERelation.txt
