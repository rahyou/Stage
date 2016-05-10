PWD= 'pwd'
cd ~/Documents/SPOC/Chiron_work/build/Bytecode 
rm *.csv
 ./Add1_Chiron_vecteurs.byte "1" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/016/187/888/1/file-3.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/016/187/888/1/file-4.csv" 
cp *.csv ~/Documents/stage/Spoc_Workflows/Files_Workflow/Output
cat Erelation.txt > $OLDPWD/ERelation.txt
