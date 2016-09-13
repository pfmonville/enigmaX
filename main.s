	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 11
	.globl	_ceilRound
	.align	4, 0x90
_ceilRound:                             ## @ceilRound
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp2:
	.cfi_def_cfa_register %rbp
	cvttss2si	%xmm0, %rcx
	cvtsi2ssq	%rcx, %xmm1
	subss	%xmm1, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	seta	%al
	movzbl	%al, %eax
	addq	%rcx, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_clearBuffer
	.align	4, 0x90
_clearBuffer:                           ## @clearBuffer
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp3:
	.cfi_def_cfa_offset 16
Ltmp4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp5:
	.cfi_def_cfa_register %rbp
	xorl	%eax, %eax
	jmp	LBB1_1
	.align	4, 0x90
LBB1_3:                                 ##   in Loop: Header=BB1_1 Depth=1
	callq	_getchar
LBB1_1:                                 ## =>This Inner Loop Header: Depth=1
	cmpl	$-1, %eax
	je	LBB1_4
## BB#2:                                ##   in Loop: Header=BB1_1 Depth=1
	cmpl	$10, %eax
	jne	LBB1_3
LBB1_4:
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_readString
	.align	4, 0x90
_readString:                            ## @readString
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp6:
	.cfi_def_cfa_offset 16
Ltmp7:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp8:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
Ltmp9:
	.cfi_offset %rbx, -24
	movq	%rdi, %rbx
	movq	___stdinp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdx
	callq	_fgets
	testq	%rax, %rax
	je	LBB2_1
## BB#5:
	movl	$10, %esi
	movq	%rbx, %rdi
	callq	_strchr
	testq	%rax, %rax
	je	LBB2_6
## BB#10:
	movb	$0, (%rax)
	movl	$1, %eax
	jmp	LBB2_11
LBB2_1:
	xorl	%ecx, %ecx
	jmp	LBB2_2
	.align	4, 0x90
LBB2_4:                                 ##   in Loop: Header=BB2_2 Depth=1
	callq	_getchar
	movl	%eax, %ecx
LBB2_2:                                 ## %.preheader
                                        ## =>This Inner Loop Header: Depth=1
	xorl	%eax, %eax
	cmpl	$-1, %ecx
	je	LBB2_11
## BB#3:                                ## %.preheader
                                        ##   in Loop: Header=BB2_2 Depth=1
	cmpl	$10, %ecx
	jne	LBB2_4
	jmp	LBB2_11
LBB2_6:
	xorl	%ecx, %ecx
	jmp	LBB2_7
	.align	4, 0x90
LBB2_9:                                 ##   in Loop: Header=BB2_7 Depth=1
	callq	_getchar
	movl	%eax, %ecx
LBB2_7:                                 ## %.preheader3
                                        ## =>This Inner Loop Header: Depth=1
	movl	$1, %eax
	cmpl	$-1, %ecx
	je	LBB2_11
## BB#8:                                ## %.preheader3
                                        ##   in Loop: Header=BB2_7 Depth=1
	cmpl	$10, %ecx
	jne	LBB2_9
LBB2_11:                                ## %clearBuffer.exit
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__literal16,16byte_literals
	.align	4
LCPI3_0:
	.long	32                      ## 0x20
	.long	32                      ## 0x20
	.long	32                      ## 0x20
	.long	32                      ## 0x20
LCPI3_1:
	.long	1                       ## 0x1
	.long	1                       ## 0x1
	.long	1                       ## 0x1
	.long	1                       ## 0x1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_processTarString
	.align	4, 0x90
_processTarString:                      ## @processTarString
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp10:
	.cfi_def_cfa_offset 16
Ltmp11:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp12:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
Ltmp13:
	.cfi_offset %rbx, -48
Ltmp14:
	.cfi_offset %r12, -40
Ltmp15:
	.cfi_offset %r14, -32
Ltmp16:
	.cfi_offset %r15, -24
	movq	%rdi, %r15
	callq	_strlen
	xorl	%edx, %edx
	testq	%rax, %rax
	movl	$0, %esi
	je	LBB3_7
## BB#1:                                ## %.lr.ph6.preheader
	cmpq	$4, %rax
	movl	$0, %esi
	jb	LBB3_15
## BB#2:                                ## %min.iters.checked
	xorl	%esi, %esi
	movq	%rax, %rcx
	andq	$-4, %rcx
	movl	$0, %edx
	je	LBB3_15
## BB#3:                                ## %vector.body.preheader
	movq	%rax, %rdx
	andq	$-4, %rdx
	pxor	%xmm0, %xmm0
	movdqa	LCPI3_0(%rip), %xmm1    ## xmm1 = [32,32,32,32]
	movdqa	LCPI3_1(%rip), %xmm3    ## xmm3 = [1,1,1,1]
	movq	%r15, %rsi
	pxor	%xmm2, %xmm2
	.align	4, 0x90
LBB3_4:                                 ## %vector.body
                                        ## =>This Inner Loop Header: Depth=1
	movd	(%rsi), %xmm4           ## xmm4 = mem[0],zero,zero,zero
	punpcklbw	%xmm0, %xmm4    ## xmm4 = xmm4[0],xmm0[0],xmm4[1],xmm0[1],xmm4[2],xmm0[2],xmm4[3],xmm0[3],xmm4[4],xmm0[4],xmm4[5],xmm0[5],xmm4[6],xmm0[6],xmm4[7],xmm0[7]
	punpcklwd	%xmm0, %xmm4    ## xmm4 = xmm4[0],xmm0[0],xmm4[1],xmm0[1],xmm4[2],xmm0[2],xmm4[3],xmm0[3]
	pcmpeqd	%xmm1, %xmm4
	pand	%xmm3, %xmm4
	paddd	%xmm4, %xmm2
	addq	$4, %rsi
	addq	$-4, %rdx
	jne	LBB3_4
## BB#5:                                ## %middle.block
	pshufd	$78, %xmm2, %xmm0       ## xmm0 = xmm2[2,3,0,1]
	paddd	%xmm2, %xmm0
	phaddd	%xmm0, %xmm0
	movd	%xmm0, %edx
	cmpq	%rcx, %rax
	movq	%rcx, %rsi
	je	LBB3_6
	.align	4, 0x90
LBB3_15:                                ## %.lr.ph6
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%r15,%rsi), %ecx
	cmpl	$32, %ecx
	sete	%cl
	movzbl	%cl, %ecx
	addl	%ecx, %edx
	incq	%rsi
	cmpq	%rax, %rsi
	jb	LBB3_15
LBB3_6:                                 ## %._crit_edge
	testl	%edx, %edx
	movq	%rax, %rsi
	je	LBB3_7
## BB#9:
	movslq	%edx, %rcx
	leaq	1(%rcx,%rax), %rsi
	movl	$1, %r12d
	movl	$1, %edi
	callq	_calloc
	movq	%rax, %r14
	movb	(%r15), %al
	testb	%al, %al
	je	LBB3_8
## BB#10:
	xorl	%ebx, %ebx
	jmp	LBB3_11
	.align	4, 0x90
LBB3_14:                                ## %..lr.ph_crit_edge
                                        ##   in Loop: Header=BB3_11 Depth=1
	incl	%ebx
	movb	(%r15,%r12), %al
	incq	%r12
LBB3_11:                                ## %.lr.ph
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	%al, %ecx
	cmpl	$32, %ecx
	jne	LBB3_13
## BB#12:                               ##   in Loop: Header=BB3_11 Depth=1
	movslq	%ebx, %rbx
	movb	$92, (%r14,%rbx)
	incl	%ebx
LBB3_13:                                ##   in Loop: Header=BB3_11 Depth=1
	movslq	%ebx, %rcx
	movb	%al, (%r14,%rcx)
	movq	%r15, %rdi
	callq	_strlen
	cmpq	%rax, %r12
	jb	LBB3_14
	jmp	LBB3_8
LBB3_7:                                 ## %._crit_edge.thread
	movl	$1, %edi
	callq	_calloc
	movq	%rax, %r14
	movq	$-1, %rdx
	movq	%r14, %rdi
	movq	%r15, %rsi
	callq	___strcat_chk
LBB3_8:                                 ## %.loopexit
	movq	%r14, %rax
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_generateNumber
	.align	4, 0x90
_generateNumber:                        ## @generateNumber
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp17:
	.cfi_def_cfa_offset 16
Ltmp18:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp19:
	.cfi_def_cfa_register %rbp
	movslq	_seedIndex(%rip), %rax
	leaq	_seed(%rip), %rcx
	movq	(%rcx,%rax,8), %rdx
	leal	1(%rax), %eax
	andl	$15, %eax
	movl	%eax, _seedIndex(%rip)
	movq	(%rcx,%rax,8), %rsi
	movq	%rsi, %rdi
	shlq	$31, %rdi
	xorq	%rsi, %rdi
	movq	%rdx, %rsi
	shrq	$30, %rsi
	xorq	%rdx, %rsi
	xorq	%rdi, %rsi
	shrq	$11, %rdi
	xorq	%rsi, %rdi
	movq	%rdi, (%rcx,%rax,8)
	movabsq	$1181783497276652981, %rax ## imm = 0x106689D45497FDB5
	imulq	%rdi, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_FIPS202_SHAKE128
	.align	4, 0x90
_FIPS202_SHAKE128:                      ## @FIPS202_SHAKE128
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp20:
	.cfi_def_cfa_offset 16
Ltmp21:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp22:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdx, %rax
	movq	%rdi, %rdx
	movq	%rcx, (%rsp)
	movl	$1344, %edi             ## imm = 0x540
	movl	$31, %r8d
	movq	%rsi, %rcx
	movq	%rax, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_Keccak
	.align	4, 0x90
_Keccak:                                ## @Keccak
	.cfi_startproc
## BB#0:                                ## %.preheader
	pushq	%rbp
Ltmp23:
	.cfi_def_cfa_offset 16
Ltmp24:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp25:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$248, %rsp
Ltmp26:
	.cfi_offset %rbx, -56
Ltmp27:
	.cfi_offset %r12, -48
Ltmp28:
	.cfi_offset %r13, -40
Ltmp29:
	.cfi_offset %r14, -32
Ltmp30:
	.cfi_offset %r15, -24
	movq	%r9, %r13
	movq	%rcx, %r12
	movq	%rdx, %r14
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	xorps	%xmm0, %xmm0
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm0, -144(%rbp)
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -256(%rbp)
	movq	$0, -64(%rbp)
	shrl	$3, %edi
	movq	%rdi, -264(%rbp)        ## 8-byte Spill
	xorl	%ecx, %ecx
	testq	%r12, %r12
	movl	$0, %r10d
	je	LBB6_15
## BB#1:                                ## %.lr.ph18
	movl	%r8d, -276(%rbp)        ## 4-byte Spill
	movl	%edi, %r15d
	movq	%rdi, %rax
	notq	%rax
	movq	%rax, -272(%rbp)        ## 8-byte Spill
	.align	4, 0x90
LBB6_2:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB6_8 Depth 2
                                        ##     Child Loop BB6_10 Depth 2
	cmpq	%r15, %r12
	movq	%r15, %rcx
	cmovbq	%r12, %rcx
	movl	%r15d, %r10d
	cmovbl	%r12d, %r10d
	testl	%r10d, %r10d
	je	LBB6_11
## BB#3:                                ## %.lr.ph14.preheader
                                        ##   in Loop: Header=BB6_2 Depth=1
	movl	%ecx, %edx
	cmpq	%r12, %rdi
	movq	%rdi, %r9
	cmovaq	%r12, %r9
	cmpq	$16, %r9
	movl	$0, %eax
	jb	LBB6_10
## BB#4:                                ## %min.iters.checked
                                        ##   in Loop: Header=BB6_2 Depth=1
	movq	%r9, %r8
	andq	$-16, %r8
	movl	$0, %eax
	je	LBB6_10
## BB#5:                                ## %vector.memcheck
                                        ##   in Loop: Header=BB6_2 Depth=1
	cmpq	%r12, %rdi
	movq	%rdi, %rsi
	cmovaq	%r12, %rsi
	leaq	-1(%r14,%rsi), %rax
	leaq	-256(%rbp), %rbx
	cmpq	%rax, %rbx
	ja	LBB6_7
## BB#6:                                ## %vector.memcheck
                                        ##   in Loop: Header=BB6_2 Depth=1
	leaq	-258(%rbp), %rax
	leaq	1(%rax,%rsi), %rsi
	cmpq	%rsi, %r14
	movl	$0, %eax
	jbe	LBB6_10
LBB6_7:                                 ## %vector.body.preheader
                                        ##   in Loop: Header=BB6_2 Depth=1
	movq	%r12, %rax
	notq	%rax
	movq	-272(%rbp), %rsi        ## 8-byte Reload
	cmpq	%rsi, %rax
	cmovbeq	%rsi, %rax
	notq	%rax
	andq	$-16, %rax
	leaq	-256(%rbp), %rsi
	movq	%r14, %rbx
	.align	4, 0x90
LBB6_8:                                 ## %vector.body
                                        ##   Parent Loop BB6_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movups	(%rbx), %xmm0
	xorps	(%rsi), %xmm0
	movaps	%xmm0, (%rsi)
	addq	$16, %rbx
	addq	$16, %rsi
	addq	$-16, %rax
	jne	LBB6_8
## BB#9:                                ## %middle.block
                                        ##   in Loop: Header=BB6_2 Depth=1
	cmpq	%r8, %r9
	movq	%r8, %rax
	je	LBB6_11
	.align	4, 0x90
LBB6_10:                                ## %.lr.ph14
                                        ##   Parent Loop BB6_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movb	(%r14,%rax), %bl
	xorb	%bl, -256(%rbp,%rax)
	incq	%rax
	cmpq	%rdx, %rax
	jb	LBB6_10
LBB6_11:                                ## %._crit_edge.15
                                        ##   in Loop: Header=BB6_2 Depth=1
	movl	%ecx, %ebx
	cmpl	%edi, %r10d
	jne	LBB6_13
## BB#12:                               ##   in Loop: Header=BB6_2 Depth=1
	leaq	-256(%rbp), %rdi
	callq	_KeccakF1600
	movq	-264(%rbp), %rdi        ## 8-byte Reload
	xorl	%r10d, %r10d
LBB6_13:                                ## %.backedge5
                                        ##   in Loop: Header=BB6_2 Depth=1
	addq	%rbx, %r14
	subq	%rbx, %r12
	jne	LBB6_2
## BB#14:                               ## %._crit_edge.19.loopexit
	movl	%r10d, %ecx
	movb	-256(%rbp,%rcx), %cl
	movl	-276(%rbp), %r8d        ## 4-byte Reload
LBB6_15:                                ## %._crit_edge.19
	movq	16(%rbp), %r14
	movl	%r10d, %edx
	xorb	%r8b, %cl
	movb	%cl, -256(%rbp,%rdx)
	leal	-1(%rdi), %ebx
	movq	%rdi, %r12
	testb	%r8b, %r8b
	jns	LBB6_18
## BB#16:                               ## %._crit_edge.19
	cmpl	%ebx, %r10d
	jne	LBB6_18
## BB#17:
	leaq	-256(%rbp), %rdi
	callq	_KeccakF1600
LBB6_18:
	movl	%ebx, %eax
	xorb	$-128, -256(%rbp,%rax)
	leaq	-256(%rbp), %r15
	movq	%r15, %rdi
	callq	_KeccakF1600
	testq	%r14, %r14
	movq	%r12, %r10
	je	LBB6_31
## BB#19:                               ## %.lr.ph10
	movl	%r10d, %r12d
	movq	%r10, %rax
	notq	%rax
	movq	%rax, -272(%rbp)        ## 8-byte Spill
	jmp	LBB6_20
	.align	4, 0x90
LBB6_30:                                ## %.backedge.thread27
                                        ##   in Loop: Header=BB6_20 Depth=1
	addq	%rax, %r13
	movq	%r15, %rdi
	movq	%r10, %rbx
	callq	_KeccakF1600
	movq	%rbx, %r10
LBB6_20:                                ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB6_26 Depth 2
                                        ##     Child Loop BB6_28 Depth 2
	cmpq	%r12, %r14
	movq	%r12, %rax
	cmovbq	%r14, %rax
	movl	%r12d, %ecx
	cmovbl	%r14d, %ecx
	testl	%ecx, %ecx
	je	LBB6_29
## BB#21:                               ## %.lr.ph.preheader
                                        ##   in Loop: Header=BB6_20 Depth=1
	movl	%eax, %ecx
	cmpq	%r14, %r10
	movq	%r10, %r9
	cmovaq	%r14, %r9
	cmpq	$16, %r9
	movl	$0, %edi
	jb	LBB6_28
## BB#22:                               ## %min.iters.checked41
                                        ##   in Loop: Header=BB6_20 Depth=1
	movq	%r9, %r8
	andq	$-16, %r8
	movl	$0, %edi
	je	LBB6_28
## BB#23:                               ## %vector.memcheck55
                                        ##   in Loop: Header=BB6_20 Depth=1
	cmpq	%r14, %r10
	movq	%r10, %rdx
	cmovaq	%r14, %rdx
	leaq	-258(%rbp), %rsi
	leaq	1(%rsi,%rdx), %rsi
	cmpq	%rsi, %r13
	ja	LBB6_25
## BB#24:                               ## %vector.memcheck55
                                        ##   in Loop: Header=BB6_20 Depth=1
	leaq	-1(%r13,%rdx), %rdx
	cmpq	%rdx, %r15
	movl	$0, %edi
	jbe	LBB6_28
LBB6_25:                                ## %vector.body36.preheader
                                        ##   in Loop: Header=BB6_20 Depth=1
	movq	%r14, %rdi
	notq	%rdi
	movq	-272(%rbp), %rdx        ## 8-byte Reload
	cmpq	%rdx, %rdi
	cmovbeq	%rdx, %rdi
	notq	%rdi
	andq	$-16, %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	.align	4, 0x90
LBB6_26:                                ## %vector.body36
                                        ##   Parent Loop BB6_20 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movaps	(%rdx), %xmm0
	movups	%xmm0, (%rsi)
	addq	$16, %rdx
	addq	$16, %rsi
	addq	$-16, %rdi
	jne	LBB6_26
