	.file	"main.c"
	.local	progName
	.comm	progName,8,8
	.local	fileName
	.comm	fileName,8,8
	.data
	.align 64
	.type	pathToMainFile, @object
	.size	pathToMainFile, 1000
pathToMainFile:
	.string	"./"
	.zero	997
	.local	_isADirectory
	.comm	_isADirectory,1,1
	.local	seed
	.comm	seed,128,64
	.local	seedIndex
	.comm	seedIndex,4,4
	.local	scrambleAsciiTables
	.comm	scrambleAsciiTables,4096,64
	.local	unscrambleAsciiTables
	.comm	unscrambleAsciiTables,4096,64
	.type	isCrypting, @object
	.size	isCrypting, 1
isCrypting:
	.byte	1
	.type	scrambling, @object
	.size	scrambling, 1
scrambling:
	.byte	1
	.local	usingKeyFile
	.comm	usingKeyFile,1,1
	.local	isCodingInverted
	.comm	isCodingInverted,1,1
	.local	normalised
	.comm	normalised,1,1
	.local	numberOfBuffer
	.comm	numberOfBuffer,8,8
	.local	scramblingTablesOrder
	.comm	scramblingTablesOrder,16384,64
	.local	passPhrase
	.comm	passPhrase,16384,64
	.local	passIndex
	.comm	passIndex,8,8
	.local	passPhraseSize
	.comm	passPhraseSize,4,4
	.local	keyFileSize
	.comm	keyFileSize,4,4
	.section	.rodata
	.align 8
.LC0:
	.ascii	"%s(1)\t\t\tcopyright <Pierre-Fran\303\247ois Monville>\t\t\t"
	.ascii	"%s(1)\n\nNAME\n\t%s -- crypt or decrypt any data\n\nSYNOPSIS"
	.ascii	"\n\t%s [options] FILE [KEYFILE]\n\nDESCRIPTION\n\t(FR) perme"
	.ascii	"t de chiffrer et de d\303\251chiffrer toutes les donn\303\251"
	.ascii	"es entr\303\251es en param\303\250tre. Le mot de passe deman"
	.ascii	"d\303\251 au d\303\251but est hash\303\251 puis sert de grai"
	.ascii	"ne pour le PRNG(g\303\251n\303\251rateur de nombre al\303\251"
	.ascii	"atoire). Le PRNG permet de fournir une cl\303\251 unique \303"
	.ascii	"\251gale \303\240 la longueur du fichier \303\240 coder. La "
	.ascii	"cl\303\251 unique subit un xor avec le mot de passe (le mot "
	.ascii	"de passe est r\303\251p\303\251t\303\251 autant de fois que "
	.ascii	"n\303\251c\303\251ssaire). Le fichier subit un xor avec cett"
	.ascii	"e cl\303\251 Puis un brouilleur est utilis\303\251, il m\303"
	.ascii	"\251lange la table des caract\303\250res (ascii) en utilisan"
	.ascii	"t le PRNG et en utilisant le keyfile s'il est fourni. 16 tab"
	.ascii	"les de brouillages sont utilis\303\251es au total dans un or"
	.ascii	"dre non pr\303\251dictible.\n\t(EN) Can crypt and decrypt an"
	.ascii	"y data given in argument. The password asked is hashed to be"
	.ascii	" used as a seed for the PRNG(pseudo random number generator)"
	.ascii	". The PRNG gives a unique key which has the same length as t"
	.ascii	"he source file. The key is xored with the password (the pass"
	.ascii	"word is repeated as long as necessary). The file is then xor"
	.ascii	"ed with this new key, then a scrambler is used. It scrambles"
	.ascii	" the ascii table using the PRNG and the keyfile if it is giv"
	.ascii	"en. 16 scramble's tables are used in an unpredictible order."
	.ascii	"\n\nOPTIONS\n\tthe options are as follows:\n\n\t-h | --help\t"
	.ascii	"further help.\n\n\t-s (simple)\tputs the scrambler on off.\n"
	.ascii	"\n\t-i (inverted)\tinverts the coding/decoding process, firs"
	.ascii	"t it xors then it scrambles.\n\n\t-n (normalised)\tnormalise"
	.ascii	"s the size of the keyfile, if the keyfile is too long (over "
	.ascii	"1 cycle in the Yates and Fisher algorithm) it will be croped"
	.ascii	" to complete 1 cycle\n\n\t-d (destroy)\tdelete the main file"
	.ascii	" at the end of the process\n\n\tKEYFILE    \tthe path to a f"
	.ascii	"ile which will be used to scramble the substitution's tables"
	.ascii	" and choose in which order they will be used instead of the "
	.ascii	"PRNG only (starting at 4 ko for the keyfile is great, howeve"
	.ascii	"r not interesting to be too heavy) \n\nEXIT STAT"
	.ascii	"US\n\tthe %s program exits 0 on success, and anything else i"
	.ascii	"f an error occurs.\n\nEXAMPLES\n\tthe command :\t%s file1\n\n"
	.ascii	"\tlets you choose between crypting or decrypting then it wil"
	.ascii	"l prompt for a password that crypt/decrypt file1 as xfile1 i"
	.ascii	"n the same folder, file1 is not modified.\n\n\tthe command :"
	.ascii	"\t%s file2 keyfile1\n\n\tlets you choose between crypting or"
	.ascii	" decrypting, will prompt for the password that crypt/decrypt"
	.ascii	" file2, uses keyfile1 to generate the scrambler then crypt/d"
	.ascii	"ecrypt file2 as file2x in the same folder, file2 is not modi"
	.ascii	"fied.\n\n\tthe command :\t%s -s file3\n\n\tlets you choose b"
	.ascii	"etween crypting or decrypting, will prompt for a password th"
	.ascii	"at crypt/decrypt the file without using the scrambler(option"
	.ascii	" 's'), resulting in using the unique key only.\n\n\tthe comm"
	.ascii	"and :\t%s -dni file4 keyfile2\n\n\tlets you choose between c"
	.ascii	"rypting or decrypting, will prompt for a password that cryp"
	.string	"t/decrypt the file but generates the substitution's tables with the keyfile passing only one cycle of the Fisher & Yates algorythm(option 'n'), inverts the scrambling phase with the xoring phase(option 'i') and destroy the main file afterwards(option 'd')\n"
	.align 8
.LC1:
	.ascii	"\nVersion : 3.0\n\nUsage : %s [options] FILE [KEYFILE]\n\nOp"
	.ascii	"tions :\n  -h | --help :\t\tfurther help\n  -s (simple) :\t\t"
	.ascii	"put the s"
	.string	"crambler off\n  -i (inverted) :\tinverts the coding/decoding process\n  -n (normalised) :\tnormalise the size of the keyfile\n  -d (destroy) :\tdelete the main file afterwards\n\nFILE :\t\t\tpath to the file\n\nKEYFILE :\t\tpath to a keyfile for the substitution's table\n"
	.text
	.type	usage, @function
usage:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L2
	movq	stdout(%rip), %rax
	jmp	.L3
.L2:
	movq	stderr(%rip), %rax
