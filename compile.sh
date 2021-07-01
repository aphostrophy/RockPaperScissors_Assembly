nasm -f elf32 -o RPS.o RPS.asm
ld -m elf_i386 -o RPS RPS.o