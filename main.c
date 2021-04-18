#include <pspsdk.h>

#define PSP_O_RDONLY	0x0001
#define PSP_O_WRONLY	0x0002
#define PSP_O_RDWR	(PSP_O_RDONLY | PSP_O_WRONLY)
#define PSP_O_NBLOCK	0x0004
#define PSP_O_DIROPEN	0x0008	// Internal use for dopen
#define PSP_O_APPEND	0x0100
#define PSP_O_CREAT	0x0200
#define PSP_O_TRUNC	0x0400
#define	PSP_O_EXCL	0x0800
#define PSP_O_NOWAIT	0x8000

int memcmp(char *m1, char *m2, int size)
{
	int i;
	for(i = 0; i < size; i++) if(m1[i] != m2[i]) return m2[i] - m1[i];
	return 0;
}

int strlen(char *str)
{
	int i = 0;
	while(*str)
	{
		str++;
		i++;
	}
	return i;
}

void memcpy(u8 *m1, u8 *m2, int size)
{
	int i;
	for(i = 0; i < size; i++) m1[i] = m2[i];
}

#define MAKE_CALL(a, f) _sw(0x0C000000 | (((u32)(f) >> 2) & 0x03FFFFFF), a);

int psp_model;

int size_rebootex;

__attribute__((noinline)) void memset(u8 *m1, int c, int size)
{
	int i;
	for(i = 0; i < size; i++) m1[i] = c;
}

int (* decompress_kle)(void *outbuf, u32 outcapacity, void *inbuf, void *unk);

int decompress_kle_patched(void *outbuf, u32 outcapacity, void *inbuf, void *unk)
{
	memcpy((void *)0x88FC0000, (void *)0x08900000, size_rebootex);

	memset((void *)0x88FB0000, 0, 0x20);
	*(u32 *)0x88FB0000 = psp_model;
	*(u32 *)0x88FB0004 = size_rebootex;

	return decompress_kle(outbuf, outcapacity, inbuf, unk);
}

#define LOADCORE_ADDR 0x88017000

int PatchLoadExec()
{
	u32 *(*sceKernelFindModuleByName638)(const char *name) = (void *)LOADCORE_ADDR + 0x72D8;

	u32 *mod = (u32 *)sceKernelFindModuleByName638("sceLoadExec");
	u32 text_addr = *(mod + 27);

	int (* sceKernelGetModel638)() = (void *)0x8800A13C;
	psp_model = sceKernelGetModel638();

	static u32 ofs_go[] = { 0x2FA8, 0x2FF4 };
	static u32 ofs_other[] = { 0x2D5C, 0x2DA8 };

	u32 *ofs = ofs_other;
	if(psp_model == 4) ofs = ofs_go;

	decompress_kle = (void *)text_addr;
	MAKE_CALL(text_addr + ofs[0], decompress_kle_patched);
	_sw(0x3C0188FC, text_addr + ofs[1]);

	/* Repair sysmem */
	_sw(0x3C078801, 0x8800CD30);

	return 0;
}

int (* sceIoWrite)();
int (* sceIoRead)();
int (* sceIoOpen)();
int (* sceIoClose)();
int (* sceKernelDcacheWritebackAll)();

void ClearCaches()
{
	/* Clear Icache */
	int i = 0;
	while(i < 0x100000) i++;

	/* Clear Dcache */
	sceKernelDcacheWritebackAll();
}

u32 FindModuleAddressByName(char *name, u32 name_offset)
{
	u32 mem;
	for(mem = 0x09600000; mem < (0x08800000 + (56 << 20)); mem += 4)
	{
		if(memcmp((char *)mem, name, strlen(name)) == 0)
		{
			return mem - name_offset;
		}
	}

	return 0;
}

int ReadFile(char *file, void *buf, int size)
{
	int fd = sceIoOpen(file, PSP_O_RDONLY, 0);
	if(fd < 0) return fd;
	int read = sceIoRead(fd, buf, size);
	sceIoClose(fd);
	return read;
}

int WriteFile(char *file, void *buf, int size)
{
	int fd = sceIoOpen(file, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_TRUNC, 0777);
	if(fd < 0) return fd;
	int written = sceIoWrite(fd, buf, size);
	sceIoClose(fd);
	return written;
}

void _start(u32 text_addr) __attribute__((section(".text.start")));
void _start(u32 text_addr)
{
	sceIoWrite = (void *)text_addr + 0x15B65C;
	sceIoRead = (void *)text_addr + 0x15B66C;
	sceIoOpen = (void *)text_addr + 0x15B684;
	sceIoClose = (void *)text_addr + 0x15B674;
	sceKernelDcacheWritebackAll = (void *)text_addr + 0x15B7F4;

	u32 vsh_addr = FindModuleAddressByName("vsh_module", 0x3FF80);
	u32 music_addr = FindModuleAddressByName("music_player_module", 0x3D7C4);

	int (* vshKernelExitVSHVSH)() = (void *)vsh_addr + 0x3F99C;
	int (* sceKernelVolatileMemLock)() = (void *)vsh_addr + 0x3F82C;
	int (* sceVshBridge_C5EEA964)() = (void *)music_addr + 0x3D578;

	/* Load rebootex */
	size_rebootex = ReadFile("ms0:/rebootex.bin", (void *)0x08900000, 0x10000);
	if(size_rebootex < 0)
	{
		size_rebootex = ReadFile("ef0:/rebootex.bin", (void *)0x08900000, 0x10000);
	}

	/* Patch sceKernelVolatileMemLock */
	/* Overwrite 0x8800CD30 with -1 */
	/* I don't know why it works o.O */
	sceVshBridge_C5EEA964(0x8800CD30, 0, 0, 0, 0, 0);
	ClearCaches();

	/* Patch sceLoadExec from kmode */
	u32 var1 = (u32)((u32)PatchLoadExec | 0x80000000);
	u32 var2 = ((u32)&var1) - 0x1C;
	sceKernelVolatileMemLock(0, 0, 0, ((u32)&var2) - 0x40F4);
	ClearCaches();

	vshKernelExitVSHVSH(0);
}