.L3:
	movq	%rax, -24(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L4
	movq	progName(%rip), %r10
	movq	progName(%rip), %r9
	movq	progName(%rip), %r8
	movq	progName(%rip), %rdi
	movq	progName(%rip), %rsi
	movq	progName(%rip), %rbx
	movq	progName(%rip), %r11
	movq	progName(%rip), %rcx
	movq	progName(%rip), %rdx
	subq	$8, %rsp
	movq	-24(%rbp), %rax
	pushq	%r10
	pushq	%r9
	pushq	%r8
	pushq	%rdi
	pushq	%rsi
	movq	%rbx, %r9
	movq	%r11, %r8
	movl	$.LC0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	addq	$48, %rsp
	jmp	.L5
.L4:
	movq	progName(%rip), %rdx
	movq	-24(%rbp), %rax
	movl	$.LC1, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
.L5:
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	exit
	.cfi_endproc
.LFE0:
	.size	usage, .-usage
	.globl	ceilRound
	.type	ceilRound, @function
ceilRound:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movss	%xmm0, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
	cvttss2siq	-8(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rax, %xmm0
	movss	-4(%rbp), %xmm1
	subss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	pxor	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jbe	.L11
	movl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
	cvttss2siq	-8(%rbp), %rax
	addq	$1, %rax
	jmp	.L9
.L11:
	movl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
	cvttss2siq	-8(%rbp), %rax
.L9:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	ceilRound, .-ceilRound
	.globl	clearBuffer
	.type	clearBuffer, @function
clearBuffer:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L13
.L15:
	call	getchar
	movl	%eax, -4(%rbp)
.L13:
	cmpl	$10, -4(%rbp)
	je	.L12
	cmpl	$-1, -4(%rbp)
	jne	.L15
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	clearBuffer, .-clearBuffer
	.globl	readString
	.type	readString, @function
readString:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	$0, -8(%rbp)
	movq	stdin(%rip), %rdx
	movq	-32(%rbp), %rax
	movl	%eax, %ecx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L17
	movq	-24(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	strchr
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L18
	movq	-8(%rbp), %rax
	movb	$0, (%rax)
	jmp	.L19
.L18:
	movl	$0, %eax
	call	clearBuffer
.L19:
	movl	$1, %eax
	jmp	.L20
.L17:
	movl	$0, %eax
	call	clearBuffer
	movl	$0, %eax
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	readString, .-readString
	.globl	processTarString
	.type	processTarString, @function
processTarString:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L22
.L24:
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L23
	addl	$1, -20(%rbp)
.L23:
	addl	$1, -24(%rbp)
.L22:
	movl	-24(%rbp), %eax
	movslq	%eax, %rbx
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	cmpq	%rax, %rbx
	jb	.L24
	cmpl	$0, -20(%rbp)
	jne	.L25
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rsi
	movl	$1, %edi
	call	calloc
	movq	%rax, -40(%rbp)
	movq	-56(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcat
	movq	-40(%rbp), %rax
	jmp	.L26
.L25:
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	addq	$1, %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	calloc
	movq	%rax, -40(%rbp)
	movl	$0, -28(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L27
.L29:
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L28
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movb	$92, (%rax)
	addl	$1, -32(%rbp)
.L28:
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-28(%rbp), %eax
	movslq	%eax, %rcx
	movq	-56(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -28(%rbp)
	addl	$1, -32(%rbp)
.L27:
	movl	-28(%rbp), %eax
	movslq	%eax, %rbx
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	cmpq	%rax, %rbx
	jb	.L29
	movq	-40(%rbp), %rax
.L26:
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	processTarString, .-processTarString
	.globl	generateNumber
	.type	generateNumber, @function
generateNumber:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	seedIndex(%rip), %eax
	cltq
	movq	seed(,%rax,8), %rax
	movq	%rax, -8(%rbp)
	movl	seedIndex(%rip), %eax
	addl	$1, %eax
	andl	$15, %eax
	movl	%eax, seedIndex(%rip)
	movl	seedIndex(%rip), %eax
	cltq
	movq	seed(,%rax,8), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	salq	$31, %rax
	xorq	%rax, -16(%rbp)
	movl	seedIndex(%rip), %ecx
	movq	-16(%rbp), %rax
	xorq	-8(%rbp), %rax
	movq	-16(%rbp), %rdx
	shrq	$11, %rdx
	xorq	%rax, %rdx
	movq	-8(%rbp), %rax
	shrq	$30, %rax
	xorq	%rax, %rdx
	movslq	%ecx, %rax
	movq	%rdx, seed(,%rax,8)
	movl	seedIndex(%rip), %eax
	cltq
	movq	seed(,%rax,8), %rdx
	movabsq	$1181783497276652981, %rax
	imulq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	generateNumber, .-generateNumber
	.globl	FIPS202_SHAKE128
	.type	FIPS202_SHAKE128, @function
FIPS202_SHAKE128:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	subq	$8, %rsp
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	pushq	-32(%rbp)
	movq	%rcx, %r9
	movl	$31, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$256, %esi
	movl	$1344, %edi
	call	Keccak
	addq	$16, %rsp
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	FIPS202_SHAKE128, .-FIPS202_SHAKE128
	.globl	FIPS202_SHAKE256
	.type	FIPS202_SHAKE256, @function
FIPS202_SHAKE256:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	subq	$8, %rsp
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	pushq	-32(%rbp)
	movq	%rcx, %r9
	movl	$31, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$512, %esi
	movl	$1088, %edi
	call	Keccak
	addq	$16, %rsp
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	FIPS202_SHAKE256, .-FIPS202_SHAKE256
	.globl	FIPS202_SHA3_224
	.type	FIPS202_SHA3_224, @function
FIPS202_SHA3_224:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	pushq	$28
	movq	%rcx, %r9
	movl	$6, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$448, %esi
	movl	$1152, %edi
	call	Keccak
	addq	$16, %rsp
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	FIPS202_SHA3_224, .-FIPS202_SHA3_224
	.globl	FIPS202_SHA3_256
	.type	FIPS202_SHA3_256, @function
FIPS202_SHA3_256:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	pushq	$32
	movq	%rcx, %r9
	movl	$6, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$512, %esi
	movl	$1088, %edi
	call	Keccak
	addq	$16, %rsp
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	FIPS202_SHA3_256, .-FIPS202_SHA3_256
	.globl	FIPS202_SHA3_384
	.type	FIPS202_SHA3_384, @function
FIPS202_SHA3_384:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	pushq	$48
	movq	%rcx, %r9
	movl	$6, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$768, %esi
	movl	$832, %edi
	call	Keccak
	addq	$16, %rsp
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	FIPS202_SHA3_384, .-FIPS202_SHA3_384
	.globl	FIPS202_SHA3_512
	.type	FIPS202_SHA3_512, @function
FIPS202_SHA3_512:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	subq	$8, %rsp
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	pushq	$64
	movq	%rcx, %r9
	movl	$6, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$1024, %esi
	movl	$576, %edi
	call	Keccak
	addq	$16, %rsp
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	FIPS202_SHA3_512, .-FIPS202_SHA3_512
	.globl	LFSR86540
	.type	LFSR86540, @function
LFSR86540:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addl	%eax, %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L39
	movl	$113, %eax
	jmp	.L40
.L39:
	movl	$0, %eax
.L40:
	xorl	%edx, %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movb	%dl, (%rax)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	andl	$2, %eax
	sarl	%eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	LFSR86540, .-LFSR86540
	.type	load64, @function
load64:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	$0, -16(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L43
.L44:
	salq	$8, -16(%rbp)
	movl	$7, %eax
	subl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	orq	%rax, -16(%rbp)
	addl	$1, -4(%rbp)
.L43:
	cmpl	$7, -4(%rbp)
	jbe	.L44
	movq	-16(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	load64, .-load64
	.type	store64, @function
store64:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L47
.L48:
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-32(%rbp), %rdx
	movb	%dl, (%rax)
	shrq	$8, -32(%rbp)
	addl	$1, -4(%rbp)
.L47:
	cmpl	$7, -4(%rbp)
	jbe	.L48
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	store64, .-store64
	.type	xor64, @function
xor64:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L50
.L51:
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %ecx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movq	-32(%rbp), %rcx
	xorl	%ecx, %edx
	movb	%dl, (%rax)
	shrq	$8, -32(%rbp)
	addl	$1, -4(%rbp)
.L50:
	cmpl	$7, -4(%rbp)
	jbe	.L51
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	xor64, .-xor64
	.globl	KeccakF1600
	.type	KeccakF1600, @function
KeccakF1600:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -96(%rbp)
	movb	$1, -45(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L53
.L71:
	movl	$0, -16(%rbp)
	jmp	.L54
.L55:
	movl	-16(%rbp), %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	movq	%rax, %rbx
	movl	-16(%rbp), %eax
	addl	$5, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	xorq	%rax, %rbx
	movl	-16(%rbp), %eax
	addl	$10, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	xorq	%rax, %rbx
	movl	-16(%rbp), %eax
	addl	$15, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	xorq	%rax, %rbx
	movl	-16(%rbp), %eax
	addl	$20, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	xorq	%rax, %rbx
	movq	%rbx, %rdx
	movl	-16(%rbp), %eax
	movq	%rdx, -88(%rbp,%rax,8)
	addl	$1, -16(%rbp)
.L54:
	cmpl	$4, -16(%rbp)
	jbe	.L55
	movl	$0, -16(%rbp)
	jmp	.L56
.L59:
	movl	-16(%rbp), %eax
	leal	4(%rax), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$2, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	movq	-88(%rbp,%rax,8), %rsi
	movl	-16(%rbp), %eax
	leal	1(%rax), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$2, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	movq	-88(%rbp,%rax,8), %rax
	rolq	%rax
	xorq	%rsi, %rax
	movq	%rax, -40(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L57
.L58:
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	xor64
	addl	$1, -20(%rbp)
.L57:
	cmpl	$4, -20(%rbp)
	jbe	.L58
	addl	$1, -16(%rbp)
.L56:
	cmpl	$4, -16(%rbp)
	jbe	.L59
	movl	$1, -16(%rbp)
	movl	$0, -12(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	movq	%rax, -40(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L60
.L61:
	movl	-28(%rbp), %edx
	movl	-12(%rbp), %eax
	addl	%edx, %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	movl	-16(%rbp), %eax
	leal	(%rax,%rax), %ecx
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	movl	%edx, %eax
	shrl	$2, %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, -44(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	movq	%rax, -88(%rbp)
	movl	-12(%rbp), %eax
	andl	$63, %eax
	movq	-40(%rbp), %rdx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movl	-12(%rbp), %eax
	andl	$63, %eax
	movl	$64, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, %ecx
	movq	-40(%rbp), %rax
	shrq	%cl, %rax
	movq	%rdx, %rcx
	xorq	%rax, %rcx
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	store64
	movq	-88(%rbp), %rax
	movq	%rax, -40(%rbp)
	addl	$1, -28(%rbp)
.L60:
	cmpl	$23, -28(%rbp)
	jbe	.L61
	movl	$0, -20(%rbp)
	jmp	.L62
.L67:
	movl	$0, -16(%rbp)
	jmp	.L63
.L64:
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load64
	movq	%rax, %rdx
	movl	-16(%rbp), %eax
	movq	%rdx, -88(%rbp,%rax,8)
	addl	$1, -16(%rbp)
.L63:
	cmpl	$4, -16(%rbp)
	jbe	.L64
	movl	$0, -16(%rbp)
	jmp	.L65
.L66:
	movl	-16(%rbp), %eax
	movq	-88(%rbp,%rax,8), %rsi
	movl	-16(%rbp), %eax
	leal	1(%rax), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$2, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	movq	-88(%rbp,%rax,8), %rax
	notq	%rax
	movq	%rax, %rdi
	movl	-16(%rbp), %eax
	leal	2(%rax), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$2, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	movq	-88(%rbp,%rax,8), %rax
	andq	%rdi, %rax
	xorq	%rax, %rsi
	movq	%rsi, %rcx
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	store64
	addl	$1, -16(%rbp)
.L65:
	cmpl	$4, -16(%rbp)
	jbe	.L66
	addl	$1, -20(%rbp)
.L62:
	cmpl	$4, -20(%rbp)
	jbe	.L67
	movl	$0, -28(%rbp)
	jmp	.L68
.L70:
	leaq	-45(%rbp), %rax
	movq	%rax, %rdi
	call	LFSR86540
	testl	%eax, %eax
	je	.L69
	movl	-28(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	subl	$1, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	xor64
.L69:
	addl	$1, -28(%rbp)
.L68:
	cmpl	$6, -28(%rbp)
	jbe	.L70
	addl	$1, -24(%rbp)
.L53:
	cmpl	$23, -24(%rbp)
	jbe	.L71
	addq	$88, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	KeccakF1600, .-KeccakF1600
	.globl	Keccak
	.type	Keccak, @function
Keccak:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$264, %rsp
	movl	%edi, -228(%rbp)
	movl	%esi, -232(%rbp)
	movq	%rdx, -240(%rbp)
	movq	%rcx, -248(%rbp)
	movl	%r8d, %eax
	movq	%r9, -264(%rbp)
	movb	%al, -252(%rbp)
	movl	-228(%rbp), %eax
	shrl	$3, %eax
	movl	%eax, -12(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L73
.L74:
	movl	-4(%rbp), %eax
	movb	$0, -224(%rbp,%rax)
	addl	$1, -4(%rbp)
.L73:
	cmpl	$199, -4(%rbp)
	jbe	.L74
	jmp	.L75
.L78:
	movl	-12(%rbp), %edx
	movq	-248(%rbp), %rax
	cmpq	%rax, %rdx
	cmovbe	%rdx, %rax
	movl	%eax, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L76
.L77:
	movl	-4(%rbp), %eax
	movzbl	-224(%rbp,%rax), %edx
	movl	-4(%rbp), %ecx
	movq	-240(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	xorl	%eax, %edx
	movl	-4(%rbp), %eax
	movb	%dl, -224(%rbp,%rax)
	addl	$1, -4(%rbp)
.L76:
	movl	-4(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jb	.L77
	movl	-8(%rbp), %eax
	addq	%rax, -240(%rbp)
	movl	-8(%rbp), %eax
	subq	%rax, -248(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jne	.L75
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	KeccakF1600
	movl	$0, -8(%rbp)
.L75:
	cmpq	$0, -248(%rbp)
	jne	.L78
	movl	-8(%rbp), %eax
	movzbl	-224(%rbp,%rax), %eax
	xorb	-252(%rbp), %al
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	movb	%dl, -224(%rbp,%rax)
	movzbl	-252(%rbp), %eax
	testb	%al, %al
	jns	.L79
	movl	-12(%rbp), %eax
	subl	$1, %eax
	cmpl	-8(%rbp), %eax
	jne	.L79
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	KeccakF1600
.L79:
	movl	-12(%rbp), %eax
	leal	-1(%rax), %edx
	movl	-12(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %eax
	movzbl	-224(%rbp,%rax), %eax
	xorl	$-128, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	movb	%cl, -224(%rbp,%rax)
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	KeccakF1600
	jmp	.L80
.L83:
	movl	-12(%rbp), %edx
	movq	16(%rbp), %rax
	cmpq	%rax, %rdx
	cmovbe	%rdx, %rax
	movl	%eax, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L81
.L82:
	movl	-4(%rbp), %edx
	movq	-264(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movzbl	-224(%rbp,%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -4(%rbp)
.L81:
	movl	-4(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jb	.L82
	movl	-8(%rbp), %eax
	addq	%rax, -264(%rbp)
	movl	-8(%rbp), %eax
	subq	%rax, 16(%rbp)
	cmpq	$0, 16(%rbp)
	je	.L80
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	KeccakF1600
.L80:
	cmpq	$0, 16(%rbp)
	jne	.L83
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	Keccak, .-Keccak
	.globl	getHash
	.type	getHash, @function
getHash:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rsi
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	movl	$128, %ecx
	movq	%rax, %rdi
	call	FIPS202_SHAKE256
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	getHash, .-getHash
	.globl	getSeed
	.type	getSeed, @function
getSeed:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movq	%rdi, -152(%rbp)
	movq	-152(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	getHash
	movl	$0, -4(%rbp)
	jmp	.L86
.L87:
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	seed(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	leaq	-144(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	addl	$1, -4(%rbp)
.L86:
	cmpl	$15, -4(%rbp)
	jle	.L87
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	getSeed, .-getSeed
	.globl	getNext255StringFromKeyFile
	.type	getNext255StringFromKeyFile, @function
getNext255StringFromKeyFile:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	$0, -8(%rbp)
	jmp	.L89
.L91:
	movl	$255, %eax
	subq	-8(%rbp), %rax
	movq	%rax, %rsi
	movq	-8(%rbp), %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rdi
	movq	-24(%rbp), %rax
	movq	%rax, %rcx
	movq	%rsi, %rdx
	movl	$1, %esi
	call	fread
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L90
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	jmp	.L89
.L90:
	movq	-16(%rbp), %rax
	addq	%rax, -8(%rbp)
.L89:
	cmpq	$254, -8(%rbp)
	jle	.L91
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	getNext255StringFromKeyFile, .-getNext255StringFromKeyFile
	.section	.rodata
	.align 8
.LC3:
	.string	"scrambling substitution's tables, may be long..."
	.align 8
.LC4:
	.string	"\rscrambling substitution's tables, may be long...(%d/16)"
	.align 8
.LC7:
	.string	"\rscrambling substitution's tables... Done               "
	.text
	.globl	scramble
	.type	scramble, @function
scramble:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16448, %rsp
	movq	%rdi, -16440(%rbp)
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movl	$0, -4(%rbp)
	jmp	.L93
.L105:
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, %esi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movb	$0, -37(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L94
.L95:
	movl	-8(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$scrambleAsciiTables, %rax
	movb	%cl, (%rax)
	addl	$1, -8(%rbp)
.L94:
	cmpl	$255, -8(%rbp)
	jle	.L95
	movzbl	usingKeyFile(%rip), %eax
	testb	%al, %al
	je	.L96
	movl	keyFileSize(%rip), %eax
	pxor	%xmm0, %xmm0
	cvtsi2ss	%eax, %xmm0
	movss	.LC5(%rip), %xmm1
	divss	%xmm1, %xmm0
	call	ceilRound
	movq	%rax, -16(%rbp)
	movzbl	normalised(%rip), %eax
	testb	%al, %al
	je	.L97
	movq	$1, -16(%rbp)
.L97:
	movl	$0, -20(%rbp)
	jmp	.L98
.L101:
	leaq	-16432(%rbp), %rdx
	movq	-16440(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	getNext255StringFromKeyFile
	movl	$0, -24(%rbp)
	jmp	.L99
.L100:
	call	generateNumber
	movl	%eax, %edx
	movl	-24(%rbp), %eax
	cltq
	movzbl	-16432(%rbp,%rax), %eax
	xorl	%edx, %eax
	movsbl	%al, %eax
	pxor	%xmm0, %xmm0
	cvtsi2ss	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movapd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sd	-24(%rbp), %xmm0
	movsd	.LC6(%rip), %xmm2
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sd	-24(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	movb	%al, -38(%rbp)
	movl	-24(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movb	%al, -37(%rbp)
	movzbl	-38(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	movl	-4(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$scrambleAsciiTables, %rdx
	movb	%al, (%rdx)
	movzbl	-38(%rbp), %edx
	movzbl	-37(%rbp), %eax
	movslq	%edx, %rdx
	movl	-4(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$scrambleAsciiTables, %rdx
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
.L99:
	cmpl	$254, -24(%rbp)
	jle	.L100
	addl	$1, -20(%rbp)
.L98:
	movl	-20(%rbp), %eax
	cltq
	cmpq	-16(%rbp), %rax
	jl	.L101
	jmp	.L102
.L96:
	movl	$0, -28(%rbp)
	jmp	.L103
.L104:
	call	generateNumber
	movl	%eax, %edx
	movq	passIndex(%rip), %rax
	movzbl	passPhrase(%rax), %eax
	xorl	%edx, %eax
	movsbl	%al, %eax
	pxor	%xmm0, %xmm0
	cvtsi2ss	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movapd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sd	-28(%rbp), %xmm0
	movsd	.LC6(%rip), %xmm2
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sd	-28(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	movb	%al, -39(%rbp)
	movq	passIndex(%rip), %rax
	addq	$1, %rax
	movq	%rax, passIndex(%rip)
	movq	passIndex(%rip), %rax
	movl	passPhraseSize(%rip), %edx
	movslq	%edx, %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	movq	%rax, passIndex(%rip)
	movl	-28(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movb	%al, -37(%rbp)
	movzbl	-39(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	movl	-4(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$scrambleAsciiTables, %rdx
	movb	%al, (%rdx)
	movzbl	-39(%rbp), %edx
	movzbl	-37(%rbp), %eax
	movslq	%edx, %rdx
	movl	-4(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$scrambleAsciiTables, %rdx
	movb	%al, (%rdx)
	addl	$1, -28(%rbp)
.L103:
	cmpl	$254, -28(%rbp)
	jle	.L104
.L102:
	addl	$1, -4(%rbp)
.L93:
	cmpl	$15, -4(%rbp)
	jle	.L105
	movzbl	usingKeyFile(%rip), %eax
	testb	%al, %al
	je	.L106
	movl	$0, -32(%rbp)
	jmp	.L107
.L112:
	movq	-16440(%rbp), %rdx
	leaq	-16432(%rbp), %rax
	movq	%rdx, %rcx
	movl	$16384, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movl	%eax, -44(%rbp)
	cmpl	$0, -44(%rbp)
	jne	.L108
	movq	-16440(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	jmp	.L107
.L108:
	movl	$0, -36(%rbp)
	jmp	.L109
.L111:
	movl	-36(%rbp), %eax
	cltq
	movzbl	-16432(%rbp,%rax), %eax
	andl	$15, %eax
	movl	%eax, %edx
	movl	-32(%rbp), %eax
	cltq
	movb	%dl, scramblingTablesOrder(%rax)
	addl	$1, -32(%rbp)
	cmpl	$16384, -32(%rbp)
	jne	.L110
	jmp	.L107
.L110:
	addl	$1, -36(%rbp)
.L109:
	movl	-36(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L111
.L107:
	cmpl	$16383, -32(%rbp)
	jle	.L112
.L106:
	movl	$.LC7, %edi
	call	puts
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	scramble, .-scramble
	.globl	unscramble
	.type	unscramble, @function
unscramble:
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -4(%rbp)
	jmp	.L114
.L117:
	movl	$0, -8(%rbp)
	jmp	.L115
.L116:
	movl	-8(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movb	%al, -9(%rbp)
	movzbl	-9(%rbp), %eax
	movl	-8(%rbp), %edx
	movl	%edx, %ecx
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$8, %rdx
	addq	%rdx, %rax
	addq	$unscrambleAsciiTables, %rax
	movb	%cl, (%rax)
	addl	$1, -8(%rbp)
.L115:
	cmpl	$255, -8(%rbp)
	jle	.L116
	addl	$1, -4(%rbp)
.L114:
	cmpl	$15, -4(%rbp)
	jle	.L117
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	unscramble, .-unscramble
	.globl	codingXOR
	.type	codingXOR, @function
codingXOR:
.LFB24:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	%ecx, -44(%rbp)
	movzbl	usingKeyFile(%rip), %eax
	testb	%al, %al
	je	.L119
	movzbl	isCodingInverted(%rip), %eax
	testb	%al, %al
	je	.L120
	movl	$0, -4(%rbp)
	jmp	.L121
.L122:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	movzbl	scramblingTablesOrder(%rax), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	xorl	%ecx, %eax
	movsbl	%al, %eax
	andl	$15, %eax
	movl	%eax, %edi
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	xorl	%ecx, %eax
	movzbl	%al, %eax
	cltq
	movslq	%edi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -4(%rbp)
.L121:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L122
	jmp	.L118
.L120:
	movl	$0, -4(%rbp)
	jmp	.L124
.L125:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	movzbl	scramblingTablesOrder(%rax), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	xorl	%ecx, %eax
	movsbl	%al, %eax
	andl	$15, %eax
	movl	%eax, %esi
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movslq	%esi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rax
	addq	$scrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movl	%eax, %esi
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	xorl	%esi, %eax
	movb	%al, (%rdx)
	addl	$1, -4(%rbp)
.L124:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L125
	jmp	.L118
.L119:
	movzbl	isCodingInverted(%rip), %eax
	testb	%al, %al
	je	.L126
	movl	$0, -4(%rbp)
	jmp	.L127
.L128:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movsbl	%dl, %edx
	movl	%edx, %edi
	andl	$15, %edi
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %ecx
	movl	-4(%rbp), %edx
	movslq	%edx, %rsi
	movq	-32(%rbp), %rdx
	addq	%rsi, %rdx
	movzbl	(%rdx), %edx
	xorl	%ecx, %edx
	movzbl	%dl, %edx
	movslq	%edx, %rdx
	movslq	%edi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$scrambleAsciiTables, %rdx
	movzbl	(%rdx), %edx
	movb	%dl, (%rax)
	addl	$1, -4(%rbp)
.L127:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L128
	jmp	.L118
.L126:
	movl	$0, -4(%rbp)
	jmp	.L129
.L130:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movsbl	%dl, %edx
	movl	%edx, %esi
	andl	$15, %esi
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movzbl	%dl, %edx
	movslq	%edx, %rdx
	movslq	%esi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$scrambleAsciiTables, %rdx
	movzbl	(%rdx), %edx
	movl	%edx, %esi
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	xorl	%esi, %edx
	movb	%dl, (%rax)
	addl	$1, -4(%rbp)
.L129:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L130
.L118:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	codingXOR, .-codingXOR
	.globl	decodingXOR
	.type	decodingXOR, @function
decodingXOR:
.LFB25:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	%ecx, -44(%rbp)
	movzbl	usingKeyFile(%rip), %eax
	testb	%al, %al
	je	.L132
	movzbl	isCodingInverted(%rip), %eax
	testb	%al, %al
	je	.L133
	movl	$0, -4(%rbp)
	jmp	.L134
.L135:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	movzbl	scramblingTablesOrder(%rax), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	xorl	%ecx, %eax
	movsbl	%al, %eax
	andl	$15, %eax
	movl	%eax, %esi
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movslq	%esi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rax
	addq	$unscrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movl	%eax, %esi
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	xorl	%esi, %eax
	movb	%al, (%rdx)
	addl	$1, -4(%rbp)
.L134:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L135
	jmp	.L131
.L133:
	movl	$0, -4(%rbp)
	jmp	.L137
.L138:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	movzbl	scramblingTablesOrder(%rax), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	xorl	%ecx, %eax
	movsbl	%al, %eax
	andl	$15, %eax
	movl	%eax, %edi
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	xorl	%ecx, %eax
	movzbl	%al, %eax
	cltq
	movslq	%edi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rax
	addq	$unscrambleAsciiTables, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -4(%rbp)
.L137:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L138
	jmp	.L131
.L132:
	movzbl	isCodingInverted(%rip), %eax
	testb	%al, %al
	je	.L139
	movl	$0, -4(%rbp)
	jmp	.L140
.L141:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movsbl	%dl, %edx
	movl	%edx, %esi
	andl	$15, %esi
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movzbl	%dl, %edx
	movslq	%edx, %rdx
	movslq	%esi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$unscrambleAsciiTables, %rdx
	movzbl	(%rdx), %edx
	movl	%edx, %esi
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	xorl	%esi, %edx
	movb	%dl, (%rax)
	addl	$1, -4(%rbp)
.L140:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L141
	jmp	.L131
.L139:
	movl	$0, -4(%rbp)
	jmp	.L142
.L143:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movsbl	%dl, %edx
	movl	%edx, %edi
	andl	$15, %edi
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %ecx
	movl	-4(%rbp), %edx
	movslq	%edx, %rsi
	movq	-32(%rbp), %rdx
	addq	%rsi, %rdx
	movzbl	(%rdx), %edx
	xorl	%ecx, %edx
	movzbl	%dl, %edx
	movslq	%edx, %rdx
	movslq	%edi, %rcx
	salq	$8, %rcx
	addq	%rcx, %rdx
	addq	$unscrambleAsciiTables, %rdx
	movzbl	(%rdx), %edx
	movb	%dl, (%rax)
	addl	$1, -4(%rbp)
.L142:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L143
.L131:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	decodingXOR, .-decodingXOR
	.globl	standardXOR
	.type	standardXOR, @function
standardXOR:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	%ecx, -44(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L145
.L146:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %ecx
	movl	-4(%rbp), %edx
	movslq	%edx, %rsi
	movq	-32(%rbp), %rdx
	addq	%rsi, %rdx
	movzbl	(%rdx), %edx
	xorl	%ecx, %edx
	movb	%dl, (%rax)
	addl	$1, -4(%rbp)
.L145:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L146
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	standardXOR, .-standardXOR
	.globl	fillBuffer
	.type	fillBuffer, @function
fillBuffer:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-40(%rbp), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rcx
	movl	$16384, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L148
.L149:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	call	generateNumber
	movl	%eax, %edx
	movq	passIndex(%rip), %rax
	movzbl	passPhrase(%rax), %eax
	xorl	%edx, %eax
	movb	%al, (%rbx)
	movq	passIndex(%rip), %rax
	addq	$1, %rax
	movq	%rax, passIndex(%rip)
	movq	passIndex(%rip), %rax
	movl	passPhraseSize(%rip), %edx
	movslq	%edx, %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	movq	%rax, passIndex(%rip)
	addl	$1, -20(%rbp)
.L148:
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L149
	movl	-24(%rbp), %eax
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	fillBuffer, .-fillBuffer
	.section	.rodata
.LC10:
	.string	" %3d%% ["
.LC11:
	.string	"] %.0f        \r"
	.text
	.type	loadBar, @function
loadBar:
.LFB28:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	%edx, -44(%rbp)
	movl	%ecx, -48(%rbp)
	movzbl	firstCall.3126(%rip), %eax
	testb	%al, %al
	je	.L152
	movl	$0, %edi
	call	time
	movq	%rax, startingTime.3129(%rip)
	movb	$0, firstCall.3126(%rip)
.L152:
	movl	-40(%rbp), %eax
	cltd
	idivl	-44(%rbp)
	leal	1(%rax), %ecx
	movl	-36(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	testl	%eax, %eax
	je	.L153
	jmp	.L151
.L153:
	pxor	%xmm0, %xmm0
	cvtsi2ss	-36(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2ss	-40(%rbp), %xmm1
	divss	%xmm1, %xmm0
	movd	%xmm0, %eax
	movl	%eax, -12(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2ss	-48(%rbp), %xmm0
	mulss	-12(%rbp), %xmm0
	cvttss2si	%xmm0, %eax
	movl	%eax, -16(%rbp)
	movl	$0, %edi
	call	time
	movq	%rax, -24(%rbp)
	movq	startingTime.3129(%rip), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	difftime
	movq	%xmm0, %rax
	movq	%rax, elapsedTime.3127(%rip)
	cvtss2sd	-12(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	elapsedTime.3127(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, -32(%rbp)
	movss	-12(%rbp), %xmm1
	movss	.LC9(%rip), %xmm0
	mulss	%xmm1, %xmm0
	cvttss2si	%xmm0, %eax
	movl	%eax, %esi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	movl	$0, -4(%rbp)
	jmp	.L155
.L156:
	movl	$61, %edi
	call	putchar
	addl	$1, -4(%rbp)
.L155:
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	.L156
	movl	-16(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.L157
.L158:
	movl	$32, %edi
	call	putchar
	addl	$1, -8(%rbp)
.L157:
	movl	-8(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jl	.L158
	movq	-32(%rbp), %rax
	movq	%rax, -56(%rbp)
	movsd	-56(%rbp), %xmm0
	movl	$.LC11, %edi
	movl	$1, %eax
	call	printf
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
.L151:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	loadBar, .-loadBar
	.section	.rodata
.LC12:
	.string	"%sx%s"
.LC13:
	.string	"w+"
.LC14:
	.string	"exiting..."
.LC15:
	.string	"starting encryption..."
	.text
	.globl	code
	.type	code, @function
code:
.LFB29:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$49232, %rsp
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -49240(%rbp)
	movq	%rsp, %rax
	movq	%rax, %r12
	movl	$pathToMainFile, %edi
	call	strlen
	movq	%rax, %rbx
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	strlen
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, -48(%rbp)
	movq	%rax, -49264(%rbp)
	movq	$0, -49256(%rbp)
	movq	%rax, %r13
	movl	$0, %r14d
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %ebx
	movl	$0, %edx
	divq	%rbx
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -56(%rbp)
	movq	$0, -16464(%rbp)
	leaq	-16456(%rbp), %rax
	movl	$16376, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	$0, -32848(%rbp)
	leaq	-32840(%rbp), %rax
	movl	$16376, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	$0, -49232(%rbp)
	leaq	-49224(%rbp), %rax
	movl	$16376, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	fileName(%rip), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rcx
	movl	$pathToMainFile, %edx
	movl	$.LC12, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf
	movq	-56(%rbp), %rax
	movl	$.LC13, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	jne	.L160
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	perror
	movl	$.LC14, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L160:
	movq	$0, -40(%rbp)
	movl	$.LC15, %edi
	call	puts
	movzbl	scrambling(%rip), %eax
	testb	%al, %al
	je	.L161
	jmp	.L162
.L163:
	leaq	-32848(%rbp), %rdx
	leaq	-16464(%rbp), %rcx
	movq	-49240(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fillBuffer
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %ecx
	leaq	-49232(%rbp), %rdx
	leaq	-32848(%rbp), %rsi
	leaq	-16464(%rbp), %rax
	movq	%rax, %rdi
	call	codingXOR
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	leaq	-49232(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	numberOfBuffer(%rip), %rax
	movl	%eax, %esi
	addq	$1, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	$50, %ecx
	movl	$100, %edx
	movl	%eax, %edi
	call	loadBar
.L162:
	movq	-49240(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	testl	%eax, %eax
	je	.L163
	jmp	.L164
.L161:
	jmp	.L165
.L166:
	leaq	-32848(%rbp), %rdx
	leaq	-16464(%rbp), %rcx
	movq	-49240(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fillBuffer
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %ecx
	leaq	-49232(%rbp), %rdx
	leaq	-32848(%rbp), %rsi
	leaq	-16464(%rbp), %rax
	movq	%rax, %rdi
	call	standardXOR
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	leaq	-49232(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	numberOfBuffer(%rip), %rax
	movl	%eax, %esi
	addq	$1, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	$50, %ecx
	movl	$100, %edx
	movl	%eax, %edi
	call	loadBar
.L165:
	movq	-49240(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	testl	%eax, %eax
	je	.L166
.L164:
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movzbl	_isADirectory(%rip), %eax
	testb	%al, %al
	je	.L167
	movl	$pathToMainFile, %edi
	call	strlen
	movq	%rax, %rbx
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	strlen
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	calloc
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movl	$pathToMainFile, %esi
	movq	%rax, %rdi
	call	strcpy
	movq	fileName(%rip), %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcat
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	remove
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	free
.L167:
	movq	%r12, %rsp
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	code, .-code
	.section	.rodata
.LC16:
	.string	"starting decryption..."
	.text
	.globl	decode
	.type	decode, @function
decode:
.LFB30:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$49232, %rsp
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -49240(%rbp)
	movq	%rsp, %rax
	movq	%rax, %r12
	movl	$pathToMainFile, %edi
	call	strlen
	movq	%rax, %rbx
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	strlen
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, -48(%rbp)
	movq	%rax, -49264(%rbp)
	movq	$0, -49256(%rbp)
	movq	%rax, %r13
	movl	$0, %r14d
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %ebx
	movl	$0, %edx
	divq	%rbx
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -56(%rbp)
	movq	$0, -16464(%rbp)
	leaq	-16456(%rbp), %rax
	movl	$16376, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	$0, -32848(%rbp)
	leaq	-32840(%rbp), %rax
	movl	$16376, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	$0, -49232(%rbp)
	leaq	-49224(%rbp), %rax
	movl	$16376, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movl	$0, %eax
	call	unscramble
	movq	fileName(%rip), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rcx
	movl	$pathToMainFile, %edx
	movl	$.LC12, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf
	movq	-56(%rbp), %rax
	movl	$.LC13, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	jne	.L169
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	perror
	movl	$.LC14, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L169:
	movq	$0, -40(%rbp)
	movl	$.LC16, %edi
	call	puts
	movzbl	scrambling(%rip), %eax
	testb	%al, %al
	je	.L170
	jmp	.L171
.L172:
	leaq	-32848(%rbp), %rdx
	leaq	-16464(%rbp), %rcx
	movq	-49240(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fillBuffer
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %ecx
	leaq	-49232(%rbp), %rdx
	leaq	-32848(%rbp), %rsi
	leaq	-16464(%rbp), %rax
	movq	%rax, %rdi
	call	decodingXOR
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	leaq	-49232(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	numberOfBuffer(%rip), %rax
	movl	%eax, %esi
	addq	$1, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	$50, %ecx
	movl	$100, %edx
	movl	%eax, %edi
	call	loadBar
.L171:
	movq	-49240(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	testl	%eax, %eax
	je	.L172
	jmp	.L173
.L170:
	jmp	.L174
.L175:
	leaq	-32848(%rbp), %rdx
	leaq	-16464(%rbp), %rcx
	movq	-49240(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fillBuffer
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %ecx
	leaq	-49232(%rbp), %rdx
	leaq	-32848(%rbp), %rsi
	leaq	-16464(%rbp), %rax
	movq	%rax, %rdi
	call	standardXOR
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	leaq	-49232(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	numberOfBuffer(%rip), %rax
	movl	%eax, %esi
	addq	$1, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	$50, %ecx
	movl	$100, %edx
	movl	%eax, %edi
	call	loadBar
.L174:
	movq	-49240(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	testl	%eax, %eax
	je	.L175
.L173:
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movq	%r12, %rsp
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	decode, .-decode
	.section	.rodata
	.align 8
.LC17:
	.string	"Error : file's path is not correct, one or several directories and or file are missing"
.LC18:
	.string	"stat"
	.text
	.globl	isADirectory
	.type	isADirectory, @function
isADirectory:
.LFB31:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	leaq	-160(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	stat
	movl	%eax, -4(%rbp)
	cmpl	$-1, -4(%rbp)
	jne	.L177
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$2, %eax
	jne	.L178
	movl	$.LC17, %edi
	call	puts
	movl	$.LC14, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L178:
	movl	$.LC18, %edi
	call	perror
	movl	$.LC14, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L177:
	movl	-136(%rbp), %eax
	andl	$61440, %eax
	cmpl	$16384, %eax
	jne	.L180
	movb	$1, _isADirectory(%rip)
	movl	$1, %eax
	jmp	.L182
.L180:
	movb	$0, _isADirectory(%rip)
	movl	$0, %eax
.L182:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	isADirectory, .-isADirectory
	.section	.rodata
.LC19:
	.string	"Error : Too many arguments"
.LC20:
	.string	"-h"
.LC21:
	.string	"--help"
	.align 8
.LC22:
	.string	"Warning : with the option 'd'(delete) the main file will be deleted at the end"
	.align 8
.LC23:
	.string	"Error : no valid option has been found"
.LC24:
	.string	"r"
	.align 8
.LC25:
	.string	"Warning : the keyfile is a directory and will not be used"
	.align 8
.LC26:
	.string	"Warning : with the option 's'(simple), the keyfile will not bu used"
	.align 8
.LC27:
	.string	"Warning : the keyFile is empty and thus will not be used"
	.align 8
.LC28:
	.string	"Warning : without the keyFile, the option 'n'(normalised) will be ignored"
	.align 8
.LC29:
	.string	"Error : several trailing '/' in the path of your file"
	.align 8
.LC30:
	.string	"regrouping the folder in one file using tar, may be long..."
.LC31:
	.string	"%s.tar"
	.align 8
.LC32:
	.string	"cd %s && tar -cf %s %s &>/dev/null"
	.align 8
.LC33:
	.string	"\nError : unable to tar your file"
	.align 8
.LC34:
	.string	"\rregrouping the folder in one file using tar... Done          "
.LC35:
	.string	"%s%s"
.LC37:
	.string	"Crypt(C) or Decrypt(d):"
.LC38:
	.string	"\033[F\033[J"
.LC39:
	.string	"Password:"
.LC40:
	.string	"the password can't be empty"
	.align 8
.LC41:
	.string	"Done                                                                  "
	.text
	.globl	main
	.type	main, @function
main:
.LFB32:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1160, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, -1172(%rbp)
	movq	%rsi, -1184(%rbp)
	movq	$0, -64(%rbp)
	movq	-1184(%rbp), %rax
	movq	(%rax), %rax
	movl	$47, %esi
	movq	%rax, %rdi
	call	strrchr
	movq	%rax, progName(%rip)
	movq	progName(%rip), %rax
	testq	%rax, %rax
	je	.L184
	movq	progName(%rip), %rax
	addq	$1, %rax
	movq	%rax, progName(%rip)
	jmp	.L185
.L184:
	movq	-1184(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, progName(%rip)
.L185:
	cmpl	$1, -1172(%rbp)
	jg	.L186
	movl	$1, %edi
	call	usage
	jmp	.L187
.L186:
	cmpl	$4, -1172(%rbp)
	jle	.L188
	movl	$.LC19, %edi
	call	puts
	movl	$1, %edi
	call	usage
	jmp	.L187
.L188:
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$.LC20, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L189
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$.LC21, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L187
.L189:
	movl	$0, %edi
	call	usage
.L187:
	movb	$1, -65(%rbp)
	movb	$0, -66(%rbp)
	cmpl	$2, -1172(%rbp)
	jle	.L190
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L191
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen
	cmpq	$4, %rax
	ja	.L191
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$115, %esi
	movq	%rax, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L192
	movb	$0, scrambling(%rip)
.L192:
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$105, %esi
	movq	%rax, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L193
	movb	$1, isCodingInverted(%rip)
.L193:
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$110, %esi
	movq	%rax, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L194
	movb	$1, normalised(%rip)
.L194:
	movq	-1184(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$100, %esi
	movq	%rax, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L195
	movb	$1, -66(%rbp)
	movl	$.LC22, %edi
	call	puts
.L195:
	movzbl	scrambling(%rip), %eax
	testb	%al, %al
	je	.L196
	movzbl	isCodingInverted(%rip), %eax
	testb	%al, %al
	jne	.L196
	movzbl	normalised(%rip), %eax
	testb	%al, %al
	jne	.L196
	cmpb	$0, -66(%rbp)
	jne	.L196
	movl	$.LC23, %edi
	call	puts
	movl	$1, %edi
	call	usage
	jmp	.L197
.L196:
	movb	$2, -65(%rbp)
.L197:
	cmpl	$3, -1172(%rbp)
	jle	.L198
	movq	-1184(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	jne	.L199
	movq	-1184(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	perror
	movl	$1, %edi
	call	usage
.L199:
	cmpq	$0, -64(%rbp)
	je	.L198
	movq	-1184(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	isADirectory
	testl	%eax, %eax
	je	.L200
	movl	$.LC25, %edi
	call	puts
	movq	$0, -64(%rbp)
	jmp	.L198
.L200:
	movzbl	scrambling(%rip), %eax
	testb	%al, %al
	jne	.L198
	movl	$.LC26, %edi
	call	puts
	movq	$0, -64(%rbp)
	jmp	.L201
.L198:
	jmp	.L201
.L191:
	movq	-1184(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	jne	.L202
	movq	-1184(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	perror
	movl	$1, %edi
	call	usage
	jmp	.L201
.L202:
	cmpq	$0, -64(%rbp)
	je	.L201
	movq	-1184(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	isADirectory
	testl	%eax, %eax
	je	.L203
	movl	$.LC25, %edi
	call	puts
	movq	$0, -64(%rbp)
.L203:
	cmpl	$3, -1172(%rbp)
	jle	.L201
	movl	$.LC19, %edi
	call	puts
	movl	$1, %edi
	call	usage
.L201:
	cmpq	$0, -64(%rbp)
	je	.L204
	movb	$1, usingKeyFile(%rip)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	movq	-64(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movl	%eax, keyFileSize(%rip)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	movl	keyFileSize(%rip), %eax
	testl	%eax, %eax
	jne	.L204
	movl	$.LC27, %edi
	call	puts
	movq	$0, -64(%rbp)
	movb	$0, usingKeyFile(%rip)
.L204:
	movzbl	usingKeyFile(%rip), %eax
	testb	%al, %al
	jne	.L190
	movzbl	normalised(%rip), %eax
	testb	%al, %al
	je	.L190
	movl	$.LC28, %edi
	call	puts
	movb	$0, normalised(%rip)
.L190:
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %r12
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen
	subq	$1, %rax
	addq	%r12, %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jne	.L205
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %r12
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen
	subq	$2, %rax
	addq	%r12, %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jne	.L205
	movl	$.LC29, %edi
	call	puts
	movl	$.LC14, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L205:
	movq	$0, -80(%rbp)
	movq	$0, -88(%rbp)
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	isADirectory
	testl	%eax, %eax
	je	.L206
	movq	%rsp, %rax
	movq	%rax, %r13
	leaq	-1168(%rbp), %rdx
	movl	$0, %eax
	movl	$126, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$.LC30, %edi
	movl	$0, %eax
	call	printf
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$47, %esi
	movq	%rax, %rdi
	call	strrchr
	movq	%rax, fileName(%rip)
	movq	fileName(%rip), %rax
	testq	%rax, %rax
	je	.L207
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	strlen
	cmpq	$1, %rax
	jne	.L208
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen
	addq	$5, %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	calloc
	movq	%rax, -88(%rbp)
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-88(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy
	movq	fileName(%rip), %rax
	movq	%rax, %rcx
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-88(%rbp), %rax
	movl	$47, %esi
	movq	%rax, %rdi
	call	strrchr
	movq	%rax, fileName(%rip)
	movq	fileName(%rip), %rax
	testq	%rax, %rax
	je	.L209
	movq	fileName(%rip), %rax
	addq	$1, %rax
	movq	%rax, fileName(%rip)
	movq	fileName(%rip), %rax
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	movq	%rax, %rsi
	movl	$pathToMainFile, %edi
	call	strncpy
	movq	fileName(%rip), %rax
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	movb	$0, pathToMainFile(%rax)
	jmp	.L212
.L209:
	movq	-88(%rbp), %rax
	movq	%rax, fileName(%rip)
	jmp	.L212
.L208:
	movq	fileName(%rip), %rax
	addq	$1, %rax
	movq	%rax, fileName(%rip)
	movq	fileName(%rip), %rax
	movq	%rax, %rcx
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, %rcx
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rcx, %rdx
	movq	%rax, %rsi
	movl	$pathToMainFile, %edi
	call	strncpy
	movq	fileName(%rip), %rax
	movq	%rax, %rcx
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	subq	%rax, %rcx
	movq	%rcx, %rax
	movb	$0, pathToMainFile(%rax)
	jmp	.L212
.L207:
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, fileName(%rip)
.L212:
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	strlen
	addq	$5, %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	calloc
	movq	%rax, -80(%rbp)
	movq	fileName(%rip), %rdx
	movq	-80(%rbp), %rax
	movl	$.LC31, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	processTarString
	movq	%rax, -96(%rbp)
	movl	$pathToMainFile, %edi
	call	processTarString
	movq	%rax, -104(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	processTarString
	movq	%rax, -112(%rbp)
	movq	-96(%rbp), %rsi
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rdx
	leaq	-1168(%rbp), %rax
	movq	%rsi, %r8
	movl	$.LC32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	free
	leaq	-1168(%rbp), %rax
	movq	%rax, %rdi
	call	system
	movl	%eax, -116(%rbp)
	cmpl	$0, -116(%rbp)
	je	.L213
	movl	$.LC33, %edi
	call	puts
	movl	$.LC14, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L213:
	movl	$.LC34, %edi
	call	puts
	movq	-80(%rbp), %rax
	movq	%rax, fileName(%rip)
	movl	$pathToMainFile, %edi
	call	strlen
	movq	%rax, %r12
	movq	fileName(%rip), %rax
	movq	%rax, %rdi
	call	strlen
	addq	%r12, %rax
	movq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, -128(%rbp)
	movq	%rax, -1200(%rbp)
	movq	$0, -1192(%rbp)
	movq	%rax, %r14
	movl	$0, %r15d
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %ecx
	movl	$0, %edx
	divq	%rcx
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -136(%rbp)
	movq	fileName(%rip), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rcx
	movl	$pathToMainFile, %edx
	movl	$.LC35, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf
	movq	-136(%rbp), %rax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -56(%rbp)
	cmpq	$0, -56(%rbp)
	jne	.L214
	movq	-136(%rbp), %rax
	movq	%rax, %rdi
	call	perror
	movl	$.LC14, %edi
	call	puts
	movl	$1, %ebx
	movl	$0, %eax
	jmp	.L215
.L214:
	movl	$1, %eax
.L215:
	movq	%r13, %rsp
	cmpl	$1, %eax
	jne	.L235
	jmp	.L218
.L206:
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$47, %esi
	movq	%rax, %rdi
	call	strrchr
	movq	%rax, fileName(%rip)
	movq	fileName(%rip), %rax
	testq	%rax, %rax
	je	.L219
	movq	fileName(%rip), %rax
	addq	$1, %rax
	movq	%rax, fileName(%rip)
	movq	fileName(%rip), %rax
	movq	%rax, %rcx
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, %rcx
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rcx, %rdx
	movq	%rax, %rsi
	movl	$pathToMainFile, %edi
	call	strncpy
	jmp	.L220
.L219:
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, fileName(%rip)
.L220:
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -56(%rbp)
	cmpq	$0, -56(%rbp)
	jne	.L218
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	perror
	movl	$.LC14, %edi
	call	puts
	movl	$1, %ebx
	jmp	.L235
.L218:
	movq	-56(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movq	%rax, -144(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	pxor	%xmm0, %xmm0
	cvtsi2ssq	-144(%rbp), %xmm0
	movss	.LC36(%rip), %xmm1
	divss	%xmm1, %xmm0
	call	ceilRound
	movq	%rax, numberOfBuffer(%rip)
	movq	numberOfBuffer(%rip), %rax
	testq	%rax, %rax
	jg	.L221
	movq	$1, numberOfBuffer(%rip)
.L221:
	movb	$-1, isCrypting(%rip)
.L226:
	movl	$.LC37, %edi
	movl	$0, %eax
	call	printf
	leaq	-160(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readString
	movl	$.LC38, %edi
	movl	$0, %eax
	call	printf
	movzbl	-160(%rbp), %eax
	cmpb	$67, %al
	je	.L222
	movzbl	-160(%rbp), %eax
	cmpb	$99, %al
	jne	.L223
.L222:
	movb	$1, isCrypting(%rip)
	jmp	.L224
.L223:
	movzbl	-160(%rbp), %eax
	cmpb	$68, %al
	je	.L225
	movzbl	-160(%rbp), %eax
	cmpb	$100, %al
	jne	.L224
.L225:
	movb	$0, isCrypting(%rip)
.L224:
	movzbl	isCrypting(%rip), %eax
	cmpb	$-1, %al
	je	.L226
.L229:
	movl	$.LC39, %edi
	movl	$0, %eax
	call	printf
	movl	$16383, %esi
	movl	$passPhrase, %edi
	call	readString
	movl	$passPhrase, %edi
	call	strlen
	movq	%rax, -152(%rbp)
	cmpq	$0, -152(%rbp)
	jg	.L227
	movl	$.LC40, %edi
	call	puts
	jmp	.L228
.L227:
	movl	$.LC38, %edi
	movl	$0, %eax
	call	printf
.L228:
	cmpq	$0, -152(%rbp)
	jle	.L229
	movl	$passPhrase, %edi
	call	strlen
	movl	%eax, passPhraseSize(%rip)
	movl	$passPhrase, %edi
	call	getSeed
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	scramble
	movzbl	isCrypting(%rip), %eax
	testb	%al, %al
	je	.L230
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	code
	jmp	.L231
.L230:
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	decode
.L231:
	movl	$.LC41, %edi
	call	puts
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	cmpb	$0, -66(%rbp)
	je	.L232
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	remove
	testl	%eax, %eax
	je	.L232
	movsbq	-65(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-1184(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	perror
.L232:
	cmpq	$0, -80(%rbp)
	je	.L233
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	free
.L233:
	cmpq	$0, -88(%rbp)
	je	.L234
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	free
.L234:
	movl	$0, %ebx
.L235:
	movl	%ebx, %eax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	main, .-main
	.data
	.type	firstCall.3126, @object
	.size	firstCall.3126, 1
firstCall.3126:
	.byte	1
	.local	startingTime.3129
	.comm	startingTime.3129,8,8
	.local	elapsedTime.3127
	.comm	elapsedTime.3127,8,8
	.section	.rodata
	.align 4
.LC5:
	.long	1132396544
	.align 8
.LC6:
	.long	0
	.long	1081073664
	.align 8
.LC8:
	.long	0
	.long	1072693248
	.align 4
.LC9:
	.long	1120403456
	.align 4
.LC36:
	.long	1182793728
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
