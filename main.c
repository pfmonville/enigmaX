#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static const char *progname;
static const char *filename;

static void usage(int status)
{
	FILE *dest = (status == 0) ? stdout : stderr;

	fprintf(dest, "Usage: %s [-h] file\ncode/decode the file given\ncoded file must end with .x\n", progname);
	exit(status);
}

int compterMots(char *str){
	int n;        /* nombre des mots */
	int DANS_MOT; /* indicateur logique: */
 
	/* Compter les mots */
	n=0;
	DANS_MOT=0;
	for (unsigned int i = 0; i < strlen(str); i++)
	{
	    if (isspace(*(str+i)))
	    	DANS_MOT=0;
	    else if (!DANS_MOT)
	    {
	        DANS_MOT=1;
	        n++;
	    }  
	}
	return n;
}

int getWord(char *str, char **tab){
	int d2 = 0, d1 = 0, espace = 1, size = 0;

	for (unsigned long i = 0; i < strlen(str); ++i)
	{
		if (isspace (str[i]))
		{
			if (espace == 0)
			{
				d2++;
				d1=0;
			}
			espace = 1;	
		}
		else
		{
			if (espace == 1)
			{
				*(tab+d2) = (char*)malloc(100);
				size++;
			}
			tab[d2][d1] = str[i]; 
			d1++;
			espace = 0;
		}
	}
	return size;
}

void afficherTab(char **tab, int size){
	for (int i = 0; i < size; ++i)
	{
		if (*(tab+i) == NULL)
		{
			break;
		}
		printf("%s \n", *(tab+i));
	}
}

void libererTab(char **tab, int size){
	for (int i = 0; i < size; ++i)
	{
		if (*(tab+i) == NULL)
		{
			break;
		}
		free(*(tab+i));
	}
}

void XOR(FILE *fichier1, FILE *fichier2, char **tab, int nb){
	int i = 0;
	char b, c;
	rewind(fichier1);
	rewind(fichier2);
	do{
    	b = fgetc(fichier1);
    	if (b == EOF && feof)	//todo faire un assert propre
    		break;
    	else if(b == EOF && ferror)
    		break;
    	c = (*(tab[nb]+i) ^ b);
        fputc(c, fichier2);
        i = (i+1)%(strlen(tab[nb]));	//si le premier mot fait 7 lettres i ira de 0 à 6
	}while(b != EOF);
}

void code(FILE *fp, char **tab, int nbMot){
	FILE *fichierCode = NULL, *fichierTmp1 = NULL, *fichierTmp2 = NULL;
	FILE *ptr = NULL;
	int size = strlen(filename);
 	char name[size+2];

 	//on nomme le fichier qui sera codé
 	strcpy(name, filename);
 	name[size] = '.';
 	name[size+1] = 'x';
 	name[size+2] = '\0';

 	if ((fichierCode = fopen(name, "w+")) == NULL) {
		perror(name);
		exit(0);
	}
 	if ((fichierTmp1 = fopen("tmp1", "w+")) == NULL) {
		perror("tmp1");
		exit(0);
	}
 	if(nbMot > 1)
 	{
 		XOR(fp, fichierTmp1, tab, 0);
		if ((fichierTmp2 = fopen("tmp2", "w+")) == NULL) {
			perror("tmp2");
			exit(0);
		} 		
		ptr = fichierTmp1;
	 	for (int nb = 1; nb < nbMot; ++nb)
	 	{
	 		if (nb == nbMot-1)
	 			XOR(ptr, fichierCode, tab, nb);
	 		else if(nb%2 == 1){
		 		XOR(fichierTmp1, fichierTmp2, tab, nb);
		 		ptr = fichierTmp2;
	 		}
		 	else{
		 		XOR(fichierTmp2,fichierTmp1, tab, nb);
		 		ptr = fichierTmp1;
		 	}
	 	}
 	}
 	else{
 		XOR(fp, fichierCode, tab, 0);

 	}

    fclose(fichierCode);
    fclose(fichierTmp2);
    fclose(fichierTmp1);
    remove("tmp1");
    remove("tmp2");
}

void decode(FILE *fp, char **tab, int nbMot){
	FILE * fichierDecode = NULL, *fichierTmp1 = NULL, *fichierTmp2 = NULL;
	FILE *ptr = NULL;

	int size = strlen(filename);
 	char name[size];

 	//on nomme le fichier qui sera codé
 	strcpy(name, filename);
 	name[size-2] = '\0';	
 	if ((fichierDecode = fopen(name, "w+")) == NULL) {
		perror(name);
		exit(0);
	}
 	if ((fichierTmp1 = fopen("tmp1", "w+")) == NULL) {
		perror("tmp1");
		exit(0);
	}
 	rewind(fp);

 	if(nbMot > 1)
 	{
 		XOR(fp, fichierTmp1, tab, nbMot-1);
		if ((fichierTmp2 = fopen("tmp2", "w+")) == NULL) {
			perror("tmp2");
			exit(0);
		}  		
		ptr = fichierTmp1;
	 	for (int nb = 1; nb < nbMot; ++nb)
	 	{
	 		if (nb == nbMot-1)
	 			XOR(ptr, fichierDecode, tab, (nbMot-1)-nb);
	 		else if(nb%2 == 1){
		 		XOR(fichierTmp1, fichierTmp2, tab, (nbMot-1)-nb);
		 		ptr = fichierTmp2;
	 		}
		 	else{
		 		XOR(fichierTmp2, fichierTmp1, tab, (nbMot-1)-nb);
		 		ptr = fichierTmp1;
		 	}
	 	}
 	}
 	else{
 		 	XOR(fp, fichierDecode, tab, 0);

 	}


    fclose(fichierDecode);
    fclose(fichierTmp2);
    fclose(fichierTmp1);
    remove("tmp1");
    remove("tmp2");
}

int main (int argc, char const *argv[])
{
	FILE *fp;
	double size;

	//on récupère le nom du prog ainsi que la taille du fichier
	if ((progname = strrchr(argv[0], '/')) != NULL) {
		++progname;
	} else {
		progname = argv[0];
	}
	if (argc < 2) {
		usage(EXIT_FAILURE);
	} else if (strcmp(argv[1], "-h") == 0) {
		usage(EXIT_SUCCESS);
	}
	if ((filename = strrchr(argv[1], '/')) != NULL) {
		++filename;
	} else {
		filename = argv[1];
	}
	if ((fp = fopen(argv[1], "r")) == NULL) {
		perror(argv[1]);
		return EXIT_FAILURE;
	}
	fseek(fp, 0, SEEK_END);
	size = (double)ftell(fp);



	char mdp[100];
	int nbMot;
	
	printf("Qu'avez vous à me dire ?\n>>");
	fgets (mdp, 99, stdin);
	nbMot = compterMots(mdp);
	char **tab = (char**) malloc (sizeof (char*) * nbMot) ;

	getWord(mdp, tab);

	if (*(argv[1]+strlen(argv[1])-1) == 'x' && *(argv[1]+strlen(argv[1])-2) == '.'){
		decode(fp, tab, nbMot);
	}
	else{
		code(fp, tab, nbMot);
	}

	//on libère la mémoire
	libererTab(tab, nbMot);
	free (tab);

	//on ferme le fichier
	fclose(fp);

	return 0;
}