## BB#27:                               ## %middle.block37
                                        ##   in Loop: Header=BB6_20 Depth=1
	cmpq	%r8, %r9
	movq	%r8, %rdi
	je	LBB6_29
	.align	4, 0x90
LBB6_28:                                ## %.lr.ph
                                        ##   Parent Loop BB6_20 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movb	-256(%rbp,%rdi), %dl
	movb	%dl, (%r13,%rdi)
	incq	%rdi
	cmpq	%rcx, %rdi
	jb	LBB6_28
LBB6_29:                                ## %._crit_edge
                                        ##   in Loop: Header=BB6_20 Depth=1
	movl	%eax, %eax
	subq	%rax, %r14
	jne	LBB6_30
LBB6_31:                                ## %._crit_edge.11
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-48(%rbp), %rax
	jne	LBB6_33
## BB#32:                               ## %._crit_edge.11
	addq	$248, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB6_33:                                ## %._crit_edge.11
	callq	___stack_chk_fail
	.cfi_endproc

	.globl	_FIPS202_SHAKE256
	.align	4, 0x90
_FIPS202_SHAKE256:                      ## @FIPS202_SHAKE256
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp31:
	.cfi_def_cfa_offset 16
Ltmp32:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp33:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdx, %rax
	movq	%rdi, %rdx
	movq	%rcx, (%rsp)
	movl	$1088, %edi             ## imm = 0x440
	movl	$31, %r8d
	movq	%rsi, %rcx
	movq	%rax, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_FIPS202_SHA3_224
	.align	4, 0x90
_FIPS202_SHA3_224:                      ## @FIPS202_SHA3_224
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp34:
	.cfi_def_cfa_offset 16
Ltmp35:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp36:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdx, %rax
	movq	%rdi, %rcx
	movq	$28, (%rsp)
	movl	$1152, %edi             ## imm = 0x480
	movl	$6, %r8d
	movq	%rcx, %rdx
	movq	%rsi, %rcx
	movq	%rax, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_FIPS202_SHA3_256
	.align	4, 0x90
_FIPS202_SHA3_256:                      ## @FIPS202_SHA3_256
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp37:
	.cfi_def_cfa_offset 16
Ltmp38:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp39:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdx, %rax
	movq	%rdi, %rcx
	movq	$32, (%rsp)
	movl	$1088, %edi             ## imm = 0x440
	movl	$6, %r8d
	movq	%rcx, %rdx
	movq	%rsi, %rcx
	movq	%rax, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_FIPS202_SHA3_384
	.align	4, 0x90
_FIPS202_SHA3_384:                      ## @FIPS202_SHA3_384
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp40:
	.cfi_def_cfa_offset 16
Ltmp41:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp42:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdx, %rax
	movq	%rdi, %rcx
	movq	$48, (%rsp)
	movl	$832, %edi              ## imm = 0x340
	movl	$6, %r8d
	movq	%rcx, %rdx
	movq	%rsi, %rcx
	movq	%rax, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_FIPS202_SHA3_512
	.align	4, 0x90
_FIPS202_SHA3_512:                      ## @FIPS202_SHA3_512
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp43:
	.cfi_def_cfa_offset 16
Ltmp44:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp45:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdx, %rax
	movq	%rdi, %rcx
	movq	$64, (%rsp)
	movl	$576, %edi              ## imm = 0x240
	movl	$6, %r8d
	movq	%rcx, %rdx
	movq	%rsi, %rcx
	movq	%rax, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_LFSR86540
	.align	4, 0x90
_LFSR86540:                             ## @LFSR86540
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp46:
	.cfi_def_cfa_offset 16
Ltmp47:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp48:
	.cfi_def_cfa_register %rbp
	movzbl	(%rdi), %eax
	movb	%al, %cl
	addb	%cl, %cl
	movb	%al, %dl
	sarb	$7, %dl
	andb	$113, %dl
	xorb	%cl, %dl
	movb	%dl, (%rdi)
	andl	$1, %eax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_KeccakF1600
	.align	4, 0x90
_KeccakF1600:                           ## @KeccakF1600
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp49:
	.cfi_def_cfa_offset 16
Ltmp50:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp51:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$104, %rsp
Ltmp52:
	.cfi_offset %rbx, -56
Ltmp53:
	.cfi_offset %r12, -48
Ltmp54:
	.cfi_offset %r13, -40
Ltmp55:
	.cfi_offset %r14, -32
Ltmp56:
	.cfi_offset %r15, -24
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	leaq	7(%rdi), %rax
	movq	%rax, -104(%rbp)        ## 8-byte Spill
	leaq	47(%rdi), %rax
	movq	%rax, -120(%rbp)        ## 8-byte Spill
	leaq	87(%rdi), %rax
	movq	%rax, -128(%rbp)        ## 8-byte Spill
	leaq	127(%rdi), %rax
	movq	%rax, -136(%rbp)        ## 8-byte Spill
	leaq	167(%rdi), %rax
	movq	%rax, -144(%rbp)        ## 8-byte Spill
	movb	$1, %r9b
	xorl	%eax, %eax
	.align	4, 0x90
LBB13_1:                                ## %.preheader56
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB13_2 Depth 2
                                        ##       Child Loop BB13_3 Depth 3
                                        ##       Child Loop BB13_5 Depth 3
                                        ##       Child Loop BB13_7 Depth 3
                                        ##       Child Loop BB13_9 Depth 3
                                        ##       Child Loop BB13_11 Depth 3
                                        ##     Child Loop BB13_15 Depth 2
                                        ##       Child Loop BB13_16 Depth 3
                                        ##         Child Loop BB13_17 Depth 4
                                        ##     Child Loop BB13_19 Depth 2
                                        ##     Child Loop BB13_21 Depth 2
                                        ##       Child Loop BB13_22 Depth 3
                                        ##       Child Loop BB13_24 Depth 3
                                        ##     Child Loop BB13_27 Depth 2
                                        ##       Child Loop BB13_28 Depth 3
                                        ##         Child Loop BB13_29 Depth 4
                                        ##       Child Loop BB13_33 Depth 3
                                        ##         Child Loop BB13_34 Depth 4
                                        ##     Child Loop BB13_37 Depth 2
                                        ##       Child Loop BB13_39 Depth 3
	movl	%eax, -112(%rbp)        ## 4-byte Spill
	movb	%r9b, -105(%rbp)        ## 1-byte Spill
	movq	-144(%rbp), %r15        ## 8-byte Reload
	movq	-136(%rbp), %r11        ## 8-byte Reload
	movq	-128(%rbp), %r12        ## 8-byte Reload
	movq	-120(%rbp), %r8         ## 8-byte Reload
	movq	-104(%rbp), %r9         ## 8-byte Reload
	xorl	%r10d, %r10d
	.align	4, 0x90
LBB13_2:                                ##   Parent Loop BB13_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB13_3 Depth 3
                                        ##       Child Loop BB13_5 Depth 3
                                        ##       Child Loop BB13_7 Depth 3
                                        ##       Child Loop BB13_9 Depth 3
                                        ##       Child Loop BB13_11 Depth 3
	movq	%r9, %rax
	movl	$8, %esi
	xorl	%ebx, %ebx
	.align	4, 0x90
LBB13_3:                                ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_2 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	%rbx, %rcx
	shlq	$8, %rcx
	movzbl	(%rax), %ebx
	orq	%rcx, %rbx
	decq	%rax
	decq	%rsi
	jne	LBB13_3
## BB#4:                                ##   in Loop: Header=BB13_2 Depth=2
	movq	%r8, %rax
	movl	$8, %r13d
	xorl	%r14d, %r14d
	.align	4, 0x90
LBB13_5:                                ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_2 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	%r14, %rcx
	shlq	$8, %rcx
	movzbl	(%rax), %r14d
	orq	%rcx, %r14
	decq	%rax
	decq	%r13
	jne	LBB13_5
## BB#6:                                ##   in Loop: Header=BB13_2 Depth=2
	movq	%r12, %rdx
	movl	$8, %ecx
	xorl	%eax, %eax
	.align	4, 0x90
LBB13_7:                                ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_2 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	%rax, %rsi
	shlq	$8, %rsi
	movzbl	(%rdx), %eax
	orq	%rsi, %rax
	decq	%rdx
	decq	%rcx
	jne	LBB13_7
## BB#8:                                ## %load64.exit47
                                        ##   in Loop: Header=BB13_2 Depth=2
	xorq	%rbx, %r14
	movq	%r11, %rdx
	movl	$8, %ecx
	xorl	%ebx, %ebx
	.align	4, 0x90
LBB13_9:                                ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_2 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	%rbx, %rsi
	shlq	$8, %rsi
	movzbl	(%rdx), %ebx
	orq	%rsi, %rbx
	decq	%rdx
	decq	%rcx
	jne	LBB13_9
## BB#10:                               ## %load64.exit42
                                        ##   in Loop: Header=BB13_2 Depth=2
	xorq	%rax, %r14
	movq	%r15, %rdx
	movl	$8, %ecx
	xorl	%eax, %eax
	.align	4, 0x90
LBB13_11:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_2 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	%rax, %rsi
	shlq	$8, %rsi
	movzbl	(%rdx), %eax
	orq	%rsi, %rax
	decq	%rdx
	decq	%rcx
	jne	LBB13_11
## BB#12:                               ## %load64.exit37
                                        ##   in Loop: Header=BB13_2 Depth=2
	xorq	%rbx, %r14
	xorq	%rax, %r14
	movq	%r14, -96(%rbp,%r10,8)
	incq	%r10
	addq	$8, %r9
	addq	$8, %r8
	addq	$8, %r12
	addq	$8, %r11
	addq	$8, %r15
	cmpq	$5, %r10
	jne	LBB13_2
## BB#13:                               ##   in Loop: Header=BB13_1 Depth=1
	movq	%rdi, %r9
	xorl	%r8d, %r8d
	xorl	%r15d, %r15d
	movl	$3435973837, %r12d      ## imm = 0xCCCCCCCD
	.align	4, 0x90
LBB13_15:                               ## %.preheader55
                                        ##   Parent Loop BB13_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB13_16 Depth 3
                                        ##         Child Loop BB13_17 Depth 4
	leaq	4(%r8), %rax
	movl	%eax, %ecx
	imulq	%r12, %rcx
	shrq	$34, %rcx
	leal	(%rcx,%rcx,4), %ecx
	subl	%ecx, %eax
	incq	%r8
	cmpq	$5, %r8
	movl	%r8d, %ecx
	cmoveq	%r15, %rcx
	movq	-96(%rbp,%rcx,8), %r10
	rolq	%r10
	xorq	-96(%rbp,%rax,8), %r10
	movq	%r9, %r11
	xorl	%r14d, %r14d
	.align	4, 0x90
LBB13_16:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_15 Depth=2
                                        ## =>    This Loop Header: Depth=3
                                        ##         Child Loop BB13_17 Depth 4
	movq	%r11, %rsi
	movl	$8, %eax
	movq	%r10, %rdx
	.align	4, 0x90
LBB13_17:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_15 Depth=2
                                        ##       Parent Loop BB13_16 Depth=3
                                        ## =>      This Inner Loop Header: Depth=4
	movzbl	(%rsi), %ecx
	movl	%edx, %ebx
	xorl	%ecx, %ebx
	movb	%bl, (%rsi)
	shrq	$8, %rdx
	incq	%rsi
	decq	%rax
	jne	LBB13_17
## BB#18:                               ## %xor64.exit32
                                        ##   in Loop: Header=BB13_16 Depth=3
	incq	%r14
	addq	$40, %r11
	cmpq	$5, %r14
	jne	LBB13_16
## BB#14:                               ## %.loopexit
                                        ##   in Loop: Header=BB13_15 Depth=2
	addq	$8, %r9
	cmpq	$5, %r8
	movl	$8, %eax
	movl	$0, %edx
	jne	LBB13_15
	.align	4, 0x90
LBB13_19:                               ## %.preheader79
                                        ##   Parent Loop BB13_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movq	%rdx, %rcx
	shlq	$8, %rcx
	movzbl	7(%rdi,%rax), %edx
	orq	%rcx, %rdx
	decq	%rax
	jne	LBB13_19
## BB#20:                               ##   in Loop: Header=BB13_1 Depth=1
	xorl	%r8d, %r8d
	movl	$1, %r9d
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	.align	4, 0x90
LBB13_21:                               ## %load64.exit27.preheader
                                        ##   Parent Loop BB13_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB13_22 Depth 3
                                        ##       Child Loop BB13_24 Depth 3
	movl	%r9d, %eax
	movl	%r11d, %r9d
	incl	%r10d
	leal	(%r9,%r9,2), %ecx
	leal	(%rcx,%rax,2), %r11d
	movl	$3435973837, %eax       ## imm = 0xCCCCCCCD
	imulq	%r11, %rax
	shrq	$34, %rax
	leal	(%rax,%rax,4), %eax
	subl	%eax, %r11d
	leal	(%r11,%r11,4), %eax
	leal	(,%r9,8), %r15d
	leal	(%r15,%rax,8), %eax
	addq	%rdi, %rax
	movl	$8, %ecx
	xorl	%ebx, %ebx
	.align	4, 0x90
LBB13_22:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_21 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	%rbx, %rsi
	shlq	$8, %rsi
	movzbl	-1(%rax,%rcx), %ebx
	orq	%rsi, %rbx
	decq	%rcx
	jne	LBB13_22
## BB#23:                               ## %load64.exit22
                                        ##   in Loop: Header=BB13_21 Depth=2
	addl	%r10d, %r8d
	movl	%r8d, %ecx
	andl	$63, %ecx
	movq	%rdx, %rsi
	shlq	%cl, %rsi
	movl	$64, %eax
	subl	%ecx, %eax
	movb	%al, %cl
	shrq	%cl, %rdx
	xorq	%rsi, %rdx
	leal	(%r11,%r11,4), %eax
	leal	(%r15,%rax,8), %eax
	addq	%rdi, %rax
	xorl	%ecx, %ecx
	.align	4, 0x90
LBB13_24:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_21 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movb	%dl, (%rax,%rcx)
	shrq	$8, %rdx
	incq	%rcx
	cmpq	$8, %rcx
	jne	LBB13_24
## BB#25:                               ## %store64.exit17
                                        ##   in Loop: Header=BB13_21 Depth=2
	cmpl	$24, %r10d
	movq	%rbx, %rdx
	jne	LBB13_21
## BB#26:                               ## %.preheader54
                                        ##   in Loop: Header=BB13_1 Depth=1
	movq	%rbx, -96(%rbp)
	movq	%rdi, %r8
	movq	-104(%rbp), %r10        ## 8-byte Reload
	xorl	%r9d, %r9d
	.align	4, 0x90
LBB13_27:                               ## %.preheader
                                        ##   Parent Loop BB13_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB13_28 Depth 3
                                        ##         Child Loop BB13_29 Depth 4
                                        ##       Child Loop BB13_33 Depth 3
                                        ##         Child Loop BB13_34 Depth 4
	movq	%r10, %r11
	xorl	%ecx, %ecx
	.align	4, 0x90
LBB13_28:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_27 Depth=2
                                        ## =>    This Loop Header: Depth=3
                                        ##         Child Loop BB13_29 Depth 4
	movq	%r11, %rsi
	movl	$8, %ebx
	xorl	%edx, %edx
	.align	4, 0x90
LBB13_29:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_27 Depth=2
                                        ##       Parent Loop BB13_28 Depth=3
                                        ## =>      This Inner Loop Header: Depth=4
	movq	%rdx, %rax
	shlq	$8, %rax
	movzbl	(%rsi), %edx
	orq	%rax, %rdx
	decq	%rsi
	decq	%rbx
	jne	LBB13_29
## BB#30:                               ## %load64.exit12
                                        ##   in Loop: Header=BB13_28 Depth=3
	movq	%rdx, -96(%rbp,%rcx,8)
	incq	%rcx
	addq	$8, %r11
	cmpq	$5, %rcx
	jne	LBB13_28
## BB#31:                               ##   in Loop: Header=BB13_27 Depth=2
	movq	%r8, %rdx
	xorl	%r11d, %r11d
	.align	4, 0x90
LBB13_33:                               ## %store64.exit.preheader
                                        ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_27 Depth=2
                                        ## =>    This Loop Header: Depth=3
                                        ##         Child Loop BB13_34 Depth 4
	movq	%r11, %rbx
	leaq	1(%rbx), %r11
	cmpq	$5, %r11
	movl	%r11d, %eax
	movl	$0, %ecx
	cmovneq	%rax, %rcx
	movq	-96(%rbp,%rcx,8), %rcx
	notq	%rcx
	leaq	2(%rbx), %rax
	movl	%eax, %r14d
	movl	$3435973837, %esi       ## imm = 0xCCCCCCCD
	imulq	%r14, %rsi
	shrq	$34, %rsi
	leal	(%rsi,%rsi,4), %esi
	subl	%esi, %eax
	andq	-96(%rbp,%rax,8), %rcx
	xorq	-96(%rbp,%rbx,8), %rcx
	movq	%rdx, %rax
	movl	$8, %ebx
	.align	4, 0x90
LBB13_34:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_27 Depth=2
                                        ##       Parent Loop BB13_33 Depth=3
                                        ## =>      This Inner Loop Header: Depth=4
	movb	%cl, (%rax)
	shrq	$8, %rcx
	incq	%rax
	decq	%rbx
	jne	LBB13_34
## BB#32:                               ## %store64.exit.loopexit
                                        ##   in Loop: Header=BB13_33 Depth=3
	addq	$8, %rdx
	cmpq	$5, %r11
	jne	LBB13_33
## BB#35:                               ##   in Loop: Header=BB13_27 Depth=2
	incq	%r9
	addq	$40, %r10
	addq	$40, %r8
	xorl	%eax, %eax
	cmpq	$5, %r9
	jne	LBB13_27
## BB#36:                               ##   in Loop: Header=BB13_1 Depth=1
	movb	-105(%rbp), %r9b        ## 1-byte Reload
	.align	4, 0x90
