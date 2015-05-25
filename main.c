// Copyright <Pierre-François Monville>
// ===========================================================================
// 									enigmaX
// permet de chiffrer et de déchiffrer tout fichier donné en paramètre
// le mot de passe demandé au début est hashé puis sert de graine pour le PRNG
// le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder
// ainsi la sécurité est maximale (seule solution, bruteforcer le mot de passe)
// De plus un brouilleur est utilisé, il mélange la table des caractères (ascii)
// en utilisant le PRNG ou en utilisant le keyFile fourni au cas où une faille
// matériel permettrait d'analyser la ram afin d'inverser les xor, le résultat
// obtenu serait toujours illisible.
//
// Can crypt and decrypt any file given in argument. The password asked is hashed
// to be used as a seed for the PRNG. The PRNG gives a unique key
// which has the same length as the source file, thus the security is maximum
// (the only way to break through is by bruteforce). Moreover, a scambler is used,
// it scrambles the ascii table using the PRNG or the keyFile given to prevent
// an hardware failure allowing ram analysis to invert the xoring process, making
// such an exploit useless.
//
// USAGE : enigmaX file [keyFile]
// 		then enter a password to crypt or decrypt if the file given is a .x
//
// ===========================================================================


/*
	includes
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>


/*
	constants
 */
#define BUFFER_SIZE 16384


/*
	global variables
 */
static const char *progName;
static const char *fileName;
static uint64_t seed[2];
static unsigned char scrambleAsciiTable[256];
static unsigned char unscrambleAsciiTable[256] = "";
static char isCoding = 1;
static char scambling = 1;


/*
	-static void usage(int status)
	status : expect EXIT_FAILURE or EXIT_SUCCESS code to choose the output stream

	when the program is typed without arguments in terminal it shows the usage
 */
static void usage(int status)
{
	FILE *dest = (status == 0) ? stdout : stderr;

	if(status == 0){
		fprintf(dest,
			"%s(1)\t\t\tcopyright <Pierre-François Monville>\t\t\t%s(1)\n\nNAME\n\t%s -- crypt or decrypt files\n\nSYNOPSIS\n\t%s [-h | --help] FILE [-s | --standard | KEYFILE]\n\n\tDESCRIPTION\n\t\tpermet de chiffrer et de déchiffrer tous fichiers donnés en paramètrele mot de passe demandé au début est hashé puis sert de graine pour le PRNGle PRNG permet de fournir une clé unique égale à la longueur du fichier à coderainsi la sécurité est maximale (seule solution, bruteforcer le mot de passe)De plus un brouilleur est utilisé, il mélange la table des caractères (ascii)en utilisant le PRNG ou en utilisant le keyFile fourni au cas où une faillematériel permettrait d'analyser la ram afin d'inverser les xor, le résultatobtenu serait toujours illisible.\nCan crypt and decrypt any file given in argument. The password asked is hashedto be used as a seed for the PRNG. The PRNG gives a unique keywhich has the same length as the source file, thus the security is maximum(the only way to break through is by bruteforce). Moreover, a scambler is used,it scrambles the ascii table using the PRNG or the keyFile given to preventan hardware failure allowing ram analysis to invert the xoring process, makingsuch an exploit useless.\n\n\tthe options are as follows:\n\n\t-h | --help\tfurther help.\n\n\t-s | --standard\tput the scambler on off.\n\nEXIT STATUS\n\tthe %s program exits 0 on success, and anything else if an error occurs.\n\nEXAMPLES\n\tthe command:\n\n\t\t%s file1\n\n\t\twill prompt for a password then crypt the file then store it to file.x in the same folder, file1 is not modified.\n\n\tthe command:\n\n\t\t%s file2.x keyfile1\n\n\twill prompt for the password that encrypted file2, uses keyfile1 to generate the scambler then decrypt file2.x, file2.x is not modified.\n\n\tthe command:\n\n\t\t%s file3 -s\n\n\twill prompt for a password then crypt the file without using the scambler, resulting in using the unique key only.\n", progName, progName, progName, progName, progName, progName, progName, progName);
	} else{
		fprintf(dest,
			"Usage: %s [-h | --help] FILE [-s | --standard | KEYFILE]\n\n\tcode or decode the given file\n\tthe file you want to decode must finish with .x\n\n\tKEYFILE: \n\t\tpath to a keyfile that is used to generate the scambler instead of the password\n\n\t-s --standard : \n\t\t put the scambler on off\n\n\t-h --help : \n\t\tfurther help\n", progName);
	}
	exit(status);
}


