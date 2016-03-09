#include"asm.h"

void writeProgramToFile(FILE * f){
	int i,j;
	for(i=0; i< counter; i++){
		fprintf(f,"%s ",prog[i].codeOp);
		for(j=0;j< prog[i].nb_args; j++){
			fprintf(f, "%d ",prog[i].args[j]);
		}
		fprintf(f,"\n");
	}
}

void addInstruction(char * code, int nb, int * args){
	strcpy(prog[counter].codeOp,code); prog[counter].nb_args = nb;
	int i;
	for(i=0;i<nb;i++){
		prog[counter].args[i]=args[i];
	}
	counter ++;
	free(args);
}