LBB13_37:                               ## %.preheader53
                                        ##   Parent Loop BB13_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB13_39 Depth 3
	movb	%r9b, %r8b
	addb	%r8b, %r8b
	sarb	$7, %r9b
	andb	$113, %r9b
	testb	$2, %r8b
	je	LBB13_40
## BB#38:                               ##   in Loop: Header=BB13_37 Depth=2
	movl	$1, %edx
	movb	%al, %cl
	shll	%cl, %edx
	decl	%edx
	movl	$1, %esi
	movb	%dl, %cl
	shlq	%cl, %rsi
	xorl	%ecx, %ecx
	.align	4, 0x90
LBB13_39:                               ##   Parent Loop BB13_1 Depth=1
                                        ##     Parent Loop BB13_37 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movzbl	(%rdi,%rcx), %edx
	movl	%esi, %ebx
	xorl	%edx, %ebx
	movb	%bl, (%rdi,%rcx)
	shrq	$8, %rsi
	incq	%rcx
	cmpq	$8, %rcx
	jne	LBB13_39
LBB13_40:                               ## %xor64.exit
                                        ##   in Loop: Header=BB13_37 Depth=2
	xorb	%r8b, %r9b
	incl	%eax
	cmpl	$7, %eax
	jne	LBB13_37
## BB#41:                               ##   in Loop: Header=BB13_1 Depth=1
	movl	-112(%rbp), %eax        ## 4-byte Reload
	incl	%eax
	cmpl	$24, %eax
	jne	LBB13_1
## BB#42:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-48(%rbp), %rax
	jne	LBB13_44
## BB#43:
	addq	$104, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB13_44:
	callq	___stack_chk_fail
	.cfi_endproc

	.globl	_getHash
	.align	4, 0x90
_getHash:                               ## @getHash
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp57:
	.cfi_def_cfa_offset 16
Ltmp58:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp59:
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	subq	$16, %rsp
Ltmp60:
	.cfi_offset %rbx, -32
Ltmp61:
	.cfi_offset %r14, -24
	movq	%rsi, %rbx
	movq	%rdi, %r14
	movq	%rbx, %rdi
	callq	_strlen
	movq	$128, (%rsp)
	movl	$1088, %edi             ## imm = 0x440
	movl	$31, %r8d
	movq	%rbx, %rdx
	movq	%rax, %rcx
	movq	%r14, %r9
	callq	_Keccak
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_getSeed
	.align	4, 0x90
_getSeed:                               ## @getSeed
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp62:
	.cfi_def_cfa_offset 16
Ltmp63:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp64:
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	subq	$160, %rsp
Ltmp65:
	.cfi_offset %rbx, -32
Ltmp66:
	.cfi_offset %r14, -24
	movq	%rdi, %rbx
	movq	___stack_chk_guard@GOTPCREL(%rip), %r14
	movq	(%r14), %r14
	movq	%r14, -24(%rbp)
	callq	_strlen
	movq	$128, (%rsp)
	leaq	-160(%rbp), %r9
	movl	$1088, %edi             ## imm = 0x440
	movl	$31, %r8d
	movq	%rbx, %rdx
	movq	%rax, %rcx
	callq	_Keccak
	xorl	%eax, %eax
	leaq	_seed(%rip), %rcx
	.align	4, 0x90
LBB15_1:                                ## =>This Inner Loop Header: Depth=1
	movq	-160(%rbp,%rax), %rdx
	movq	%rdx, (%rax,%rcx)
	addq	$8, %rax
	cmpq	$128, %rax
	jne	LBB15_1
## BB#2:
	cmpq	-24(%rbp), %r14
	jne	LBB15_4
## BB#3:
	addq	$160, %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
LBB15_4:
	callq	___stack_chk_fail
	.cfi_endproc

	.globl	_getNext255StringFromKeyFile
	.align	4, 0x90
_getNext255StringFromKeyFile:           ## @getNext255StringFromKeyFile
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp67:
	.cfi_def_cfa_offset 16
Ltmp68:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp69:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
Ltmp70:
	.cfi_offset %rbx, -56
Ltmp71:
	.cfi_offset %r12, -48
Ltmp72:
	.cfi_offset %r13, -40
Ltmp73:
	.cfi_offset %r14, -32
Ltmp74:
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %rbx
	xorl	%r13d, %r13d
	.align	4, 0x90
LBB16_1:                                ## %.lr.ph.split.us.preheader
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB16_3 Depth 2
	leaq	(%r14,%r13), %r15
	movl	$255, %r12d
	subq	%r13, %r12
	jmp	LBB16_3
	.align	4, 0x90
LBB16_2:                                ## %.lr.ph.split.us
                                        ##   in Loop: Header=BB16_3 Depth=2
	movq	%rbx, %rdi
	callq	_rewind
LBB16_3:                                ## %.lr.ph.split.us
                                        ##   Parent Loop BB16_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$1, %esi
	movq	%r15, %rdi
	movq	%r12, %rdx
	movq	%rbx, %rcx
	callq	_fread
	testq	%rax, %rax
	je	LBB16_2
## BB#4:                                ## %.outer
                                        ##   in Loop: Header=BB16_1 Depth=1
	addq	%rax, %r13
	cmpq	$255, %r13
	jl	LBB16_1
## BB#5:                                ## %.outer._crit_edge
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__literal16,16byte_literals
	.align	4
LCPI17_0:
	.byte	0                       ## 0x0
	.byte	1                       ## 0x1
	.byte	2                       ## 0x2
	.byte	3                       ## 0x3
	.byte	4                       ## 0x4
	.byte	5                       ## 0x5
	.byte	6                       ## 0x6
	.byte	7                       ## 0x7
	.byte	8                       ## 0x8
	.byte	9                       ## 0x9
	.byte	10                      ## 0xa
	.byte	11                      ## 0xb
	.byte	12                      ## 0xc
	.byte	13                      ## 0xd
	.byte	14                      ## 0xe
	.byte	15                      ## 0xf
	.section	__TEXT,__literal8,8byte_literals
	.align	3
LCPI17_1:
	.quad	4643176031446892544     ## double 255
LCPI17_2:
	.quad	4571171282956062736     ## double 0.0039215686274509803
	.section	__TEXT,__literal4,4byte_literals
	.align	2
LCPI17_3:
	.long	998277249               ## float 0.00392156886
LCPI17_4:
	.long	0                       ## float 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_scramble
	.align	4, 0x90
_scramble:                              ## @scramble
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp75:
	.cfi_def_cfa_offset 16
Ltmp76:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp77:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$16472, %rsp            ## imm = 0x4058
Ltmp78:
	.cfi_offset %rbx, -56
Ltmp79:
	.cfi_offset %r12, -48
Ltmp80:
	.cfi_offset %r13, -40
Ltmp81:
	.cfi_offset %r14, -32
Ltmp82:
	.cfi_offset %r15, -24
	movq	%rdi, %r12
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	leaq	L_.str(%rip), %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
	leaq	_scrambleAsciiTables(%rip), %r14
	movabsq	$1181783497276652981, %r13 ## imm = 0x106689D45497FDB5
	movq	%r14, %r15
	xorl	%eax, %eax
	.align	4, 0x90
LBB17_1:                                ## %min.iters.checked
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB17_2 Depth 2
                                        ##     Child Loop BB17_5 Depth 2
                                        ##     Child Loop BB17_11 Depth 2
                                        ##       Child Loop BB17_12 Depth 3
                                        ##         Child Loop BB17_14 Depth 4
                                        ##       Child Loop BB17_17 Depth 3
	movq	%rax, -16456(%rbp)      ## 8-byte Spill
	leaq	1(%rax), %rsi
	movq	%rsi, -16472(%rbp)      ## 8-byte Spill
	xorl	%eax, %eax
	leaq	L_.str.1(%rip), %rdi
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
	movq	%r15, %rax
	xorl	%ecx, %ecx
	pxor	%xmm1, %xmm1
	movdqa	LCPI17_0(%rip), %xmm2   ## xmm2 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
	.align	4, 0x90
LBB17_2:                                ## %vector.body
                                        ##   Parent Loop BB17_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movd	%ecx, %xmm0
	pshufb	%xmm1, %xmm0
	paddb	%xmm2, %xmm0
	movdqa	%xmm0, (%rax)
	addq	$16, %rcx
	addq	$16, %rax
	cmpq	$256, %rcx              ## imm = 0x100
	jne	LBB17_2
## BB#3:                                ## %middle.block
                                        ##   in Loop: Header=BB17_1 Depth=1
	movb	_usingKeyFile(%rip), %al
	andb	$1, %al
	leaq	_seed(%rip), %r10
	movsd	LCPI17_1(%rip), %xmm3   ## xmm3 = mem[0],zero
	movsd	LCPI17_2(%rip), %xmm4   ## xmm4 = mem[0],zero
	je	LBB17_4
## BB#10:                               ##   in Loop: Header=BB17_1 Depth=1
	xorps	%xmm0, %xmm0
	cvtsi2ssl	_keyFileSize(%rip), %xmm0
	mulss	LCPI17_3(%rip), %xmm0
	cvttss2si	%xmm0, %rax
	cvtsi2ssq	%rax, %xmm1
	subss	%xmm1, %xmm0
	ucomiss	LCPI17_4(%rip), %xmm0
	seta	%cl
	movzbl	%cl, %ecx
	addq	%rax, %rcx
	movb	_normalised(%rip), %al
	andb	$1, %al
	movl	$1, %eax
	cmovneq	%rax, %rcx
	movq	%rcx, -16464(%rbp)      ## 8-byte Spill
	testq	%rcx, %rcx
	movl	$0, %eax
	jle	LBB17_7
	.align	4, 0x90
LBB17_11:                               ## %.lr.ph29
                                        ##   Parent Loop BB17_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB17_12 Depth 3
                                        ##         Child Loop BB17_14 Depth 4
                                        ##       Child Loop BB17_17 Depth 3
	movq	%rax, -16448(%rbp)      ## 8-byte Spill
	xorl	%r14d, %r14d
	.align	4, 0x90
LBB17_12:                               ## %.lr.ph.split.us.preheader.i
                                        ##   Parent Loop BB17_1 Depth=1
                                        ##     Parent Loop BB17_11 Depth=2
                                        ## =>    This Loop Header: Depth=3
                                        ##         Child Loop BB17_14 Depth 4
	leaq	-16432(%rbp,%r14), %r13
	movl	$255, %ebx
	subq	%r14, %rbx
	jmp	LBB17_14
	.align	4, 0x90
LBB17_13:                               ## %.lr.ph.split.us.i
                                        ##   in Loop: Header=BB17_14 Depth=4
	movq	%r12, %rdi
	callq	_rewind
LBB17_14:                               ## %.lr.ph.split.us.i
                                        ##   Parent Loop BB17_1 Depth=1
                                        ##     Parent Loop BB17_11 Depth=2
                                        ##       Parent Loop BB17_12 Depth=3
                                        ## =>      This Inner Loop Header: Depth=4
	movl	$1, %esi
	movq	%r13, %rdi
	movq	%rbx, %rdx
	movq	%r12, %rcx
	callq	_fread
	testq	%rax, %rax
	je	LBB17_13
## BB#15:                               ## %.outer.i
                                        ##   in Loop: Header=BB17_12 Depth=3
	addq	%rax, %r14
	cmpq	$255, %r14
	jl	LBB17_12
## BB#16:                               ## %getNext255StringFromKeyFile.exit.preheader
                                        ##   in Loop: Header=BB17_11 Depth=2
	movl	_seedIndex(%rip), %eax
	xorl	%ecx, %ecx
	leaq	_scrambleAsciiTables(%rip), %r14
	movabsq	$1181783497276652981, %r13 ## imm = 0x106689D45497FDB5
	leaq	_seed(%rip), %r8
	movsd	LCPI17_1(%rip), %xmm3   ## xmm3 = mem[0],zero
	movsd	LCPI17_2(%rip), %xmm4   ## xmm4 = mem[0],zero
	movq	-16456(%rbp), %r9       ## 8-byte Reload
	.align	4, 0x90
LBB17_17:                               ## %getNext255StringFromKeyFile.exit
                                        ##   Parent Loop BB17_1 Depth=1
                                        ##     Parent Loop BB17_11 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	cltq
	movq	(%r8,%rax,8), %rdx
	incl	%eax
	andl	$15, %eax
	movq	(%r8,%rax,8), %rsi
	movq	%rsi, %rdi
	shlq	$31, %rdi
	xorq	%rsi, %rdi
	movq	%rdx, %rsi
	shrq	$30, %rsi
	xorq	%rdx, %rsi
	xorq	%rdi, %rsi
	shrq	$11, %rdi
	xorq	%rsi, %rdi
	movq	%rdi, (%r8,%rax,8)
	movl	%r13d, %edx
	imull	%edi, %edx
	movsbl	%dl, %edx
	movsbl	-16432(%rbp,%rcx), %esi
	xorl	%edx, %esi
	cvtsi2ssl	%esi, %xmm0
	cvtss2sd	%xmm0, %xmm0
	cvtsi2sdl	%ecx, %xmm1
	movapd	%xmm3, %xmm2
	subsd	%xmm1, %xmm2
	mulsd	%xmm4, %xmm2
	mulsd	%xmm0, %xmm2
	addsd	%xmm1, %xmm2
	cvttsd2si	%xmm2, %edx
	movb	(%r15,%rcx), %dil
	movzbl	%dl, %edx
	movq	%r9, %rsi
	shlq	$8, %rsi
	addq	%r14, %rsi
	movb	(%rdx,%rsi), %bl
	movb	%bl, (%r15,%rcx)
	movb	%dil, (%rdx,%rsi)
	incq	%rcx
	cmpq	$255, %rcx
	jne	LBB17_17
## BB#18:                               ##   in Loop: Header=BB17_11 Depth=2
	movl	%eax, _seedIndex(%rip)
	movq	-16448(%rbp), %rax      ## 8-byte Reload
	incq	%rax
	cmpq	-16464(%rbp), %rax      ## 8-byte Folded Reload
	jne	LBB17_11
	jmp	LBB17_7
	.align	4, 0x90
LBB17_4:                                ## %.preheader13
                                        ##   in Loop: Header=BB17_1 Depth=1
	movslq	_passPhraseSize(%rip), %rax
	movq	%rax, -16448(%rbp)      ## 8-byte Spill
	movl	_seedIndex(%rip), %ecx
	movq	_passIndex(%rip), %rax
	xorl	%edi, %edi
	leaq	_passPhrase(%rip), %r11
	movq	-16456(%rbp), %r8       ## 8-byte Reload
	.align	4, 0x90
LBB17_5:                                ##   Parent Loop BB17_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movslq	%ecx, %rcx
	movq	(%r10,%rcx,8), %rdx
	incl	%ecx
	andl	$15, %ecx
	movq	(%r10,%rcx,8), %rsi
	movq	%rsi, %rbx
	shlq	$31, %rbx
	xorq	%rsi, %rbx
	movq	%rdx, %rsi
	shrq	$30, %rsi
	xorq	%rdx, %rsi
	xorq	%rbx, %rsi
	shrq	$11, %rbx
	xorq	%rsi, %rbx
	movq	%rbx, (%r10,%rcx,8)
	movl	%r13d, %edx
	imull	%ebx, %edx
	movsbl	%dl, %edx
	movsbl	(%rax,%r11), %esi
	xorl	%edx, %esi
	cvtsi2ssl	%esi, %xmm0
	cvtss2sd	%xmm0, %xmm0
	cvtsi2sdl	%edi, %xmm1
	movapd	%xmm3, %xmm2
	subsd	%xmm1, %xmm2
	mulsd	%xmm4, %xmm2
	mulsd	%xmm0, %xmm2
	addsd	%xmm1, %xmm2
	cvttsd2si	%xmm2, %esi
	incq	%rax
	xorl	%edx, %edx
	divq	-16448(%rbp)            ## 8-byte Folded Reload
	movb	(%r15,%rdi), %r9b
	movzbl	%sil, %esi
	movq	%r8, %rbx
	shlq	$8, %rbx
	addq	%r14, %rbx
	movb	(%rsi,%rbx), %al
	movb	%al, (%r15,%rdi)
	movb	%r9b, (%rsi,%rbx)
	incq	%rdi
	cmpq	$255, %rdi
	movq	%rdx, %rax
	jne	LBB17_5
## BB#6:                                ## %.loopexit14
                                        ##   in Loop: Header=BB17_1 Depth=1
	movl	%ecx, _seedIndex(%rip)
	movq	%rax, _passIndex(%rip)
LBB17_7:                                ## %.backedge
                                        ##   in Loop: Header=BB17_1 Depth=1
	addq	$256, %r15              ## imm = 0x100
	movq	-16472(%rbp), %rax      ## 8-byte Reload
	cmpq	$16, %rax
	jne	LBB17_1
## BB#8:
	movb	_usingKeyFile(%rip), %al
	andb	$1, %al
	je	LBB17_26
## BB#9:
	xorl	%ebx, %ebx
	leaq	-16432(%rbp), %r14
	leaq	_scramblingTablesOrder(%rip), %r15
	jmp	LBB17_21
	.align	4, 0x90
LBB17_20:                               ## %.lr.ph.split.us
                                        ##   in Loop: Header=BB17_21 Depth=1
	movq	%r12, %rdi
	callq	_rewind
LBB17_21:                               ## %.lr.ph.split.us
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB17_25 Depth 2
	movl	$1, %esi
	movl	$16384, %edx            ## imm = 0x4000
	movq	%r14, %rdi
	movq	%r12, %rcx
	callq	_fread
	testl	%eax, %eax
	je	LBB17_20
## BB#22:                               ## %.preheader
                                        ##   in Loop: Header=BB17_21 Depth=1
	testl	%eax, %eax
	jle	LBB17_19
## BB#23:                               ## %.lr.ph18.preheader
                                        ##   in Loop: Header=BB17_21 Depth=1
	cltq
	movslq	%ebx, %rbx
	xorl	%ecx, %ecx
	.align	4, 0x90