/*
	-uint64_t generateNumber(void)
	returned value :  uint64_t number (equivalent to long long but on all OS)

	random number generator
	with the Xorshift+ algorythm which is one of the quickiest PRNG
	it passes the BigCrush test :
	http://en.wikipedia.org/wiki/Xorshift
 */
uint64_t generateNumber()
{
	uint64_t x = seed[0];
	uint64_t const y = seed[1];
	seed[0] = y;
	x ^= x << 23; // a
	x ^= x >> 17; // b
	x ^= y ^ (y >> 26); // c
	seed[1] = x;
	return x + y;
}


/*
	-void hash(char* password)
	password : a string which is the password typed by the user

	simple function that hashes a string into numbers
	we don't have to worry about security here because it is just to transform the password into numbers
	that populate the seeds of the RNG (seed[2])
	the number which is multiplied (131) must be a prime number and superior to 256 to avoid collision
 */
void hash(char* password)
{
	uint64_t h = 0;
	for (int j = 0; j < 2; ++j)
	{
		for (int i = 0; password[i]; i++)
		{
			h = 257 * h + password[i];
		}
		seed[j] = h;
	}
}


/*
	-void scramble(FILE* keyFile)
	keyFile : can be null, if present random256 takes its values from it

	scramble the ascii table assuring that there is no duplicate
	inspired by the Enigma machine; switching letters but without its weekness,
	here a letter can be switched by itself and it is not possible to know how many letters
	have been switched
 */
void scramble(FILE* keyFile){
	char temp = 0;

	for (int i = 0; i < 256; ++i)
	{
		scrambleAsciiTable[i] = i;
	}

	if (keyFile != NULL){
		int size;
		char extractedString[BUFFER_SIZE] = "";
		while((size = fread(extractedString, 1, BUFFER_SIZE, keyFile)) > 0){
			for (int i = 0; i < size; ++i)
			{
				temp = scrambleAsciiTable[i%256];
				scrambleAsciiTable[i%256] = scrambleAsciiTable[(unsigned char)(extractedString[i])];
				scrambleAsciiTable[(unsigned char)(extractedString[i])] = temp;
			}
		}
	} else {
		unsigned char random256;
		for (int i = 0; i < 10 * 256; ++i)
		{
			random256 = generateNumber();
			temp = scrambleAsciiTable[i%256];
			scrambleAsciiTable[i%256] = scrambleAsciiTable[random256];
			scrambleAsciiTable[random256] = temp;
		}
	}
}


/*
	-void unscramble(void)

	this function is here only for optimization
	it inverses the key/value in the scramble ascii table making the backward process instaneous
 */
void unscramble(){
	for (int i = 0; i < 256; ++i)
	{
		unscrambleAsciiTable[(unsigned char) scrambleAsciiTable[i]] = i;
	}
}


/*
	-void XOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCoding == 1) then we switche the character from the source file then xor it
	if we are decoding (isCoding == 0) then we xor the character from the source file then unscramble it
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original(a) -> scramble(x) -> xored(?)
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void codingXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
{
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = scrambleAsciiTable[(unsigned char)extractedString[i]] ^ keyString[i];
	}
}


/*
	-void XOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Here only for optimization purpose to limit the amount of conditions
	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCoding == 1) then we switche the character from the source file then xor it
	if we are decoding (isCoding == 0) then we xor the character from the source file then unscramble it
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original(a) -> scramble(x) -> xored(?)
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void decodingXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
{
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = unscrambleAsciiTable[(unsigned char)(extractedString[i] ^ keyString[i])];
	}
}


/*
	-void standardXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Here only for optimization purpose so that there is the small amount
	of condition possible when encrypt or decrypt
	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCoding == 1) then we switche the character from the source file then xor it
	if we are decoding (isCoding == 0) then we xor the character from the source file then unscramble it
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original(a) -> scramble(x) -> xored(?)
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void standardXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
{
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = extractedString[i] ^ keyString[i];
	}
}


/*
	-int fillbuffer(FILE* mainFile, char* extractedString, char* keyString)
	mainFile : pointer to the file given by the user
	extractedString : will contains the data extracted from the source file in a string format
	keyString : will contains a part of the unique key in a string format
	returned value : the size of the data reed

	read a packet of data from the source file
	return the length of the packet which is the buffer size (BUFFER_SIZE)
	it can be less at the final packet (if the file isn't a multiple of the buffer size)

	former version (multiply execution time by 5) :
	int fillBuffer(FILE* mainFile, char* extractedString, char* keyString)
	{
		int i = 0;

		while(!feof(mainFile) && i < BUFFER_SIZE)
		{
			char charBuffer = fgetc(mainFile);
			if (feof(mainFile)) break; //special debug for the last character in text files
			extractedString[i] = charBuffer;
			i++;
		}

		return i;
	}
 */
