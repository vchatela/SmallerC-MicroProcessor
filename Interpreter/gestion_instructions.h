#ifndef __GESTION_INSTRUCTIONS_H__
#define __GESTION_INSTRUCTIONS_H__

#define NB_ARGS_MAX 3
#define NB_INSTRUCTIONS_MAX 512

typedef struct Instruction {
	
	char * id;
	int nb_args;
	int args[NB_ARGS_MAX];
	
} Instruction;

/* Initialise la liste d'instructions ainsi que le pointeur sur le fichier assembleur */
void mem_instr_init();

void mem_instr_inserer_cop(int dest, int orig);
void mem_instr_inserer_afc(int dest, int constante);
void mem_instr_inserer_jmp(int no_instruction);
void mem_instr_inserer_jmf(int adresse, int no_instruction);
void mem_instr_inserer_infeq(int resultat, int op1, int op2);
void mem_instr_inserer_supeq(int resultat, int op1, int op2);
void mem_instr_inserer_inf(int resultat, int op1, int op2);
void mem_instr_inserer_sup(int resultat, int op1, int op2);
void mem_instr_inserer_equ(int resultat, int op1, int op2);
void mem_instr_inserer_ret();
void mem_instr_inserer_call(int addr);

void mem_instr_inserer_pri(int adresse);

void mem_instr_inserer_add(int resultat, int op1, int op2);
void mem_instr_inserer_sub(int resultat, int op1, int op2);
void mem_instr_inserer_mul(int resultat, int op1, int op2);
void mem_instr_inserer_div(int resultat, int op1, int op2);

/* Renvoie dans addr_val_pointee la valeur pointée par le pointeur à l'adresse addr_pointeur */
void mem_instr_inserer_pcopa(int addr_val_pointee, int addr_pointeur) ;

/* Ecrit la valeur à l'adresse addr_valeur dans le pointeur à l'adresse addr_pointeur */
void mem_instr_inserer_pcopb(int addr_pointeur, int addr_valeur) ;

/* Met à jour le dernier saut dont la ligne de destination n'est pas connue (-1) */
void mem_instr_maj_dernier_jmx(int ligne);

/* Ferme le pointeur de fichier */
void mem_instr_fermer_fichier();

void mem_instr_afficher_instructions();

void mem_instr_generer_instructions();

/* Renvoie le nombre total d'instructions */
int mem_instr_nb_instructions();

Instruction mem_instr_get_instruction(int no);

#endif
