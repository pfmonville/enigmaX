xoxor
=====
Permet de crypter n'importe quelle plage de donnée (texte, image, audio, vidéo...) en se basant sur le chiffre de Vigenère en utilisant un système xor ainsi qu'une passphrase.
la passphrase est analysée et le programme sépare tous les mots (un nouveau mot à chaque espace). la plage de donnée va subir un xor avec la premier mot répété autant de fois que nécéssaire puis l'opération est répétée s'il y a un autre mots et ainsi de suite.
chaque mot représente une couche supplémentaire renforcant la sécurité. (autant de chiffre de Vigenère que de mots).
Afin d'éviter de pouvoir être décrypté par analogie avec une langue ( repérer la longueur des mots, les lettres courantes ...)
il faut éviter de ne mettre qu'une lettre par mot car tous les bytes du fichier seront modifiés de façon synchrone.
Il est préférable d'utiliser plusieurs mots et de longueurs différentes afin de ne pas subir l'analyse des fréquences.

Si on respècte ces règles:
*  Utiliser un mot de plus de 1 caractère
*  Utiliser au moins deux mots et faire en sorte que les mots aient des longueurs différentes
Alors on se rapproche d'un codage type "chiffre de Vernam" inconditionnellement sûr.


Utilisation :
Pour chiffrer
```
./xoxor NOM_DU_FICHIER
```
Pour déchiffrer
```
./xoxor NOM_DU_FICHIER.x
```

Il faut laisser le .x comme extension du fichier quand on met celui-ci dans la console afin de le déchiffrer. 
