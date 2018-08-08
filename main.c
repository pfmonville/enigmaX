// Copyright <Pierre-François Monville>
// ===========================================================================
// 									enigmaX
// Permet de chiffrer et de déchiffrer toutes les données entrées en paramètre. 
// Le mot de passe demandé au début est hashé puis sert de graine pour 
// le PRNG(générateur de nombre aléatoire). Le PRNG permet de fournir une clé unique 
// égale à la longueur du fichier à coder. La clé unique subit un xor avec 
// le mot de passe (le mot de passe est répété autant de fois que nécéssaire). 
// Le fichier subit un xor avec cette nouvelle clé, puis un brouilleur est utilisé. 
// Il mélange la table des caractères (ascii) en utilisant le PRNG et en utilisant 
// le keyfile s'il est fourni. 256 tables de brouillages sont utilisées au total dans 
// un ordre non prédictible donné par la clé unique combiné avec le keyfile s'il est fournit.
//
// Can crypt and decrypt any data given in argument. 
// The password asked is hashed to be used as a seed for the PRNG(pseudo random number generator). 
// The PRNG gives a unique key which has the same length as the source file. 
// The key is xored with the password (the password is repeated as long as necessary). 
// The file is then xored with this new key, then a scrambler is used. 
// It scrambles the ascii table using the PRNG and the keyfile if it is given. 
// 256 scramble's tables are used in an unpredictible order given by the unique key combined with 
// the keyfile if present.
//
// USAGE : 
//		enigmax [options] FILE|DIRECTORY [KEYFILE]
//
// 		code or decode the given file
//
//		FILE|DIRECTORY
//			path to the file or directory that will be crypted/decrypted
//
// 		KEYFILE: 
// 			path to a keyfile that is used to generate the scrambler instead of the password
//
// 		-s (simple) : 
// 	 		put the scrambler off
//
//		-i (inverted) :
//			invert the coding/decoding process, first it xors then it scrambles
//
//		-n (normalised) :
//			normalise the size of the keyFile, make its length matching one scrambling cycle
//
//		-d (destroy) :
//			write on top of the source file (except folder they are deleted at the end)
// 
// 		-f (force) :
// 			never ask, overwrites existing files
// 
// 		-r (randomize) :
// 			randomize the name of the output file, keeping extension
// 
// 		-R (full randomize) :
// 			randomize the name of the output file, no extension
// 
// 		-k --keyfile : 
// 			generate a keyfile
// 
// 		-h --help : 
// 			further help
//
//
// ===========================================================================

/*
TODO:
crypted folders explorer
graphical interface
special option (multi layer's password)
 */


/*
Installation

MAC:
clang -Ofast -fno-unroll-loops main.c -std='c11' -o enigmax

LINUX:
gcc -fno-move-loop-invariants -fno-unroll-loops main.c -std='c11' -o enigmax

WINDOWS (with bash for windows only):
gcc -fno-move-loop-invariants -fno-unroll-loops main.c -std='c11' -o enigmax

you can put the compiled file "enigmax" in your path to use it everywhere
export PATH=$PATH:/PATH/TO/enigmax
write it in your ~/.bashrc if you want it to stay after a reboot
*/


/*
	constants
 */
#define BUFFER_SIZE 16384  //16384 //8192
#define _XOPEN_SOURCE 500 //to use extra function used by X/OPEN and POSIX, here nftw, "500 - X/Open 5, incorporating POSIX 1995"



/*
	includes
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>
#include <time.h>
#include <limits.h>
#include <sys/ioctl.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <ftw.h>
#include <errno.h>


/*
	global variables
 */
static const char *progName;
static const char *fileName;
static char pathToMainFile[PATH_MAX] = "./";
static char outputFileName[PATH_MAX];
static char _isADirectory;
static uint64_t seed[16];
static int seedIndex = 0;
static unsigned char scrambleAsciiTables[256][256];
static unsigned char unscrambleAsciiTables[256][256];
static char isCrypting = 1;
static char scrambling = 1;
static char usingKeyFile = 0;
static char isCodingInverted = 0;
static char normalised = 0;
static char keyfileGeneration = 0;
static char force = 0;
static long numberOfBuffer;
static char scramblingTablesOrder[BUFFER_SIZE];

static char passPhrase[16384];
static uint64_t passIndex = 0;
static int passPhraseSize = 0;
static int keyFileSize = 0;

// _set_output_format(_TWO_DIGIT_EXPONENT);

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
			"NAME\n\t%s -- crypt or decrypt any data\n\nSYNOPSIS\n\t%s [options] FILE|DIRECTORY [KEYFILE]\n\nDESCRIPTION\n\t(FR) Permet de chiffrer et de déchiffrer toutes les données entrées en paramètre. Le mot de passe demandé au début est hashé puis sert de graine pour le PRNG(générateur de nombre aléatoire). Le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder. La clé unique subit un xor avec le mot de passe (le mot de passe est répété autant de fois que nécéssaire). Le fichier subit un xor avec cette nouvelle clé, puis un brouilleur est utilisé. Il mélange la table des caractères (ascii) en utilisant le PRNG et en utilisant le keyfile s'il est fourni. 256 tables de brouillages sont utilisées au total dans un ordre non prédictible donné par la clé unique combiné avec le keyfile s'il est fournit.\n\t(EN) Can crypt and decrypt any data given in argument. The password asked is hashed to be used as a seed for the PRNG(pseudo random number generator). The PRNG gives a unique key which has the same length as the source file. The key is xored with the password (the password is repeated as long as necessary). The file is then xored with this new key, then a scrambler is used. It scrambles the ascii table using the PRNG and the keyfile if it is given. 256 scramble's tables are used in an unpredictible order given by the unique key combined with the keyfile if present.\n\nOPTIONS\n\toptions are as follows:\n\n\t-h | --help\tfurther help.\n\n\t-k | --keyfile\tgenerate keyfile.\n\n\t-s (simple)\tput the scrambler on off.\n\n\t-i (inverted)\tinvert the coding/decoding process, for coding it xors then scrambles and for decoding it scrambles then xors.\n\n\t-n (normalised)\tnormalise the size of the keyfile, if the keyfile is too long (over 1 cycle in the Yates and Fisher algorithm) it will be croped to complete 1 cycle\n\n\t-d (destroy)\twrite on top of the source file (securely erase source data), except when the source is a folder where it's just deleted by the system at the end)\n\n\t-f (force)\tnever ask something to the user after entering password (overwrites the output file if it already exists and treat the second argument as a file if it looks like a set of options)\n\n\t-r (randomize)\trandomize the name of the output file but keeping the extension intact\n\n\t-R (randomize)\trandomize the name of the output file included the extension\n\n\tFILE|DIRECTORY\tthe path to the file or directory to crypt/decrypt\n\n\tKEYFILE    \tthe path to a file which will be used to scramble the substitution's tables and choose in which order they will be used instead of the PRNG only (starting at 16 ko for the keyfile is great, however not interesting to be too heavy) \n\nEXIT STATUS\n\tthe %s program exits 0 on success, and anything else if an error occurs.\n\nEXAMPLES\n\tthe command :\t%s file1\n\n\tlets you choose between crypting or decrypting then it will prompt for a password that crypt/decrypt file1 as xfile1 in the same folder, file1 is not modified.\n\n\tthe command :\t%s file2 keyfile1\n\n\tlets you choose between crypting or decrypting, will prompt for the password that crypt/decrypt file2, uses keyfile1 to generate the scrambler then crypt/decrypt file2 as xfile2 in the same folder, file2 is not modified.\n\n\tthe command :\t%s -s file3\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file without using the scrambler(option 's'), resulting in using the unique key only.\n\n\tthe command :\t%s -i file4 keyfile2\n\n\tlets you choose between crypting or decrypting, uses keyfile2 to generate the scramble table and will prompt for a password that crypt/decrypt the file but will inverts the process(option 'i'): first it xors then it scrambles for the coding process or first it unscrambles then it xors for the decoding process\n\n\tthe command :\t%s -dni file5 keyfile2\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file but generates the substitution's tables with the keyfile passing only one cycle of the Fisher & Yates algorythm(option 'n', so it's shorter in time), inverts the scrambling phase with the xoring phase(option 'i') and write on top of the source file(option 'd')\n\n\tthe command :\t%s -k file6\n\n\tgenerate a keyfile and use it to crypt/decrypt the file\n\n\tthe command :\t%s --keyfile\n\n\tonly generate a keyfile and put it in the current directory\n\nBUGS\n\tIn rare cases, when crypting/decrypting from a  directory,  the  system cannot  open  the  tarfile  it created from the directory (possibly the file system is too slow to register it). That's why the  program  waits one  second  after  the  creation  of  the tarfile when sourcefile is a directory. If it is not enough, the tarfile will not be deleted and you just  have to redo the same command with the tarfile as the source file instead of the directory (you can use the d option to  securely  delete the tarfile to produce the same steps as the standard case).\n\nAUTHOR\n\tPierre-François MONVILLE\n\nCOPYRIGHT\n\tMIT <12 september 2015> <Pierre-François MONVILLE>\n\n", progName, progName, progName, progName, progName, progName, progName, progName, progName, progName);
	} else{
		fprintf(dest,
			"\n%s -- crypt or decrypt any data\n\nVersion : 3.6.1\n\nUsage : %s [options] FILE|DIRECTORY [KEYFILE]\n\nFILE|DIRECTORY :\tpath to the file or directory to crypt/decrypt\n\nKEYFILE :\t\tpath to a keyfile for the substitution's table\n\nOptions :\n  -h | --help :\t\tfurther help\n  -k | --keyfile :\tgenerate keyfile\n  -s (simple) :\t\tput the scrambler off\n  -i (inverted) :\tinvert the process, swapping xor with scramble\n  -n (normalised) :\tnormalise the size of the keyfile\n  -d (destroy) :\toverwrite source file or delete source folder afterwards\n  -f (force) :\t\tnever ask, overwrites existing files\n  -r (randomize) :\trandomize the name of the output file, keeping extension\n  -R (full randomize) : randomize the name of the output file, no extension\n\n", progName, progName);
	}
	exit(status);
}


