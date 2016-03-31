#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "interpreteur_asm.h"
#include "gestion_instructions.h"

int no_instr_courante;				// Program Counter qui représente le numéro d'instruction courant
int mem_donnees[NB_SYMBOLES_MAX];	// tableau qui contient toutes les valeurs de variables

void add(int addr_resultat, int addr_op1, int addr_op2)
{
	mem_donnees[addr_resultat] = mem_donnees[addr_op1] + mem_donnees[addr_op2];
	no_instr_courante++;
}

void sub(int addr_resultat, int addr_op1, int addr_op2)
{
	mem_donnees[addr_resultat] = mem_donnees[addr_op1] - mem_donnees[addr_op2];
	no_instr_courante++;
}

void mul(int addr_resultat, int addr_op1, int addr_op2)
{
	mem_donnees[addr_resultat] = mem_donnees[addr_op1] * mem_donnees[addr_op2];
	no_instr_courante++;
}

void div(int addr_resultat, int addr_op1, int addr_op2)
{
	mem_donnees[addr_resultat] = mem_donnees[addr_op1] / mem_donnees[addr_op2];
	no_instr_courante++;
}

void cop(int addr_resultat, int addr_op)
{
	mem_donnees[addr_resultat] = mem_donnees[addr_op];
	no_instr_courante++;
}

void pcopa(int addr_resultat, int addr_op)
{
	mem_donnees[addr_resultat] = mem_donnees[mem_donnees[addr_op]];
	no_instr_courante++;
}

void pcopb(int addr_resultat, int addr_op)
{
	mem_donnees[mem_donnees[addr_resultat]] = mem_donnees[addr_op];
	no_instr_courante++;
}

void afc(int addr_resultat, int val_const)
{
	mem_donnees[addr_resultat] = val_const;
	no_instr_courante++;
}

void pri(int addr_resultat)
{
	printf("\t\t\t---> Valeur contenue a l'adresse %3d : %d", addr_resultat, mem_donnees[addr_resultat]);	
	no_instr_courante++;
}

void ret(){
    //restore le contexte et met la valeur de retour au bon endroit
  no_instr_courante++;
}

void call(int addr){
    //sauvegarde le contexte
  no_instr_courante++;
}

void inf(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] < mem_donnees[addr_op2])
	{
		mem_donnees[addr_resultat] = 1;		
	}
	else
	{
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}

void sup(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] > mem_donnees[addr_op2])	{
		mem_donnees[addr_resultat] = 1;		
	}
	else {
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}
void infeq(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] <= mem_donnees[addr_op2])
	{
		mem_donnees[addr_resultat] = 1;		
	}
	else
	{
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}

void supeq(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] >= mem_donnees[addr_op2])	{
		mem_donnees[addr_resultat] = 1;		
	}
	else {
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}

void equ(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] == mem_donnees[addr_op2])	{
		mem_donnees[addr_resultat] = 1;		
	}
	else {
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}

void and(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] && mem_donnees[addr_op2])	{
		mem_donnees[addr_resultat] = 1;		
	}
	else {
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}

void or(int addr_resultat, int addr_op1, int addr_op2)
{
	if (mem_donnees[addr_op1] || mem_donnees[addr_op2])	{
		mem_donnees[addr_resultat] = 1;		
	}
	else {
		mem_donnees[addr_resultat] = 0;
	}
	no_instr_courante++;
}

void jmp(int ligne) {
	no_instr_courante = ligne;
}

void jmf(int cond, int ligne) {
	if (mem_donnees[cond] == 0) {
		no_instr_courante = ligne;
	}
	else {
		no_instr_courante++;
	}
}

