#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static const char *progName;
static const char *fileName;

static void usage(int status)
{
	FILE *dest = (status == 0) ? stdout : stderr;

	fprintf(dest, "Usage: %s [-h] file\ncode/decode the file given\ncoded file must end with .x\n", progName);
	exit(status);
}

int countWord(char *passPhrase){
	int numberOfWord;        /* nombre des mots */
	int isInsideWord; /* indicateur logique: à l'intérieur d'un mot */
 
	/* Compter les mots */
	numberOfWord=0;
	isInsideWord=0;
	for (unsigned int i = 0; i < strlen(passPhrase); i++)
	{
	    if (isspace(*(passPhrase+i)))
	    	isInsideWord=0;
	    else if (!isInsideWord)
	    {
	        isInsideWord=1;
	        numberOfWord++;
	    }  
	}
	return numberOfWord;
}

void getWord(char *passPhrase, char **tab){
	int row = 0, line = 0, hasSpaceBefore = 1;

	for (unsigned long i = 0; i < strlen(passPhrase); ++i)
	{
		if (isspace (passPhrase[i]))
		{
			if (hasSpaceBefore == 0)
			{
				row++;
				line=0;
			}
			hasSpaceBefore = 1;	
		}
		else
		{
			if (hasSpaceBefore == 1)
				*(tab+row) = (char*)malloc(100);
			tab[row][line] = passPhrase[i]; 
			line++;
			hasSpaceBefore = 0;
		}
	}
}

void afficherTab(char **tab, int numberOfWord){
	for (int i = 0; i < numberOfWord; ++i)
	{
		if (*(tab+i) == NULL)
			break;
		printf("%s \n", *(tab+i));
	}
}

void freeTab(char **tab, int numberOfWord){
	for (int i = 0; i < numberOfWord; ++i)
	{
		if (*(tab+i) == NULL)
		{
			break;
		}
		free(*(tab+i));
	}
}

void XOR(FILE *filePtr1, FILE *filePtr2, char **tab, int ActualWord){
	int i = 0;
	char fileCharacter, xoredCharacter;
	rewind(filePtr1);
	rewind(filePtr2);
	while(!feof(filePtr1)){
    	fileCharacter = fgetc(filePtr1);
    	xoredCharacter = (*(tab[ActualWord]+i) ^ fileCharacter);
        fputc(xoredCharacter, filePtr2);
        i = (i+1)%(strlen(tab[ActualWord]));	//si le premier mot fait 7 lettres i ira de 0 à 6
	}
}

void code(FILE *mainFile, char **tab, int numberOfWord){
	FILE *codedFile = NULL, *tmpFile1 = NULL, *tmpFile2 = NULL;
	FILE *actualFile = NULL;
	int mainFileSize = strlen(fileName);
 	char finalName[mainFileSize+2];

 	//on nomme le fichier qui sera codé
 	strcpy(finalName, fileName);
 	finalName[mainFileSize] = '.';
 	finalName[mainFileSize+1] = 'x';
 	finalName[mainFileSize+2] = '\0';

 	if ((codedFile = fopen(finalName, "w+")) == NULL) {
		perror(finalName);
		exit(0);
	}
 	if ((tmpFile1 = fopen("tmp1", "w+")) == NULL) {
		perror("tmp1");
		exit(0);
	}
 	if(numberOfWord > 1)
 	{
 		XOR(mainFile, tmpFile1, tab, 0);
		if ((tmpFile2 = fopen("tmp2", "w+")) == NULL) {
			perror("tmp2");
			exit(0);
		} 		
		actualFile = tmpFile1;
	 	for (int nb = 1; nb < numberOfWord; ++nb)
	 	{
	 		if (nb == numberOfWord-1)
	 			XOR(actualFile, codedFile, tab, nb);
	 		else if(nb%2 == 1){
		 		XOR(tmpFile1, tmpFile2, tab, nb);
		 		actualFile = tmpFile2;
	 		}
		 	else{
		 		XOR(tmpFile2,tmpFile1, tab, nb);
		 		actualFile = tmpFile1;
		 	}
	 	}
 	}
 	else{
 		XOR(mainFile, codedFile, tab, 0);

 	}

    fclose(codedFile);
    fclose(tmpFile2);
    fclose(tmpFile1);
    remove("tmp1");
    remove("tmp2");
}