/*
	-long ceilRound(float numberToBeRounded)
	returned value : the number rounded (ceil form)

	to prevent from importing all math.h for just one function 
	I had to add it myself
*/
long ceilRound(float numberToBeRounded){
	if (numberToBeRounded - (long) numberToBeRounded > 0)
	{
		return (long) numberToBeRounded + 1;
	}
	return (long) numberToBeRounded;
}


/*
	void clearBuffer()

	empty the buffer	
*/
void clearBuffer()	
{
    int charInBuffer = 0;
    while (charInBuffer != '\n' && charInBuffer != EOF)
    {
        charInBuffer = getchar();
    }
}

/*
	-int readStr(char *str, unsigned long size)
	returned value : 1 on success, 0 on failure

	basicaly, it's doing a fgets but take care of the buffer
*/
int readString(char *string, unsigned long size)
{
    char *EOFPos = NULL;
    
    if(fgets(string, size, stdin) != NULL)	
    {
        EOFPos = strchr(string, '\n'); 
        if(EOFPos != NULL)	
        {
            *EOFPos = '\0';	
        }
        else	
        {
            clearBuffer();	
        }
        return 1;
    }
    else
    {
        clearBuffer();  
        return 0;
    }
}


/*
	-void processTarString(char* string)

	change string placing '\' just before every spaces in order to 
	the tar command to work with files/directories with spaces in their names
*/
char* processTarString(char* string){
	int numberOfSpace = 0;
	char* resultString;

	for (int i = 0; i < strlen(string); ++i)
	{
		if (string[i] == ' ')	
		{
			numberOfSpace++;
		}
	}

	if (numberOfSpace == 0) //just returns the same string basicaly
	{
		resultString = (char*) calloc(1, sizeof(char)* (strlen(string)));
		strcat(resultString, string);
		return resultString;
	}

	resultString = (char*) calloc(1, sizeof(char)* (strlen(string) + numberOfSpace + 1));
	for (int i = 0, j = 0; i < strlen(string); ++i, ++j)
	{
		if (string[i] == ' ')
		{
			resultString[j] = '\\';
			j++;
		}
		resultString[j] = string[i];
	}

	return resultString;
}

/*
	-void fillWithSpaces(char* string, int n)
	string : a string to fill with spaces
	size : the max size of the string given
	numberOfSpaces : the number of desired spaces
*/
void fillWithSpaces(char* string, int size, int numberOfSpaces){
	struct winsize windowSize;
	char spaceLeft;
	ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowSize);
	char toFill;
	if(numberOfSpaces - (windowSize.ws_col - strlen(string)) > 0){
		toFill = windowSize.ws_col - strlen(string) -1;
	}else{
		toFill = numberOfSpaces;
	}
	int len = strlen(string);
    // string contains a valid '\0' terminated string, so len is smaller than size
    if( len + toFill >= size ) {
        toFill = size - len - 1;
    }  
    memset( string+len, ' ', toFill );   
    string[len + toFill] = '\0';
}

/*
	-uint64_t generateNumber(void)
	returned value :  uint64_t number (equivalent to long long but on all OS)

	random number generator
	with the xorshift1024* algorythm
	represents 2^1024 states which is equal to 95^x with x the maximum number of characters before looping to an already known state and 95 equals the number of different symbols that can be used for the password. Here x = 156 characters
	it passes the BigCrush test :
	http://xoroshiro.di.unimi.it/xorshift1024star.c
 */
uint64_t generateNumber(void) {
	const uint64_t seed0 = seed[seedIndex];
	uint64_t seed1 = seed[seedIndex = (seedIndex + 1) & 15];

	seed1 ^= seed1 << 31; // a
	seed[seedIndex] = seed1 ^ seed0 ^ (seed1 >> 11) ^ (seed0 >> 30); // b,c

	return seed[seedIndex] * 0x9e3779b97f4a7c13;
}



//**********************************************************
//xoroshiro 128+ to get a random string to fill the password at the end to clean it
//from this implementation : http://xoroshiro.di.unimi.it/xoroshiro128plus.c
//**********************************************************
uint64_t secondarySeed[2];

static inline uint64_t rotl(const uint64_t x, int k) {
	return (x << k) | (x >> (64 - k));
}

uint64_t xoroshiro128(void) {
	const uint64_t s0 = secondarySeed[0];
	uint64_t s1 = secondarySeed[1];
	const uint64_t result = s0 + s1;

	s1 ^= s0;
	secondarySeed[0] = rotl(s0, 24) ^ s1 ^ (s1 << 16); // a, b
	secondarySeed[1] = rotl(s1, 37); // c

	return result;
}

void jumpForXoroshiro128(void) {
	static const uint64_t JUMP[] = { 0xdf900294d8f554a5, 0x170865df4b3201fc };

	uint64_t s0 = 0;
	uint64_t s1 = 0;
	for(int i = 0; i < sizeof JUMP / sizeof *JUMP; i++)
		for(int b = 0; b < 64; b++) {
			if (JUMP[i] & UINT64_C(1) << b) {
				s0 ^= secondarySeed[0];
				s1 ^= secondarySeed[1];
			}
			xoroshiro128();
		}

	secondarySeed[0] = s0;
	secondarySeed[1] = s1;
}
//**********************************************************

/*
	-void writeKeyFile(char* pathToKeyFile)
	pathToKeyFile : a string representing the path where to write the keyFile

	writes the keyFile in the current directory
*/
void writeKeyFile(char* pathToKeyFile){
	srand(time(NULL));
	int start = 10;
	int end = 21;
	int length = rand()%(end-start)+start;
	FILE* keyFile;
	if ((keyFile = fopen(pathToKeyFile, "wb")) == NULL) {
			perror(pathToKeyFile);
			printf("exiting...\n");
			exit(EXIT_FAILURE);
	}
	numberOfBuffer = length;
	for (int i = 0; i < numberOfBuffer; ++i)
	{
		char buffer[BUFFER_SIZE];
		for(int j = 0; j < BUFFER_SIZE; j++){
			buffer[j] = (char) xoroshiro128();
		}
		fwrite(buffer, sizeof(char), BUFFER_SIZE, keyFile);
		// random number of jump
		int numberOfJump = rand()%11;
		for (int i = 0; i < numberOfJump; ++i)
		{
			jumpForXoroshiro128();
		}
	}
	fclose(keyFile);
}