LBB17_25:                               ## %.lr.ph18
                                        ##   Parent Loop BB17_21 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movb	-16432(%rbp,%rcx), %dl
	andb	$15, %dl
	movb	%dl, (%rbx,%r15)
	cmpl	$16383, %ebx            ## imm = 0x3FFF
	je	LBB17_26
## BB#24:                               ##   in Loop: Header=BB17_25 Depth=2
	incq	%rcx
	incq	%rbx
	cmpq	%rax, %rcx
	jl	LBB17_25
LBB17_19:                               ## %.loopexit
                                        ##   in Loop: Header=BB17_21 Depth=1
	cmpl	$16383, %ebx            ## imm = 0x3FFF
	jle	LBB17_21
LBB17_26:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-48(%rbp), %rax
	jne	LBB17_27
## BB#28:
	leaq	L_str(%rip), %rdi
	addq	$16472, %rsp            ## imm = 0x4058
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	jmp	_puts                   ## TAILCALL
LBB17_27:
	callq	___stack_chk_fail
	.cfi_endproc

	.globl	_unscramble
	.align	4, 0x90
_unscramble:                            ## @unscramble
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp83:
	.cfi_def_cfa_offset 16
Ltmp84:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp85:
	.cfi_def_cfa_register %rbp
	leaq	_scrambleAsciiTables(%rip), %r8
	xorl	%edx, %edx
	leaq	_unscrambleAsciiTables(%rip), %r9
	.align	4, 0x90
LBB18_1:                                ## %.preheader
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB18_2 Depth 2
	movq	%r8, %rsi
	xorl	%edi, %edi
	.align	4, 0x90
LBB18_2:                                ##   Parent Loop BB18_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%rsi), %eax
	movq	%rdx, %rcx
	shlq	$8, %rcx
	addq	%r9, %rcx
	movb	%dil, (%rax,%rcx)
	incq	%rdi
	incq	%rsi
	cmpq	$256, %rdi              ## imm = 0x100
	jne	LBB18_2
## BB#3:                                ##   in Loop: Header=BB18_1 Depth=1
	incq	%rdx
	addq	$256, %r8               ## imm = 0x100
	cmpq	$16, %rdx
	jne	LBB18_1
## BB#4:
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_codingXOR
	.align	4, 0x90
_codingXOR:                             ## @codingXOR
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp86:
	.cfi_def_cfa_offset 16
Ltmp87:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp88:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
Ltmp89:
	.cfi_offset %rbx, -24
	movb	_isCodingInverted(%rip), %r8b
	movzbl	_usingKeyFile(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	LBB19_8
## BB#1:
	testb	$1, %r8b
	je	LBB19_2
## BB#5:                                ## %.preheader
	testl	%ecx, %ecx
	jle	LBB19_15
## BB#6:                                ## %.lr.ph.preheader
	movl	%ecx, %r10d
	xorl	%ecx, %ecx
	leaq	_scramblingTablesOrder(%rip), %r8
	leaq	_scrambleAsciiTables(%rip), %r9
	.align	4, 0x90
LBB19_7:                                ## %.lr.ph
                                        ## =>This Inner Loop Header: Depth=1
	movb	(%rsi,%rcx), %r11b
	movb	(%rdi,%rcx), %al
	xorb	%r11b, %al
	movzbl	%al, %ebx
	xorb	(%rcx,%r8), %r11b
	movzbl	%r11b, %eax
	andl	$15, %eax
	shlq	$8, %rax
	addq	%r9, %rax
	movb	(%rbx,%rax), %al
	movb	%al, (%rdx,%rcx)
	incq	%rcx
	cmpl	%ecx, %r10d
	jne	LBB19_7
	jmp	LBB19_15
LBB19_8:
	testb	$1, %r8b
	je	LBB19_9
## BB#12:                               ## %.preheader4
	testl	%ecx, %ecx
	jle	LBB19_15
## BB#13:
	leaq	_scrambleAsciiTables(%rip), %r8
	.align	4, 0x90
LBB19_14:                               ## %.lr.ph12
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%rsi), %ebx
	movb	(%rdi), %al
	xorb	%bl, %al
	movzbl	%al, %eax
	andl	$15, %ebx
	shlq	$8, %rbx
	addq	%r8, %rbx
	movb	(%rax,%rbx), %al
	movb	%al, (%rdx)
	incq	%rdi
	incq	%rsi
	incq	%rdx
	decl	%ecx
	jne	LBB19_14
	jmp	LBB19_15
LBB19_2:                                ## %.preheader2
	testl	%ecx, %ecx
	jle	LBB19_15
## BB#3:                                ## %.lr.ph10.preheader
	movl	%ecx, %r10d
	xorl	%ecx, %ecx
	leaq	_scramblingTablesOrder(%rip), %r8
	leaq	_scrambleAsciiTables(%rip), %r9
	.align	4, 0x90
LBB19_4:                                ## %.lr.ph10
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%rdi,%rcx), %r11d
	movb	(%rsi,%rcx), %al
	movb	(%rcx,%r8), %bl
	xorb	%al, %bl
	movzbl	%bl, %ebx
	andl	$15, %ebx
	shlq	$8, %rbx
	addq	%r9, %rbx
	xorb	(%r11,%rbx), %al
	movb	%al, (%rdx,%rcx)
	incq	%rcx
	cmpl	%ecx, %r10d
	jne	LBB19_4
	jmp	LBB19_15
LBB19_9:                                ## %.preheader6
	testl	%ecx, %ecx
	jle	LBB19_15
## BB#10:
	leaq	_scrambleAsciiTables(%rip), %r8
	.align	4, 0x90
LBB19_11:                               ## %.lr.ph14
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%rdi), %r9d
	movzbl	(%rsi), %ebx
	movl	%ebx, %eax
	andl	$15, %eax
	shlq	$8, %rax
	addq	%r8, %rax
	movb	(%r9,%rax), %al
	xorb	%bl, %al
	movb	%al, (%rdx)
	incq	%rdi
	incq	%rsi
	incq	%rdx
	decl	%ecx
	jne	LBB19_11
LBB19_15:                               ## %.loopexit
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_decodingXOR
	.align	4, 0x90
_decodingXOR:                           ## @decodingXOR
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp90:
	.cfi_def_cfa_offset 16
Ltmp91:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp92:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
Ltmp93:
	.cfi_offset %rbx, -24
	movb	_isCodingInverted(%rip), %r8b
	movzbl	_usingKeyFile(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	LBB20_8
## BB#1:
	testb	$1, %r8b
	je	LBB20_2
## BB#5:                                ## %.preheader
	testl	%ecx, %ecx
	jle	LBB20_15
## BB#6:                                ## %.lr.ph.preheader
	movl	%ecx, %r10d
	xorl	%ecx, %ecx
	leaq	_scramblingTablesOrder(%rip), %r8
	leaq	_unscrambleAsciiTables(%rip), %r9
	.align	4, 0x90
LBB20_7:                                ## %.lr.ph
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%rdi,%rcx), %r11d
	movb	(%rsi,%rcx), %al
	movb	(%rcx,%r8), %bl
	xorb	%al, %bl
	movzbl	%bl, %ebx
	andl	$15, %ebx
	shlq	$8, %rbx
	addq	%r9, %rbx
	xorb	(%r11,%rbx), %al
	movb	%al, (%rdx,%rcx)
	incq	%rcx
	cmpl	%ecx, %r10d
	jne	LBB20_7
	jmp	LBB20_15
LBB20_8:
	testb	$1, %r8b
	je	LBB20_9
## BB#12:                               ## %.preheader4
	testl	%ecx, %ecx
	jle	LBB20_15
## BB#13:
	leaq	_unscrambleAsciiTables(%rip), %r8
	.align	4, 0x90
LBB20_14:                               ## %.lr.ph12
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%rdi), %r9d
	movzbl	(%rsi), %ebx
	movl	%ebx, %eax
	andl	$15, %eax
	shlq	$8, %rax
	addq	%r8, %rax
	movb	(%r9,%rax), %al
	xorb	%bl, %al
	movb	%al, (%rdx)
	incq	%rdi
	incq	%rsi
	incq	%rdx
	decl	%ecx
	jne	LBB20_14
	jmp	LBB20_15
LBB20_2:                                ## %.preheader2
	testl	%ecx, %ecx
	jle	LBB20_15
## BB#3:                                ## %.lr.ph10.preheader
	movl	%ecx, %r10d
	xorl	%ecx, %ecx
	leaq	_scramblingTablesOrder(%rip), %r8
	leaq	_unscrambleAsciiTables(%rip), %r9
	.align	4, 0x90
LBB20_4:                                ## %.lr.ph10
                                        ## =>This Inner Loop Header: Depth=1
	movb	(%rsi,%rcx), %bl
	movb	(%rdi,%rcx), %al
	xorb	%bl, %al
	movzbl	%al, %eax
	xorb	(%rcx,%r8), %bl
	movzbl	%bl, %ebx
	andl	$15, %ebx
	shlq	$8, %rbx
	addq	%r9, %rbx
	movb	(%rax,%rbx), %al
	movb	%al, (%rdx,%rcx)
	incq	%rcx
	cmpl	%ecx, %r10d
	jne	LBB20_4
	jmp	LBB20_15
LBB20_9:                                ## %.preheader6
	testl	%ecx, %ecx
	jle	LBB20_15
## BB#10:
	leaq	_unscrambleAsciiTables(%rip), %r8
	.align	4, 0x90
LBB20_11:                               ## %.lr.ph14
                                        ## =>This Inner Loop Header: Depth=1
	movzbl	(%rsi), %ebx
	movb	(%rdi), %al
	xorb	%bl, %al
	movzbl	%al, %eax
	andl	$15, %ebx
	shlq	$8, %rbx
	addq	%r8, %rbx
	movb	(%rax,%rbx), %al
	movb	%al, (%rdx)
	incq	%rdi
	incq	%rsi
	incq	%rdx
	decl	%ecx
	jne	LBB20_11
LBB20_15:                               ## %.loopexit
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_standardXOR
	.align	4, 0x90
_standardXOR:                           ## @standardXOR
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp94:
	.cfi_def_cfa_offset 16
Ltmp95:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp96:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
Ltmp97:
	.cfi_offset %rbx, -48
Ltmp98:
	.cfi_offset %r12, -40
Ltmp99:
	.cfi_offset %r14, -32
Ltmp100:
	.cfi_offset %r15, -24
	testl	%ecx, %ecx
	jle	LBB21_10
## BB#1:                                ## %.lr.ph.preheader
	leal	-1(%rcx), %r14d
	leaq	1(%r14), %r8
	xorl	%r10d, %r10d
	cmpq	$16, %r8
	jb	LBB21_8
## BB#2:                                ## %min.iters.checked
	xorl	%r10d, %r10d
	movabsq	$8589934576, %r11       ## imm = 0x1FFFFFFF0
	movq	%r8, %r9
	andq	%r11, %r9
	je	LBB21_8
## BB#3:                                ## %vector.memcheck
	leaq	(%rdx,%r14), %rbx
	leaq	(%rdi,%r14), %rax
	leaq	(%rsi,%r14), %r10
	cmpq	%rdx, %rax
	setae	%r15b
	cmpq	%rdi, %rbx
	setae	%r12b
	cmpq	%rdx, %r10
	setae	%al
	cmpq	%rsi, %rbx
	setae	%bl
	xorl	%r10d, %r10d
	testb	%r12b, %r15b
	jne	LBB21_8
## BB#4:                                ## %vector.memcheck
	andb	%bl, %al
	jne	LBB21_8
## BB#5:                                ## %vector.body.preheader
	incq	%r14
	andq	%r11, %r14
	movq	%rdx, %r10
	movq	%rsi, %rbx
	movq	%rdi, %rax
	.align	4, 0x90
LBB21_6:                                ## %vector.body
                                        ## =>This Inner Loop Header: Depth=1
	movups	(%rax), %xmm0
	movups	(%rbx), %xmm1
	xorps	%xmm0, %xmm1
	movups	%xmm1, (%r10)
	addq	$16, %rax
	addq	$16, %rbx
	addq	$16, %r10
	addq	$-16, %r14
	jne	LBB21_6
## BB#7:                                ## %middle.block
	cmpq	%r9, %r8
	movq	%r9, %r10
	je	LBB21_10
LBB21_8:                                ## %.lr.ph.preheader10
	addq	%r10, %rdi
	addq	%r10, %rsi
	addq	%r10, %rdx
	subl	%r10d, %ecx
	.align	4, 0x90
LBB21_9:                                ## %.lr.ph
                                        ## =>This Inner Loop Header: Depth=1
	movb	(%rsi), %al
	xorb	(%rdi), %al
	movb	%al, (%rdx)
	incq	%rdi
	incq	%rsi
	incq	%rdx
	decl	%ecx
	jne	LBB21_9
LBB21_10:                               ## %._crit_edge
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_fillBuffer
	.align	4, 0x90
_fillBuffer:                            ## @fillBuffer
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp101:
	.cfi_def_cfa_offset 16
Ltmp102:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp103:
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
Ltmp104:
	.cfi_offset %rbx, -32
Ltmp105:
	.cfi_offset %r14, -24
	movq	%rdx, %r14
	movq	%rsi, %rax
	movq	%rdi, %rcx
	movl	$1, %esi
	movl	$16384, %edx            ## imm = 0x4000
	movq	%rax, %rdi
	callq	_fread
	movq	%rax, %r8
	testl	%r8d, %r8d
	jle	LBB22_4
## BB#1:                                ## %.lr.ph
	movslq	_passPhraseSize(%rip), %r10
	movl	_seedIndex(%rip), %esi
	movq	_passIndex(%rip), %rax
	leaq	_seed(%rip), %r11
	leaq	_passPhrase(%rip), %r9
	movl	%r8d, %edi
	.align	4, 0x90
LBB22_2:                                ## =>This Inner Loop Header: Depth=1
	movslq	%esi, %rsi
	movq	(%r11,%rsi,8), %rdx
	incl	%esi
	andl	$15, %esi
	movq	(%r11,%rsi,8), %rbx
	movq	%rbx, %rcx
	shlq	$31, %rcx
	xorq	%rbx, %rcx
	movq	%rdx, %rbx
	shrq	$30, %rbx
	xorq	%rdx, %rbx
	xorq	%rcx, %rbx
	shrq	$11, %rcx
	xorq	%rbx, %rcx
	movq	%rcx, (%r11,%rsi,8)
	imull	$1419247029, %ecx, %ecx ## imm = 0x5497FDB5
	xorb	(%rax,%r9), %cl
	movb	%cl, (%r14)
	incq	%rax
	xorl	%edx, %edx
	divq	%r10
	incq	%r14
	decl	%edi
	movq	%rdx, %rax
	jne	LBB22_2
## BB#3:                                ## %._crit_edge
	movl	%esi, _seedIndex(%rip)
	movq	%rax, _passIndex(%rip)
LBB22_4:
	movl	%r8d, %eax
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__literal4,4byte_literals
	.align	2
LCPI23_0:
	.long	1112014848              ## float 50
LCPI23_3:
	.long	1120403456              ## float 100
	.section	__TEXT,__literal8,8byte_literals
	.align	3
LCPI23_1:
	.quad	4607182418800017408     ## double 1
LCPI23_2:
	.quad	-4616189618054758400    ## double -1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_code
	.align	4, 0x90
_code:                                  ## @code
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp106:
	.cfi_def_cfa_offset 16
Ltmp107:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp108:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$49208, %rsp            ## imm = 0xC038
Ltmp109:
	.cfi_offset %rbx, -56
Ltmp110:
	.cfi_offset %r12, -48
Ltmp111:
	.cfi_offset %r13, -40
Ltmp112:
	.cfi_offset %r14, -32
Ltmp113:
	.cfi_offset %r15, -24
	movq	%rdi, %r15
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	_fileName(%rip), %r14
	movq	%r14, %rdi
	callq	_strlen
	incl	%eax
	addq	$15, %rax
	movabsq	$8589934576, %rcx       ## imm = 0x1FFFFFFF0
	andq	%rax, %rcx
	movq	%rsp, %rbx
	subq	%rcx, %rbx
	movq	%rbx, %rsp
	leaq	-16432(%rbp), %r13
	movl	$16384, %esi            ## imm = 0x4000
	movq	%r13, %rdi
	callq	___bzero
	leaq	-32816(%rbp), %rdi
	movl	$16384, %esi            ## imm = 0x4000
	callq	___bzero
	leaq	-49200(%rbp), %rdi
	movl	$16384, %esi            ## imm = 0x4000
	callq	___bzero
	leaq	L_.str.3(%rip), %rcx
	leaq	_pathToMainFile(%rip), %r8
	movl	$0, %esi
	movq	$-1, %rdx
	xorl	%eax, %eax
	movq	%rbx, %rdi
	movq	%r14, %r9
	callq	___sprintf_chk
	leaq	L_.str.4(%rip), %rsi
	movq	%rbx, %rdi
	callq	_fopen
	movq	%rax, -49216(%rbp)      ## 8-byte Spill
	testq	%rax, %rax
	je	LBB23_45
## BB#1:
	movabsq	$1181783497276652981, %r14 ## imm = 0x106689D45497FDB5
	leaq	L_str.39(%rip), %rdi
	callq	_puts
	movb	_scrambling(%rip), %bl
	andb	$1, %bl
	movq	%r15, %rdi
	callq	_feof
	testb	%bl, %bl
	je	LBB23_2
## BB#12:                               ## %loadBar.exit33.preheader
	xorl	%ecx, %ecx
	movq	%rcx, -49208(%rbp)      ## 8-byte Spill
	testl	%eax, %eax
	movq	%r15, %rbx
	movq	%rbx, -49224(%rbp)      ## 8-byte Spill
	jne	LBB23_28
## BB#13:
	leaq	_seed(%rip), %r15
	leaq	_passPhrase(%rip), %r12
	.align	4, 0x90
