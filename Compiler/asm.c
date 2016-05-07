#include"asm.h"

void writeProgramToFile(FILE * f){
	int i,j;
	int args[3];
	for(i=0; i< counter; i++){
	    fprintf(f,"%s ",prog[i].codeOp);
	    for(j=0;j< prog[i].nb_args; j++){
		    fprintf(f, "%d ",prog[i].args[j]);
	    }
	    fprintf(f,"\n");
	}
	/*on ne garde pas le dernier jump*/
	if(strcmp(prog[++i].codeOp,"JMP") == 0){
	      // on l'ignore
	}
}

void addInstruction(char * code, int nb, int * args){
	strcpy(prog[counter].codeOp,code); prog[counter].nb_args = nb;
	int i;
	for(i=0;i<nb;i++){
		prog[counter].args[i]=args[i];
	}
	counter ++;
}

void updateJMF(int pos, int to){
	prog[pos].args[1]=to;
} 

void updateJMP(int pos, int to){
	prog[pos].args[0] = to;
}

void suiteIfJMF(int pos, int to){
	prog[pos].args[1]+=to;
} 