/*
	-char* generateKeyFile(char* directory)
	keyFileName : a string that will contain the name of the keyfile
	directory (OPTIONAL) : the path of the directory where to save the keyFile

	asks for a name for the keyFile then writes the keyFile in the current directory
*/
char* generateKeyFile(char* keyFileName, char* directory){
	int directorySize;
	if (directory == NULL){
		directorySize = 0;
	}else{
		directorySize = strlen(directory);
	}
	FILE* keyFile;
	char loop = 0;
	char procedureResponse1[50];
	if(force){
		sprintf(keyFileName, "key.bin");
	}
	else{
		do{
			keyFileName[0] = '\0';
			if(loop){
				printf("An error occured while trying to create keyFile: ");
				perror(procedureResponse1);
				printf("\n");
			}
			printf("Enter the name of the keyFile [key]:");
			readString(procedureResponse1, 49);
			if(strlen(procedureResponse1) == 0){
				sprintf(procedureResponse1, "key");
			}
			if(directory == NULL){
				sprintf(keyFileName, "%s.bin", procedureResponse1);
			}else{
				sprintf(keyFileName, "%s%s.bin", directory, procedureResponse1);
			}
			if((keyFile = fopen(keyFileName, "rb")) != NULL){
				char hasAnswered = 0;
				do{
					char procedureResponse2[2];
					printf("A file named %s already exists, do you want to overwrite it ? [y|N]:", keyFileName);
					readString(procedureResponse2, 2);
					if(procedureResponse2[0] == 'Y' || procedureResponse2[0] == 'y'){
						fclose(keyFile);
						keyFile = NULL;
						hasAnswered = 1;
					}else if(procedureResponse2[0] == 'N' || procedureResponse2[0] == 'n' || strlen(procedureResponse2) == 0){
						fclose(keyFile);
						keyFile = NULL;
						hasAnswered = 2;
					}
				}while(hasAnswered == 0);
				if(hasAnswered == 2){
					continue;
				}
			}
			keyFile = fopen(keyFileName, "wb");
			loop = 1;
		}while(keyFile == NULL);
		fclose(keyFile);
	}
	writeKeyFile(keyFileName);
}


/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
less readable implementation for sha-3 (Keccak) cryptographic hash function
see : https://github.com/gvanas/KeccakCodePackage/blob/master/Standalone/CompactFIPS202/Keccak-more-compact.c
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
#define FOR(i,n) for(i=0; i<n; ++i)
typedef unsigned char u8;
typedef unsigned long long int u64;
typedef unsigned int ui;

void Keccak(ui r, ui c, const u8 *in, u64 inLen, u8 sfx, u8 *out, u64 outLen);
void FIPS202_SHAKE128(const u8 *in, u64 inLen, u8 *out, u64 outLen) { Keccak(1344, 256, in, inLen, 0x1F, out, outLen); }
void FIPS202_SHAKE256(const u8 *in, u64 inLen, u8 *out, u64 outLen) { Keccak(1088, 512, in, inLen, 0x1F, out, outLen); }
void FIPS202_SHA3_224(const u8 *in, u64 inLen, u8 *out) { Keccak(1152, 448, in, inLen, 0x06, out, 28); }
void FIPS202_SHA3_256(const u8 *in, u64 inLen, u8 *out) { Keccak(1088, 512, in, inLen, 0x06, out, 32); }
void FIPS202_SHA3_384(const u8 *in, u64 inLen, u8 *out) { Keccak(832, 768, in, inLen, 0x06, out, 48); }
void FIPS202_SHA3_512(const u8 *in, u64 inLen, u8 *out) { Keccak(576, 1024, in, inLen, 0x06, out, 64); }

int LFSR86540(u8 *R) { (*R)=((*R)<<1)^(((*R)&0x80)?0x71:0); return ((*R)&2)>>1; }
#define ROL(a,o) ((((u64)a)<<o)^(((u64)a)>>(64-o)))
static u64 load64(const u8 *x) { ui i; u64 u=0; FOR(i,8) { u<<=8; u|=x[7-i]; } return u; }
static void store64(u8 *x, u64 u) { ui i; FOR(i,8) { x[i]=u; u>>=8; } }
static void xor64(u8 *x, u64 u) { ui i; FOR(i,8) { x[i]^=u; u>>=8; } }
#define rL(x,y) load64((u8*)s+8*(x+5*y))
#define wL(x,y,l) store64((u8*)s+8*(x+5*y),l)
#define XL(x,y,l) xor64((u8*)s+8*(x+5*y),l)
void KeccakF1600(void *s)
{
    ui r,x,y,i,j,Y; u8 R=0x01; u64 C[5],D;
    for(i=0; i<24; i++) {
        /*θ*/ FOR(x,5) C[x]=rL(x,0)^rL(x,1)^rL(x,2)^rL(x,3)^rL(x,4); FOR(x,5) { D=C[(x+4)%5]^ROL(C[(x+1)%5],1); FOR(y,5) XL(x,y,D); }
        /*ρπ*/ x=1; y=r=0; D=rL(x,y); FOR(j,24) { r+=j+1; Y=(2*x+3*y)%5; x=y; y=Y; C[0]=rL(x,y); wL(x,y,ROL(D,r%64)); D=C[0]; }
        /*χ*/ FOR(y,5) { FOR(x,5) C[x]=rL(x,y); FOR(x,5) wL(x,y,C[x]^((~C[(x+1)%5])&C[(x+2)%5])); }
        /*ι*/ FOR(j,7) if (LFSR86540(&R)) XL(0,0,(u64)1<<((1<<j)-1));
    }
}
void Keccak(ui r, ui c, const u8 *in, u64 inLen, u8 sfx, u8 *out, u64 outLen)
{
    /*initialize*/ u8 s[200]; ui R=r/8; ui i,b=0; FOR(i,200) s[i]=0;
    /*absorb*/ while(inLen>0) { b=(inLen<R)?inLen:R; FOR(i,b) s[i]^=in[i]; in+=b; inLen-=b; if (b==R) { KeccakF1600(s); b=0; } }
    /*pad*/ s[b]^=sfx; if((sfx&0x80)&&(b==(R-1))) KeccakF1600(s); s[R-1]^=0x80; KeccakF1600(s);
    /*squeeze*/ while(outLen>0) { b=(outLen<R)?outLen:R; FOR(i,b) out[i]=s[i]; out+=b; outLen-=b; if(outLen>0) KeccakF1600(s); }
}
/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
END of sha-3(keccak) implementation
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

/*
	-void getHash(unsigned char* output, char* password)
	output : a 128 Byte string to store the output
	password : a string which is the password typed by the user
	
	uses sha-3 (Keccak) hash function to hash the password into a 1024 bits flow
 */
void getHash(char* output, char* password){

	FIPS202_SHAKE256((unsigned char*)password, strlen(password), (unsigned char*)output, 128);
}


/*
	-void getSeed(char* password)
	password : the string corresponding to the password given by the user

	this function is here to populate the seed for the PRNG, 
	it hashes the password then puts the output into the seed array
*/
void getSeed(){
	char hash[128];
	getHash(hash, passPhrase);

	for (int i = 0; i < 16; ++i)
	{
		memcpy (&seed[i], hash + (sizeof(uint64_t) * i), sizeof (uint64_t));
	}
}

/*
	-void setSecondarySeed()

	sets the seed of xoroshiro128 so that it is not 0 everywhere
*/
void setSecondarySeed(){
	secondarySeed[0] = time(NULL);
	secondarySeed[1] = secondarySeed[0] >> 1;
}

/*
	-void getNext255StringFromKeyFile(FILE* keyFile)
	keyFile : the keyFile on which we will extract the string

	Get a 255 string from the keyFile it stops at 255 if keyFile is too long
	and make it loop if keyFile is too short
 */
void getNext255StringFromKeyFile(FILE* keyFile, char* extractedString){
	long charactersRead = 0;
	while(charactersRead < 255){

		long size = fread(extractedString + charactersRead, 1, 255 - charactersRead, keyFile);
		if(size == 0){
			rewind(keyFile);
			continue;
		}
		charactersRead += size;
	}
}



/*
	-char* getRandomFileName()

	return a dynamic string representing a random file name
 */
char* getRandomFileName(){
	char authorizedChar[] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','Y','Z','0','1','2','3','4','5','6','7','8','9','\0'};
	unsigned int length = ((unsigned int) xoroshiro128())%15 + 6;
	char* randomName;
	randomName = malloc(sizeof(char)*length);
	for(int i = 0; i < length; ++i){
		randomName[i] = authorizedChar[(unsigned int)xoroshiro128()%strlen(authorizedChar)];
	}
	randomName[length-1] = '\0';
	return randomName;
}



