
## Files_Workflow: 
cet exemple présente une activité de l'opérateur Map. L'activité Ex3Act1 execute un extracteur extractor.cmd. 

#####input.dataset:
le fichier d'entrée est en format "csv", contient 3 colonnes ID, FILE1, FILE2. 
Les colonnes FILE1 et FILE2 contiennent les chemins des fichiers d'entrées. On applique une opération d'addition sur les fichiers de FILE1 et FILE2. 
La colonne ID est de type Float, on l'utilise pour identifier le fichier de sortie.

##### extractor.cmd 
L'extractor invoque un programme pour Appliquer une opération d'addition entre deux colonnes des deux fichiers de format csv.


##### Input relation "iact1":
la relation iact1 est la relation d'entrée de l'activité act1. ID, FILE1, FILE2.


##### Output relation "oact1":
la relation oact1 est la relation produite par l'activité act1. ID, FILE1, FILE2, FILE3.
FILE3: un champ ajouté par l'extracteur présente la sortie de l'opération appliquer sur FILE1 et FILE2. 


##### Add1_Chiron_vecteurs.byte: 
Prend en arguments ID FILE1 FILE2. Le programme applique une opération d'addition entre la colonne V de fichier FILE1 et la colonne K de fichier FILE2, et met le résultat dans un fichier de sortie qu'il le nomme selon l'argument ID,
et ajoute dans la relation de sortie une colonne FILE3 qui contiennent les chemins de fichiers de sorties.




Dans la base de données, pour "Files_Workflow" on trouve deux tables Iact1 et Oact1.


###### La table iact1
contient les champs de la relation d'entrée.
  

![alt tag](https://github.com/rahyou/Stage/blob/master/Spoc_Workflows/Files_Workflow/Files_Spoc_I.png)


###### La table oact1 
contient les champs de la relation de sortie, on trouve la colonne FILE3 qui contient les chemins des fichiers de sorties.


![alt tag](https://github.com/rahyou/Stage/blob/master/Spoc_Workflows/Files_Workflow/Files_Spoc_O.png)

















