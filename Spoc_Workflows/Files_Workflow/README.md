
input.dataset: un fichier en format "csv", contient 3 colonnes ID, FILE1, FILE2. Le colonne ID est de type Float, on l'utulise pour identifier le fichier de sortie.




Dans la base de données on trouve deux table, iact1 et Oact1.

* La table iact1 contient les champs de la relation d'entrée.
  
![alt tag](https://github.com/rahyou/Stage/blob/master/Spoc_Workflows/Files_Workflow/Files_Spoc_I.png)


* * La table iact1 contient les champs de la relation de sortie, on trouve la colonne FILE3 qui contient les chemins des fichiers de sorties.

![alt tag](https://github.com/rahyou/Stage/blob/master/Spoc_Workflows/Files_Workflow/Files_Spoc_O.png)





_ Les fichiers de sortie sont distribués dans les noeuds de calcules, Comment les collectés, ils sont dans la base?

_ Dans la base Chiron met un chemin pour le fichier de sortie. 

_ Il faut changer le format des fichiers, un image en format csv.