/*
	-void scramble(FILE* keyFile)
	keyFile : can be null, if present it passes through all the keyfile to scramble the ascii table

	scramble the ascii table assuring that there is no duplicate
	inspired by the Enigma machine; switching letters but without its weeknesses,
	here a letter can be switched by itself and it is not possible to know how many letters
	have been switched
 */
void scramble(FILE* keyFile){
	printf("scrambling substitution's tables, may be long...");
	fflush(stdout);
	for (int j = 0; j < 256; ++j)
	{
		printf("\rscrambling substitution's tables...(%d/256)       ", j + 1);
		fflush(stdout);
		char temp = 0;

		for (int i = 0; i < 256; ++i)
		{
			scrambleAsciiTables[j][i] = i;
		}

		if(! usingKeyFile) {
			unsigned char random256;
			for (int i = 0; i < 255; ++i)
			{
				//generate number between i and 255 according to Fisher and Yates shuffle algorithm
				random256 = (char)((float)((char)(generateNumber()) ^ passPhrase[passIndex]) / 255.0 * (255.0 - i) + i);
				passIndex++;
				passIndex %= passPhraseSize;
				temp = scrambleAsciiTables[j][i];
				scrambleAsciiTables[j][i] = scrambleAsciiTables[j][random256];
				scrambleAsciiTables[j][random256] = temp;
			}
		}
	}

	if (usingKeyFile){
		//scramble all tables with keyFile
		unsigned char random256;
		long numberOfCycles = ceilRound((float)keyFileSize/(float)255);
		if(normalised){
			numberOfCycles = 1;
		}
		int k = 0;
		float progress = 0;
		char temp = 0;
		// adjust loadbar to display width
		struct winsize windowSize;
		char spaceLeft;
		ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowSize);
		spaceLeft = windowSize.ws_col - 65;
		if(spaceLeft < 3){
			printf("\rscrambling sub.'s tables with keyFile...%.0f%%", progress);
		}else{
			printf("\rscrambling substitution's tables with keyFile, may be long...(%.0f%%)", progress);
		}
		fflush(stdout);
		while(k < numberOfCycles){
			if((int)((float)(k)/(float)(numberOfCycles) * 100.0) > progress){
				progress = (float)(k)/(float)(numberOfCycles) * 100.0;
				// adjust loadbar to display width
				ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowSize);
				spaceLeft = windowSize.ws_col - 65;
				if(spaceLeft < 3){
					printf("\rscrambling sub.'s tables with keyFile...%.0f%%", progress);
				}else{
					printf("\rscrambling substitution's tables with keyFile, may be long...(%.0f%%)", progress);
				}
				fflush(stdout);
			}
			for(int j = 0; j < 256; ++j){
				char extractedString[255];
				getNext255StringFromKeyFile(keyFile, extractedString);
				for (int i = 0; i < 255; ++i)
				{
					//generate number between i and 255 according to Fisher and Yates shuffle algorithm
					random256 = (char)((float)((char)(generateNumber()) ^ extractedString[i]) / 255.0 * (255.0 - i) + i);
					temp = scrambleAsciiTables[j][i];
					scrambleAsciiTables[j][i] = scrambleAsciiTables[j][random256];
					scrambleAsciiTables[j][random256] = temp;
				}
				k++;
			}
		}
		//get scramble's table order using keyFile
		char message[100];
		sprintf(message, "get scramble's table order using keyFile...");
		fillWithSpaces(message,100, 24);
		// printf("get scramble's table order using keyFile...                        \n");
		printf("\r%s", message);
		fflush(stdout);
		int j = 0;
		char tablesOrder[BUFFER_SIZE];
		while(j < BUFFER_SIZE){
			int size = fread(tablesOrder, 1, BUFFER_SIZE, keyFile);
			if(size == 0){
				rewind(keyFile);
				continue;
			}
			for (int i = 0; i < size; ++i)
			{
				scramblingTablesOrder[j] = tablesOrder[i];
				j++;
				if(j == BUFFER_SIZE){
					break;
				}
			}
		}
	}
	char message[100];
	sprintf(message, "scrambling substitution's tables... Done");
	fillWithSpaces(message,100, 27);
	// printf("scrambling substitution's tables... Done                           \n");
	printf("\r%s\n", message);
	fflush(stdout);
}


/*
	-void unscramble(void)

	this function is here only for optimization
	it inverses the key/value in the scramble ascii table making the backward process instantaneous
 */
void unscramble(){
	for (int j = 0; j < 256; ++j)
	{
		for (int i = 0; i < 256; ++i)
		{
			unsigned char c = scrambleAsciiTables[j][i];
			unscrambleAsciiTables[j][c] = i;
		}
	}
}


/*
	-void codingXOR...(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Every function is split for optimization purposes to limit the amount of conditions
	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCrypting == 1) then we switche the character from the source file then xor it
	if we are decoding (isCrypting == 0) then we xor the character from the source file then unscramble it
	The scramble table is chosed thanks to the key. 
	it gives a number from 0 to 255 that is used to chose the scrambled table. 
	It prevents a frequence analysis of the scrambled file in the event where the unique key has been found. 
	Thus even if you find the seed and by extension, the unique key, you can't apply headers and try to match 
	them to the scrambled file in order to deduce the scramble table. You absolutely need the password.
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original:a -> scramble:x -> xored:?
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void codingXORKeyFileInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = scrambleAsciiTables[(unsigned char)(scramblingTablesOrder[i] ^ keyString[i])][(unsigned char)(extractedString[i] ^ keyString[i])];
	}
}
void codingXORKeyFileNotInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = scrambleAsciiTables[(unsigned char) (scramblingTablesOrder[i] ^ keyString[i])][(unsigned char)extractedString[i]] ^ keyString[i];
	}
}
void codingXORNoKeyFileInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = scrambleAsciiTables[(unsigned char)keyString[i]][(unsigned char)(extractedString[i] ^ keyString[i])];
	}
}
void codingXORNoKeyFileNotInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = scrambleAsciiTables[(unsigned char)keyString[i]][(unsigned char)extractedString[i]] ^ keyString[i];
	}
}


/*
	-void decodingXOR...(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Every function is split for optimization purposes to limit the amount of conditions
	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCrypting == 1) then we switche the character from the source file then xor it
	if we are decoding (isCrypting == 0) then we xor the character from the source file then unscramble it
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original(a) -> scramble(x) -> xored(?)
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void decodingXORKeyFileInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = unscrambleAsciiTables[(unsigned char)(scramblingTablesOrder[i] ^ keyString[i])][(unsigned char)extractedString[i]] ^ keyString[i];
	}
}
void decodingXORKeyFileNotInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = unscrambleAsciiTables[(unsigned char)(scramblingTablesOrder[i] ^ keyString[i])][(unsigned char)(extractedString[i] ^ keyString[i])];
	}
}
void decodingXORNoKeyFileInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = unscrambleAsciiTables[(unsigned char)keyString[i]][(unsigned char)extractedString[i]] ^ keyString[i];
	}
}
void decodingXORNoKeyFileNotInverted(char* extractedString, char* keyString, char* xoredString, int bufferLength){
	int i;
	for (i = 0; i < bufferLength; ++i)
	{
		xoredString[i] = unscrambleAsciiTables[(unsigned char)keyString[i]][(unsigned char)(extractedString[i] ^ keyString[i])];
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
	if we are coding (isCrypting == 1) then we switche the character from the source file then xor it
	if we are decoding (isCrypting == 0) then we xor the character from the source file then unscramble it
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original(a) -> scramble(x) -> xored(?)
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
	but here we don't scramble so it is:
	coding : original(a) -> xored(?)
	decoding: xored(?) -> unxored(a)
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
	returned value : the size of the data read

	read a packet of data from the source file
	return the length of the packet which is the buffer size (BUFFER_SIZE)
	it can be less at the final packet (if the file isn't a multiple of the buffer size)

	the keyString is get by generating a random number with the seed and then xoring it 
	with the password itself allowing the key to be really unique and not only one of the 
	2^64 possibilities offered by the seed (uint64_t)
	the password is xoring this way : generateNumber1 ^ passPhrase[0]
									  generateNumber2 ^ passPhrase[1]
									  ...
									  then the index overflows and it returns to 0 again
									  generataNumberX ^ passPhrase[0]
									  ...
 */
