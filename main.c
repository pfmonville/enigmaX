// Copyright <Pierre-François Monville>
// ===========================================================================
// 									enigmaX
// permet de chiffrer et de déchiffrer toutes les données entrées en paramètre. 
// Le mot de passe demandé au début est hashé puis sert de graine pour le PRNG(générateur de nombre aléatoire). 
// Le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder. 
// La clé unique subit un xor avec le mot de passe (le mot de passe est répété autant de fois que nécéssaire). 
// Le fichier subit un xor avec cette clé Puis un brouilleur est utilisé, 
// il mélange la table des caractères (ascii) en utilisant le PRNG et en utilisant le keyfile s'il est fourni. 
// 16 tables de brouillages sont utilisées au total dans un ordre non prédictible.
//
// Can crypt and decrypt any data given in argument. 
// The password asked is hashed to be used as a seed for the PRNG(pseudo random number generator). 
// The PRNG gives a unique key which has the same length as the source file. 
// The key is xored with the password (the password is repeated as long as necessary). 
// The file is then xored with this new key, then a scrambler is used. 
// It scrambles the ascii table using the PRNG and the keyfile if it is given. 
// 16 scramble's tables are used in an unpredictible order.
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
//			inverts the coding/decoding process, first it xors then it scrambles
//
//		-n (normalised) :
//			normalise the size of the keyFile, improving too short (less secure) or too long (take long time) keyFiles
//
//		-d (destroy) :
//			delete the main file at the end of the process
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
clang -Ofast -fno-unroll-loops main.c -o enigmax

LINUX:
gcc -fno-move-loop-invariants -fno-unroll-loops main.c -o enigmax

you can put the compiled file "enigmax" in your path to use it everywhere
export PATH=$PATH:/PATH/TO/enigmax
write it in your ~/.bashrc if you want it to stay after a reboot
*/

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
#include <errno.h>


/*
	constants
 */
#define BUFFER_SIZE 16384  //16384 //8192


/*
	global variables
 */
