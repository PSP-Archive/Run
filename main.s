	.file	1 "main.c"
	.section .mdebug.eabi32
	.previous
	.section .gcc_compiled_long32
	.previous
	.text
	.align	2
	.globl	memcmp
	.set	nomips16
	.ent	memcmp
memcmp:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	blez	$6,$L2
	nop

	lb	$7,0($4)
	lb	$2,0($5)
	bne	$7,$2,$L3
	move	$3,$0

	j	$L12
	addiu	$3,$3,1

$L7:
	lb	$7,0($7)
	lb	$2,0($8)
	bne	$7,$2,$L3
	addiu	$3,$3,1

$L12:
	slt	$2,$3,$6
	addu	$7,$4,$3
	bne	$2,$0,$L7
	addu	$8,$5,$3

$L2:
	j	$31
	move	$2,$0

$L3:
	j	$31
	subu	$2,$2,$7

	.set	macro
	.set	reorder
	.end	memcmp
	.size	memcmp, .-memcmp
	.align	2
	.globl	strlen
	.set	nomips16
	.ent	strlen
strlen:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lb	$2,0($4)
	beq	$2,$0,$L20
	move	$3,$0

$L16:
	addiu	$4,$4,1
	lb	$2,0($4)
	bne	$2,$0,$L16
	addiu	$3,$3,1

$L15:
$L20:
	j	$31
	move	$2,$3

	.set	macro
	.set	reorder
	.end	strlen
	.size	strlen, .-strlen
	.align	2
	.globl	memcpy
	.set	nomips16
	.ent	memcpy
memcpy:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	blez	$6,$L26
	move	$8,$4

	move	$7,$0
$L23:
	addu	$2,$5,$7
	lbu	$4,0($2)
	addu	$3,$8,$7
	addiu	$7,$7,1
	slt	$2,$7,$6
	bne	$2,$0,$L23
	sb	$4,0($3)

$L26:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	memcpy
	.size	memcpy, .-memcpy
	.align	2
	.globl	memset
	.set	nomips16
	.ent	memset
memset:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	blez	$6,$L32
	andi	$5,$5,0x00ff

	move	$7,$0
$L29:
	addu	$3,$4,$7
	addiu	$7,$7,1
	slt	$2,$7,$6
	bne	$2,$0,$L29
	sb	$5,0($3)

$L32:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	memset
	.size	memset, .-memset
	.align	2
	.globl	decompress_kle_patched
	.set	nomips16
	.ent	decompress_kle_patched
decompress_kle_patched:
	.frame	$sp,24,$31		# vars= 0, regs= 6/0, args= 0, gp= 0
	.mask	0x801f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$20,16($sp)
	lui	$20,%hi(size_rebootex)
	lw	$2,%lo(size_rebootex)($20)
	sw	$19,12($sp)
	sw	$18,8($sp)
	sw	$17,4($sp)
	sw	$16,0($sp)
	sw	$31,20($sp)
	move	$16,$4
	move	$17,$5
	move	$18,$6
	blez	$2,$L34
	move	$19,$7

	li	$4,143654912			# 0x8900000
	addu	$5,$2,$4
	li	$6,-2140405760			# 0xffffffff806c0000
$L35:
	lbu	$3,0($4)
	addu	$2,$4,$6
	addiu	$4,$4,1
	bne	$4,$5,$L35
	sb	$3,0($2)

$L34:
	li	$4,-1996816384			# 0xffffffff88fb0000
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lui	$2,%hi(psp_model)
	lw	$5,%lo(psp_model)($2)
	lw	$4,%lo(size_rebootex)($20)
	lui	$2,%hi(decompress_kle)
	li	$3,-1996816384			# 0xffffffff88fb0000
	lw	$25,%lo(decompress_kle)($2)
	ori	$2,$3,0x4
	sw	$4,0($2)
	move	$6,$18
	sw	$5,0($3)
	move	$4,$16
	move	$5,$17
	move	$7,$19
	lw	$31,20($sp)
	lw	$20,16($sp)
	lw	$19,12($sp)
	lw	$18,8($sp)
	lw	$17,4($sp)
	lw	$16,0($sp)
	jr	$25
	addiu	$sp,$sp,24

	.set	macro
	.set	reorder
	.end	decompress_kle_patched
	.size	decompress_kle_patched, .-decompress_kle_patched
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC0:
	.ascii	"sceLoadExec\000"
	.text
	.align	2
	.globl	PatchLoadExec
	.set	nomips16
	.ent	PatchLoadExec
