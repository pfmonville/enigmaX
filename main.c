// Copyright <Pierre-François Monville>
// ===========================================================================
// 									enigmaX
// Permet de chiffrer et de déchiffrer toutes les données entrées en paramètre. 
// Le mot de passe demandé au début est hashé puis sert de graine pour le PRNG(générateur de nombre aléatoire). 
// Le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder. 
// La clé unique subit un xor avec le mot de passe (le mot de passe est répété autant de fois que nécéssaire). 
// Le fichier subit un xor avec cette nouvelle clé, puis un brouilleur est utilisé. 
// il mélange la table des caractères (ascii) en utilisant le PRNG et en utilisant le keyfile s'il est fourni. 
// 256 tables de brouillages sont utilisées au total dans un ordre non prédictible donné par la clé unique combiné 
// avec le keyfile s'il est fournit.
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
//		enigmax [options] FILE [KEYFILE]
//
// 		code or decode the given file
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
// 		-h --help : 
// 			further help
//
//
// ===========================================================================

/*
TODO:
crypted folders explorer
graphical interface
special option (multi layer's password, hide extension, randomize the name)
 */


/*
Installation

MAC:
clang -Ofast -fno-unroll-loops main.c -std='c11' -o enigmax

LINUX:
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
static char pathToMainFile[1000] = "./";
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
static long numberOfBuffer;
static char scramblingTablesOrder[BUFFER_SIZE];

static char passPhrase[16384];
static uint64_t passIndex = 0;
static int passPhraseSize = 0;
static int keyFileSize = 0;

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
			"%s(1)\t\tcopyright <Pierre-François Monville>\t\t%s(1)\n\nNAME\n\t%s -- crypt or decrypt any data\n\nSYNOPSIS\n\t%s [options] FILE [KEYFILE]\n\nDESCRIPTION\n\t(FR) Permet de chiffrer et de déchiffrer toutes les données entrées en paramètre. Le mot de passe demandé au début est hashé puis sert de graine pour le PRNG(générateur de nombre aléatoire). Le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder. La clé unique subit un xor avec le mot de passe (le mot de passe est répété autant de fois que nécéssaire). Le fichier subit un xor avec cette nouvelle clé, puis un brouilleur est utilisé. il mélange la table des caractères (ascii) en utilisant le PRNG et en utilisant le keyfile s'il est fourni. 256 tables de brouillages sont utilisées au total dans un ordre non prédictible donné par la clé unique combiné avec le keyfile s'il est fournit.\n\t(EN) Can crypt and decrypt any data given in argument. The password asked is hashed to be used as a seed for the PRNG(pseudo random number generator). The PRNG gives a unique key which has the same length as the source file. The key is xored with the password (the password is repeated as long as necessary). The file is then xored with this new key, then a scrambler is used. It scrambles the ascii table using the PRNG and the keyfile if it is given. 256 scramble's tables are used in an unpredictible order given by the unique key combined with the keyfile if present.\n\nOPTIONS\n\toptions are as follows:\n\n\t-h | --help\tfurther help.\n\n\t-s (simple)\tput the scrambler on off.\n\n\t-i (inverted)\tinvert the coding/decoding process, for coding it xors then scrambles and for decoding it scrambles then xors.\n\n\t-n (normalised)\tnormalise the size of the keyfile, if the keyfile is too long (over 1 cycle in the Yates and Fisher algorithm) it will be croped to complete 1 cycle\n\n\t-d (destroy)\twrite on top of the source file(securely erase source data), except when the source is a folder where it's just deleted by the system at the end)\n\n\tKEYFILE    \tthe path to a file which will be used to scramble the substitution's tables and choose in which order they will be used instead of the PRNG only (starting at 16 ko for the keyfile is great, however not interesting to be too heavy) \n\nEXIT STATUS\n\tthe %s program exits 0 on success, and anything else if an error occurs.\n\nEXAMPLES\n\tthe command :\t%s file1\n\n\tlets you choose between crypting or decrypting then it will prompt for a password that crypt/decrypt file1 as xfile1 in the same folder, file1 is not modified.\n\n\tthe command :\t%s file2 keyfile1\n\n\tlets you choose between crypting or decrypting, will prompt for the password that crypt/decrypt file2, uses keyfile1 to generate the scrambler then crypt/decrypt file2 as xfile2 in the same folder, file2 is not modified.\n\n\tthe command :\t%s -s file3\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file without using the scrambler(option 's'), resulting in using the unique key only.\n\n\tthe command :\t%s -dni file4 keyfile2\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file but generates the substitution's tables with the keyfile passing only one cycle of the Fisher & Yates algorythm(option 'n', so it's shorter in time), inverts the scrambling phase with the xoring phase(option 'i') and write on top of the source file(option 'd')\n\n", progName, progName, progName, progName, progName, progName, progName, progName, progName);
	} else{
		fprintf(dest,
			"\n%s -- crypt or decrypt any data\n\nVersion : 3.4.1\n\nUsage : %s [options] FILE [KEYFILE]\n\nOptions :\n  -h | --help :\t\tfurther help\n  -s (simple) :\t\tput the scrambler off\n  -i (inverted) :\tinvert the coding/decoding process\n  -n (normalised) :\tnormalise the size of the keyfile\n  -d (destroy) :\toverwrite source file or delete source folder afterwards\n\nFILE :\t\t\tpath to the file\n\nKEYFILE :\t\tpath to a keyfile for the substitution's table\n\n", progName, progName);
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
	secondarySeed[0] = rotl(s0, 55) ^ s1 ^ (s1 << 14); // a, b
	secondarySeed[1] = rotl(s1, 36); // c

	return result;
}
//**********************************************************



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
		printf("\rscrambling substitution's tables...(%d/256)", j + 1);
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
		printf("\rscrambling substitution's tables with keyFile, may be long...(%.0f%%)", progress);
		fflush(stdout);
		while(k < numberOfCycles){
			if((float)(k)/(float)(numberOfCycles) * 100.0 > progress){
				progress = (float)(k)/(float)(numberOfCycles) * 100.0;
				printf("\rscrambling substitution's tables with keyFile, may be long...(%.0f%%)", progress);
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
		printf("\rget scramble's table order using keyFile...                        ");
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
	printf("\rscrambling substitution's tables... Done                           \n");
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
static inline void loadBar(int currentIteration, int maximalIteration, int numberOfSteps, int numberOfSegments)
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

    // Calculate the ratio of complete-to-incomplete.
    float ratio = (float) currentIteration / (float) maximalIteration;
    int loadBarCursorPosition = ratio * numberOfSegments;

    // get the clock now
	currentTime = time(NULL);
	// calculate the remaining time
	elapsedTime = difftime(currentTime, startingTime);
	timeTillEnd = elapsedTime * (1.0/ratio - 1.0);

    // Show the percentage.
    printf(" %3d%% [", (int)(ratio*100));

    // Show the loading bar.
    for (int i = 0; i < loadBarCursorPosition; i++)
       printf("=");

    for (int i = loadBarCursorPosition; i < numberOfSegments; i++)
       printf(" ");

    // go back to the beginning of the line.
    // other way (with ANSI CODE) go to previous line then erase it : printf("] %.0f\n\033[F\033[J", timeTillEnd);
    printf("] %.0f        \r", timeTillEnd);
    fflush(stdout);
}


/*
	-void code(FILE* mainFile)
	mainFile : pointer to the file given by the user

	Controller for coding the source file
 */
