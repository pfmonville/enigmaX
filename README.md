xoxor
=====
permet de chiffrer et de déchiffrer tous fichiers donnés en paramètre
le mot de passe demandé au début est hashé puis sert de graine pour le PRNG
le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder
ainsi la sécurité est maximale (seule solution, bruteforcer le mot de passe)
De plus un brouilleur est utilisé, il mélange la table des caractères (ascii)
en utilisant le PRNG ou en utilisant le keyFile fourni au cas où une faille
matériel permettrait d'analyser la ram afin d'inverser les xor, le résultat
obtenu serait toujours illisible.

Can crypt and decrypt any file given in argument. The password asked is hashed
to be used as a seed for the PRNG. The PRNG gives a unique key
which has the same length as the source file, thus the security is maximum
(the only way to break through is by bruteforce). Moreover, a scambler is used,
it scrambles the ascii table using the PRNG or the keyFile given to prevent
an hardware failure allowing ram analysis to invert the xoring process, making
such an exploit useless.

##Utilisation :

```
./enigmaX [-h | --help] FILE [-s | --standard | KEYFILE]
```

Pour chiffrer / to crypt
```
./enigmaX FILE [-s | --standard | KEYFILE]
```
Pour déchiffrer/ to decrypt
```
./enigmaX FILE.x [-s | --standard | KEYFILE]
```

### options :

-h | --help:
  further help.
  
-s | --standard:
  put the scambler on off.
  
KEYFILE:
  path to the keyfile, generate the scrambler instead of the password.

Il faut laisser le .x comme extension du fichier quand on met celui-ci dans la console afin de le déchiffrer.
to decode the file must have the .x extension.

## Example :

the command 

```
enigmaX file1
```

will prompt for a password then crypt the file then store it to file.x in the same folder, file1 is not modified.

the command:

```
enigmaX file2.x keyfile1
```

will prompt for the password that encrypted file2, uses keyfile1 to generate the scambler then decrypt file2.x, file2.x is not modified.

the command:

```
enigmaX file3 -s
```

will prompt for a password then crypt the file without using the scambler, resulting in using the unique key only.
