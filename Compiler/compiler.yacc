%{
#include<stdio.h>
#include"table_of_symbol.h"
#include"asm.h"


int yyerror(char *s);

extern int current_row;
extern int current_row_temp;
extern int depth;
extern int counter;

FILE * f;
extern struct s_instruction prog[512];

%}

%token tMAIN
%token tID tCONST
%token tPLUS tMOINS tETOILE tDIV tEG
%token tPO tPF 
%token tAO tAF
%token tEGALITE tOU tET tSUP tSUPEG tINF tINFEG
%token tNON
%token tIF tELSE tWHILE
%token tPRINT
%token tINT
%token tNB
%token tRETURN
%token tPV tVIR tERR 

%type <variable> tID
%type <value> tNB
%type <value> EXPARITHMETIQUE

%union{int value; char * variable;}

%left tPLUS tMOINS
%right tETOILE tDIV tEG

%start Prg
%%
Prg :  Dfct Prg
	|Main;

Dfct : tINT tID tPO PARAMS tPF BODYF;

Main : tINT tMAIN tPO tPF BODY {print_table_symb();};

PARAMS : PARAM tVIR PARAMS
		| PARAM
		|;

PARAM : tINT tID ;

BODYF : tAO INSTRUCTIONS tAF;

BODY : tAO {up_depth();} DECLARATIONS INSTRUCTIONS tAF {down_depth(); };

DECLARATIONS : tINT SUITEDECLARATIONS tPV DECLARATIONS
	| tCONST tINT AFFECTATIONSCONSTS tPV DECLARATIONS {}			
	| ;

SUITEDECLARATIONS : DECLARATION tVIR SUITEDECLARATIONS
				| DECLARATION;

DECLARATION : tID 
	{add_symb($1,0,0);}
		| tID tEG EXPARITHMETIQUE 
	{add_symb($1,1,0); int * args = malloc(2*sizeof(int)); args[0] = find_symbol($1,depth); args[1] = $3; addInstruction("COP",2,args); current_row_temp = MAX-1;};

AFFECTATIONSCONSTS : AFFECTATIONSCONST tVIR AFFECTATIONSCONSTS
		| AFFECTATIONSCONST;

AFFECTATIONSCONST : tID tEG EXPARITHMETIQUE 
	{ add_symb($1,1,1); int * args = malloc(2*sizeof(int)); args[0] = find_symbol($1,depth); args[1] = $3; addInstruction("COP",2,args); current_row_temp = MAX-1;};

AFFECTATIONS : AFFECTATION tVIR AFFECTATIONS
		| AFFECTATION;

AFFECTATION : tID tEG EXPARITHMETIQUE 
	{ int * args = malloc(2*sizeof(int)); args[0] = find_symbol($1,depth); args[1] = $3; addInstruction("COP",2,args); current_row_temp = MAX-1;};

INSTRUCTIONS : 	AFFECTATIONS tPV INSTRUCTIONS
			| 	WHILE INSTRUCTIONS
			|	IF INSTRUCTIONS	
			| 	RETURN
			|	tPV
			| 	PRINT
			|;

EXPARITHMETIQUE : EXPARITHMETIQUE tPLUS EXPARITHMETIQUE 
	{int * args = malloc(3*sizeof(int)); args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("ADD",3,args); $$ = $1;current_row_temp++;}
				| EXPARITHMETIQUE tMOINS EXPARITHMETIQUE 
	{int * args = malloc(3*sizeof(int)); args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("SOU",3,args); $$ = $1;current_row_temp++;}
				| EXPARITHMETIQUE tETOILE EXPARITHMETIQUE 
	{int * args = malloc(3*sizeof(int)); args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("MUL",3,args); $$ = $1;current_row_temp++;}
				| EXPARITHMETIQUE tDIV EXPARITHMETIQUE 
	{int * args = malloc(3*sizeof(int)); args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("DIV",3,args); $$ = $1;current_row_temp++;}
				| tPO EXPARITHMETIQUE tPF 
	{$$ = $2;}
				| tNB 
	{ int * args = malloc(2*sizeof(int)); args[0] = current_row_temp; args[1] = $1; addInstruction("AFC",2,args); $$ = current_row_temp; current_row_temp--;}
				| tID 
	{ int * args = malloc(2*sizeof(int)); args[0] = current_row_temp; args[1] = find_symbol($1,depth); addInstruction("COP",2,args); $$ = current_row_temp; current_row_temp--;};

EXPCONDITIONNELLE : EXPARITHMETIQUE tOU EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tET EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tINFEG EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tINF EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tSUPEG EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tSUP EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tEGALITE EXPARITHMETIQUE
				| 	tPO EXPARITHMETIQUE tPF
				| 	tNON EXPARITHMETIQUE;

IF : tIF tPO EXPCONDITIONNELLE tPF BODY SUITEIF;

SUITEIF : tELSE BODY
		| ;

WHILE : tWHILE tPO EXPCONDITIONNELLE tPF BODY;

RETURN : tRETURN EXPARITHMETIQUE tPV
		| tRETURN tID tPV
		| tRETURN tPV;

PRINT : tPRINT tPO tID tPF tPV;


%%
int yyerror(char *s) {
 fprintf(stderr,"%s\n",s);
}

int main(void) {
	counter = 0;	
	init_tab_symb();
	f = fopen("assembler.asm","w");
	yyparse();	
	//write prog to file	
	writeProgramToFile(f);
	fclose(f);
}
