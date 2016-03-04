%{
#include<stdio.h>
#include"table_of_symbol.h"

int yyerror(char *s);
extern int current_row;
extern int current_row_temp;
extern int depth;
FILE * f;
%}

%token tMAIN
%token tID tCONST
%token tPLUS tMOINS tFOIS tMOD tDIV tEG
%token tPO tPF 
%token tAO tAF
%token tEGALITE tOU tET tSUP tSUPEG tINF tINFEG
%token tNON
%token tIF tWHILE
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
%right tFOIS tDIV tEG

%start Prg
%%
Prg :  Dfct Prg
	|Main;

Dfct : tINT tID tPO PARAMS tPF BODYF;

Main : tINT tMAIN tPO tPF BODY {print_table();};

PARAMS : PARAM tVIR PARAMS
		| PARAM
		|;

PARAM : tINT tID ;

BODYF : tAO INSTRUCTIONS tAF;

BODY : tAO {up_depth();} DECLARATIONS INSTRUCTIONS tAF {/*delete_depth_at();*/down_depth(); };

DECLARATIONS : tINT SUITEDECLARATIONS tPV DECLARATIONS
	| tCONST tINT AFFECTATIONSCONSTS tPV DECLARATIONS {}			
	| ;

SUITEDECLARATIONS : DECLARATION tVIR SUITEDECLARATIONS
				| DECLARATION;

DECLARATION : tID {add_symb($1,0,0);}
		| tID tEG EXPARITHMETIQUE {add_symb($1,1,0); fprintf(f,"COP %d %d\n",find_symbol($1,depth),$3); current_row_temp = MAX-1;};

AFFECTATIONSCONSTS : AFFECTATIONSCONST tVIR AFFECTATIONSCONSTS
		| AFFECTATIONSCONST;

AFFECTATIONSCONST : tID tEG EXPARITHMETIQUE { add_symb($1,1,1); fprintf(f,"COP %d %d\n",find_symbol($1,depth),$3); current_row_temp = MAX-1;};

AFFECTATIONS : AFFECTATION tVIR AFFECTATIONS
		| AFFECTATION;

AFFECTATION : tID tEG EXPARITHMETIQUE { fprintf(f,"COP %d %d\n",find_symbol($1,depth),$3); current_row_temp = MAX-1;};

INSTRUCTIONS : 	AFFECTATIONS tPV INSTRUCTIONS
			| 	WHILE INSTRUCTIONS
			|	IF INSTRUCTIONS	
			| 	RETURN
			|	tPV
			| 	PRINT
			|;

EXPARITHMETIQUE : EXPARITHMETIQUE tPLUS EXPARITHMETIQUE {fprintf(f,"ADD %d %d %d\n",$1,$1,$3); $$ = $1;current_row_temp++;}
				| EXPARITHMETIQUE tMOINS EXPARITHMETIQUE
				| EXPARITHMETIQUE tFOIS EXPARITHMETIQUE
				| EXPARITHMETIQUE tDIV EXPARITHMETIQUE
				| EXPARITHMETIQUE tMOD EXPARITHMETIQUE
				| tPO EXPARITHMETIQUE tPF {$$ = $2;}
				| tNB { fprintf(f,"AFC %d %d\n",current_row_temp,$1); $$ = current_row_temp; current_row_temp--;}
				| tID {fprintf(f,"COP %d %d\n",current_row_temp,find_symbol($1,depth)); $$ = current_row_temp; current_row_temp--;};

EXPCONDITIONNELLE : EXPARITHMETIQUE tOU EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tET EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tINFEG EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tINF EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tSUPEG EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tSUP EXPARITHMETIQUE
				| 	EXPARITHMETIQUE tEGALITE EXPARITHMETIQUE
				| 	tPO EXPARITHMETIQUE tPF
				| 	tNON EXPARITHMETIQUE;

IF : tIF tPO EXPCONDITIONNELLE tPF BODY;

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
	init_tab();
	f = fopen("assembler.asm","w");
  yyparse();
	fclose(f);
}
