#ifndef ASM_H
#define ASM_H

#include<stdio.h>
#include<string.h>
#include<stdlib.h> 
#define MAX 512

struct s_instruction{
	char codeOp[6];
	int args[4];
	int nb_args;
};

struct s_instruction prog[MAX];
int counter;

void addInstruction(char * code, int nb, int * args);
void writeProgramToFile(FILE * f);
void updateJMF(int pos, int to);
void updateJMP(int pos, int to);
void suiteIfJMP(int pos, int to);
#endif
