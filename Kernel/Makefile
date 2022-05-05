# Works for nmake (Windows)

OUTNAME=SomeOS
ASMFLAGS=-f elf64
# -c				Do not link into an executable
# -ffreestanding	Do not assume the standard library behaves as usual
CCFLAGS=-c -ffreestanding -target x86_64-none-elf
CSOURCES=$(wildcard src/*.c)
# -Ttext			Set address of section
#					0x8200 is specified in BootLoader/Boot.asm in BeginLongMode
LDFLAGS=-Ttext 0x8200 --oformat binary -o $(OUTNAME).out


all: Entry.asm $(CSOURCES)
	nasm $(ASMFLAGS) Entry.asm
	clang $(CCFLAGS) src/*.c
	ld.lld $(LDFLAGS) *.o
