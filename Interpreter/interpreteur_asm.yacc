%{
	#include <stdio.h>
	#include "interpreteur_asm.h"
	#include "gestion_instructions.h"
	
	// Prototype de yylex que l'on n'utilise pas mais qui enlève un warning.
	int yylex();			
	
	// Indique les erreurs rencontrées lors du parsing du fichier C.
	void yyerror(char * s);
	
	// notre tableau de variables
	extern int variables[NB_SYMBOLES_MAX];
%}

// les mots-clefs assembleur ainsi que le token tNB
%token tADD tMUL tSUB tDIV tCOP tAFC tJMP tJMF tINF tSUP tEQU tPRI tNB tINFEQ tSUPEQ

%union { int nb; char * id; }	// crée deux champs "nb" et "id" dans yylval utilisables dans le Lex

/* C.F. Poly p29 */
%type <nb> tNB			// tout token de type tNB a une valeur numérale qui lui est associée (cf. Lex)

%start Programme		// symbole de départ

%%

Programme : Instructions;

Instructions : Instruction Instructions
			 | ;

/* On appelle les fonctions du même nom dans le fichier C */
Instruction : tADD tNB tNB tNB	{ mem_instr_inserer_add($2, $3, $4); }
			| tMUL tNB tNB tNB	{ mem_instr_inserer_mul($2, $3, $4); }
			| tSUB tNB tNB tNB	{ mem_instr_inserer_sub($2, $3, $4); }
			| tDIV tNB tNB tNB	{ mem_instr_inserer_div($2, $3, $4); }
			| tCOP tNB tNB		{ mem_instr_inserer_cop($2, $3); }
			| tAFC tNB tNB		{ mem_instr_inserer_afc($2, $3); }
			| tJMP tNB			{ mem_instr_inserer_jmp($2); }
			| tJMF tNB tNB		{ mem_instr_inserer_jmf($2, $3); }
			| tINFEQ tNB tNB tNB	{ mem_instr_inserer_infeq($2, $3, $4); }
			| tSUPEQ tNB tNB tNB	{ mem_instr_inserer_supeq($2, $3, $4); }
			| tINF tNB tNB tNB	{ mem_instr_inserer_inf($2, $3, $4); }
			| tSUP tNB tNB tNB	{ mem_instr_inserer_sup($2, $3, $4); }
			| tEQU tNB tNB tNB	{ mem_instr_inserer_equ($2, $3, $4); }
			| tPRI tNB 			{ mem_instr_inserer_pri($2); }
			;
%%

// Indique les erreurs rencontrées lors du parsing du fichier C.
void yyerror (char  * s) {
   fprintf(stderr, "<Erreur rencontree> %s\n", s);
}

int main() 
{
	yyparse();
	interpreter();
	
	return 0;
}



