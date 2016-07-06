cd ~/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add
 ./Add.byte "1" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/132/694/203/1/file-3.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/132/694/203/1/file-4.csv" 
cp *.csv ~/Documents/stage/Spoc_Workflows/Files_Workflow/Output
cp *.csv $OLDPWD
rm *.csv
cat Erelation.txt > $OLDPWD/ERelation.txt


#/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add/Add.byte "1" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/132/694/203/1/file-3.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/132/694/203/1/file-4.csv" 
#cp  /home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add/*.csv /home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/Output
#rm /home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add/*.csv
#cat WFDIR%/bin/Add/Erelation.txt > ERelation.txt
