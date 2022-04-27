@echo off
cd BootLoader
nasm Boot.asm -f bin -o Boot.bin
cd ..

cd Kernel
nmake
cd ..

cp BootLoader/Boot.bin SomeOS.img
cat Kernel/SomeOS.out >> SomeOS.img
echo File size:
wc -c < SomeOS.img
qemu-system-x86_64 -drive format=raw,file=SomeOS.img -D log.txt -d cpu_reset

@REM qemu-system-x86_64 Boot.bin -D log.txt -d cpu_reset
