%{
#include<stdio.h>

int i = 0; //compteur global
int instructions[512][4]; //512 instructions + 4 operandes      -> faire une structure avec pointeur de fonctions (remplacer tADD par la fonction d'addition) + tableau d'operandes (3). Dans le while on executera uniquement la fonction associee;

int mem[512];
%}

%token tNB tADD tMUL tSOU tDIV tCOP tAFC tJMP tJMF tINF tSUP tEQU tPRI
%type <nb> Instruction
%type <nb> tNB
%union{ int nb; }

%start Instructions
%% 
Instructions : Instruction Instructions 
			|	Instruction;
Instruction : 		tADD tNB tNB tNB {instructions[i][0] = tADD; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tMUL tNB tNB tNB 	{instructions[i][0] = tMUL; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tSOU tNB tNB tNB {instructions[i][0] = tSOU; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tDIV tNB tNB tNB {instructions[i][0] = tDIV; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tCOP tNB tNB {instructions[i][0] = tCOP; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								i++;}
			| tAFC tNB tNB {instructions[i][0] = tAFC; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								i++;}
			| tJMP tNB {instructions[i][0] = tJMP; 
								instructions[i][1] = $2;
								i++;}
			| tJMF tNB tNB {instructions[i][0] = tJMF; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								i++;}
			| tINF tNB tNB tNB {instructions[i][0] = tINF; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tSUP tNB tNB tNB {instructions[i][0] = tSUP; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tEQU tNB tNB tNB {instructions[i][0] = tEQU; 
								instructions[i][1] = $2;
								instructions[i][2] = $3;
								instructions[i][3] = $4;
								i++;}
			| tPRI tNB {instructions[i][0] = tPRI; 
								instructions[i][1] = $2;
								i++;}
			;
%%			
int main(void){
	yyparse();
	int ip = 0;
	while (ip<i){
		if(instructions[n][0]==tADD){
		n[ins[ip][0]+bp]
			m[instructions[ip][1]+bp] = m[instructions[ip][2]+bp] + m[instructions[ip][3]+bp];
			n++;
		} else if(instructions[n][0]==COP){
			m[instructions[n][1]]=m[instructions[n][2]];
		} else if(instructions[n][0]==PCOPA){
			m[instructions[n][1]]=m[m[instructions[n][2]]];
		} else if(instructions[n][0]==PCOPB){
			
		} else if(instructions[n][0]==ABP){
			bp += ins[ip][1];
			ip++;
		} else if(instructions[n][0]==CALL){
			m[bp] = ip+1;
			ip = ins[ip][1];
		} else if(instructions[n][0]==RET){
			ip = m[bp];
		}
	}
}