void decode(FILE *mainFile, char **tab, int numberOfWord){
	FILE * decodedFile = NULL, *tmpFile1 = NULL, *tmpFile2 = NULL;
	FILE * actualFile = NULL;

	int mainFileSize = strlen(fileName);
 	char finalName[mainFileSize];

 	//on nomme le fichier qui sera codé
 	strcpy(finalName, fileName);
 	finalName[mainFileSize-2] = '\0';	
 	if ((decodedFile = fopen(finalName, "w+")) == NULL) {
		perror(finalName);
		exit(0);
	}
 	if ((tmpFile1 = fopen("tmp1", "w+")) == NULL) {
		perror("tmp1");
		exit(0);
	}
 	rewind(mainFile);

 	if(numberOfWord > 1)
 	{
 		XOR(mainFile, tmpFile1, tab, numberOfWord-1);
		if ((tmpFile2 = fopen("tmp2", "w+")) == NULL) {
			perror("tmp2");
			exit(0);
		}  		
		actualFile = tmpFile1;
	 	for (int nb = 1; nb < numberOfWord; ++nb)
	 	{
	 		if (nb == numberOfWord-1)
	 			XOR(actualFile, decodedFile, tab, (numberOfWord-1)-nb);
	 		else if(nb%2 == 1){
		 		XOR(tmpFile1, tmpFile2, tab, (numberOfWord-1)-nb);
		 		actualFile = tmpFile2;
	 		}
		 	else{
		 		XOR(tmpFile2, tmpFile1, tab, (numberOfWord-1)-nb);
		 		actualFile = tmpFile1;
		 	}
	 	}
 	}
 	else{
 		 	XOR(mainFile, decodedFile, tab, 0);

 	}


    fclose(decodedFile);
    fclose(tmpFile2);
    fclose(tmpFile1);
    remove("tmp1");
    remove("tmp2");
}

int main (int argc, char const *argv[])
{
	FILE *mainFile;
	double mainFileSize;

	//on récupère le nom du prog ainsi que la taille du fichier
	if ((progName = strrchr(argv[0], '/')) != NULL) {
		++progName;
	} else {
		progName = argv[0];
	}
	if (argc < 2) {
		usage(EXIT_FAILURE);
	} else if (strcmp(argv[1], "-h") == 0) {
		usage(EXIT_SUCCESS);
	}
	if ((fileName = strrchr(argv[1], '/')) != NULL) {
		++fileName;
	} else {
		fileName = argv[1];
	}
	if ((mainFile = fopen(argv[1], "r")) == NULL) {
		perror(argv[1]);
		return EXIT_FAILURE;
	}
	fseek(mainFile, 0, SEEK_END);
	mainFileSize = (double)ftell(mainFile);



	char passPhrase[100];
	int numberOfWord;
	
	printf("Qu'avez vous à me dire ?\n>>");
	fgets (passPhrase, 99, stdin);
	numberOfWord = countWord(passPhrase);
	char **tab = (char**) malloc (sizeof (char*) * numberOfWord) ;

	getWord(passPhrase, tab);

	if (*(argv[1]+strlen(argv[1])-2) == '.' && *(argv[1]+strlen(argv[1])-1) == 'x'){
		decode(mainFile, tab, numberOfWord);
	}
	else{
		code(mainFile, tab, numberOfWord);
	}

	//on libère la mémoire
	freeTab(tab, numberOfWord);
	free (tab);

	//on ferme le fichier
	fclose(mainFile);

	return 0;
}