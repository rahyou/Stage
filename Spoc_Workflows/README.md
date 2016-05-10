

Fatal error: the file './Add1_Chiron.byte' is not a bytecode executable file.

Le fichier executable dépand de l'architecture et des bibliothèques, il doit étre compilé statiquement, (on envoie juste le .byte). 

Une altèrnative est de compiler dynamiquement sur la machine distante, (envoyer le .ml et le Makefile).


---------------------------------------------------------------------


marche avec: rammener les data à Spoc puis rammener les résultat.

extractor.cmd
PWD= 'pwd'
cd ~/Documents/SPOC/Chiron_work/build/Bytecode && ./Add1_Chiron.byte "%=ID%" "%=T1%" "%=T2%" 
cat Erelation.txt > $PWD/ERelation.txt
