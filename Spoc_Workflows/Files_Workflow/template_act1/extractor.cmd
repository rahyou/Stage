cd ~/Documents/stage/Spoc_Workflows/Files_Workflow/bin/Add
 ./Add.byte "%=ID%" "%=FILE1%" "%=FILE2%" 
cp *.csv ~/Documents/stage/Spoc_Workflows/Files_Workflow/Output
cp *.csv $OLDPWD
rm *.csv
cat Erelation.txt > $OLDPWD/ERelation.txt


#%=WFDIR%/bin/Add/Add.byte "%=ID%" "%=FILE1%" "%=FILE2%" 
#cp  %=WFDIR%/bin/Add/*.csv %=WFDIR%/Output
#rm %=WFDIR%/bin/Add/*.csv
#cat WFDIR%/bin/Add/Erelation.txt > ERelation.txt