int fillBuffer(FILE* mainFile, char* extractedString, char* keyString)
{
	int i = 0;

	for (int i = 0; i < BUFFER_SIZE; ++i)
	{
		keyString[i] = generateNumber();
	}

	return fread(extractedString, 1, BUFFER_SIZE, mainFile);
}


/*
	-void code(FILE* mainFile)
	mainFile : pointer to the file given by the user

	Controller for coding the source file
 */
void code (FILE* mainFile)
{
	int mainFileSize = strlen(fileName);
	char codedFileName[mainFileSize+2];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* codedFile;

	// naming the file which will be crypted(get the source name and put a .x at the end)
	strcpy(codedFileName, fileName);
	codedFileName[mainFileSize] = '.';
	codedFileName[mainFileSize+1] = 'x';
	codedFileName[mainFileSize+2] = '\0';

	// opening the output file
	if ((codedFile = fopen(codedFileName, "w+")) == NULL) {
		perror(codedFileName);
		exit(EXIT_FAILURE);
	}

	// starting encryption
	if (scambling == 1){
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			codingXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, codedFile);
		}
	} else {
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			standardXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, codedFile);
		}
	}
	// closing the output file
	fclose(codedFile);
}


/*
	-void decode(FILE* mainFile)
	mainFile : pointer to the file given by the user

	controller for decoding the source file
 */
void decode(FILE* mainFile)
{
	int mainFileSize = strlen(fileName);
	char decodedFileName[mainFileSize];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* decodedFile;

	// naming the file which will be decrypted (get the source name and cut the .x at the end)
	strcpy(decodedFileName, fileName);
	decodedFileName[mainFileSize-2] = '\0';

	// opening the output file
	if ((decodedFile = fopen(decodedFileName, "w+")) == NULL) {
		perror(decodedFileName);
		exit(EXIT_FAILURE);
	}

	// starting decryption
	if(scambling == 1){
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			decodingXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
		}
	} else {
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			standardXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
		}
	}
	// closing the output file
	fclose(decodedFile);
}


/*
	-int main(int argc, char const* argv[])
	argc : number of arguments passed in the terminal
	argv : pointer to the arguments passed in the terminal
	returned value : 0

 */
int main(int argc, char const *argv[])
{
	FILE* mainFile;
	FILE* keyFile = NULL;

	if ((progName = strrchr(argv[0], '/')) != NULL) {
		++progName;
	} else {
		progName = argv[0];
	}
	if (argc < 2) {
		usage(EXIT_FAILURE);
	} else if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0) {
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
	if (argc >= 3)
	{
		if (strcmp(argv[2], "-s") == 0 || strcmp(argv[2], "--standard") == 0){
		scambling = 0;
		} else if ((keyFile = fopen(argv[2], "r")) == NULL) {
			perror(argv[1]);
			return EXIT_FAILURE;
		}
	}

	char passPhrase[1000];
	printf("Qu'avez vous à me dire ?\n>>");
	fgets (passPhrase, 999, stdin);
	hash(passPhrase);
	scramble(keyFile);

	if (*(argv[1]+strlen(argv[1])-2) == '.' && *(argv[1]+strlen(argv[1])-1) == 'x'){
		isCoding = 0;
		unscramble();
		decode(mainFile);
	}
	else{
		isCoding = 1;
		code(mainFile);
	}

	fclose(mainFile);
	return 0;
}
