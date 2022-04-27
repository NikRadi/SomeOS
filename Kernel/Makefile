# Works for nmake (Windows)

OUTNAME=SomeOS
ASMFLAGS=-f elf64
# -c				Do not link into an executable
# -ffreestanding	Do not assume the standard library behaves as usual
CCFLAGS=-c -ffreestanding -target x86_64-none-elf
# -Ttext			Set address of section
LDFLAGS=-Ttext 0x8200 --oformat binary -o $(OUTNAME).out


all:
	nasm $(ASMFLAGS) Entry.asm
	clang $(CCFLAGS) src\*.c
	ld.lld $(LDFLAGS) *.o