int fillBuffer(FILE* mainFile, char* extractedString, char* keyString)
{
	int charactersRead = fread(extractedString, 1, BUFFER_SIZE, mainFile);

	for (int i = 0; i < charactersRead; ++i)
	{
		keyString[i] = (char)(generateNumber()) ^ passPhrase[passIndex];
		passIndex++;
		passIndex %= passPhraseSize;
	}

	return charactersRead;
}


/*
	-static inline void loadBar(int x, int n, int r, int w)
	currentIteration : the current iteration of the thing that is proccessed
	maximalIteration : the number which represents 100% of the process
	numberOfSteps : number defining how many times the bar updates
	numberOfSegments : diplayed on w segment

	display a loading bar with current percentage, graphic representation, and time remaining
	which update on every new percent by deleting itself to display the updating bar on top
	inspired by Ross Hemsley's code : https://www.ross.click/2011/02/creating-a-progress-bar-in-c-or-any-other-console-app/

 */
static inline void loadBar(int currentIteration, int maximalIteration, int numberOfSteps, char* startMessage)
{
	static char firstCall = 1;
	static double elapsedTime;
	double timeTillEnd;
	static time_t startingTime;
	time_t currentTime;

	if(firstCall){
		startingTime = time(NULL);
		firstCall = 0;
	}

    // numberOfSteps defines the number of times the bar updates.
    if ( currentIteration % (maximalIteration/numberOfSteps + 1) != 0 ) return;


	// adjust loadbar to display width
	struct winsize windowSize;
	char numberOfSegments;
	ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowSize);
	numberOfSegments = windowSize.ws_col - 45;
	if(numberOfSegments < 4){
		numberOfSegments = windowSize.ws_col - 13;
		if (numberOfSegments < 4){
			numberOfSegments = 4;
		}
	}else{
		if(numberOfSegments > 50){
			numberOfSegments = 50;
		}
		// Start with the message
		printf("%s", startMessage);
	}

    // Calculate the ratio of complete-to-incomplete.
    float ratio = (float) currentIteration / (float) maximalIteration;
    int loadBarCursorPosition = ratio * numberOfSegments;

    // get the clock now
	currentTime = time(NULL);
	// calculate the remaining time
	elapsedTime = difftime(currentTime, startingTime);
	timeTillEnd = elapsedTime * (1.0/ratio - 1.0);

    // Show the percentage.
    printf("%3d%% [", (int)(ratio*100));

    // Show the loading bar.
    for (int i = 0; i < loadBarCursorPosition; i++){
        printf("=");
    }

    for (int i = loadBarCursorPosition; i < numberOfSegments; i++){
        printf(" ");
    }

    // go back to the beginning of the line.
    // other way (with ANSI CODE) go to previous line then erase it : printf("] %.0f\n\033[F\033[J", timeTillEnd);
   	//printf("] %.0f\n\033[F\033[J", timeTillEnd);
    if(timeTillEnd > 99999){
	    printf("] %2.0E        \r", timeTillEnd);
    }else{
	    printf("] %.0f        \r", timeTillEnd);
    }
    fflush(stdout);
}


/*
	-void code(FILE* mainFile)
	mainFile : pointer to the file given by the user

	Controller for coding the source file
 */