PatchLoadExec:
	.frame	$sp,8,$31		# vars= 0, regs= 2/0, args= 0, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-8
	lui	$4,%hi($LC0)
	li	$3,-2013200384			# 0xffffffff88010000
	addiu	$4,$4,%lo($LC0)
	sw	$31,4($sp)
	ori	$3,$3,0xe2d8
	jalr	$3
	sw	$16,0($sp)

	li	$3,-2013265920			# 0xffffffff88000000
	ori	$3,$3,0xa13c
	jalr	$3
	lw	$16,108($2)

	lui	$3,%hi(psp_model)
	li	$4,4			# 0x4
	beq	$2,$4,$L42
	sw	$2,%lo(psp_model)($3)

	lui	$2,%hi(ofs_other.2670)
	addiu	$6,$2,%lo(ofs_other.2670)
$L40:
	lui	$3,%hi(decompress_kle_patched)
	lw	$5,0($6)
	addiu	$3,$3,%lo(decompress_kle_patched)
	li	$2,67043328			# 0x3ff0000
	ori	$2,$2,0xffff
	srl	$3,$3,2
	and	$3,$3,$2
	li	$4,201326592			# 0xc000000
	or	$3,$3,$4
	addu	$5,$16,$5
	sw	$3,0($5)
	lw	$4,4($6)
	li	$2,1006698496			# 0x3c010000
	ori	$2,$2,0x88fc
	addu	$4,$16,$4
	lw	$31,4($sp)
	sw	$2,0($4)
	li	$3,1007091712			# 0x3c070000
	li	$2,-2013265920			# 0xffffffff88000000
	ori	$2,$2,0xcd30
	ori	$3,$3,0x8801
	lui	$4,%hi(decompress_kle)
	sw	$3,0($2)
	sw	$16,%lo(decompress_kle)($4)
	move	$2,$0
	lw	$16,0($sp)
	j	$31
	addiu	$sp,$sp,8

$L42:
	lui	$2,%hi(ofs_go.2669)
	j	$L40
	addiu	$6,$2,%lo(ofs_go.2669)

	.set	macro
	.set	reorder
	.end	PatchLoadExec
	.size	PatchLoadExec, .-PatchLoadExec
	.align	2
	.globl	ClearCaches
	.set	nomips16
	.ent	ClearCaches
ClearCaches:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lui	$2,%hi(sceKernelDcacheWritebackAll)
	lw	$25,%lo(sceKernelDcacheWritebackAll)($2)
	jr	$25
	nop

	.set	macro
	.set	reorder
	.end	ClearCaches
	.size	ClearCaches, .-ClearCaches
	.align	2
	.globl	FindModuleAddressByName
	.set	nomips16
	.ent	FindModuleAddressByName
FindModuleAddressByName:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lb	$9,0($4)
	bne	$9,$0,$L46
	move	$11,$5

	li	$5,157286400			# 0x9600000
$L47:
	j	$31
	subu	$2,$5,$11

$L46:
	li	$5,157286400			# 0x9600000
	li	$10,201326592			# 0xc000000
	move	$3,$4
$L59:
	move	$8,$0
$L48:
	addiu	$3,$3,1
	lb	$2,0($3)
	bne	$2,$0,$L48
	addiu	$8,$8,1

	lb	$2,0($5)
	bnel	$2,$9,$L57
	addiu	$5,$5,4

	move	$6,$0
	addiu	$6,$6,1
