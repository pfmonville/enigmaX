enigmaX
=====
permet de chiffrer et de déchiffrer tout fichier donné en paramètre
le mot de passe demandé au début est hashé puis sert de graine pour le PRNG
le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder
ainsi la sécurité est maximale (seule solution, bruteforcer le mot de passe)
De plus un brouilleur est utilisé, il mélange la table des caractères (ascii)
en utilisant le PRNG ou en utilisant le keyFile fourni au cas où une faille
matérielle permettrait d'analyser la ram afin d'inverser les xor, le résultat
obtenu serait toujours illisible.

Can crypt and decrypt any file given in argument. The password asked is hashed
to be used as a seed for the PRNG. The PRNG gives a unique key
which has the same length as the source file, thus the security is maximum
(the only way to break through is by bruteforce). Moreover, a scrambler is used,
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
  put the scrambler off.
  
KEYFILE:
  path to the keyfile, generate the scrambler instead of the password.


## Example :

the command 

```
enigmaX file1
```

let you choose between crypting or decrypting then it will prompt for a password that crypt/decrypt file1 as file1x in the same folder, file1 is not modified.

the command:

```
enigmaX file2 keyfile1
```

let you choose between crypting or decrypting, will prompt for the password that crypt/decrypt file2, uses keyfile1 to generate the scrambler then crypt/decrypt file2 as file2x in the same folder, file2 is not modified.

the command:

```
enigmaX file3 -s
```

let you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file without using the scrambler, resulting in using the unique key only.
