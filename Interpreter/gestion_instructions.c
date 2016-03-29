
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gestion_instructions.h"

// Pointeur sur notre fichier assembleur
FILE * fic_assembleur;

struct Mem_Instructions {

	int nb_instructions;
	struct Instruction instructions[NB_INSTRUCTIONS_MAX];

} mem_instr;


void mem_instr_init() {
	mem_instr.nb_instructions = 0;
	// ouvrir le fichier assembleur
	fic_assembleur = (FILE *)fopen("assembler.asm", "w+");
}

void mem_instr_inserer_cop(int dest, int orig) {
	
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 2;
	mem_instr.instructions[mem_instr.nb_instructions].id = "COP";
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = dest;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = orig;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_afc(int dest, int constante) {

	mem_instr.instructions[mem_instr.nb_instructions].id = "AFC";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 2;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = dest;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = constante;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_jmp(int no_instruction) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "JMP";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 1;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = no_instruction;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_jmf(int adresse, int no_instruction) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "JMF";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 2;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = adresse;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = no_instruction;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_inf(int resultat, int op1, int op2) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "INF";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_infeq(int resultat, int op1, int op2) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "INFEQ";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_supeq(int resultat, int op1, int op2) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "SUPEQ";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_sup(int resultat, int op1, int op2) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "SUP";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_equ(int resultat, int op1, int op2) {

	mem_instr.instructions[mem_instr.nb_instructions].id = "EQU";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_pri(int adresse) {

	mem_instr.instructions[mem_instr.nb_instructions].id = "PRI";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 1;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = adresse;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_add(int resultat, int op1, int op2) {

	
	mem_instr.instructions[mem_instr.nb_instructions].id = "ADD";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_sub(int resultat, int op1, int op2) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "SUB";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_mul(int resultat, int op1, int op2) {

	
	mem_instr.instructions[mem_instr.nb_instructions].id = "MUL";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_div(int resultat, int op1, int op2) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "DIV";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 3;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = resultat;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = op1;
	mem_instr.instructions[mem_instr.nb_instructions].args[2] = op2;
	
	mem_instr.nb_instructions++;
}


void mem_instr_inserer_pcopa(int addr_val_pointee, int addr_pointeur) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "PCOPA";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 2;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = addr_val_pointee;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = addr_pointeur;
	
	mem_instr.nb_instructions++;
}

void mem_instr_inserer_pcopb(int addr_pointeur, int addr_valeur) {
	
	mem_instr.instructions[mem_instr.nb_instructions].id = "PCOPB";
	mem_instr.instructions[mem_instr.nb_instructions].nb_args = 2;
	mem_instr.instructions[mem_instr.nb_instructions].args[0] = addr_pointeur;
	mem_instr.instructions[mem_instr.nb_instructions].args[1] = addr_valeur;
	
	mem_instr.nb_instructions++;
}

void mem_instr_maj_dernier_jmx(int ligne) {
	int i = mem_instr.nb_instructions - 1, continuer = 1;
	
	// parcourir toutes les instructions jusqu'à ce que l'on tombe sur un jmp ou un jmf
	while (i >= 0 && continuer) {
		// on saute à la dernière ligne de l'assembleur généré
		if (strcmp("JMP", mem_instr.instructions[i].id) == 0 && mem_instr.instructions[i].args[0] == -1) {
			mem_instr.instructions[i].args[0] = ligne;
			continuer = 0;
		}
		else if (strcmp("JMF", mem_instr.instructions[i].id) == 0 && mem_instr.instructions[i].args[1] == -1) {
			mem_instr.instructions[i].args[1] = ligne;
			continuer = 0;
		}
		i--;
	}
	
}

void mem_instr_afficher_instructions() {

	int i, j;
	
	for (i = 0; i < mem_instr.nb_instructions ; i++) {
		
		printf("%s ", mem_instr.instructions[i].id);
		
		for (j = 0; j < mem_instr.instructions[i].nb_args; j++) {
			printf("%d ", mem_instr.instructions[i].args[j]);
		}
		
		printf("\n");
	
	}
}

void mem_instr_generer_instructions() {

	int i, j;
	
	for (i = 0; i < mem_instr.nb_instructions ; i++) {
		
		fprintf(fic_assembleur, "%s ", mem_instr.instructions[i].id);
		
		for (j = 0; j < mem_instr.instructions[i].nb_args; j++) {
			fprintf(fic_assembleur, "%d ", mem_instr.instructions[i].args[j]);
		}
		fprintf(fic_assembleur, "\n");
	}
}

int mem_instr_nb_instructions() {
	return mem_instr.nb_instructions;
}

Instruction mem_instr_get_instruction(int no) {
	return mem_instr.instructions[no];
}

void mem_instr_fermer_fichier() {
	// fermer le fichier assembleur
	fclose(fic_assembleur);
}