void code (FILE* mainFile, char wantsToDeleteFirstFile)
{
	char codedFileName[strlen(pathToMainFile) + strlen(fileName) + 1];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* codedFile;

	sprintf(codedFileName, "%sx%s", pathToMainFile, fileName);
	// opening the output file
	if(wantsToDeleteFirstFile){
		codedFile = mainFile;
	}else if ((codedFile = fopen(codedFileName, "w+")) == NULL) {
		perror(codedFileName);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	// starting encryption
	printf("starting encryption...\n");
	long bufferCount = 0; //keep trace of the task's completion
	void (*XORFunction) ();
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
				XORFunction(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				XORFunction(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
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
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				standardXOR(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, codedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
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
void decode(FILE* mainFile, char wantsToDeleteFirstFile)
{
	char decodedFileName[strlen(pathToMainFile) + strlen(fileName) + 1];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* decodedFile;

	// Return the file to a unscramble ascii table
	unscramble();

	// naming the file which will be decrypted
	sprintf(decodedFileName, "%sx%s", pathToMainFile, fileName);

	// opening the output file
	if(wantsToDeleteFirstFile){
		decodedFile = mainFile;
	}
	else if ((decodedFile = fopen(decodedFileName, "w+")) == NULL) {
		perror(decodedFileName);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	// starting decryption
	printf("starting decryption...\n");
	long bufferCount = 0; //keep trace of the task's completion
	void (*XORFunction) ();
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
	if(scrambling){
		if(wantsToDeleteFirstFile){
			for(int i = 0; i < numberOfBuffer; i++)
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				//writing on the same file so get the cursor where it starts reading the buffer
				fseek(decodedFile, -bufferLength, SEEK_CUR);
				XORFunction(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				XORFunction(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
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
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
			}
		}else{
			while(!feof(mainFile))
			{
				int bufferLength = fillBuffer(mainFile, extractedString, keyString);
				standardXOR(extractedString, keyString, xoredString, bufferLength);
				fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
				loadBar(++bufferCount, numberOfBuffer, 100, 50);
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
            printf("Error : file's path is not correct, one or several directories and or file are missing\n");
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
	-void checkArguments(int numberOfArgument, char* secondArgument)
	numberOfArgument : represents argc, the number of arguments given in the terminal
	secondArgument : a string reprensenting the argument just after the call of the program

	checks whether the number of arguments is correct or if the user calls for help

*/
void checkArguments(int numberOfArgument, char* secondArgument){	
	if (numberOfArgument < 2) {
		usage(1);
	} else if(numberOfArgument >= 5 ) { 
		printf("Error : Too many arguments(%d)\n", numberOfArgument);
		usage(1);
	} else if (strcmp(secondArgument, "-h") == 0 || strcmp(secondArgument, "--help") == 0) {
		usage(0);
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
void getOptionsAndKeyFile(char** arguments, int numberOfArgument, FILE** keyFile, unsigned char* filePosition, unsigned char* wantsToDeleteFirstFile){
	if (numberOfArgument >= 3)
	{
		char hasOptions = 0;
		if(arguments[1][0] == '-' && strlen(arguments[1]) <= 5){
			hasOptions = 1;
			if(numberOfArgument == 3){
				FILE* testFile;
				if((testFile = fopen(arguments[1], "r")) != NULL){
					char procedureResponse[2];
					char secondArgumentIsAFile = -1;
					do{
						printf("'%s' is a valid file, do you want to treat it as a set of options(o) or a file(F):", arguments[1]);
						readString(procedureResponse, 2);
						printf("\033[F\033[J");
						if (procedureResponse[0] == 'F' || procedureResponse[0] == 'f') {
							secondArgumentIsAFile = 1;
							hasOptions = 0;
						}
						else if(procedureResponse[0] == 'O' || procedureResponse[0] == 'o'){
							secondArgumentIsAFile = 0;
							hasOptions = 1;
						}
					}while(secondArgumentIsAFile == -1);
				}
			}
			if(hasOptions){
				char optionS = 0;
				char optionI = 0;
				char optionN = 0;
				char optionD = 0;
				char several = 0;
				char other   = 0;
				char dupChar;
				for (int i = 1; i < strlen(arguments[1]); ++i){
					switch(arguments[1][i]){
						case 's':
							if(++optionS > 1){
								several = 1;
								dupChar = 's';
							}	
							scrambling = 0;
							break;
						case 'i':
							if(++optionI > 1){
								several = 1;
								dupChar = 'i';
							}
							isCodingInverted = 1;
							break;
						case 'n':
							if(++optionN > 1){
								several = 1;
								dupChar = 'n';
							}
							normalised = 1;
							break;
						case 'd':
							if(++optionD > 1){
								several = 1;
								dupChar = 'd';
							}
							*wantsToDeleteFirstFile = 1;
							break;
						default:
							other = 1;
					}
					if(other){
						printf("Error: unknown option set '%c'\n", arguments[1][i]);
						printf("exiting...\n");
						exit(EXIT_FAILURE);
					}
					if(several){
						printf("Error: an option has been entered several times, '%c'\n", dupChar);
						printf("exiting...\n");
						exit(EXIT_FAILURE);
					}
				}

				if(!scrambling && isCodingInverted){
					printf("Error: option 's'(no scrambling) and option 'i'(invert coding/scrambling) cannot be set together\n");
					printf("exiting...\n");
					exit(EXIT_FAILURE);
				}

				if(!scrambling && normalised){
					printf("Error: option 's'(no scrambling) and option 'n'(normalised scrambler) cannot be set together\n");
					printf("exiting...\n");
					exit(EXIT_FAILURE);
				}

				if(*wantsToDeleteFirstFile){
					printf("Warning : with the option 'd'(delete) the source file will be overwritten. Do not quit during encryption\n");
				}

				if(scrambling && !isCodingInverted && !normalised && !*wantsToDeleteFirstFile){
					printf("Error : no valid option has been found\n");
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
						if(isADirectory(arguments[3])){
							printf("Warning : the keyfile is a directory and will not be used\n");
							*keyFile = NULL;
						}else if(!scrambling){
							printf("Warning : with the option 's'(simple), the keyfile will not be used\n");
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
				printf("Warning : the keyfile is a directory and will not be used\n");
				*keyFile = NULL;
			}
			if(numberOfArgument >= 4){
				printf("Error : Too many arguments(%d)\n", numberOfArgument);
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
				printf("Warning : the keyFile is empty and thus will not be used\n");
				*keyFile = NULL;
				usingKeyFile = 0;
			}
		}
		if(!usingKeyFile && normalised){
			printf("Warning : without the keyFile, the option 'n'(normalised) will be ignored\n");
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
void prepareAndOpenMainFile(char** tarName, char** dirName, FILE** mainFile, const char* filePath, char wantsToDeleteFirstFile){
	char openType[4] = "";

	if (wantsToDeleteFirstFile)
	{
		strcpy(openType, "rb+");
	}else{
		strcpy(openType, "rb");
	}

	if (filePath[strlen(filePath)-1] == '/' && filePath[strlen(filePath)-2] == '/')
	{
		printf("Error : several trailing '/' in the path of your file\n");
		printf("path given: '%s'\n", filePath);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	if (isADirectory(filePath)){
		char command[1008] = {'\0'};
		//we don't need that anymore
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
		sprintf (command, "cd %s && tar -cf %s %s &>/dev/null", cleanPathToMainFile, cleanTarName, cleanFileName); //&>/dev/null

		//free the temporary strings
		free(cleanPathToMainFile);
		free(cleanTarName);
		free(cleanFileName);

		// make the archive of the folder with tar
		int status;
		if((status = system(command)) != 0){ //if problems when taring
			printf("\nError : unable to tar your file\n");
			printf("exiting...\n");
			exit(EXIT_FAILURE);
		}else{
			printf("\rregrouping the folder in one file using tar... Done          \n");
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
		printf("Crypt(C) or Decrypt(d):");
		readString(procedureResponse, 2);
		printf("\033[F\033[J");
		if (procedureResponse[0] == 'C' || procedureResponse[0] == 'c') {
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
void startMainProcess(FILE* mainFile, char wantsToDeleteFirstFile){
	if (isCrypting){
		code(mainFile, wantsToDeleteFirstFile);
	}
	else{
		decode(mainFile, wantsToDeleteFirstFile);
	}
	printf("Done                                                                  \n");
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
void clean(FILE* mainFile, char* tarName, char* dirName, char wantsToDeleteFirstFile, char* filePath){
	printf("cleaning buffers and ram... ");
	fflush(stdout);
	secondarySeed[0] = time(NULL);
	secondarySeed[1] = secondarySeed[0] >> 1;
	for (int i = 0; i < passPhraseSize; i++)
	{
		passPhrase[i] = (char) xoroshiro128();
	}

	char mainFileString[strlen(pathToMainFile) + strlen(fileName) + 1];
	sprintf(mainFileString, "%s%s", pathToMainFile, fileName);
	//if we write on top of source file, we rename the source file so it's not confusing
	if(wantsToDeleteFirstFile){
		char outputFileString[strlen(mainFileString) + 1];
		sprintf(outputFileString, "%sx%s", pathToMainFile, fileName);
		rename(mainFileString, (const char*)outputFileString);
	}else if(_isADirectory){
			// we have to securely delete the archive file used to crypt the folder
			// put random char in the file then remove it
			rewind(mainFile);
			for(int i = 0; i < numberOfBuffer; i++)
			{
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
	}
	if(tarName != NULL){
		free(tarName);
	}
	if(dirName != NULL){
		free(dirName);
	}
	if(_isADirectory && wantsToDeleteFirstFile){
		//not secure removal but it's the best we can do so far with folders
		if(rmrf(filePath) != 0){
			//error
			printf("Error: the source file (folder) were not completely deleted\n");
			fflush(stdout);
		}
	}

	printf("Done\n");
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
	//outside their scope because we need to free them at the end
	char* tarName = NULL;
	char* dirName = NULL;

	getProgName((char*)argv[0]);
	checkArguments(argc, (char*)argv[1]);
	getOptionsAndKeyFile((char**)argv, argc, &keyFile, &filePosition, &wantsToDeleteFirstFile);
	prepareAndOpenMainFile(&tarName, &dirName, &mainFile, (char*)argv[filePosition], wantsToDeleteFirstFile);
	getNumberOfBuffer(mainFile);

	getUserPrompt();	
	
	getSeed();
	scramble(keyFile);
	startMainProcess(mainFile, wantsToDeleteFirstFile);
	//avoid the password to be stored in ram
	clean(mainFile, tarName, dirName, wantsToDeleteFirstFile, (char*)argv[filePosition]);

	printf("\n");

	return EXIT_SUCCESS;
}