LBB23_14:                               ## %.lr.ph
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB23_16 Depth 2
                                        ##     Child Loop BB23_20 Depth 2
                                        ##     Child Loop BB23_23 Depth 2
                                        ##     Child Loop BB23_43 Depth 2
                                        ##     Child Loop BB23_40 Depth 2
	movl	$1, %esi
	movl	$16384, %edx            ## imm = 0x4000
	movq	%r13, %rdi
	movq	%rbx, %rcx
	callq	_fread
	movq	%rax, %r8
	testl	%r8d, %r8d
	jle	LBB23_24
## BB#15:                               ## %.lr.ph.i.9
                                        ##   in Loop: Header=BB23_14 Depth=1
	movslq	_passPhraseSize(%rip), %r9
	movl	_seedIndex(%rip), %esi
	movq	_passIndex(%rip), %rax
	movl	%r8d, %r10d
	leaq	-32816(%rbp), %rcx
	.align	4, 0x90
LBB23_16:                               ##   Parent Loop BB23_14 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movslq	%esi, %rsi
	movq	(%r15,%rsi,8), %r11
	incl	%esi
	andl	$15, %esi
	movq	(%r15,%rsi,8), %rbx
	movq	%rbx, %rdi
	shlq	$31, %rdi
	xorq	%rbx, %rdi
	movq	%r11, %rdx
	shrq	$30, %rdx
	xorq	%r11, %rdx
	xorq	%rdi, %rdx
	shrq	$11, %rdi
	xorq	%rdx, %rdi
	movq	%rdi, (%r15,%rsi,8)
	movl	%r14d, %edx
	imull	%edi, %edx
	xorb	(%rax,%r12), %dl
	movb	%dl, (%rcx)
	incq	%rax
	xorl	%edx, %edx
	divq	%r9
	incq	%rcx
	decl	%r10d
	movq	%rdx, %rax
	jne	LBB23_16
## BB#17:                               ## %.lr.ph.i.20.preheader
                                        ##   in Loop: Header=BB23_14 Depth=1
	movl	%esi, _seedIndex(%rip)
	movq	%rax, _passIndex(%rip)
	leal	-1(%r8), %eax
	incq	%rax
	cmpq	$16, %rax
	movl	$0, %edi
	jb	LBB23_22
## BB#18:                               ## %min.iters.checked
                                        ##   in Loop: Header=BB23_14 Depth=1
	movl	%r8d, %ecx
	andl	$15, %ecx
	subq	%rcx, %rax
	movl	$0, %edi
	je	LBB23_22
## BB#19:                               ## %vector.body.preheader
                                        ##   in Loop: Header=BB23_14 Depth=1
	movl	$4294967295, %edx       ## imm = 0xFFFFFFFF
	leal	(%r8,%rdx), %edx
	incq	%rdx
	movl	%r8d, %esi
	andl	$15, %esi
	subq	%rsi, %rdx
	leaq	-49200(%rbp), %rsi
	leaq	-32816(%rbp), %rdi
	movq	%r13, %rbx
	.align	4, 0x90
LBB23_20:                               ## %vector.body
                                        ##   Parent Loop BB23_14 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movapd	(%rdi), %xmm0
	xorpd	(%rbx), %xmm0
	movapd	%xmm0, (%rsi)
	addq	$16, %rbx
	addq	$16, %rdi
	addq	$16, %rsi
	addq	$-16, %rdx
	jne	LBB23_20
## BB#21:                               ## %middle.block
                                        ##   in Loop: Header=BB23_14 Depth=1
	testq	%rcx, %rcx
	movq	%rax, %rdi
	je	LBB23_24
	.align	4, 0x90
LBB23_22:                               ## %.lr.ph.i.20.preheader61
                                        ##   in Loop: Header=BB23_14 Depth=1
	leaq	-49200(%rbp,%rdi), %rax
	leaq	-32816(%rbp,%rdi), %rcx
	leaq	-16432(%rbp,%rdi), %rdx
	movl	%r8d, %esi
	subl	%edi, %esi
	.align	4, 0x90
LBB23_23:                               ## %.lr.ph.i.20
                                        ##   Parent Loop BB23_14 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movb	(%rcx), %bl
	xorb	(%rdx), %bl
	movb	%bl, (%rax)
	incq	%rax
	incq	%rcx
	incq	%rdx
	decl	%esi
	jne	LBB23_23
LBB23_24:                               ## %standardXOR.exit
                                        ##   in Loop: Header=BB23_14 Depth=1
	movslq	%r8d, %rdx
	movl	$1, %esi
	leaq	-49200(%rbp), %rdi
	movq	-49216(%rbp), %rcx      ## 8-byte Reload
	callq	_fwrite
	incq	-49208(%rbp)            ## 8-byte Folded Spill
	movl	_numberOfBuffer(%rip), %ebx
	movb	_loadBar.firstCall(%rip), %al
	andb	$1, %al
	jne	LBB23_26
## BB#25:                               ##   in Loop: Header=BB23_14 Depth=1
	xorl	%edi, %edi
	callq	_time
	movq	%rax, _loadBar.startingTime(%rip)
	movb	$1, _loadBar.firstCall(%rip)
LBB23_26:                               ##   in Loop: Header=BB23_14 Depth=1
	movslq	%ebx, %rax
	imulq	$1374389535, %rax, %rax ## imm = 0x51EB851F
	movq	%rax, %rcx
	sarq	$37, %rcx
	shrq	$63, %rax
	leal	1(%rcx,%rax), %ecx
	movq	-49208(%rbp), %rax      ## 8-byte Reload
	cltd
	idivl	%ecx
	testl	%edx, %edx
	jne	LBB23_27
## BB#42:                               ##   in Loop: Header=BB23_14 Depth=1
	movq	-49208(%rbp), %rax      ## 8-byte Reload
	cvtsi2ssl	%eax, %xmm1
	cvtsi2ssl	%ebx, %xmm0
	divss	%xmm0, %xmm1
	movss	%xmm1, -49236(%rbp)     ## 4-byte Spill
	movaps	%xmm1, %xmm0
	mulss	LCPI23_0(%rip), %xmm0
	cvttss2si	%xmm0, %r13d
	xorl	%edi, %edi
	callq	_time
	movq	_loadBar.startingTime(%rip), %rsi
	movq	%rax, %rdi
	callq	_difftime
	movss	-49236(%rbp), %xmm3     ## 4-byte Reload
                                        ## xmm3 = mem[0],zero,zero,zero
	xorps	%xmm1, %xmm1
	cvtss2sd	%xmm3, %xmm1
	movsd	LCPI23_1(%rip), %xmm2   ## xmm2 = mem[0],zero
	divsd	%xmm1, %xmm2
	addsd	LCPI23_2(%rip), %xmm2
	mulsd	%xmm0, %xmm2
	movsd	%xmm2, -49232(%rbp)     ## 8-byte Spill
	mulss	LCPI23_3(%rip), %xmm3
	cvttss2si	%xmm3, %esi
	xorl	%eax, %eax
	leaq	L_.str.33(%rip), %rdi
	callq	_printf
	testl	%r13d, %r13d
	movl	%r13d, %ebx
	jle	LBB23_39
	.align	4, 0x90
LBB23_43:                               ## %.lr.ph5.i.27
                                        ##   Parent Loop BB23_14 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$61, %edi
	callq	_putchar
	decl	%ebx
	jne	LBB23_43
## BB#38:                               ## %.preheader.i.23
                                        ##   in Loop: Header=BB23_14 Depth=1
	cmpl	$49, %r13d
	jg	LBB23_41
LBB23_39:                               ## %.lr.ph.i.32.preheader
                                        ##   in Loop: Header=BB23_14 Depth=1
	movl	%r13d, %eax
	movl	$50, %r13d
	subl	%eax, %r13d
	.align	4, 0x90
LBB23_40:                               ## %.lr.ph.i.32
                                        ##   Parent Loop BB23_14 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$32, %edi
	callq	_putchar
	decl	%r13d
	jne	LBB23_40
LBB23_41:                               ## %._crit_edge.i.28
                                        ##   in Loop: Header=BB23_14 Depth=1
	movb	$1, %al
	leaq	L_.str.36(%rip), %rdi
	movsd	-49232(%rbp), %xmm0     ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
	leaq	-16432(%rbp), %r13
LBB23_27:                               ## %loadBar.exit33.backedge
                                        ##   in Loop: Header=BB23_14 Depth=1
	movq	-49224(%rbp), %rbx      ## 8-byte Reload
	movq	%rbx, %rdi
	callq	_feof
	testl	%eax, %eax
	je	LBB23_14
	jmp	LBB23_28
LBB23_2:                                ## %loadBar.exit.preheader
	xorl	%r12d, %r12d
	testl	%eax, %eax
	movq	%r15, %rbx
	movq	%rbx, -49224(%rbp)      ## 8-byte Spill
	jne	LBB23_28
## BB#3:
	leaq	_seed(%rip), %r15
	leaq	_passPhrase(%rip), %r13
	.align	4, 0x90
LBB23_4:                                ## %.lr.ph41
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB23_6 Depth 2
                                        ##     Child Loop BB23_37 Depth 2
                                        ##     Child Loop BB23_34 Depth 2
	movq	%r12, -49208(%rbp)      ## 8-byte Spill
	movl	$1, %esi
	movl	$16384, %edx            ## imm = 0x4000
	leaq	-16432(%rbp), %rdi
	movq	%rbx, %rcx
	callq	_fread
	movq	%rax, %r12
	testl	%r12d, %r12d
	jle	LBB23_8
## BB#5:                                ## %.lr.ph.i
                                        ##   in Loop: Header=BB23_4 Depth=1
	movslq	_passPhraseSize(%rip), %r8
	movl	_seedIndex(%rip), %ecx
	movq	_passIndex(%rip), %rax
	movl	%r12d, %r9d
	leaq	-32816(%rbp), %rbx
	.align	4, 0x90
LBB23_6:                                ##   Parent Loop BB23_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movslq	%ecx, %rcx
	movq	(%r15,%rcx,8), %rdx
	incl	%ecx
	andl	$15, %ecx
	movq	(%r15,%rcx,8), %rdi
	movq	%rdi, %rsi
	shlq	$31, %rsi
	xorq	%rdi, %rsi
	movq	%rdx, %rdi
	shrq	$30, %rdi
	xorq	%rdx, %rdi
	xorq	%rsi, %rdi
	shrq	$11, %rsi
	xorq	%rdi, %rsi
	movq	%rsi, (%r15,%rcx,8)
	movl	%r14d, %edx
	imull	%esi, %edx
	xorb	(%rax,%r13), %dl
	movb	%dl, (%rbx)
	incq	%rax
	xorl	%edx, %edx
	divq	%r8
	incq	%rbx
	decl	%r9d
	movq	%rdx, %rax
	jne	LBB23_6
## BB#7:                                ## %._crit_edge.i
                                        ##   in Loop: Header=BB23_4 Depth=1
	movl	%ecx, _seedIndex(%rip)
	movq	%rax, _passIndex(%rip)
LBB23_8:                                ## %fillBuffer.exit
                                        ##   in Loop: Header=BB23_4 Depth=1
	leaq	-16432(%rbp), %rdi
	leaq	-32816(%rbp), %rsi
	leaq	-49200(%rbp), %rbx
	movq	%rbx, %rdx
	movl	%r12d, %ecx
	callq	_codingXOR
	movslq	%r12d, %rdx
	movl	$1, %esi
	movq	%rbx, %rdi
	movq	-49216(%rbp), %rcx      ## 8-byte Reload
	callq	_fwrite
	movq	-49208(%rbp), %r12      ## 8-byte Reload
	incq	%r12
	movl	_numberOfBuffer(%rip), %ebx
	movb	_loadBar.firstCall(%rip), %al
	andb	$1, %al
	jne	LBB23_10
## BB#9:                                ##   in Loop: Header=BB23_4 Depth=1
	xorl	%edi, %edi
	callq	_time
	movq	%rax, _loadBar.startingTime(%rip)
	movb	$1, _loadBar.firstCall(%rip)
LBB23_10:                               ##   in Loop: Header=BB23_4 Depth=1
	movslq	%ebx, %rax
	imulq	$1374389535, %rax, %rax ## imm = 0x51EB851F
	movq	%rax, %rcx
	sarq	$37, %rcx
	shrq	$63, %rax
	leal	1(%rcx,%rax), %ecx
	movl	%r12d, %eax
	cltd
	idivl	%ecx
	testl	%edx, %edx
	jne	LBB23_11
## BB#36:                               ##   in Loop: Header=BB23_4 Depth=1
	cvtsi2ssl	%r12d, %xmm1
	movq	%r12, -49208(%rbp)      ## 8-byte Spill
	cvtsi2ssl	%ebx, %xmm0
	divss	%xmm0, %xmm1
	movss	%xmm1, -49236(%rbp)     ## 4-byte Spill
	movaps	%xmm1, %xmm0
	mulss	LCPI23_0(%rip), %xmm0
	cvttss2si	%xmm0, %r12d
	xorl	%edi, %edi
	callq	_time
	movq	_loadBar.startingTime(%rip), %rsi
	movq	%rax, %rdi
	callq	_difftime
	movss	-49236(%rbp), %xmm3     ## 4-byte Reload
                                        ## xmm3 = mem[0],zero,zero,zero
	xorps	%xmm1, %xmm1
	cvtss2sd	%xmm3, %xmm1
	movsd	LCPI23_1(%rip), %xmm2   ## xmm2 = mem[0],zero
	divsd	%xmm1, %xmm2
	addsd	LCPI23_2(%rip), %xmm2
	mulsd	%xmm0, %xmm2
	movsd	%xmm2, -49232(%rbp)     ## 8-byte Spill
	mulss	LCPI23_3(%rip), %xmm3
	cvttss2si	%xmm3, %esi
	xorl	%eax, %eax
	leaq	L_.str.33(%rip), %rdi
	callq	_printf
	testl	%r12d, %r12d
	movl	%r12d, %ebx
	jle	LBB23_33
	.align	4, 0x90
LBB23_37:                               ## %.lr.ph5.i
                                        ##   Parent Loop BB23_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$61, %edi
	callq	_putchar
	decl	%ebx
	jne	LBB23_37
## BB#32:                               ## %.preheader.i
                                        ##   in Loop: Header=BB23_4 Depth=1
	cmpl	$49, %r12d
	jg	LBB23_35
LBB23_33:                               ## %.lr.ph.i.6.preheader
                                        ##   in Loop: Header=BB23_4 Depth=1
	movl	$50, %ebx
	subl	%r12d, %ebx
	.align	4, 0x90
LBB23_34:                               ## %.lr.ph.i.6
                                        ##   Parent Loop BB23_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$32, %edi
	callq	_putchar
	decl	%ebx
	jne	LBB23_34
LBB23_35:                               ## %._crit_edge.i.4
                                        ##   in Loop: Header=BB23_4 Depth=1
	movb	$1, %al
	leaq	L_.str.36(%rip), %rdi
	movsd	-49232(%rbp), %xmm0     ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
	movq	-49208(%rbp), %r12      ## 8-byte Reload
LBB23_11:                               ## %loadBar.exit.backedge
                                        ##   in Loop: Header=BB23_4 Depth=1
	movq	-49224(%rbp), %rbx      ## 8-byte Reload
	movq	%rbx, %rdi
	callq	_feof
	testl	%eax, %eax
	je	LBB23_4
