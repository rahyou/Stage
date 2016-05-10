PWD= 'pwd'
cd ~/Documents/SPOC/Chiron_work/build/Bytecode 
rm *.csv
 ./Add1_Chiron_vecteurs.byte "2" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/793/531/032/2/file-5.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/793/531/032/2/file-6.csv" 
cp *.csv $OLDPWD
cat Erelation.txt > $OLDPWD/ERelation.txt
