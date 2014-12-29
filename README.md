xoxor
=====
Permet de crypter un fichier d'entré par un système xor ainsi qu'une passphrase.
la passphrase est décomposée en mots qui seront répétés jusqu'à former la longueur du fichier afin de subir un xor avec celui-ci.
chaque mot représente une couche supplémentaire renforcant la sécurité.
il faut éviter de ne mettre qu'une lettre par mot car tous les bytes du fichier seront modifiés de façon synchrone.
A part ça c'est tout bon.

Il suffit de donner un fichier codé finissant par .x ainsi que la bonne passphrase et le décryptage se lance.