$L58:
	slt	$2,$6,$8
	addu	$3,$6,$5
	beq	$2,$0,$L47
	addu	$7,$4,$6

	lb	$3,0($3)
	lb	$2,0($7)
	beql	$3,$2,$L58
	addiu	$6,$6,1

	addiu	$5,$5,4
$L57:
	bnel	$5,$10,$L59
	move	$3,$4

	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	FindModuleAddressByName
	.size	FindModuleAddressByName, .-FindModuleAddressByName
	.align	2
	.globl	ReadFile
	.set	nomips16
	.ent	ReadFile
ReadFile:
	.frame	$sp,16,$31		# vars= 0, regs= 4/0, args= 0, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lui	$2,%hi(sceIoOpen)
	lw	$3,%lo(sceIoOpen)($2)
	addiu	$sp,$sp,-16
	sw	$18,8($sp)
	sw	$17,4($sp)
	sw	$16,0($sp)
	sw	$31,12($sp)
	move	$17,$5
	move	$18,$6
	li	$5,1			# 0x1
	jalr	$3
	move	$6,$0

	bltz	$2,$L61
	move	$16,$2

	lui	$2,%hi(sceIoRead)
	lw	$3,%lo(sceIoRead)($2)
	move	$4,$16
	move	$5,$17
	jalr	$3
	move	$6,$18

	lui	$3,%hi(sceIoClose)
	lw	$5,%lo(sceIoClose)($3)
	move	$4,$16
	jalr	$5
	move	$16,$2

$L61:
	lw	$31,12($sp)
	move	$2,$16
	lw	$18,8($sp)
	lw	$17,4($sp)
	lw	$16,0($sp)
	j	$31
	addiu	$sp,$sp,16

	.set	macro
	.set	reorder
	.end	ReadFile
	.size	ReadFile, .-ReadFile
	.align	2
	.globl	WriteFile
	.set	nomips16
	.ent	WriteFile
WriteFile:
	.frame	$sp,16,$31		# vars= 0, regs= 4/0, args= 0, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lui	$2,%hi(sceIoOpen)
	lw	$3,%lo(sceIoOpen)($2)
	addiu	$sp,$sp,-16
	sw	$18,8($sp)
	sw	$17,4($sp)
	sw	$16,0($sp)
	sw	$31,12($sp)
	move	$17,$5
	move	$18,$6
	li	$5,1538			# 0x602
	jalr	$3
	li	$6,511			# 0x1ff

	bltz	$2,$L64
	move	$16,$2

	lui	$2,%hi(sceIoWrite)
	lw	$3,%lo(sceIoWrite)($2)
	move	$4,$16
	move	$5,$17
	jalr	$3
	move	$6,$18

	lui	$3,%hi(sceIoClose)
	lw	$5,%lo(sceIoClose)($3)
	move	$4,$16
	jalr	$5
	move	$16,$2

$L64:
	lw	$31,12($sp)
	move	$2,$16
	lw	$18,8($sp)
	lw	$17,4($sp)
	lw	$16,0($sp)
	j	$31
	addiu	$sp,$sp,16

	.set	macro
	.set	reorder
	.end	WriteFile
	.size	WriteFile, .-WriteFile
	.section	.rodata.str1.4
	.align	2
$LC1:
	.ascii	"vsh_module\000"
	.align	2
$LC2:
	.ascii	"music_player_module\000"
	.align	2
$LC3:
	.ascii	"ms0:/rebootex.bin\000"
	.align	2
$LC4:
	.ascii	"ef0:/rebootex.bin\000"
	.section	.text.start,"ax",@progbits
	.align	2
	.globl	_start
	.set	nomips16
	.ent	_start
