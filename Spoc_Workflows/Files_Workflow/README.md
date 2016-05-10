
## Files_Workflow: 

Applique une addition entre la colonne V de fichier FILE1 et la colonne K de fichier FILE2, et met le resultat sous la colonne K de fichier FILE3.

##### Input relation:
 ID, FILE1, FILE2.


input.dataset: un fichier en format "csv", contient 3 colonnes ID, FILE1, FILE2. La colonne ID est de type Float, on l'utulise pour identifier le fichier de sortie.
Les colonnes FILE1 et FILE2 contiennent les chemins des fichiers d'entrées. On applique une opération d'addition sur les fichiers de FILE1 et FILE2. 

##### Output relation:
 ID, FILE1, FILE2, FILE3.


Dans la base de données on trouve deux tables iact1 et Oact1.

###### La table iact1
contient les champs de la relation d'entrée.
  
![alt tag](https://github.com/rahyou/Stage/blob/master/Spoc_Workflows/Files_Workflow/Files_Spoc_I.png)


###### La table oact1 
contient les champs de la relation de sortie, on trouve la colonne FILE3 qui contient les chemins des fichiers de sorties.

![alt tag](https://github.com/rahyou/Stage/blob/master/Spoc_Workflows/Files_Workflow/Files_Spoc_O.png)





_ Les fichiers de sortie sont distribués dans les noeuds de calcules, Comment les collectés, ils sont dans la base?

_ Dans la base Chiron met un chemin pour le fichier de sortie. 

_ Il faut changer le format des fichiers, un image en format csv.