static const char *progName;
static const char *fileName;
static char pathToMainFile[1000] = "./";
static char _isADirectory;
static uint64_t seed[16];
static int seedIndex = 0;
static unsigned char scrambleAsciiTables[16][256];
static unsigned char unscrambleAsciiTables[16][256];
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
			"%s(1)\t\t\tcopyright <Pierre-François Monville>\t\t\t%s(1)\n\nNAME\n\t%s -- crypt or decrypt any data\n\nSYNOPSIS\n\t%s [options] FILE [KEYFILE]\n\nDESCRIPTION\n\t(FR) permet de chiffrer et de déchiffrer toutes les données entrées en paramètre. Le mot de passe demandé au début est hashé puis sert de graine pour le PRNG(générateur de nombre aléatoire). Le PRNG permet de fournir une clé unique égale à la longueur du fichier à coder. La clé unique subit un xor avec le mot de passe (le mot de passe est répété autant de fois que nécéssaire). Le fichier subit un xor avec cette clé Puis un brouilleur est utilisé, il mélange la table des caractères (ascii) en utilisant le PRNG et en utilisant le keyfile s'il est fourni. 16 tables de brouillages sont utilisées au total dans un ordre non prédictible.\n\t(EN) Can crypt and decrypt any data given in argument. The password asked is hashed to be used as a seed for the PRNG(pseudo random number generator). The PRNG gives a unique key which has the same length as the source file. The key is xored with the password (the password is repeated as long as necessary). The file is then xored with this new key, then a scrambler is used. It scrambles the ascii table using the PRNG and the keyfile if it is given. 16 scramble's tables are used in an unpredictible order.\n\nOPTIONS\n\tthe options are as follows:\n\n\t-h | --help\tfurther help.\n\n\t-s (simple)\tputs the scrambler on off.\n\n\t-i (inverted)\tinverts the coding/decoding process, first it xors then it scrambles.\n\n\t-n (normalised)\tnormalises the size of the keyfile, if the keyfile is too long (over 1 cycle in the Yates and Fisher algorithm) it will be croped to complete 1 cycle\n\n\t-d (destroy)\tdelete the main file at the end of the process\n\n\tKEYFILE    \tthe path to a file which will be used to scramble the substitution's tables and choose in which order they will be used instead of the PRNG only (starting at 4 ko for the keyfile is great, however not interesting to be too heavy) \n\nEXIT STATUS\n\tthe %s program exits 0 on success, and anything else if an error occurs.\n\nEXAMPLES\n\tthe command :\t%s file1\n\n\tlets you choose between crypting or decrypting then it will prompt for a password that crypt/decrypt file1 as xfile1 in the same folder, file1 is not modified.\n\n\tthe command :\t%s file2 keyfile1\n\n\tlets you choose between crypting or decrypting, will prompt for the password that crypt/decrypt file2, uses keyfile1 to generate the scrambler then crypt/decrypt file2 as file2x in the same folder, file2 is not modified.\n\n\tthe command :\t%s -s file3\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file without using the scrambler(option 's'), resulting in using the unique key only.\n\n\tthe command :\t%s -dni file4 keyfile2\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file but generates the substitution's tables with the keyfile passing only one cycle of the Fisher & Yates algorythm(option 'n'), inverts the scrambling phase with the xoring phase(option 'i') and destroy the main file afterwards(option 'd')\n", progName, progName, progName, progName, progName, progName, progName, progName, progName);
	} else{
		fprintf(dest,
			"\nVersion : 3.1\n\nUsage : %s [options] FILE [KEYFILE]\n\nOptions :\n  -h | --help :\t\tfurther help\n  -s (simple) :\t\tput the scrambler off\n  -i (inverted) :\tinverts the coding/decoding process\n  -n (normalised) :\tnormalise the size of the keyfile\n  -d (destroy) :\tdelete the main file afterwards\n\nFILE :\t\t\tpath to the file\n\nKEYFILE :\t\tpath to a keyfile for the substitution's table\n", progName);
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
	-static inline uint64_t rotationLinearTransformation(const uint64_t seed, int constant)
	seed : the seed which will have the rotation
	constant : number which has to be between 1 and 63
	returned value :  uint64_t number (equivalent to long long but on all OS)

	rotation function for generateNumber
	part of the xoroshiro128+ algorythm :
	http://xoroshiro.di.unimi.it/xoroshiro128plus.c
 */
static inline uint64_t rotationLinearTransformation(const uint64_t seed, int constant) {
	return (seed << constant) | (seed >> (64 - constant));
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

	return seed[seedIndex] * UINT64_C(1181783497276652981);
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
void getSeed(char* password){
	char hash[128];
	getHash(hash, password);

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
	inspired by the Enigma machine; switching letters but without its weekness,
	here a letter can be switched by itself and it is not possible to know how many letters
	have been switched
 */
void scramble(FILE* keyFile){
	printf("scrambling substitution's tables, may be long...");
	fflush(stdout);
	for (int j = 0; j < 16; ++j)
	{
		printf("\rscrambling substitution's tables, may be long...(%d/16)", j + 1);
		fflush(stdout);
		char temp = 0;

		for (int i = 0; i < 256; ++i)
		{
			scrambleAsciiTables[j][i] = i;
		}

		if (usingKeyFile){
			unsigned char random256;
			long numberOfCycles = ceilRound((float)keyFileSize/(float)255);
			if(normalised){
				numberOfCycles = 1;
			}
			for (int i = 0; i < numberOfCycles; ++i)
			{
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
			}
		} else {
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
	if(usingKeyFile){
		int j = 0;
		char temp[BUFFER_SIZE];
		while(j < BUFFER_SIZE){
			int size = fread(temp, 1, BUFFER_SIZE, keyFile);
			if(size == 0){
				rewind(keyFile);
				continue;
			}
			for (int i = 0; i < size; ++i)
			{
				scramblingTablesOrder[j] = temp[i] & (1+2+4+8);
				j++;
				if(j == BUFFER_SIZE){
					break;
				}
			}
		}
	}
	printf("\rscrambling substitution's tables... Done               \n");
}


/*
	-void unscramble(void)

	this function is here only for optimization
	it inverses the key/value in the scramble ascii table making the backward process instantaneous
 */
void unscramble(){
	for (int j = 0; j < 16; ++j)
	{
		for (int i = 0; i < 256; ++i)
		{
			unsigned char c = scrambleAsciiTables[j][i];
			unscrambleAsciiTables[j][c] = i;
		}
	}
}


/*
	-void codingXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCrypting == 1) then we switche the character from the source file then xor it
	if we are decoding (isCrypting == 0) then we xor the character from the source file then unscramble it
	The scramble table is chosed thanks to the key: We apply a mask to the unique key to catch the last 4 bytes. 
	it gives a number from 0 to 15 that is used to chose the scrambled table. 
	It prevents a frequence analysis of the scrambled file in the event where the unique key has been found. 
	Thus even if you find the seed and by extension, the unique key, you can't apply headers and try to match 
	them to the scrambled file in order to deduce the scramble table. You absolutely need the password.
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original:a -> scramble:x -> xored:?
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void codingXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
{
	int i;

	if(usingKeyFile){
		if(isCodingInverted){
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = scrambleAsciiTables[(scramblingTablesOrder[i] ^ keyString[i]) & (1+2+4+8)][(unsigned char)(extractedString[i] ^ keyString[i])];
			}
		}else{
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = scrambleAsciiTables[(scramblingTablesOrder[i] ^ keyString[i]) & (1+2+4+8)][(unsigned char)extractedString[i]] ^ keyString[i];
			}
		}
	}else{
		if(isCodingInverted){
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = scrambleAsciiTables[(keyString[i]) & (1+2+4+8)][(unsigned char)(extractedString[i] ^ keyString[i])];
			}
		}else{
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = scrambleAsciiTables[(keyString[i]) & (1+2+4+8)][(unsigned char)extractedString[i]] ^ keyString[i];
			}
		}
	}
}


/*
	-void decodingXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
	extractedString : data taken from the source file in a string format
	keyString : a part of the unique key generated by the PRNG in a string format
	xoredString : the result of the xor operation between extractedString and keyString
	bufferLength : the length of the data on which this function is working on

	Here only for optimization purpose to limit the amount of conditions
	Apply the mathematical xor function to extractedString and keyString
	if we are coding (isCrypting == 1) then we switche the character from the source file then xor it
	if we are decoding (isCrypting == 0) then we xor the character from the source file then unscramble it
	we can schemate all the coding/decoding xoring process like this :
	coding : 	original(a) -> scramble(x) -> xored(?)
	decoding : 	xored(?) -> unxored(x) -> unscrambled(a)
 */
void decodingXOR(char* extractedString, char* keyString, char* xoredString, int bufferLength)
{
	int i;

	if(usingKeyFile){
		if(isCodingInverted){
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = unscrambleAsciiTables[(scramblingTablesOrder[i] ^ keyString[i]) & (1+2+4+8)][(unsigned char)extractedString[i]] ^ keyString[i];
			}
		}else{
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = unscrambleAsciiTables[(scramblingTablesOrder[i] ^ keyString[i]) & (1+2+4+8)][(unsigned char)(extractedString[i] ^ keyString[i])];
			}
		}
	}else{
		if(isCodingInverted){
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = unscrambleAsciiTables[keyString[i] & (1+2+4+8)][(unsigned char)extractedString[i]] ^ keyString[i];
			}
		}else{
			for (i = 0; i < bufferLength; ++i)
			{
				xoredString[i] = unscrambleAsciiTables[keyString[i] & (1+2+4+8)][(unsigned char)(extractedString[i] ^ keyString[i])];
			}
		}
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
void code (FILE* mainFile)
{
	char codedFileName[strlen(pathToMainFile) + strlen(fileName) + 1];
	char extractedString[BUFFER_SIZE] = "";
	char keyString[BUFFER_SIZE] = "";
	char xoredString[BUFFER_SIZE] = "";
	FILE* codedFile;

	sprintf(codedFileName, "%sx%s", pathToMainFile, fileName);
	// opening the output file
	if ((codedFile = fopen(codedFileName, "w+")) == NULL) {
		perror(codedFileName);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	// starting encryption
	long bufferCount = 0; //keep trace of the task's completion
	printf("starting encryption...\n");
	if (scrambling){
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			codingXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, codedFile);
			loadBar(++bufferCount, numberOfBuffer, 100, 50);
		}
	} else {
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			standardXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, codedFile);
			loadBar(++bufferCount, numberOfBuffer, 100, 50);
		}
	}
	// closing the output file
	fclose(codedFile);
	//if the first file was a directory then delete the archive made before crypting
	if (_isADirectory)
	{
		char* tarFile = (char*) calloc (1, sizeof(char) * (strlen(pathToMainFile) + strlen(fileName) + 1));
		strcpy(tarFile, pathToMainFile);
		strcat(tarFile, fileName);
		remove(tarFile);
		free(tarFile);
	}
}


/*
	-void decode(FILE* mainFile)
	mainFile : pointer to the file given by the user

	controller for decoding the source file
 */
void decode(FILE* mainFile)
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
	if ((decodedFile = fopen(decodedFileName, "w+")) == NULL) {
		perror(decodedFileName);
		printf("exiting...\n");
		exit(EXIT_FAILURE);
	}

	// starting decryption
	long bufferCount = 0; //keep trace of the task's completion
	printf("starting decryption...\n");
	if(scrambling){
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			decodingXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
			loadBar(++bufferCount, numberOfBuffer, 100, 50);
		}
	} else {
		while(!feof(mainFile))
		{
			int bufferLength = fillBuffer(mainFile, extractedString, keyString);
			standardXOR(extractedString, keyString, xoredString, bufferLength);
			fwrite(xoredString, sizeof(char), bufferLength, decodedFile);
			loadBar(++bufferCount, numberOfBuffer, 100, 50);
		}
	}
	// closing the output file
	fclose(decodedFile);
}