void interpreter() {
	int i;
	Instruction instruction_courante;
	
	no_instr_courante = 0;
	
	while (no_instr_courante < mem_instr_nb_instructions()) {
		instruction_courante = mem_instr_get_instruction(no_instr_courante);
		
		printf("%3d. %s ", no_instr_courante, instruction_courante.id);
		for (i = 0; i < instruction_courante.nb_args; i++) {
			printf("%3d ", instruction_courante.args[i]);
		}

		if (strcmp("ADD", instruction_courante.id) == 0) {
			add(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			// printf("\t{%d@<%d> = %d@<%d> + %d<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2]); 
		} else if (strcmp("SOU", instruction_courante.id) == 0) {
			sub(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			// printf("\t{%d@<%d> = %d@<%d> - %d<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2]); 
		} else if (strcmp("AND", instruction_courante.id) == 0) {
			and(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			// printf("\t{%d@<%d> = %d@<%d> - %d<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2]); 
		} else if (strcmp("OR", instruction_courante.id) == 0) {
			or(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			// printf("\t{%d@<%d> = %d@<%d> - %d<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2]); 
		} else if (strcmp("RET", instruction_courante.id) == 0) {
			ret();
		} else if (strcmp("CALL", instruction_courante.id) == 0) {
			call(instruction_courante.args[0]); 
		} else if (strcmp("MUL", instruction_courante.id) == 0) {
			mul(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			// printf("\t{%d@<%d> = %d@<%d> * %d<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2]); 
		} else if (strcmp("DIV", instruction_courante.id) == 0) {
			div(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			// printf("{\t%d@<%d> = %d@<%d> / %d<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2]); 
		} else if (strcmp("COP", instruction_courante.id) == 0) {
			cop(instruction_courante.args[0], instruction_courante.args[1]);
			// printf("\t\t{%d@<%d> <- %d@<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1]); 
		} else if (strcmp("PCOPA", instruction_courante.id) == 0) {
			cop(instruction_courante.args[0], instruction_courante.args[1]);
			// printf("\t\t{%d@<%d> <- %d@<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1]); 
		} else if (strcmp("PCOPB", instruction_courante.id) == 0) {
			cop(instruction_courante.args[0], instruction_courante.args[1]);
			// printf("\t\t{%d@<%d> <- %d@<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1]); 
		} else if (strcmp("AFC", instruction_courante.id) == 0) {
			afc(instruction_courante.args[0], instruction_courante.args[1]);
			// printf("\t\t{%d@<%d> <- %d@<%d>}", mem_donnees[instruction_courante.args[0]], instruction_courante.args[0], mem_donnees[instruction_courante.args[1]], instruction_courante.args[1]); 
		} else if (strcmp("PRI", instruction_courante.id) == 0) {
			pri(instruction_courante.args[0]);
		} else if (strcmp("INF", instruction_courante.id) == 0) {
			inf(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			printf("\t\t{ %d (@%d) < %d(@%d) ? %d(@%d) }", mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2], mem_donnees[instruction_courante.args[0]], instruction_courante.args[0]); 
		} else if (strcmp("INFEQ", instruction_courante.id) == 0) {
			infeq(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			printf("\t\t{ %d (@%d) < %d(@%d) ? %d(@%d) }", mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2], mem_donnees[instruction_courante.args[0]], instruction_courante.args[0]); 
		} else if (strcmp("SUP", instruction_courante.id) == 0) {
			sup(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			printf("\t\t{ %d (@%d) > %d(@%d) ? %d(@%d) }", mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2], mem_donnees[instruction_courante.args[0]], instruction_courante.args[0]); 
		} else if (strcmp("SUPEQ", instruction_courante.id) == 0) {
			supeq(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			printf("\t\t{ %d (@%d) > %d(@%d) ? %d(@%d) }", mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2], mem_donnees[instruction_courante.args[0]], instruction_courante.args[0]); 
		} else if (strcmp("EQU", instruction_courante.id) == 0) {
			equ(instruction_courante.args[0], instruction_courante.args[1], instruction_courante.args[2]);
			printf("\t\t{ %d (@%d) = %d(@%d) ? %d(@%d) }", mem_donnees[instruction_courante.args[1]], instruction_courante.args[1], mem_donnees[instruction_courante.args[2]], instruction_courante.args[2], mem_donnees[instruction_courante.args[0]], instruction_courante.args[0]); 
		} else if (strcmp("JMP", instruction_courante.id) == 0) {
			jmp(instruction_courante.args[0]);
			printf("\t\t\t{ Saut a la ligne %d }\n", instruction_courante.args[0]);
			printf("---------------------------------------------------------------");
		   	sleep(1);	
		} else if (strcmp("JMF", instruction_courante.id) == 0) {
			jmf(instruction_courante.args[0], instruction_courante.args[1]);
			if (mem_donnees[instruction_courante.args[0]] == 0) {
				printf("\t\t{ La condition a l'adresse %d est fausse, on saute a la ligne %d. }\n", instruction_courante.args[0], instruction_courante.args[1]);
			printf("---------------------------------------------------------------");
			}
			else {
				printf("\t\t{ La condition a l'adresse %d est vraie, on continue a la ligne %d. } ", instruction_courante.args[0], no_instr_courante);
			}
			sleep(1);
		}
		
		printf("\n");	
	}
}