_start:
	.frame	$sp,24,$31		# vars= 8, regs= 4/0, args= 0, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	li	$2,1376256			# 0x150000
	ori	$10,$2,0xb7f4
	ori	$7,$2,0xb65c
	ori	$8,$2,0xb66c
	ori	$9,$2,0xb684
	ori	$2,$2,0xb674
	addiu	$sp,$sp,-24
	addu	$6,$4,$2
	addu	$7,$4,$7
	lui	$2,%hi(sceIoWrite)
	addu	$10,$4,$10
	addu	$8,$4,$8
	addu	$9,$4,$9
	sw	$7,%lo(sceIoWrite)($2)
	sw	$16,8($sp)
	lui	$3,%hi(sceIoRead)
	li	$16,196608			# 0x30000
	lui	$2,%hi(sceIoOpen)
	lui	$4,%hi($LC1)
	sw	$8,%lo(sceIoRead)($3)
	sw	$9,%lo(sceIoOpen)($2)
	lui	$3,%hi(sceIoClose)
	ori	$5,$16,0xff80
	addiu	$4,$4,%lo($LC1)
	lui	$2,%hi(sceKernelDcacheWritebackAll)
	sw	$6,%lo(sceIoClose)($3)
	sw	$31,20($sp)
	sw	$10,%lo(sceKernelDcacheWritebackAll)($2)
	sw	$18,16($sp)
	jal	FindModuleAddressByName
	sw	$17,12($sp)

	lui	$4,%hi($LC2)
	ori	$5,$16,0xd7c4
	addiu	$4,$4,%lo($LC2)
	jal	FindModuleAddressByName
	move	$18,$2

	lui	$4,%hi($LC3)
	addiu	$4,$4,%lo($LC3)
	li	$5,143654912			# 0x8900000
	li	$6,65536			# 0x10000
	move	$17,$2
	jal	ReadFile
	lui	$16,%hi(size_rebootex)

	bltz	$2,$L69
	sw	$2,%lo(size_rebootex)($16)

$L67:
	li	$16,196608			# 0x30000
	ori	$3,$16,0xd578
	li	$4,-2013265920			# 0xffffffff88000000
	move	$9,$0
	addu	$3,$17,$3
	ori	$4,$4,0xcd30
	move	$8,$0
	move	$5,$0
	move	$6,$0
	jalr	$3
	move	$7,$0

	jal	ClearCaches
	nop

	lui	$2,%hi(PatchLoadExec)
	li	$3,-2147483648			# 0xffffffff80000000
	addiu	$2,$2,%lo(PatchLoadExec)
	or	$2,$2,$3
	ori	$8,$16,0xf82c
	addiu	$3,$sp,-28
	sw	$3,4($sp)
	addu	$8,$18,$8
	addiu	$7,$sp,-16624
	move	$4,$0
	move	$5,$0
	move	$6,$0
	sw	$2,0($sp)
	jalr	$8
	ori	$16,$16,0xf99c

	jal	ClearCaches
	addu	$16,$18,$16

	jalr	$16
	move	$4,$0

	lw	$31,20($sp)
	lw	$18,16($sp)
	lw	$17,12($sp)
	lw	$16,8($sp)
	j	$31
	addiu	$sp,$sp,24

$L69:
	lui	$4,%hi($LC4)
	addiu	$4,$4,%lo($LC4)
	li	$5,143654912			# 0x8900000
	jal	ReadFile
	li	$6,65536			# 0x10000

	j	$L67
	sw	$2,%lo(size_rebootex)($16)

	.set	macro
	.set	reorder
	.end	_start
	.size	_start, .-_start
	.data
	.align	2
	.type	ofs_other.2670, @object
	.size	ofs_other.2670, 8
ofs_other.2670:
	.word	11612
	.word	11688
	.align	2
	.type	ofs_go.2669, @object
	.size	ofs_go.2669, 8
ofs_go.2669:
	.word	12200
	.word	12276

	.comm	psp_model,4,4

	.comm	size_rebootex,4,4

	.comm	decompress_kle,4,4

	.comm	sceIoWrite,4,4

	.comm	sceIoRead,4,4

	.comm	sceIoOpen,4,4

	.comm	sceIoClose,4,4

	.comm	sceKernelDcacheWritebackAll,4,4
	.ident	"GCC: (GNU) 4.3.5"