/*
	-int isADirectory(char* path)
	path : string indicated the path of the file/directory
	returned value : 0 or 1

	indicates if the object with this path is a directory or not

*/
int isADirectory(char* path){
	struct stat statStruct;
    int statStatus = stat(path, &statStruct);
    if(-1 == statStatus) {
        if(ENOENT == errno) {
            printf("Error : file's path is not correct, one or several directories and or file are missing\n");
        } else {
            perror("stat");
            printf("exiting...\n");
            exit(1);
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
    exit(1);
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
		usage(1);
	} else if(argc >= 5 ) { 
		printf("Error : Too many arguments\n");
		usage(1);
	} else if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0) {
		usage(0);
	}

	char filePosition = 1;
	char wantsToDeleteFirstFile = 0;

	if (argc >= 3)
	{
		if(argv[1][0] == '-' && strlen(argv[1]) <= 4){
			if(strchr(argv[1], 's') != NULL){
				scrambling = 0;
			}
			if(strchr(argv[1], 'i') != NULL){
				isCodingInverted = 1;
			}
			if(strchr(argv[1], 'n') != NULL){
				normalised = 1;
			}
			if(strchr(argv[1], 'd') != NULL){
				wantsToDeleteFirstFile = 1;
				printf("Warning : with the option 'd'(delete) the main file will be deleted at the end\n");
			}
			if(scrambling && !isCodingInverted && !normalised && !wantsToDeleteFirstFile){
				printf("Error : no valid option has been found\n");
				usage(1);
			} else{
				filePosition = 2;
			}
			if(argc >= 4){
				if((keyFile = fopen(argv[3], "r")) == NULL){
					perror(argv[3]);
					usage(1);
				}
				if(keyFile != NULL){
					if(isADirectory((char*)argv[3])){
						printf("Warning : the keyfile is a directory and will not be used\n");
						keyFile = NULL;
					}else if(!scrambling){
						printf("Warning : with the option 's'(simple), the keyfile will not bu used\n");
						keyFile = NULL;
					}
				}
			}
		} else if ((keyFile = fopen(argv[2], "r")) == NULL) {
			perror(argv[2]);
			usage(1);
		} else if(keyFile != NULL){
			if(isADirectory((char*)argv[2])){
				printf("Warning : the keyfile is a directory and will not be used\n");
				keyFile = NULL;
			}
			if(argc >= 4){
				printf("Error : Too many arguments\n");
				usage(1);
			}
		}

		if(keyFile != NULL){
			usingKeyFile = 1;
			rewind(keyFile);
			fseek(keyFile, 0, SEEK_END);
			keyFileSize = ftell(keyFile);
			rewind(keyFile);

			if(keyFileSize == 0){
				printf("Warning : the keyFile is empty and thus will not be used\n");
				keyFile = NULL;
				usingKeyFile = 0;
			}
		}
		if(!usingKeyFile && normalised){
			printf("Warning : without the keyFile, the option 'n'(normalised) will be ignored\n");
			normalised = 0;
		}
		
	}

	if (argv[filePosition][strlen(argv[filePosition])-1] == '/' && argv[filePosition][strlen(argv[filePosition])-2] == '/')
	{
		printf("Error : several trailing '/' in the path of your file\n");
		printf("exiting...\n");
		exit(1);
	}

	//outside their scope because we need to free them at the end
	char* tarName = NULL;
	char* dirName = NULL;
	if (isADirectory((char*)argv[filePosition])){
		char command[1008] = {'\0'};
		//we don't need that anymore
		printf("regrouping the folder in one file using tar, may be long...");
		fflush(stdout);
		// get the name of the folder in a string and get the path
		if ((fileName = strrchr(argv[filePosition], '/')) != NULL) {
			//if the '/' is the last character in the string, delete it and get the fileName again
			if (strlen(fileName) == 1){
				dirName = (char*) calloc(1, sizeof(char) * (strlen(argv[filePosition]) + 5));
				strcpy(dirName, argv[filePosition]);
				*(dirName+(fileName-argv[filePosition])) = '\0';
				if ((fileName = strrchr(dirName, '/')) != NULL){
					++fileName;
					strncpy(pathToMainFile, dirName, fileName - dirName);
					pathToMainFile[fileName - dirName] = '\0';
				}
				else{
					fileName = dirName;
				}
			}
			else {
				++fileName;
				strncpy(pathToMainFile, argv[filePosition], fileName - argv[filePosition]);
				pathToMainFile[fileName - argv[filePosition]] = '\0';
			}
		}
		else {
			fileName = argv[filePosition];
		}
		// get the full path of the tarFile in a dynamic variable tarName
		tarName = (char*) calloc(1, sizeof(char) * (strlen(fileName) + 5));
		sprintf (tarName, "%s.tar", fileName);

		//all of the following is to make a clean string for the tar commands (taking care of spaces)
		char* cleanFileName       = processTarString((char*)fileName);
		char* cleanPathToMainFile = processTarString(pathToMainFile);
		char* cleanTarName        = processTarString(tarName);
		
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
			exit(1);
		}else{
			printf("\rregrouping the folder in one file using tar... Done          \n");			
		}

		fileName = tarName;

		// trying to open the new archive
		char pathPlusName[strlen(pathToMainFile)+strlen(fileName)];
		sprintf(pathPlusName, "%s%s", pathToMainFile, fileName);
		if ((mainFile = fopen(pathPlusName, "r")) == NULL) {
			perror(pathPlusName);
			printf("exiting...\n");
			return EXIT_FAILURE;
		}
	}
	else{
		if ((fileName = strrchr(argv[filePosition], '/')) != NULL) {
			++fileName;
			strncpy(pathToMainFile, argv[filePosition], fileName - argv[filePosition]);		
		} else {
			fileName = argv[filePosition];
		}
		if ((mainFile = fopen(argv[filePosition], "r")) == NULL) {
			perror(argv[filePosition]);
			printf("exiting...\n");
			return EXIT_FAILURE;
		}
	}

	fseek(mainFile, 0, SEEK_END);
	long mainFileSize = ftell(mainFile);
	rewind(mainFile);
	numberOfBuffer = ceilRound((float)mainFileSize / (float)(BUFFER_SIZE));
	if (numberOfBuffer < 1)
	{
		numberOfBuffer = 1;
	}

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
		readString(passPhrase, 16383);
		size = strlen(passPhrase);
		if(size <= 0){
			printf("the password can't be empty\n");
			continue;
		}
		printf("\033[F\033[J");
	}while(size <= 0);
	passPhraseSize = strlen(passPhrase);
	getSeed(passPhrase);
	scramble(keyFile);

	if (isCrypting){
		code(mainFile);
	}
	else{
		decode(mainFile);
	}
	printf("Done                                                                  \n");
	fclose(mainFile);

	if(wantsToDeleteFirstFile){
		if(remove(argv[filePosition]) != 0){
			perror(argv[filePosition]);
		}
	}

	//we can free (last use in code/decode)
	if(tarName != NULL){
		free(tarName);
	}
	if(dirName != NULL){
		free(dirName);
	}

	return 0;
}
