NASM = nasm
LD = ld

.PHONY: all clean

all: \
	FILE_01_Trigonometric.o \
	FILE_02_Complex.o \
	FILE_03_Matrix.o \
	FILE_04_IrrationalWave.o \
	FILE_05_LinearPolymeric.o \
	FILE_06_Parabolic.o \
	FILE_07_Logarithmic.o \
	FILE_08_ExpModInvTrig.o \
	FILE_09_Derivatives.o \
	FILE_10_Integrals.o

%.o: %.asm
	$(NASM) -f elf64 $< -o $@

clean:
	rm -f *.o
