cd ~/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add
 ./Add.byte "2" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/694/580/054/2/file-5.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/694/580/054/2/file-6.csv" 
cp *.csv ~/Documents/stage/Spoc_Workflows/Files_Workflow/Output
cp *.csv $OLDPWD
rm *.csv
cat Erelation.txt > $OLDPWD/ERelation.txt


#/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add/Add.byte "2" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/694/580/054/2/file-5.csv" "/home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/exp/Ex3Act1/694/580/054/2/file-6.csv" 
#cp  /home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add/*.csv /home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/Output
#rm /home/racha/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add/*.csv
#cat WFDIR%/bin/Add/Erelation.txt > ERelation.txt