LBB23_28:                               ## %.loopexit
	movq	-49216(%rbp), %rdi      ## 8-byte Reload
	callq	_fclose
	movzbl	__isADirectory(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	LBB23_30
## BB#29:
	leaq	_pathToMainFile(%rip), %r14
	movq	%r14, %rdi
	callq	_strlen
	movq	%rax, %rbx
	movq	_fileName(%rip), %rdi
	callq	_strlen
	leaq	1(%rbx,%rax), %rsi
	movl	$1, %edi
	callq	_calloc
	movq	%rax, %rbx
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	_strcpy
	movq	_fileName(%rip), %rsi
	movq	$-1, %rdx
	movq	%rbx, %rdi
	callq	___strcat_chk
	movq	%rbx, %rdi
	callq	_remove
	movq	%rbx, %rdi
	callq	_free
LBB23_30:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-48(%rbp), %rax
	jne	LBB23_31
## BB#44:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB23_45:
	movq	%rbx, %rdi
	callq	_perror
	leaq	L_str.54(%rip), %rdi
	callq	_puts
	movl	$1, %edi
	callq	_exit
LBB23_31:
	callq	___stack_chk_fail
	.cfi_endproc

	.section	__TEXT,__literal4,4byte_literals
	.align	2
LCPI24_0:
	.long	1112014848              ## float 50
LCPI24_3:
	.long	1120403456              ## float 100
	.section	__TEXT,__literal8,8byte_literals
	.align	3
LCPI24_1:
	.quad	4607182418800017408     ## double 1
LCPI24_2:
	.quad	-4616189618054758400    ## double -1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_decode
	.align	4, 0x90
_decode:                                ## @decode
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp114:
	.cfi_def_cfa_offset 16
Ltmp115:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp116:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$49208, %rsp            ## imm = 0xC038
Ltmp117:
	.cfi_offset %rbx, -56
Ltmp118:
	.cfi_offset %r12, -48
Ltmp119:
	.cfi_offset %r13, -40
Ltmp120:
	.cfi_offset %r14, -32
Ltmp121:
	.cfi_offset %r15, -24
	movq	%rdi, %r12
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	_fileName(%rip), %r14
	movq	%r14, %rdi
	callq	_strlen
	incl	%eax
	addq	$15, %rax
	movabsq	$8589934576, %rcx       ## imm = 0x1FFFFFFF0
	andq	%rax, %rcx
	movq	%rsp, %r15
	subq	%rcx, %r15
	movq	%r15, %rsp
	leaq	-16432(%rbp), %rdi
	movl	$16384, %esi            ## imm = 0x4000
	movq	%rdi, %r13
	callq	___bzero
	leaq	-32816(%rbp), %rdi
	movl	$16384, %esi            ## imm = 0x4000
	callq	___bzero
	leaq	-49200(%rbp), %rdi
	movl	$16384, %esi            ## imm = 0x4000
	callq	___bzero
	leaq	_scrambleAsciiTables(%rip), %r8
	xorl	%eax, %eax
	leaq	_unscrambleAsciiTables(%rip), %rdx
	.align	4, 0x90
LBB24_1:                                ## %.preheader.i
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB24_2 Depth 2
	movq	%r8, %rsi
	xorl	%edi, %edi
	.align	4, 0x90
LBB24_2:                                ##   Parent Loop BB24_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%rsi), %ebx
	movq	%rax, %rcx
	shlq	$8, %rcx
	addq	%rdx, %rcx
	movb	%dil, (%rbx,%rcx)
	incq	%rdi
	incq	%rsi
	cmpq	$256, %rdi              ## imm = 0x100
	jne	LBB24_2
## BB#3:                                ##   in Loop: Header=BB24_1 Depth=1
	incq	%rax
	addq	$256, %r8               ## imm = 0x100
	cmpq	$16, %rax
	jne	LBB24_1
## BB#4:                                ## %unscramble.exit
	leaq	L_.str.7(%rip), %rcx
	movl	$0, %esi
	movq	$-1, %rdx
	xorl	%eax, %eax
	movq	%r15, %rdi
	movq	%r14, %r8
	callq	___sprintf_chk
	leaq	_pathToMainFile(%rip), %r14
	movl	$1000, %edx             ## imm = 0x3E8
	movq	%r14, %rdi
	movq	%r15, %rsi
	callq	___strcat_chk
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	callq	_fopen
	movq	%rax, -49216(%rbp)      ## 8-byte Spill
	testq	%rax, %rax
	je	LBB24_47
## BB#5:
	movabsq	$1181783497276652981, %r14 ## imm = 0x106689D45497FDB5
	leaq	L_str.41(%rip), %rdi
	callq	_puts
	movb	_scrambling(%rip), %bl
	andb	$1, %bl
	movq	%r12, %rdi
	callq	_feof
	xorl	%ecx, %ecx
	testb	%bl, %bl
	je	LBB24_6
## BB#16:                               ## %loadBar.exit.preheader
	movq	%rcx, -49208(%rbp)      ## 8-byte Spill
	testl	%eax, %eax
	movq	%r12, %rbx
	movq	%rbx, -49224(%rbp)      ## 8-byte Spill
	movq	%r13, %r15
	jne	LBB24_32
## BB#17:
	leaq	_seed(%rip), %r13
	leaq	_passPhrase(%rip), %r12
	.align	4, 0x90
LBB24_18:                               ## %.lr.ph
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB24_20 Depth 2
                                        ##     Child Loop BB24_24 Depth 2
                                        ##     Child Loop BB24_27 Depth 2
                                        ##     Child Loop BB24_45 Depth 2
                                        ##     Child Loop BB24_42 Depth 2
	movl	$1, %esi
	movl	$16384, %edx            ## imm = 0x4000
	movq	%r15, %rdi
	movq	%rbx, %rcx
	callq	_fread
	movq	%rax, %r8
	testl	%r8d, %r8d
	jle	LBB24_28
## BB#19:                               ## %.lr.ph.i.24
                                        ##   in Loop: Header=BB24_18 Depth=1
	movslq	_passPhraseSize(%rip), %r9
	movl	_seedIndex(%rip), %esi
	movq	_passIndex(%rip), %rax
	movl	%r8d, %r10d
	leaq	-32816(%rbp), %rcx
	.align	4, 0x90
LBB24_20:                               ##   Parent Loop BB24_18 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movslq	%esi, %rsi
	movq	(%r13,%rsi,8), %r11
	incl	%esi
	andl	$15, %esi
	movq	(%r13,%rsi,8), %rbx
	movq	%rbx, %rdi
	shlq	$31, %rdi
	xorq	%rbx, %rdi
	movq	%r11, %rdx
	shrq	$30, %rdx
	xorq	%r11, %rdx
	xorq	%rdi, %rdx
	shrq	$11, %rdi
	xorq	%rdx, %rdi
	movq	%rdi, (%r13,%rsi,8)
	movl	%r14d, %edx
	imull	%edi, %edx
	xorb	(%rax,%r12), %dl
	movb	%dl, (%rcx)
	incq	%rax
	xorl	%edx, %edx
	divq	%r9
	incq	%rcx
	decl	%r10d
	movq	%rdx, %rax
	jne	LBB24_20
## BB#21:                               ## %.lr.ph.i.35.preheader
                                        ##   in Loop: Header=BB24_18 Depth=1
	movl	%esi, _seedIndex(%rip)
	movq	%rax, _passIndex(%rip)
	leal	-1(%r8), %eax
	incq	%rax
	cmpq	$16, %rax
	movl	$0, %edi
	jb	LBB24_26
## BB#22:                               ## %min.iters.checked
                                        ##   in Loop: Header=BB24_18 Depth=1
	movl	%r8d, %ecx
	andl	$15, %ecx
	subq	%rcx, %rax
	movl	$0, %edi
	je	LBB24_26
## BB#23:                               ## %vector.body.preheader
                                        ##   in Loop: Header=BB24_18 Depth=1
	movl	$4294967295, %edx       ## imm = 0xFFFFFFFF
	leal	(%r8,%rdx), %edx
	incq	%rdx
	movl	%r8d, %esi
	andl	$15, %esi
	subq	%rsi, %rdx
	leaq	-49200(%rbp), %rsi
	leaq	-32816(%rbp), %rdi
	movq	%r15, %rbx
	.align	4, 0x90
LBB24_24:                               ## %vector.body
                                        ##   Parent Loop BB24_18 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movapd	(%rdi), %xmm0
	xorpd	(%rbx), %xmm0
	movapd	%xmm0, (%rsi)
	addq	$16, %rbx
	addq	$16, %rdi
	addq	$16, %rsi
	addq	$-16, %rdx
	jne	LBB24_24
## BB#25:                               ## %middle.block
                                        ##   in Loop: Header=BB24_18 Depth=1
	testq	%rcx, %rcx
	movq	%rax, %rdi
	je	LBB24_28
	.align	4, 0x90
LBB24_26:                               ## %.lr.ph.i.35.preheader64
                                        ##   in Loop: Header=BB24_18 Depth=1
	leaq	-49200(%rbp,%rdi), %rax
	leaq	-32816(%rbp,%rdi), %rcx
	leaq	-16432(%rbp,%rdi), %rdx
	movl	%r8d, %esi
	subl	%edi, %esi
	.align	4, 0x90
LBB24_27:                               ## %.lr.ph.i.35
                                        ##   Parent Loop BB24_18 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movb	(%rcx), %bl
	xorb	(%rdx), %bl
	movb	%bl, (%rax)
	incq	%rax
	incq	%rcx
	incq	%rdx
	decl	%esi
	jne	LBB24_27
LBB24_28:                               ## %standardXOR.exit
                                        ##   in Loop: Header=BB24_18 Depth=1
	movslq	%r8d, %rdx
	movl	$1, %esi
	leaq	-49200(%rbp), %rdi
	movq	-49216(%rbp), %rcx      ## 8-byte Reload
	callq	_fwrite
	incq	-49208(%rbp)            ## 8-byte Folded Spill
	movl	_numberOfBuffer(%rip), %ebx
	movb	_loadBar.firstCall(%rip), %al
	andb	$1, %al
	jne	LBB24_30
## BB#29:                               ##   in Loop: Header=BB24_18 Depth=1
	xorl	%edi, %edi
	callq	_time
	movq	%rax, _loadBar.startingTime(%rip)
	movb	$1, _loadBar.firstCall(%rip)
LBB24_30:                               ##   in Loop: Header=BB24_18 Depth=1
	movslq	%ebx, %rax
	imulq	$1374389535, %rax, %rax ## imm = 0x51EB851F
	movq	%rax, %rcx
	sarq	$37, %rcx
	shrq	$63, %rax
	leal	1(%rcx,%rax), %ecx
	movq	-49208(%rbp), %rax      ## 8-byte Reload
	cltd
	idivl	%ecx
	testl	%edx, %edx
	jne	LBB24_31
## BB#44:                               ##   in Loop: Header=BB24_18 Depth=1
	movq	-49208(%rbp), %rax      ## 8-byte Reload
	cvtsi2ssl	%eax, %xmm1
	cvtsi2ssl	%ebx, %xmm0
	divss	%xmm0, %xmm1
	movss	%xmm1, -49236(%rbp)     ## 4-byte Spill
	movaps	%xmm1, %xmm0
	mulss	LCPI24_0(%rip), %xmm0
	cvttss2si	%xmm0, %r15d
	xorl	%edi, %edi
	callq	_time
	movq	_loadBar.startingTime(%rip), %rsi
	movq	%rax, %rdi
	callq	_difftime
	movss	-49236(%rbp), %xmm3     ## 4-byte Reload
                                        ## xmm3 = mem[0],zero,zero,zero
	xorps	%xmm1, %xmm1
	cvtss2sd	%xmm3, %xmm1
	movsd	LCPI24_1(%rip), %xmm2   ## xmm2 = mem[0],zero
	divsd	%xmm1, %xmm2
	addsd	LCPI24_2(%rip), %xmm2
	mulsd	%xmm0, %xmm2
	movsd	%xmm2, -49232(%rbp)     ## 8-byte Spill
	mulss	LCPI24_3(%rip), %xmm3
	cvttss2si	%xmm3, %esi
	xorl	%eax, %eax
	leaq	L_.str.33(%rip), %rdi
	callq	_printf
	testl	%r15d, %r15d
	movl	%r15d, %ebx
	jle	LBB24_41
	.align	4, 0x90
LBB24_45:                               ## %.lr.ph5.i
                                        ##   Parent Loop BB24_18 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$61, %edi
	callq	_putchar
	decl	%ebx
	jne	LBB24_45
## BB#40:                               ## %.preheader.i.3
                                        ##   in Loop: Header=BB24_18 Depth=1
	cmpl	$49, %r15d
	jg	LBB24_43
LBB24_41:                               ## %.lr.ph.i.preheader
                                        ##   in Loop: Header=BB24_18 Depth=1
	movl	%r15d, %eax
	movl	$50, %r15d
	subl	%eax, %r15d
	.align	4, 0x90
LBB24_42:                               ## %.lr.ph.i
                                        ##   Parent Loop BB24_18 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$32, %edi
	callq	_putchar
	decl	%r15d
	jne	LBB24_42
LBB24_43:                               ## %._crit_edge.i
                                        ##   in Loop: Header=BB24_18 Depth=1
	movb	$1, %al
	leaq	L_.str.36(%rip), %rdi
	movsd	-49232(%rbp), %xmm0     ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
	leaq	-16432(%rbp), %r15
LBB24_31:                               ## %loadBar.exit.backedge
                                        ##   in Loop: Header=BB24_18 Depth=1
	movq	-49224(%rbp), %rbx      ## 8-byte Reload
	movq	%rbx, %rdi
	callq	_feof
	testl	%eax, %eax
	je	LBB24_18
	jmp	LBB24_32
LBB24_6:                                ## %loadBar.exit21.preheader
	movq	%rcx, -49208(%rbp)      ## 8-byte Spill
	testl	%eax, %eax
	movq	%r12, %rbx
	movq	%rbx, -49224(%rbp)      ## 8-byte Spill
	jne	LBB24_32
## BB#7:
	leaq	_seed(%rip), %r13
	leaq	_passPhrase(%rip), %r15
	.align	4, 0x90
LBB24_8:                                ## %.lr.ph44
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB24_10 Depth 2
                                        ##     Child Loop BB24_39 Depth 2
                                        ##     Child Loop BB24_36 Depth 2
	movl	$1, %esi
	movl	$16384, %edx            ## imm = 0x4000
	leaq	-16432(%rbp), %rdi
	movq	%rbx, %rcx
	callq	_fread
	movq	%rax, %r12
	testl	%r12d, %r12d
	jle	LBB24_12
## BB#9:                                ## %.lr.ph.i.5
                                        ##   in Loop: Header=BB24_8 Depth=1
	movslq	_passPhraseSize(%rip), %r8
	movl	_seedIndex(%rip), %ecx
	movq	_passIndex(%rip), %rax
	movl	%r12d, %r9d
	leaq	-32816(%rbp), %rbx
	.align	4, 0x90
LBB24_10:                               ##   Parent Loop BB24_8 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movslq	%ecx, %rcx
	movq	(%r13,%rcx,8), %rdx
	incl	%ecx
	andl	$15, %ecx
	movq	(%r13,%rcx,8), %rdi
	movq	%rdi, %rsi
	shlq	$31, %rsi
	xorq	%rdi, %rsi
	movq	%rdx, %rdi
	shrq	$30, %rdi
	xorq	%rdx, %rdi
	xorq	%rsi, %rdi
	shrq	$11, %rsi
	xorq	%rdi, %rsi
	movq	%rsi, (%r13,%rcx,8)
	movl	%r14d, %edx
	imull	%esi, %edx
	xorb	(%rax,%r15), %dl
	movb	%dl, (%rbx)
	incq	%rax
	xorl	%edx, %edx
	divq	%r8
	incq	%rbx
	decl	%r9d
	movq	%rdx, %rax
	jne	LBB24_10
## BB#11:                               ## %._crit_edge.i.6
                                        ##   in Loop: Header=BB24_8 Depth=1
	movl	%ecx, _seedIndex(%rip)
	movq	%rax, _passIndex(%rip)
LBB24_12:                               ## %fillBuffer.exit
                                        ##   in Loop: Header=BB24_8 Depth=1
	leaq	-16432(%rbp), %rdi
	leaq	-32816(%rbp), %rsi
	leaq	-49200(%rbp), %rbx
	movq	%rbx, %rdx
	movl	%r12d, %ecx
	callq	_decodingXOR
	movslq	%r12d, %rdx
	movl	$1, %esi
	movq	%rbx, %rdi
	movq	-49216(%rbp), %rcx      ## 8-byte Reload
	callq	_fwrite
	movq	-49208(%rbp), %rbx      ## 8-byte Reload
	incq	%rbx
	movl	_numberOfBuffer(%rip), %r12d
	movb	_loadBar.firstCall(%rip), %al
	andb	$1, %al
	jne	LBB24_14
## BB#13:                               ##   in Loop: Header=BB24_8 Depth=1
	xorl	%edi, %edi
	callq	_time
	movq	%rax, _loadBar.startingTime(%rip)
	movb	$1, _loadBar.firstCall(%rip)
LBB24_14:                               ##   in Loop: Header=BB24_8 Depth=1
	movslq	%r12d, %rax
	imulq	$1374389535, %rax, %rax ## imm = 0x51EB851F
	movq	%rax, %rcx
	sarq	$37, %rcx
	shrq	$63, %rax
	leal	1(%rcx,%rax), %ecx
	movl	%ebx, %eax
	movq	%rbx, -49208(%rbp)      ## 8-byte Spill
	cltd
	idivl	%ecx
	testl	%edx, %edx
	jne	LBB24_15
## BB#38:                               ##   in Loop: Header=BB24_8 Depth=1
	movq	-49208(%rbp), %rax      ## 8-byte Reload
	cvtsi2ssl	%eax, %xmm1
	cvtsi2ssl	%r12d, %xmm0
	divss	%xmm0, %xmm1
	movss	%xmm1, -49236(%rbp)     ## 4-byte Spill
	movaps	%xmm1, %xmm0
	mulss	LCPI24_0(%rip), %xmm0
	cvttss2si	%xmm0, %r12d
	xorl	%edi, %edi
	callq	_time
	movq	_loadBar.startingTime(%rip), %rsi
	movq	%rax, %rdi
	callq	_difftime
	movss	-49236(%rbp), %xmm3     ## 4-byte Reload
                                        ## xmm3 = mem[0],zero,zero,zero
	xorps	%xmm1, %xmm1
	cvtss2sd	%xmm3, %xmm1
	movsd	LCPI24_1(%rip), %xmm2   ## xmm2 = mem[0],zero
	divsd	%xmm1, %xmm2
	addsd	LCPI24_2(%rip), %xmm2
	mulsd	%xmm0, %xmm2
	movsd	%xmm2, -49232(%rbp)     ## 8-byte Spill
	mulss	LCPI24_3(%rip), %xmm3
	cvttss2si	%xmm3, %esi
	xorl	%eax, %eax
	leaq	L_.str.33(%rip), %rdi
	callq	_printf
	testl	%r12d, %r12d
	movl	%r12d, %ebx
	jle	LBB24_35
	.align	4, 0x90
LBB24_39:                               ## %.lr.ph5.i.15
                                        ##   Parent Loop BB24_8 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$61, %edi
	callq	_putchar
	decl	%ebx
	jne	LBB24_39
## BB#34:                               ## %.preheader.i.11
                                        ##   in Loop: Header=BB24_8 Depth=1
	cmpl	$49, %r12d
	jg	LBB24_37
LBB24_35:                               ## %.lr.ph.i.20.preheader
                                        ##   in Loop: Header=BB24_8 Depth=1
	movl	$50, %ebx
	subl	%r12d, %ebx
	.align	4, 0x90
LBB24_36:                               ## %.lr.ph.i.20
                                        ##   Parent Loop BB24_8 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$32, %edi
	callq	_putchar
	decl	%ebx
	jne	LBB24_36
LBB24_37:                               ## %._crit_edge.i.16
                                        ##   in Loop: Header=BB24_8 Depth=1
	movb	$1, %al
	leaq	L_.str.36(%rip), %rdi
	movsd	-49232(%rbp), %xmm0     ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
LBB24_15:                               ## %loadBar.exit21.backedge
                                        ##   in Loop: Header=BB24_8 Depth=1
	movq	-49224(%rbp), %rbx      ## 8-byte Reload
	movq	%rbx, %rdi
	callq	_feof
	testl	%eax, %eax
	je	LBB24_8
LBB24_32:                               ## %.loopexit
	movq	-49216(%rbp), %rdi      ## 8-byte Reload
	callq	_fclose
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-48(%rbp), %rax
	jne	LBB24_33
## BB#46:                               ## %.loopexit
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB24_47:
	movq	%r15, %rdi
	callq	_perror
	leaq	L_str.54(%rip), %rdi
	callq	_puts
	movl	$1, %edi
	callq	_exit
LBB24_33:                               ## %.loopexit
	callq	___stack_chk_fail
	.cfi_endproc

	.globl	_isADirectory
	.align	4, 0x90
_isADirectory:                          ## @isADirectory
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp122:
	.cfi_def_cfa_offset 16
Ltmp123:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp124:
	.cfi_def_cfa_register %rbp
	subq	$144, %rsp
	leaq	-144(%rbp), %rsi
	callq	_stat$INODE64
	cmpl	$-1, %eax
	je	LBB25_1
## BB#5:
	movzwl	-140(%rbp), %eax
	andl	$61440, %eax            ## imm = 0xF000
	cmpl	$16384, %eax            ## imm = 0x4000
	sete	%al
	movzbl	%al, %eax
	sete	__isADirectory(%rip)
	addq	$144, %rsp
	popq	%rbp
	retq
LBB25_1:
	callq	___error
	cmpl	$2, (%rax)
	jne	LBB25_4
## BB#2:
	leaq	L_str.44(%rip), %rdi
	callq	_puts
	jmp	LBB25_3
LBB25_4:
	leaq	L_.str.10(%rip), %rdi
	callq	_perror
LBB25_3:
	leaq	L_str.54(%rip), %rdi
	callq	_puts
	movl	$1, %edi
	callq	_exit
	.cfi_endproc

	.section	__TEXT,__literal4,4byte_literals
	.align	2
LCPI26_0:
	.long	947912704               ## float 6.10351563E-5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp125:
	.cfi_def_cfa_offset 16
Ltmp126:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp127:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1096, %rsp             ## imm = 0x448
Ltmp128:
	.cfi_offset %rbx, -56
Ltmp129:
	.cfi_offset %r12, -48
Ltmp130:
	.cfi_offset %r13, -40
Ltmp131:
	.cfi_offset %r14, -32
Ltmp132:
	.cfi_offset %r15, -24
	movq	%rsi, %r12
	movl	%edi, %r14d
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	(%r12), %rbx
	movl	$47, %esi
	movq	%rbx, %rdi
	callq	_strrchr
	movq	%rax, _progName(%rip)
	testq	%rax, %rax
	je	LBB26_2
## BB#1:
	incq	%rax
	movq	%rax, _progName(%rip)
	jmp	LBB26_3
LBB26_2:
	movq	%rbx, _progName(%rip)
LBB26_3:
	cmpl	$1, %r14d
	jle	LBB26_112
## BB#4:
	cmpl	$5, %r14d
	jge	LBB26_5
## BB#7:
	movq	8(%r12), %rbx
	leaq	L_.str.12(%rip), %rsi
	movq	%rbx, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB26_113
## BB#8:
	leaq	L_.str.13(%rip), %rsi
	movq	%rbx, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB26_113
## BB#9:
	cmpl	$3, %r14d
	jl	LBB26_10
## BB#11:
	movzbl	(%rbx), %eax
	cmpl	$45, %eax
	jne	LBB26_33
## BB#12:
	movq	%rbx, %rdi
	callq	_strlen
	cmpq	$4, %rax
	ja	LBB26_33
## BB#13:
	movl	$115, %esi
	movq	%rbx, %rdi
	callq	_strchr
	testq	%rax, %rax
	je	LBB26_15
## BB#14:
	movb	$1, _scrambling(%rip)
LBB26_15:
	movl	$105, %esi
	movq	%rbx, %rdi
	callq	_strchr
	testq	%rax, %rax
	je	LBB26_17
## BB#16:
	movb	$1, _isCodingInverted(%rip)
LBB26_17:
	movl	$110, %esi
	movq	%rbx, %rdi
	callq	_strchr
	testq	%rax, %rax
	je	LBB26_19
## BB#18:
	movb	$1, _normalised(%rip)
LBB26_19:
	movl	$100, %esi
	movq	%rbx, %rdi
	callq	_strchr
	testq	%rax, %rax
	je	LBB26_20
## BB#21:
	leaq	L_str.62(%rip), %rdi
	callq	_puts
	movb	$1, %al
	jmp	LBB26_22
LBB26_10:
	xorl	%eax, %eax
	movq	%rax, -1096(%rbp)       ## 8-byte Spill
	movb	$1, %r15b
	xorl	%eax, %eax
	movq	%rax, -1088(%rbp)       ## 8-byte Spill
	jmp	LBB26_46
LBB26_33:
	movq	16(%r12), %rdi
	leaq	L_.str.16(%rip), %rsi
	callq	_fopen
	movq	%rax, %rbx
	movq	16(%r12), %rdi
	testq	%rbx, %rbx
	je	LBB26_114
## BB#34:
	callq	_isADirectory
	testl	%eax, %eax
	je	LBB26_36
## BB#35:
	leaq	L_str.61(%rip), %rdi
	callq	_puts
	xorl	%ebx, %ebx
LBB26_36:
	cmpl	$4, %r14d
	jge	LBB26_5
## BB#37:
	movb	$1, %r15b
	xorl	%eax, %eax
	movq	%rax, -1088(%rbp)       ## 8-byte Spill
	testq	%rbx, %rbx
	movl	$0, %eax
	jne	LBB26_38
	jmp	LBB26_43
LBB26_20:
	xorl	%eax, %eax
LBB26_22:
	testb	%al, %al
	jne	LBB26_27
## BB#23:
	testb	$1, _scrambling(%rip)
	jne	LBB26_27
## BB#24:
	testb	$1, _isCodingInverted(%rip)
	jne	LBB26_27
## BB#25:
	testb	$1, _normalised(%rip)
	je	LBB26_26
LBB26_27:
	movq	%rax, -1088(%rbp)       ## 8-byte Spill
	movb	$2, %r15b
	xorl	%eax, %eax
	cmpl	$4, %r14d
	jl	LBB26_43
## BB#28:
	movq	24(%r12), %rdi
	leaq	L_.str.16(%rip), %rsi
	callq	_fopen
	movq	%rax, %rbx
	movq	24(%r12), %rdi
	testq	%rbx, %rbx
	je	LBB26_114
## BB#29:
	callq	_isADirectory
	testl	%eax, %eax
	je	LBB26_31
## BB#30:
	leaq	L_str.61(%rip), %rdi
	callq	_puts
	jmp	LBB26_42
LBB26_31:
	movzbl	_scrambling(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	LBB26_32
## BB#41:
	leaq	L_str.60(%rip), %rdi
	callq	_puts
	movb	$2, %r15b
LBB26_42:                               ## %.thread
	xorl	%eax, %eax
	jmp	LBB26_43
LBB26_32:
	movb	$2, %r15b
LBB26_38:                               ## %.thread52
	movb	$1, _usingKeyFile(%rip)
	movq	%rbx, %rdi
	callq	_rewind
	xorl	%esi, %esi
	movl	$2, %edx
	movq	%rbx, %rdi
	callq	_fseek
	movq	%rbx, %rdi
	callq	_ftell
	movl	%eax, _keyFileSize(%rip)
	movq	%rbx, %rdi
	callq	_rewind
	cmpl	$0, _keyFileSize(%rip)
	je	LBB26_40
## BB#39:
	movq	%rbx, %rax
LBB26_43:                               ## %.thread
	movq	%rax, -1096(%rbp)       ## 8-byte Spill
	movb	_usingKeyFile(%rip), %al
	andb	$1, %al
	jne	LBB26_46
	jmp	LBB26_44
LBB26_40:                               ## %.thread38
	leaq	L_str.56(%rip), %rdi
	callq	_puts
	movb	$0, _usingKeyFile(%rip)
	xorl	%eax, %eax
	movq	%rax, -1096(%rbp)       ## 8-byte Spill
LBB26_44:
	movzbl	_normalised(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	LBB26_46
## BB#45:
	leaq	L_str.55(%rip), %rdi
	callq	_puts
	movb	$0, _normalised(%rip)
LBB26_46:
	movsbq	%r15b, %r15
	movq	(%r12,%r15,8), %rbx
	movq	%rbx, %rdi
	callq	_strlen
	movzbl	-1(%rax,%rbx), %ecx
	cmpl	$47, %ecx
	jne	LBB26_50
## BB#47:
	movzbl	-2(%rax,%rbx), %eax
	cmpl	$47, %eax
	je	LBB26_48
LBB26_50:
	movq	%rbx, %rdi
	callq	_isADirectory
	testl	%eax, %eax
	je	LBB26_71
## BB#51:
	leaq	-1056(%rbp), %rdi
	movl	$1008, %esi             ## imm = 0x3F0
	callq	___bzero
	leaq	L_.str.22(%rip), %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	callq	_fflush
	movq	(%r12,%r15,8), %r14
	movl	$47, %esi
	movq	%r14, %rdi
	callq	_strrchr
	movq	%rax, %rbx
	movq	%rbx, _fileName(%rip)
	testq	%rbx, %rbx
	je	LBB26_57
## BB#52:
	movq	%rbx, %rdi
	callq	_strlen
	cmpq	$1, %rax
	jne	LBB26_56
## BB#53:
	movq	%r14, %rdi
	callq	_strlen
	leaq	5(%rax), %rsi
	movl	$1, %edi
	callq	_calloc
	movq	%rax, %rbx
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	_strcpy
	movq	_fileName(%rip), %rax
	subq	(%r12,%r15,8), %rax
	movq	%r15, -1080(%rbp)       ## 8-byte Spill
	movb	$0, (%rbx,%rax)
	movl	$47, %esi
	movq	%rbx, %rdi
	callq	_strrchr
	movq	%rax, _fileName(%rip)
	testq	%rax, %rax
	je	LBB26_55
## BB#54:
	movq	%r12, -1072(%rbp)       ## 8-byte Spill
	incq	%rax
	movq	%rax, _fileName(%rip)
	subq	%rbx, %rax
	movq	%rbx, -1104(%rbp)       ## 8-byte Spill
	leaq	_pathToMainFile(%rip), %r15
	movl	$1000, %ecx             ## imm = 0x3E8
	movq	%r15, %rdi
	movq	%rbx, %rsi
	movq	%rax, %rdx
	callq	___strncpy_chk
	movq	_fileName(%rip), %r14
	movq	%r14, %rax
	subq	%rbx, %rax
	movb	$0, (%rax,%r15)
	jmp	LBB26_59
LBB26_71:
	movq	(%r12,%r15,8), %rbx
	movl	$47, %esi
	movq	%rbx, %rdi
	callq	_strrchr
	movq	%rax, _fileName(%rip)
	testq	%rax, %rax
	je	LBB26_73
## BB#72:
	incq	%rax
	movq	%rax, _fileName(%rip)
	subq	%rbx, %rax
	leaq	_pathToMainFile(%rip), %rdi
	movl	$1000, %ecx             ## imm = 0x3E8
	movq	%rbx, %rsi
	movq	%rax, %rdx
	callq	___strncpy_chk
	movq	(%r12,%r15,8), %rbx
	movq	%r15, -1080(%rbp)       ## 8-byte Spill
	movq	%r12, -1072(%rbp)       ## 8-byte Spill
	jmp	LBB26_74
LBB26_57:
	movq	%r15, -1080(%rbp)       ## 8-byte Spill
	movq	%r12, -1072(%rbp)       ## 8-byte Spill
	movq	%r14, _fileName(%rip)
	jmp	LBB26_58
LBB26_56:
	incq	%rbx
	movq	%rbx, _fileName(%rip)
	subq	%r14, %rbx
	movq	%r15, -1080(%rbp)       ## 8-byte Spill
	leaq	_pathToMainFile(%rip), %r13
	movl	$1000, %ecx             ## imm = 0x3E8
	movq	%r13, %rdi
	movq	%r14, %rsi
	movq	%rbx, %rdx
	callq	___strncpy_chk
	movq	_fileName(%rip), %r14
	movq	%r14, %rax
	subq	(%r12,%r15,8), %rax
	movq	%r12, -1072(%rbp)       ## 8-byte Spill
	movb	$0, (%rax,%r13)
LBB26_58:
	xorl	%eax, %eax
	movq	%rax, -1104(%rbp)       ## 8-byte Spill
LBB26_59:
	movq	%r14, %rdi
	callq	_strlen
	leaq	5(%rax), %rsi
	movl	$1, %edi
	callq	_calloc
	movq	%rax, %r13
	leaq	L_.str.23(%rip), %rcx
	movl	$0, %esi
	movq	$-1, %rdx
	xorl	%eax, %eax
	movq	%r13, %rdi
	movq	%r14, %r8
	callq	___sprintf_chk
	movq	_fileName(%rip), %rdi
	callq	_processTarString
	movq	%rax, %r14
	leaq	_pathToMainFile(%rip), %rdi
	callq	_processTarString
	movq	%rax, %r15
	movq	%r13, %rdi
	callq	_processTarString
	movq	%rax, %rbx
	subq	$16, %rsp
	movq	%r14, (%rsp)
	leaq	L_.str.24(%rip), %rcx
	leaq	-1056(%rbp), %r12
	movl	$0, %esi
	movl	$1008, %edx             ## imm = 0x3F0
	xorl	%eax, %eax
	movq	%r12, %rdi
	movq	%r15, %r8
	movq	%rbx, %r9
	callq	___sprintf_chk
	addq	$16, %rsp
	movq	%r15, %rdi
	callq	_free
	movq	%rbx, %rdi
	callq	_free
	movq	%r14, %rdi
	callq	_free
	movq	%r12, %rdi
	callq	_system
	testl	%eax, %eax
	jne	LBB26_60
## BB#61:
	leaq	L_str.49(%rip), %rdi
	callq	_puts
	movq	%r13, _fileName(%rip)
	leaq	_pathToMainFile(%rip), %r14
	movq	%r14, %rdi
	callq	_strlen
	movq	%rax, %rbx
	movq	%r13, %rdi
	callq	_strlen
	movq	%rsp, %r15
	leaq	15(%rax,%rbx), %rax
	andq	$-16, %rax
	movq	%rsp, %r12
	subq	%rax, %r12
	movq	%r12, %rsp
	leaq	L_.str.27(%rip), %rcx
	movl	$0, %esi
	movq	$-1, %rdx
	xorl	%eax, %eax
	movq	%r12, %rdi
	movq	%r14, %r8
	movq	%r13, %r9
	callq	___sprintf_chk
	leaq	L_.str.16(%rip), %rsi
	movq	%r12, %rdi
	callq	_fopen
	movq	%rax, %rbx
	testq	%rbx, %rbx
	je	LBB26_70
## BB#62:                               ## %.thread42
	movq	%r15, %rsp
	jmp	LBB26_63
LBB26_73:
	movq	%r15, -1080(%rbp)       ## 8-byte Spill
	movq	%r12, -1072(%rbp)       ## 8-byte Spill
	movq	%rbx, _fileName(%rip)
LBB26_74:
	leaq	L_.str.16(%rip), %rsi
	movq	%rbx, %rdi
	callq	_fopen
	movq	%rax, %rbx
	xorl	%eax, %eax
	movq	%rax, -1104(%rbp)       ## 8-byte Spill
	testq	%rbx, %rbx
	movl	$0, %r13d
	je	LBB26_75
LBB26_63:
	movq	%rbx, -1120(%rbp)       ## 8-byte Spill
	movq	%r13, -1112(%rbp)       ## 8-byte Spill
	xorl	%esi, %esi
	movl	$2, %edx
	movq	%rbx, %rdi
	callq	_fseek
	movq	%rbx, %rdi
	callq	_ftell
	movq	%rax, %r14
	movq	%rbx, %rdi
	callq	_rewind
	cvtsi2ssq	%r14, %xmm0
	mulss	LCPI26_0(%rip), %xmm0
	cvttss2si	%xmm0, %rax
	cvtsi2ssq	%rax, %xmm1
	subss	%xmm1, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	seta	%cl
	movzbl	%cl, %ecx
	addq	%rax, %rcx
	testq	%rcx, %rcx
	movl	$1, %eax
	cmovgq	%rcx, %rax
	movq	%rax, _numberOfBuffer(%rip)
	leaq	L_.str.28(%rip), %r14
	movq	___stdinp@GOTPCREL(%rip), %rbx
	leaq	-1058(%rbp), %r15
	leaq	L_.str.29(%rip), %r12
	xorl	%r13d, %r13d
	.align	4, 0x90
LBB26_64:                               ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB26_76 Depth 2
                                        ##     Child Loop BB26_79 Depth 2
	xorl	%eax, %eax
	movq	%r14, %rdi
	callq	_printf
	movq	(%rbx), %rdx
	movl	$2, %esi
	movq	%r15, %rdi
	callq	_fgets
	testq	%rax, %rax
	movl	$0, %eax
	je	LBB26_79
## BB#65:                               ##   in Loop: Header=BB26_64 Depth=1
	movl	$10, %esi
	movq	%r15, %rdi
	callq	_strchr
	movq	%rax, %rcx
	xorl	%eax, %eax
	testq	%rcx, %rcx
	je	LBB26_76
## BB#66:                               ##   in Loop: Header=BB26_64 Depth=1
	movb	$0, (%rcx)
	jmp	LBB26_67
	.align	4, 0x90
LBB26_81:                               ##   in Loop: Header=BB26_79 Depth=2
	callq	_getchar
LBB26_79:                               ## %.preheader.i
                                        ##   Parent Loop BB26_64 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	cmpl	$-1, %eax
	je	LBB26_67
## BB#80:                               ## %.preheader.i
                                        ##   in Loop: Header=BB26_79 Depth=2
	cmpl	$10, %eax
	jne	LBB26_81
	jmp	LBB26_67
	.align	4, 0x90
LBB26_78:                               ##   in Loop: Header=BB26_76 Depth=2
	callq	_getchar
LBB26_76:                               ## %.preheader3.i
                                        ##   Parent Loop BB26_64 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	cmpl	$-1, %eax
	je	LBB26_67
## BB#77:                               ## %.preheader3.i
                                        ##   in Loop: Header=BB26_76 Depth=2
	cmpl	$10, %eax
	jne	LBB26_78
	.align	4, 0x90
LBB26_67:                               ## %readString.exit
                                        ##   in Loop: Header=BB26_64 Depth=1
	xorl	%eax, %eax
	movq	%r12, %rdi
	callq	_printf
	movsbl	-1058(%rbp), %eax
	cmpl	$98, %eax
	jg	LBB26_82
## BB#68:                               ## %readString.exit
                                        ##   in Loop: Header=BB26_64 Depth=1
	movzbl	%al, %eax
	cmpl	$67, %eax
	je	LBB26_84
## BB#69:                               ## %readString.exit
                                        ##   in Loop: Header=BB26_64 Depth=1
	cmpl	$68, %eax
	jne	LBB26_64
	jmp	LBB26_85
	.align	4, 0x90
LBB26_82:                               ## %readString.exit
                                        ##   in Loop: Header=BB26_64 Depth=1
	movzbl	%al, %eax
	cmpl	$100, %eax
	je	LBB26_85
## BB#83:                               ## %readString.exit
                                        ##   in Loop: Header=BB26_64 Depth=1
	cmpl	$99, %eax
	jne	LBB26_64
LBB26_84:                               ## %.thread44.preheader.loopexit
	movb	$1, %r13b
LBB26_85:                               ## %.thread44.preheader
	leaq	L_.str.30(%rip), %r14
	leaq	_passPhrase(%rip), %r12
	leaq	L_str.47(%rip), %r15
	jmp	LBB26_86
	.align	4, 0x90
LBB26_90:                               ## %.thread46
                                        ##   in Loop: Header=BB26_86 Depth=1
	movq	%r15, %rdi
	callq	_puts
LBB26_86:                               ## %.thread44
                                        ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB26_91 Depth 2
                                        ##     Child Loop BB26_94 Depth 2
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	movq	%r14, %rdi
	callq	_printf
	movq	___stdinp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdx
	movl	$16383, %esi            ## imm = 0x3FFF
	movq	%r12, %rdi
	callq	_fgets
	testq	%rax, %rax
	je	LBB26_94
## BB#87:                               ##   in Loop: Header=BB26_86 Depth=1
	movl	$10, %esi
	movq	%r12, %rdi
	callq	_strchr
	movq	%rax, %rcx
	xorl	%eax, %eax
	testq	%rcx, %rcx
	je	LBB26_91
## BB#88:                               ##   in Loop: Header=BB26_86 Depth=1
	movb	$0, (%rcx)
	jmp	LBB26_89
	.align	4, 0x90
LBB26_96:                               ##   in Loop: Header=BB26_94 Depth=2
	callq	_getchar
	movl	%eax, %ebx
LBB26_94:                               ## %.preheader.i.33
                                        ##   Parent Loop BB26_86 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	cmpl	$-1, %ebx
	je	LBB26_89
## BB#95:                               ## %.preheader.i.33
                                        ##   in Loop: Header=BB26_94 Depth=2
	cmpl	$10, %ebx
	jne	LBB26_96
	jmp	LBB26_89
	.align	4, 0x90
LBB26_93:                               ##   in Loop: Header=BB26_91 Depth=2
	callq	_getchar
LBB26_91:                               ## %.preheader3.i.31
                                        ##   Parent Loop BB26_86 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	cmpl	$-1, %eax
	je	LBB26_89
## BB#92:                               ## %.preheader3.i.31
                                        ##   in Loop: Header=BB26_91 Depth=2
	cmpl	$10, %eax
	jne	LBB26_93
	.align	4, 0x90
LBB26_89:                               ## %readString.exit35
                                        ##   in Loop: Header=BB26_86 Depth=1
	movq	%r12, %rdi
	callq	_strlen
	testq	%rax, %rax
	jle	LBB26_90
## BB#97:
	leaq	L_.str.29(%rip), %rdi
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	callq	_printf
	leaq	_passPhrase(%rip), %r14
	movq	%r14, %rdi
	callq	_strlen
	movl	%eax, _passPhraseSize(%rip)
	movq	%r14, %rdi
	callq	_strlen
	subq	$16, %rsp
	movq	$128, (%rsp)
	leaq	-1056(%rbp), %r9
	movl	$1088, %edi             ## imm = 0x440
	movl	$31, %r8d
	movq	%r14, %rdx
	movq	%rax, %rcx
	callq	_Keccak
	addq	$16, %rsp
	leaq	_seed(%rip), %rax
	.align	4, 0x90
LBB26_98:                               ## =>This Inner Loop Header: Depth=1
	movq	-1056(%rbp,%rbx), %rcx
	movq	%rcx, (%rbx,%rax)
	addq	$8, %rbx
	cmpq	$128, %rbx
	jne	LBB26_98
## BB#99:                               ## %getSeed.exit
	movq	-1096(%rbp), %rdi       ## 8-byte Reload
	callq	_scramble
	testb	%r13b, %r13b
	movq	-1072(%rbp), %r14       ## 8-byte Reload
	movq	-1080(%rbp), %r15       ## 8-byte Reload
	movq	-1112(%rbp), %r12       ## 8-byte Reload
	movq	-1120(%rbp), %rbx       ## 8-byte Reload
	movq	%rbx, %rdi
	je	LBB26_101
## BB#100:
	callq	_code
	jmp	LBB26_102
LBB26_101:
	callq	_decode
LBB26_102:
	leaq	L_str.46(%rip), %rdi
	callq	_puts
	movq	%rbx, %rdi
	callq	_fclose
	movq	-1088(%rbp), %rax       ## 8-byte Reload
	testb	%al, %al
	je	LBB26_105
## BB#103:
	movq	(%r14,%r15,8), %rdi
	callq	_remove
	testl	%eax, %eax
	jne	LBB26_104
LBB26_105:
	testq	%r12, %r12
	je	LBB26_107
## BB#106:
	movq	%r12, %rdi
	callq	_free
LBB26_107:
	movq	-1104(%rbp), %rdi       ## 8-byte Reload
	testq	%rdi, %rdi
	je	LBB26_109
## BB#108:
	callq	_free
LBB26_109:
	xorl	%eax, %eax
LBB26_110:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rcx
	movq	(%rcx), %rcx
	cmpq	-48(%rbp), %rcx
	jne	LBB26_115
## BB#111:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB26_55:
	movq	%r12, -1072(%rbp)       ## 8-byte Spill
	movq	%rbx, _fileName(%rip)
	movq	%rbx, %r14
	movq	%rbx, -1104(%rbp)       ## 8-byte Spill
	jmp	LBB26_59
LBB26_70:
	movq	%r12, %rdi
	callq	_perror
	leaq	L_str.54(%rip), %rdi
	callq	_puts
	movq	%r15, %rsp
	movl	$1, %eax
	jmp	LBB26_110
LBB26_104:
	movq	(%r14,%r15,8), %rdi
	callq	_perror
	jmp	LBB26_105
LBB26_75:
	movq	-1072(%rbp), %rax       ## 8-byte Reload
	movq	-1080(%rbp), %rcx       ## 8-byte Reload
	movq	(%rax,%rcx,8), %rdi
	callq	_perror
	leaq	L_str.54(%rip), %rdi
	callq	_puts
	movl	$1, %eax
	jmp	LBB26_110
LBB26_113:
	xorl	%edi, %edi
	callq	_usage
LBB26_5:
	leaq	L_str.63(%rip), %rdi
LBB26_6:
	callq	_puts
	movl	$1, %edi
	callq	_usage
LBB26_112:
	movl	$1, %edi
	callq	_usage
LBB26_115:
	callq	___stack_chk_fail
LBB26_60:
	leaq	L_str.51(%rip), %rdi
	jmp	LBB26_49
LBB26_48:
	leaq	L_str.53(%rip), %rdi
LBB26_49:
	callq	_puts
	leaq	L_str.54(%rip), %rdi
	callq	_puts
	movl	$1, %edi
	callq	_exit
LBB26_114:
	callq	_perror
	movl	$1, %edi
	callq	_usage
LBB26_26:
	leaq	L_str.59(%rip), %rdi
	jmp	LBB26_6
	.cfi_endproc

	.align	4, 0x90
_usage:                                 ## @usage
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp133:
	.cfi_def_cfa_offset 16
Ltmp134:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp135:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	subq	$40, %rsp
Ltmp136:
	.cfi_offset %rbx, -24
	movl	%edi, %ebx
	movq	___stderrp@GOTPCREL(%rip), %rax
	testl	%ebx, %ebx
	cmoveq	___stdoutp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	_progName(%rip), %rdx
	jne	LBB27_2
## BB#1:
	movq	%rdx, 32(%rsp)
	movq	%rdx, 24(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rdx, 8(%rsp)
	movq	%rdx, (%rsp)
	leaq	L_.str.37(%rip), %rsi
	xorl	%eax, %eax
	movq	%rdx, %r8
	movq	%rdx, %r9
	movq	%rdx, %rcx
	callq	_fprintf
	movl	%ebx, %edi
	callq	_exit
LBB27_2:
	leaq	L_.str.38(%rip), %rsi
	xorl	%eax, %eax
	callq	_fprintf
	movl	%ebx, %edi
	callq	_exit
	.cfi_endproc

.zerofill __DATA,__bss,_seedIndex,4,2   ## @seedIndex
.zerofill __DATA,__bss,_seed,128,4      ## @seed
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"scrambling substitution's tables, may be long..."

L_.str.1:                               ## @.str.1
	.asciz	"\rscrambling substitution's tables, may be long...(%d/16)"

.zerofill __DATA,__bss,_scrambleAsciiTables,4096,4 ## @scrambleAsciiTables
.zerofill __DATA,__bss,_usingKeyFile,1,0 ## @usingKeyFile
.zerofill __DATA,__bss,_keyFileSize,4,2 ## @keyFileSize
.zerofill __DATA,__bss,_normalised,1,0  ## @normalised
.zerofill __DATA,__bss,_passIndex,8,3   ## @passIndex
.zerofill __DATA,__bss,_passPhrase,16384,4 ## @passPhrase
.zerofill __DATA,__bss,_passPhraseSize,4,2 ## @passPhraseSize
.zerofill __DATA,__bss,_scramblingTablesOrder,16384,4 ## @scramblingTablesOrder
.zerofill __DATA,__bss,_unscrambleAsciiTables,4096,4 ## @unscrambleAsciiTables
.zerofill __DATA,__bss,_isCodingInverted,1,0 ## @isCodingInverted
.zerofill __DATA,__bss,_fileName,8,3    ## @fileName
L_.str.3:                               ## @.str.3
	.asciz	"%sx%s"

	.section	__DATA,__data
	.align	4                       ## @pathToMainFile
_pathToMainFile:
	.asciz	"./\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

	.section	__TEXT,__cstring,cstring_literals
L_.str.4:                               ## @.str.4
	.asciz	"w+"

.zerofill __DATA,__bss,_scrambling,1,0  ## @scrambling
.zerofill __DATA,__bss,_numberOfBuffer,8,3 ## @numberOfBuffer
.zerofill __DATA,__bss,__isADirectory,1,0 ## @_isADirectory
L_.str.7:                               ## @.str.7
	.asciz	"x%s"

L_.str.10:                              ## @.str.10
	.asciz	"stat"

.zerofill __DATA,__bss,_progName,8,3    ## @progName
L_.str.12:                              ## @.str.12
	.asciz	"-h"

L_.str.13:                              ## @.str.13
	.asciz	"--help"

L_.str.16:                              ## @.str.16
	.asciz	"r"

L_.str.22:                              ## @.str.22
	.asciz	"regrouping the folder in one file using tar, may be long..."

L_.str.23:                              ## @.str.23
	.asciz	"%s.tar"

L_.str.24:                              ## @.str.24
	.asciz	"cd %s && tar -cf %s %s &>/dev/null"

L_.str.27:                              ## @.str.27
	.asciz	"%s%s"

L_.str.28:                              ## @.str.28
	.asciz	"Crypt(C) or Decrypt(d):"

L_.str.29:                              ## @.str.29
	.asciz	"\033[F\033[J"

L_.str.30:                              ## @.str.30
	.asciz	"Password:"

.zerofill __DATA,__bss,_loadBar.firstCall,1,0 ## @loadBar.firstCall
.zerofill __DATA,__bss,_loadBar.startingTime,8,3 ## @loadBar.startingTime
L_.str.33:                              ## @.str.33
	.asciz	" %3d%% ["

L_.str.36:                              ## @.str.36
	.asciz	"] %.0f        \r"

L_.str.37:                              ## @.str.37
	.asciz	"%s(1)\t\t\tcopyright <Pierre-Fran\303\247ois Monville>\t\t\t%s(1)\n\nNAME\n\t%s -- crypt or decrypt any data\n\nSYNOPSIS\n\t%s [options] FILE [KEYFILE]\n\nDESCRIPTION\n\t(FR) permet de chiffrer et de d\303\251chiffrer toutes les donn\303\251es entr\303\251es en param\303\250tre. Le mot de passe demand\303\251 au d\303\251but est hash\303\251 puis sert de graine pour le PRNG(g\303\251n\303\251rateur de nombre al\303\251atoire). Le PRNG permet de fournir une cl\303\251 unique \303\251gale \303\240 la longueur du fichier \303\240 coder. La cl\303\251 unique subit un xor avec le mot de passe (le mot de passe est r\303\251p\303\251t\303\251 autant de fois que n\303\251c\303\251ssaire). Le fichier subit un xor avec cette cl\303\251 Puis un brouilleur est utilis\303\251, il m\303\251lange la table des caract\303\250res (ascii) en utilisant le PRNG et en utilisant le keyfile s'il est fourni. 16 tables de brouillages sont utilis\303\251es au total dans un ordre non pr\303\251dictible.\n\t(EN) Can crypt and decrypt any data given in argument. The password asked is hashed to be used as a seed for the PRNG(pseudo random number generator). The PRNG gives a unique key which has the same length as the source file. The key is xored with the password (the password is repeated as long as necessary). The file is then xored with this new key, then a scrambler is used. It scrambles the ascii table using the PRNG and the keyfile if it is given. 16 scramble's tables are used in an unpredictible order.\n\nOPTIONS\n\tthe options are as follows:\n\n\t-h | --help\tfurther help.\n\n\t-s (simple)\tputs the scrambler on off.\n\n\t-i (inverted)\tinverts the coding/decoding process, first it xors then it scrambles.\n\n\t-n (normalised)\tnormalises the size of the keyfile, if the keyfile is too long (over 1 cycle in the Yates and Fisher algorithm) it will be croped to complete 1 cycle\n\n\t-d (destroy)\tdelete the main file at the end of the process\n\n\tKEYFILE    \tthe path to a file which will be used to scramble the substitution's tables and choose in which order they will be used instead of the PRNG only (starting at 4 ko for the keyfile is great, however not interesting to be too heavy) \n\nEXIT STATUS\n\tthe %s program exits 0 on success, and anything else if an error occurs.\n\nEXAMPLES\n\tthe command :\t%s file1\n\n\tlets you choose between crypting or decrypting then it will prompt for a password that crypt/decrypt file1 as xfile1 in the same folder, file1 is not modified.\n\n\tthe command :\t%s file2 keyfile1\n\n\tlets you choose between crypting or decrypting, will prompt for the password that crypt/decrypt file2, uses keyfile1 to generate the scrambler then crypt/decrypt file2 as file2x in the same folder, file2 is not modified.\n\n\tthe command :\t%s -s file3\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file without using the scrambler(option 's'), resulting in using the unique key only.\n\n\tthe command :\t%s -dni file4 keyfile2\n\n\tlets you choose between crypting or decrypting, will prompt for a password that crypt/decrypt the file but generates the substitution's tables with the keyfile passing only one cycle of the Fisher & Yates algorythm(option 'n'), inverts the scrambling phase with the xoring phase(option 'i') and destroy the main file afterwards(option 'd')\n"

L_.str.38:                              ## @.str.38
	.asciz	"\nVersion : 3.0\n\nUsage : %s [options] FILE [KEYFILE]\n\nOptions :\n  -h | --help :\t\tfurther help\n  -s (simple) :\t\tput the scrambler off\n  -i (inverted) :\tinverts the coding/decoding process\n  -n (normalised) :\tnormalise the size of the keyfile\n  -d (destroy) :\tdelete the main file afterwards\n\nFILE :\t\t\tpath to the file\n\nKEYFILE :\t\tpath to a keyfile for the substitution's table\n"

	.align	4                       ## @str
L_str:
	.asciz	"\rscrambling substitution's tables... Done               "

	.align	4                       ## @str.39
L_str.39:
	.asciz	"starting encryption..."

	.align	4                       ## @str.41
L_str.41:
	.asciz	"starting decryption..."

	.align	4                       ## @str.44
L_str.44:
	.asciz	"Error : file's path is not correct, one or several directories and or file are missing"

	.align	4                       ## @str.46
L_str.46:
	.asciz	"Done                                                                  "

	.align	4                       ## @str.47
L_str.47:
	.asciz	"the password can't be empty"

	.align	4                       ## @str.49
L_str.49:
	.asciz	"\rregrouping the folder in one file using tar... Done          "

	.align	4                       ## @str.51
L_str.51:
	.asciz	"\nError : unable to tar your file"

	.align	4                       ## @str.53
L_str.53:
	.asciz	"Error : several trailing '/' in the path of your file"

L_str.54:                               ## @str.54
	.asciz	"exiting..."

	.align	4                       ## @str.55
L_str.55:
	.asciz	"Warning : without the keyFile, the option 'n'(normalised) will be ignored"

	.align	4                       ## @str.56
L_str.56:
	.asciz	"Warning : the keyFile is empty and thus will not be used"

	.align	4                       ## @str.59
L_str.59:
	.asciz	"Error : no valid option has been found"

	.align	4                       ## @str.60
L_str.60:
	.asciz	"Warning : with the option 's'(simple), the keyfile will not bu used"

	.align	4                       ## @str.61
L_str.61:
	.asciz	"Warning : the keyfile is a directory and will not be used"

	.align	4                       ## @str.62
L_str.62:
	.asciz	"Warning : with the option 'd'(delete) the main file will be deleted at the end"

	.align	4                       ## @str.63
L_str.63:
	.asciz	"Error : Too many arguments"


.subsections_via_symbols