void code (FILE* mainFile, char wantsToDeleteFirstFile, char* startMessage)
{
	char codedFileName[strlen(pathToMainFile) + 99];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* codedFile;

	// opening the output file
	if(wantsToDeleteFirstFile){
		codedFile = mainFile;
	}else if ((codedFile = fopen(outputFileName, "wb")) == NULL) {
		perror(outputFileName);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	// starting encryption
	printf("%s\r",startMessage);
	fflush(stdout);
	long bufferCount = 0; //keep trace of the task's completion
	void (*XORFunction)();
	if(usingKeyFile){
		if(isCodingInverted){
			XORFunction = codingXORKeyFileInverted;
		}else{
			XORFunction = codingXORKeyFileNotInverted;
		}
	}else{
		if(isCodingInverted){
			XORFunction = codingXORNoKeyFileInverted;
		}else{
			XORFunction = codingXORNoKeyFileNotInverted;
		}
	}
	if (scrambling){
		if(wantsToDeleteFirstFile){
			for(int i = 0; i < numberOfBuffer; i++)
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				//writing on the same file so get the cursor where it starts reading the buffer
				fseek(codedFile, -bufferLength, SEEK_CUR);
				(*XORFunction)(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				(*XORFunction)(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}
	}else{
		if(wantsToDeleteFirstFile){
			for(int i = 0; i < numberOfBuffer; i++)
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				//writing on the same file so get the cursor where it starts reading the buffer
				fseek(codedFile, -bufferLength, SEEK_CUR);
				standardXOR(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				standardXOR(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}
	}

	//we close the coded file only if we don't write on top of the source file
	if(!wantsToDeleteFirstFile){
		fclose(codedFile);
	}
}


/*
	-void decode(FILE* mainFile)
	mainFile : pointer to the file given by the user

	controller for decoding the source file
 */
void decode(FILE* mainFile, char wantsToDeleteFirstFile, char* startMessage)
{
	char decodedFileName[strlen(pathToMainFile) + 25];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* decodedFile;

	// Return the file to a unscramble ascii table
	unscramble();

	// opening the output file
	if(wantsToDeleteFirstFile){
		decodedFile = mainFile;
	}
	else if ((decodedFile = fopen(outputFileName, "wb")) == NULL) {
		perror(outputFileName);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	// starting decryption
	printf("%s\r", startMessage);
	fflush(stdout);
	long bufferCount = 0; //keep trace of the task's completion
	void (*XORFunction)();
	if(usingKeyFile){
		if(isCodingInverted){
			XORFunction = decodingXORKeyFileInverted;
		}else{
			XORFunction = decodingXORKeyFileNotInverted;
		}
	}else{
		if(isCodingInverted){
			XORFunction = decodingXORNoKeyFileInverted;
		}else{
			XORFunction = decodingXORNoKeyFileNotInverted;
		}
	}
	if(scrambling){
		if(wantsToDeleteFirstFile){
			for(int i = 0; i < numberOfBuffer; i++)
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				//writing on the same file so get the cursor where it starts reading the buffer
				fseek(decodedFile, -bufferLength, SEEK_CUR);
				(*XORFunction)(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				(*XORFunction)(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}
	}else{
		if(wantsToDeleteFirstFile){
			for(int i = 0; i < numberOfBuffer; i++)
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				//writing on the same file so get the cursor where it starts reading the buffer
				fseek(decodedFile, -bufferLength, SEEK_CUR);
				standardXOR(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				standardXOR(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, startMessage);
			}
		}
	}


	//we close the decoded file only if we don't write on top of the source file
	if(!wantsToDeleteFirstFile){
		fclose(decodedFile);
	}
}



/*
	-int isADirectory(char* path)
	path : string indicated the path of the file/directory
	returned value : 0 or 1

	indicates if the object with this path is a directory or not

*/
int isADirectory(const char* path){
	struct stat statStruct;
    int statStatus = stat(path, &statStruct);
    if(-1 == statStatus) {
        if(ENOENT == errno) {
            printf("ERROR : file's path is not correct, one or several directories and or file are missing\n");
            printf("path given: '%s'\n", path);
        } else {
            perror("stat");
            printf("path given: '%s'\n", path);
            printf("exiting...\n");
            exit(EXIT_FAILURE);
        }
    } else {
        if(S_ISDIR(statStruct.st_mode)) {
        	_isADirectory = 1;
            return 1; //it's a directory
        } else {
        	_isADirectory = 0;
            return 0; //it's not a directory
        }
    }
    printf("exiting...\n");
    exit(EXIT_FAILURE);
}


/*
	-void getProgName(char* path)
	path : the raw string from argv[0]

	extract the name of the program (usually enigmaX)

*/
void getProgName(char* path){
	if ((progName = strrchr(path, '/')) != NULL) {
		++progName;
	} else {
		progName = path;
	}
}

/*
	-char isOptionsOrFile(char* string)
	string : the string to test
	returned value : 0 if it should be treated as a set of options and 1 for a file

	checks if the string given is a file and if so, asks the user if he wants to treat it
	like a file or a set of options
*/
char isOptionsOrFile(char* string){
	FILE* testFile;
	char secondArgumentIsAFile = -1;
	if((testFile = fopen(string, "r")) != NULL){
		if(force){
			secondArgumentIsAFile = 1;
		}else{
			char procedureResponse[2];
			do{
				printf("'%s' is a valid file, do you want to treat it as a set of options or a file [o|F]:", string);
				readString(procedureResponse, 2);
				printf("\033[F\033[J");
				if (procedureResponse[0] == 'F' || procedureResponse[0] == 'f' || strlen(procedureResponse) == 0) {
					secondArgumentIsAFile = 1;
				}
				else if(procedureResponse[0] == 'O' || procedureResponse[0] == 'o'){
					secondArgumentIsAFile = 0;
				}
			}while(secondArgumentIsAFile == -1);
			fclose(testFile);
		}
	}else{
		secondArgumentIsAFile = 0;
	}
	return secondArgumentIsAFile;
}

/*
	-void checkArguments(int numberOfArgument, char* secondArgument)
	numberOfArgument : represents argc, the number of arguments given in the terminal
	secondArgument : a string reprensenting the argument just after the call of the program

	checks whether the number of arguments is correct or if the user calls for help

*/
void checkArguments(int numberOfArgument, char* secondArgument){	
	if (numberOfArgument < 2) {
		usage(1);
	} else if(numberOfArgument >= 5 ) { 
		printf("ERROR : Too many arguments(%d)\n", numberOfArgument);
		usage(1);
	} else if (strcmp(secondArgument, "-h") == 0 || strcmp(secondArgument, "--help") == 0) {
		if(isOptionsOrFile(secondArgument) == 0){
			usage(0);
		}
	} else if (numberOfArgument == 2 && (strcmp(secondArgument, "-k") == 0 || strcmp(secondArgument, "--keyfile") == 0)){
		if(isOptionsOrFile(secondArgument) == 0){
			char path[PATH_MAX];
			generateKeyFile(path, NULL);
			char cwd[PATH_MAX];
			if(getcwd(cwd, sizeof(cwd)) != NULL){
				printf("Generate keyfile done, the keyfile is at : %s/%s\n", cwd, path);
			}else{
				printf("Generate keyfile done, the keyfile is in the working directory with name : %s\n", path);
			}
			printf("Done\n");
			fflush(stdout);
			exit(EXIT_SUCCESS);
		}
	} else if (numberOfArgument == 2 && (strcmp(secondArgument, "-kf") == 0) || numberOfArgument == 2 && (strcmp(secondArgument, "-fk") == 0)){
		printf("You can't use the force option (f) with the standalone keyfile generator\n");
		exit(EXIT_FAILURE);
	}
}


/*
	-void checkDisplaySize

	check if display width is large enough
*/
void checkDisplaySize(){
		struct winsize windowSize;
		char numberOfSegments;
	    ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowSize);

	    numberOfSegments = windowSize.ws_col - 45;
	    if(numberOfSegments < 4){
	    	printf("The width of your display is too small for the loading bar to display properly.\nThe minimum size is %d and a size of %d is recommended\n", 45+4, 45+25);
	    }
}


/*
	-void getOptionsAndKeyFile(char** arguments, int numberOfArgument, FILE** keyFile, char* filePosition, char* wantsToDeleteFirstFile)
	arguments : this is argv (all the arguments given in terminal)
	numberOfArgument : this is argc (the number of arguments given in terminal)
	keyFile : a pointer to the File pointer for the keyFile
	filePosition : a pointer to the boolean, filePosition
	wantsToDeleteFirstFile : a pointer to the boolean, wantsToDeleteFirstFile

	checks if all options are correct (no duplicates and no unknowns)
	displays all warning considering options
	get the new mainFile position
	find and try to open the keyFile

*/
void getOptionsAndKeyFile(char** arguments, int numberOfArgument, FILE** keyFile, unsigned char* filePosition, unsigned char* wantsToDeleteFirstFile, unsigned char* wantsToRandomizeFileName){
	if (numberOfArgument >= 3)
	{
		char hasOptions = 0;
		if(arguments[1][0] == '-' && strlen(arguments[1]) <= 5){
			hasOptions = 1;
			if(numberOfArgument == 3){
				if(isOptionsOrFile(arguments[1]) == 0){
					hasOptions = 1;
				}else{
					hasOptions = 0;
				}
			}
			if(hasOptions){
				char option_s = 0;
				char option_i = 0;
				char option_n = 0;
				char option_d = 0;
				char option_r = 0;
				char option_R = 0;
				char option_k = 0;
				char option_f = 0;
				char several = 0;
				char other   = 0;
				char dupChar;
				for (int i = 1; i < strlen(arguments[1]); ++i){
					switch(arguments[1][i]){
						case 'h':
							printf("\nif you want full help, put --help or -h without any other options\n");
							fflush(stdout);
							usage(1);
							break;
						case'k':
							if(++option_k > 1){
								several = 1;
								dupChar = 'k';
							}	
							keyfileGeneration = 1;
							break;
						case 's':
							if(++option_s > 1){
								several = 1;
								dupChar = 's';
							}	
							scrambling = 0;
							break;
						case 'i':
							if(++option_i > 1){
								several = 1;
								dupChar = 'i';
							}
							isCodingInverted = 1;
							break;
						case 'n':
							if(++option_n > 1){
								several = 1;
								dupChar = 'n';
							}
							normalised = 1;
							break;
						case 'd':
							if(++option_d > 1){
								several = 1;
								dupChar = 'd';
							}
							*wantsToDeleteFirstFile = 1;
							break;
						case 'r':
							if(++option_r > 1 || option_R > 0){
								several = 1;
								dupChar = 'r';
							}
							*wantsToRandomizeFileName = 1;
							break;
						case 'R':
							if(++option_R > 1 || option_r > 0){
								several = 1;
								dupChar = 'R';
							}
							*wantsToRandomizeFileName = 2;
							break;
						case 'f':
							if(++option_f > 1){
								several = 1;
								dupChar = 'f';
							}
							force = 1;
							break;
						default:
							other = 1;
					}
					if(other){
						printf("ERROR: unknown option set '%c'\n", arguments[1][i]);
						printf("exiting...\n");
						exit(EXIT_FAILURE);
					}
					if(several){
						printf("ERROR: an option has been entered several times, '%c'\n", dupChar);
						printf("exiting...\n");
						exit(EXIT_FAILURE);
					}
				}

				if(!scrambling && isCodingInverted){
					printf("ERROR: option 's'(no scrambling) and option 'i'(invert coding/scrambling) cannot be set together\n");
					printf("exiting...\n");
					exit(EXIT_FAILURE);
				}

				if(!scrambling && normalised){
					printf("ERROR: option 's'(no scrambling) and option 'n'(normalised scrambler) cannot be set together\n");
					printf("exiting...\n");
					exit(EXIT_FAILURE);
				}

				if(*wantsToDeleteFirstFile){
					printf("WARNING : with the option 'd'(delete) the source file will be overwritten. Do not quit during encryption\n");
					fflush(stdout);
				}

				if(scrambling && !isCodingInverted && !normalised && !*wantsToDeleteFirstFile && !*wantsToRandomizeFileName && !keyfileGeneration && !force){
					printf("ERROR : no valid option has been found\n");
					printf("options given: '%s'\n", arguments[1]);
					usage(1);
				}
				//we found correct options so the file is after
				else{*filePosition = 2;
				}

				//test if there is a keyFile
				if(numberOfArgument == 4){
					if((*keyFile = fopen(arguments[3], "rb")) == NULL){
						perror(arguments[3]);
						usage(1);
					}
					if(*keyFile != NULL){
						if(keyfileGeneration){
							printf("WARNING : the keyfile generated will replace the keyfile given\n");
							fflush(stdout);
							*keyFile = NULL;
						}
						if(isADirectory(arguments[3])){
							printf("WARNING : the keyfile is a directory and will not be used\n");
							fflush(stdout);
							*keyFile = NULL;
						}else if(!scrambling){
							printf("WARNING : with the option 's'(simple), the keyfile will not be used\n");
							fflush(stdout);
							*keyFile = NULL;
						}
					}
				}
			}
		} 
		if (!hasOptions && (*keyFile = fopen(arguments[2], "rb")) == NULL) {
			perror(arguments[2]);
			usage(1);
		} else if(!hasOptions && *keyFile != NULL){
			if(isADirectory(arguments[2])){
				printf("WARNING : the keyfile is a directory and will not be used\n");
				fflush(stdout);
				*keyFile = NULL;
			}
			if(numberOfArgument >= 4){
				printf("ERROR : Too many arguments(%d)\n", numberOfArgument);
				usage(1);
			}
		}

		if(*keyFile != NULL){
			usingKeyFile = 1;
			rewind(*keyFile);
			fseek(*keyFile, 0, SEEK_END);
			keyFileSize = ftell(*keyFile);
			rewind(*keyFile);

			if(keyFileSize == 0){
				printf("WARNING : the keyFile is empty and thus will not be used\n");
				fflush(stdout);
				*keyFile = NULL;
				usingKeyFile = 0;
			}
		}
		if(!usingKeyFile && normalised && !keyfileGeneration){
			printf("WARNING : without the keyFile, the option 'n'(normalised) will be ignored\n");
			fflush(stdout);
			normalised = 0;
		}
	}
}


/*
	-int prepareAndOpenMainFile(char** tarName, char** dirName, FILE** mainFile, const char* filePath)
	tarName : a pointer to the name used to tar the mainFile
	dirName : a pointer to the name of the parent directory of the mainFile
	mainFile : a pointer to the File pointer for the mainFile
	filePath : the path of the mainFile

	checks if the mainFile is a directory
	if it is the case, tries to tar it and open the new tar file as the mainFile
	otherwise just tries to open the mainFile

*/
void prepareAndOpenMainFile(char** tarName, char** dirName, FILE** mainFile, const char* filePath, char wantsToDeleteFirstFile, char wantsToRandomizeFileName, FILE** keyFile){
	char openType[4] = "";

	if (wantsToDeleteFirstFile)
	{
		strcpy(openType, "rb+");
	}else{
		strcpy(openType, "rb");
	}

	if (filePath[strlen(filePath)-1] == '/' && filePath[strlen(filePath)-2] == '/')
	{
		printf("ERROR : several trailing '/' in the path of your file\n");
		printf("path given: '%s'\n", filePath);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	if (isADirectory(filePath)){
		char command[1008] = {'\0'};
		printf("regrouping the folder in one file using tar, may be long...");
		fflush(stdout);
		// get the name of the folder in a string and get the path
		if ((fileName = strrchr(filePath, '/')) != NULL) {
			//if the '/' is the last character in the string, delete it and get the fileName again
			if (strlen(fileName) == 1){
				*dirName = (char*) calloc(1, sizeof(char) * (strlen(filePath) + 5));
				strcpy(*dirName, filePath);
				*(*dirName+(fileName-filePath)) = '\0';
				if ((fileName = strrchr(*dirName, '/')) != NULL){
					++fileName;
					strncpy(pathToMainFile, *dirName, fileName - *dirName);
					pathToMainFile[fileName - *dirName] = '\0';
				}
				else{
					fileName = *dirName;
				}
			}
			else {
				++fileName;
				strncpy(pathToMainFile, filePath, fileName - filePath);
				pathToMainFile[fileName - filePath] = '\0';
			}
		}
		else {
			fileName = filePath;
		}
		// get the full path of the tarFile in a dynamic variable tarName
		*tarName = (char*) calloc(1, sizeof(char) * (strlen(fileName) + 5));
		sprintf (*tarName, "%s.tar", fileName);

		//all of the following is to make a clean string for the tar commands (taking care of spaces)
		char* cleanFileName       = processTarString((char*)fileName);
		char* cleanPathToMainFile = processTarString(pathToMainFile);
		char* cleanTarName        = processTarString(*tarName);

		// use of cd to prevent tar to archive all the path architecture 
		// (ex: /usr/myname/my/path/theFolderWeWant/)
		sprintf (command, "cd %s && tar -cf %s %s", cleanPathToMainFile, cleanTarName, cleanFileName); //&>/dev/null

		//free the temporary strings
		free(cleanPathToMainFile);
		free(cleanTarName);
		free(cleanFileName);

		// make the archive of the folder with tar
		int status;
		if((status = system(command)) != 0){ //if problems when taring
			printf("\nERROR : unable to tar your file\n");
			printf("exiting...\n");
			exit(EXIT_FAILURE);
		}else{
			char message[100];
			sprintf(message, "regrouping the folder in one file using tar... Done");
			fillWithSpaces(message,100, 10);
			// printf("\rregrouping the folder in one file using tar... Done          \n");
			printf("\r%s\n", message);
			fflush(stdout);			
		}

		fileName = *tarName;

		// pause to let the system register the archive
		sleep(1);

		// trying to open the new archive
		char pathPlusName[strlen(pathToMainFile)+strlen(fileName)];
		sprintf(pathPlusName, "%s%s", pathToMainFile, fileName);
		if ((*mainFile = fopen(pathPlusName, openType)) == NULL) {
			perror(pathPlusName);
			printf("exiting...\n");
			exit(EXIT_FAILURE);
		}
	}
	else{
		if ((fileName = strrchr(filePath, '/')) != NULL) {
			++fileName;
			strncpy(pathToMainFile, filePath, fileName - filePath);		
		} else {
			fileName = filePath;
		}
		if ((*mainFile = fopen(filePath, openType)) == NULL) {
			perror(filePath);
			printf("exiting...\n");
			exit(EXIT_FAILURE);
		}
	}

	if(!wantsToDeleteFirstFile){
		FILE* testFile;
		if(wantsToRandomizeFileName && !wantsToDeleteFirstFile){
			char generatedNameIsUnique = 0;
			do{
				outputFileName[0] = '\0';
				char* randomName = getRandomFileName();
				if(wantsToRandomizeFileName == 2){
					sprintf(outputFileName, "%s%s", pathToMainFile, randomName);
				}else{
					char* extension = strrchr(fileName, '.');
					if(extension != NULL && (extension != fileName && extension[0] != fileName[strlen(fileName)-1])){
						sprintf(outputFileName, "%s%s%s", pathToMainFile, randomName, extension);
					}else{
						sprintf(outputFileName, "%s%s", pathToMainFile, randomName);
					}
				}
				free(randomName);
				if((testFile = fopen(outputFileName, "rb")) == NULL){
					generatedNameIsUnique = 1;
				}else{
					fclose(testFile);
					testFile = NULL;
				}
			}while(generatedNameIsUnique == 0);
		}else{
			sprintf(outputFileName, "%sx%s", pathToMainFile, fileName);
			char canWriteOnOutputFile = 0;
			do{
				if(!force && (testFile = fopen(outputFileName, "rb")) != NULL){
					char procedureResponse1[2];
					printf("A file with the name %s already exists, do you want to overwrite it ? [y|N]:", outputFileName);
					readString(procedureResponse1, 2);
					if(procedureResponse1[0] == 'Y' || procedureResponse1[0] == 'y'){
						fclose(testFile);
						testFile = NULL;
						canWriteOnOutputFile = 1;
					}else if(procedureResponse1[0] == 'N' || procedureResponse1[0] == 'n' || strlen(procedureResponse1) == 0){
						fclose(testFile);
						testFile = NULL;
						char procedureResponse2[100];
						printf("Enter the name of the output file:");
						char firstLoop = 1;
						do{
							if(firstLoop == 0){
								printf("the output filename can't be empty\n");
								printf("Enter the name of the output file:");
							}
							readString(procedureResponse2, 99);
							firstLoop = 0;
						}while(strlen(procedureResponse2) == 0);
						outputFileName[0] = '\0';
						sprintf(outputFileName, "%s%s", pathToMainFile, procedureResponse2);
					}
				}else{
					canWriteOnOutputFile = 1;
				}
			}while(canWriteOnOutputFile == 0);
		}
	}

	if(keyfileGeneration){
		char path[PATH_MAX];
		generateKeyFile(path, pathToMainFile);
		if((*keyFile = fopen(path, "rb")) == NULL){
			printf("cannot load the generated keyFile\n");
			perror(path);
			printf("exiting...\n");
		}
		usingKeyFile = 1;
		rewind(*keyFile);
		fseek(*keyFile, 0, SEEK_END);
		keyFileSize = ftell(*keyFile);
		rewind(*keyFile);

		if(keyFileSize == 0){
			printf("WARNING : the keyFile is empty and thus will not be used\n");
			fflush(stdout);
			*keyFile = NULL;
			usingKeyFile = 0;
		}
	}
}


/*
	-void getNumberOfBuffer(FILE* mainFile)
	mainFile : the mainFile
	
	calculates the number of buffer needed in order to complete 
	the main process on the mainFile

*/
void getNumberOfBuffer(FILE* mainFile){
	fseek(mainFile, 0, SEEK_END);
	fflush(stdout);
	long mainFileSize = ftell(mainFile);
	rewind(mainFile);
	numberOfBuffer = ceilRound((float)mainFileSize / (float)(BUFFER_SIZE));
	if (numberOfBuffer < 1)
	{
		numberOfBuffer = 1;
	}
}


/*
	-void getUserPrompt()

	Asks the user what he wants to do 
	and asks for the password

*/
void getUserPrompt(){
	char procedureResponse[2]; 
	isCrypting = -1;
	do{
		printf("Crypt or Decrypt [C|d]:");
		readString(procedureResponse, 2);
		printf("\033[F\033[J");
		if (procedureResponse[0] == 'C' || procedureResponse[0] == 'c' || strlen(procedureResponse) == 0) {
			isCrypting = 1;
		}
		else if(procedureResponse[0] == 'D' || procedureResponse[0] == 'd'){
			isCrypting = 0;
		}
	}while(isCrypting == -1);
	long size;
	do{
		printf("Password:");
		readString(passPhrase, 16384);
		size = strlen(passPhrase);
		if(size <= 0){
			printf("the password can't be empty\n");
			continue;
		}
		printf("\033[F\033[J");
	}while(size <= 0);
	passPhraseSize = strlen(passPhrase);
}



/*
	-void startMainProcess(FILE* mainFile, char wantsToDeleteFirstFile)
	mainFile : the mainFile
	wantsToDeleteFirstFile : a boolean that indicates if the user wants to delete the source file afterwards
	
	Launches the coding or decoding process 
	and deletes the source file if the user wants so

*/
void startMainProcess(FILE* mainFile, char wantsToDeleteFirstFile, char wantsToRandomizeFileName){
	if (isCrypting){
		code(mainFile, wantsToDeleteFirstFile, "starting encryption... ");
		char message[100];
		sprintf(message, "starting encryption... Done");
		fillWithSpaces(message,100, 67);
		// printf("\rstarting encryption... Done                                                                   \n");
		printf("\r%s\n", message);
	}
	else{
		decode(mainFile, wantsToDeleteFirstFile, "starting decryption... ");
		char message[100];
		sprintf(message, "starting decryption... Done");
		fillWithSpaces(message,100, 67);
		// printf("\rstarting decryption... Done                                                                   \n");
		printf("\r%s\n", message);
	}
	fflush(stdout);
	if(!_isADirectory){
		fclose(mainFile);
	}
}



/*
	-int unlink_cb(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf)
	fpath : the string path of the file or empty folder
	sb : necessary to be a callback function for nftw
	typeflag : necessary to be a callback function for nftw
	ftwbuf : necessary to be a callback function for nftw
	return int 0 on success -1 otherwise

	remove the file or the empty directory from system

 */
int unlink_cb(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf)
{
    int rv = remove(fpath);

    if (rv)
        perror(fpath);

    return rv;
}



/*
	-int rmrf(char *path)
	path : the string path of the folder
	return int 0 if success -1 otherwise

	delete a folder and any file/folder in it using nftw function and the function unlink_cb()

 */
int rmrf(char *path)
{
    return nftw(path, unlink_cb, 64, FTW_DEPTH | FTW_PHYS);
}



/*
	-void clean(char* tarName, char* dirName)
	tarName : the string used to name the tarFile from the mainFile
	dirName : the string used to store the path of the parent directory of the mainFile

	writes in the passPhrase emplacement random informations, 
	so the password is not retrievable from RAM after the program ends
	free tarName and dirName variables

*/
void clean(FILE* mainFile, char* tarName, char* dirName, char wantsToDeleteFirstFile, char wantsToRandomizeFileName, char* filePath){
	char mainFileString[strlen(pathToMainFile) + strlen(fileName) + 1];
	sprintf(mainFileString, "%s%s", pathToMainFile, fileName);
	//if we write on top of source file, we rename the source file so it's not confusing
	if(wantsToDeleteFirstFile){
		FILE* testFile;
		char outputFileString[strlen(mainFileString) + 25];
		if(wantsToRandomizeFileName){
			char generatedNameIsUnique = 0;
			do{
				outputFileString[0] = '\0';
				char* randomName = getRandomFileName();
				if(wantsToRandomizeFileName == 2){
					sprintf(outputFileString, "%s%s", pathToMainFile, randomName);
				}else{
					char* extension = strrchr(fileName, '.');
					if(extension != NULL && (extension != fileName && extension[0] != fileName[strlen(fileName)-1])){
						sprintf(outputFileString, "%s%s%s", pathToMainFile, randomName, extension);
					}else{
						sprintf(outputFileString, "%s%s", pathToMainFile, randomName);
					}
				}
				free(randomName);
				if((testFile = fopen(outputFileString, "rb")) == NULL){
					generatedNameIsUnique = 1;
				}else{
					fclose(testFile);
					testFile = NULL;
				}
			}while(generatedNameIsUnique == 0);
			rename(mainFileString, (const char*)outputFileString);
		}else{
			sprintf(outputFileString, "%sx%s", pathToMainFile, fileName);
			if ((testFile = fopen(outputFileString, "rb")) != NULL){
				printf("\nWARNING : the source has been processed in place but it can't be renamed because a file named %s already exists so the file kept its name %s\n",outputFileString, fileName);
				fclose(testFile);
			}else{
				rename(mainFileString, (const char*)outputFileString);
			}
		}
	}else if(_isADirectory){
			// we have to securely delete the archive file used to crypt the folder
			// put random char in the file then remove it
			rewind(mainFile);
			float progress = 0.0;
			for(int i = 0; i < numberOfBuffer; i++)
			{
				if((int)((float)(i)/(float)(numberOfBuffer) * 100.0) > progress){
					progress = (float)(i)/(float)(numberOfBuffer) * 100.0;
					printf("\rsecurely deleting archive... (%.0f%%)", progress);
					fflush(stdout);
				}
				char buffer[BUFFER_SIZE];
				//fill a buffer
				for(int j = 0; j < BUFFER_SIZE; j++){
					buffer[j] = (char) xoroshiro128();
				}
				//put buffer in filePath
				fwrite(buffer, sizeof(char), BUFFER_SIZE, mainFile);
			}
			fclose(mainFile);
			remove((const char*)mainFileString);
			printf("\rsecurely deleting archive... Done   \n");
			fflush(stdout);
	}
	if(_isADirectory && wantsToDeleteFirstFile){
		//not secure removal but it's the best we can do so far with folders
		if(rmrf(filePath) != 0){
			//error
			printf("ERROR : the source file (folder) were not completely deleted\n");
			fflush(stdout);
		}
	}
	printf("cleaning buffers and ram... ");
	fflush(stdout);
	for (int i = 0; i < passPhraseSize; i++)
	{
		passPhrase[i] = (char) xoroshiro128();
	}

	if(tarName != NULL){
		free(tarName);
	}
	if(dirName != NULL){
		free(dirName);
	}
	printf("Done\n");
	fflush(stdout);
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
	unsigned char filePosition = 1;
	unsigned char wantsToDeleteFirstFile = 0;
	unsigned char wantsToRandomizeFileName = 0;
	//outside their scope because we need to free them at the end
	char* tarName = NULL;
	char* dirName = NULL;

	setSecondarySeed();
	getProgName((char*)argv[0]);
	checkDisplaySize();
	checkArguments(argc, (char*)argv[1]);
	getOptionsAndKeyFile((char**)argv, argc, &keyFile, &filePosition, &wantsToDeleteFirstFile, &wantsToRandomizeFileName);

	prepareAndOpenMainFile(&tarName, &dirName, &mainFile, (char*)argv[filePosition], wantsToDeleteFirstFile, wantsToRandomizeFileName, &keyFile);
	getNumberOfBuffer(mainFile);

	getUserPrompt();	
	
	getSeed();
	scramble(keyFile);
	startMainProcess(mainFile, wantsToDeleteFirstFile, wantsToRandomizeFileName);
	//avoid the password to be stored in ram
	clean(mainFile, tarName, dirName, wantsToDeleteFirstFile, wantsToRandomizeFileName, (char*)argv[filePosition]);

	printf("\n");

	return EXIT_SUCCESS;
}
