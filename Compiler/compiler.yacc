%{
#include<stdio.h>
#include"table_of_symbol.h"
#include"table_of_function.h"
#include"asm.h"


int yyerror(char *s);
int error= 0;
extern int current_row;
extern int current_row_temp;
extern int depth;
extern int counter;

FILE * f;
extern struct s_instruction prog[512];
/*pointer d'instruction*/
%}

%token tMAIN
%token tID tCONST
%token tPLUS tMOINS tETOILE tDIV tEG
%token tPO tPF tCO tCF
%token tAO tAF
%token tEGALITE tOU tET tSUP tSUPEG tINF tINFEG
%token tNON
%token tIF tELSE tWHILE
%token tPRINT
%token tINT
%token tNB
%token tRETURN
%token tPV tVIR tADDR tERR 

%type <variable> tID
%type <value> tNB
%type <value> SUITEPARAMS
%type <value> SUITEPARAMSFUNCT
%type <value> PARAMS
%type <value> tWHILE
%type <value> tIF
%type <value> EXPARITHMETIQUE
%type <value> EXPCONDITIONNELLE
%type <value> AFFECTATION
%type <value> tELSE
%type <value> tPO

%union{int value; char * variable;}

%left tPLUS tMOINS
%right tETOILE tDIV tEG

%start Prg
%%

Prg : Dfct Prg
	|Main;

Dfct : tINT tID tPO PARAMS tPF {add_funct($2,0,$4,counter);} BODY {addInstruction("RET",0,NULL);}
	/*| tINT tETOILE tID tPO PARAMS tPF BODY {}*/
	;

Main : tINT tMAIN {add_funct("main",0,0,counter);} tPO tPF BODY {print_table_funct();};

PARAMS : SUITEPARAMS {$$ = $1;}
		| {$$ = 0;};

SUITEPARAMS : PARAM tVIR SUITEPARAMS {$$ = 1 + $3;}
	| PARAM {$$ = 1;};

PARAM : tINT tID {/*QUOI EN FAIRE*/}
	/*| tINT tETOILE tID {}*/
	; 
	
BODY : tAO {up_depth();} DECLARATIONS INSTRUCTIONS {/*print_table_symb();*/} tAF {delete_depth_at();down_depth(); };

DECLARATIONS : tINT SUITEDECLARATIONS tPV DECLARATIONS
	| tCONST tINT AFFECTATIONSCONSTS tPV DECLARATIONS 
	| tINT tID tCO tNB tCF tPV  {int i; for(i = 0; i<$4;i++){add_symb($2,0,0,$4);}} DECLARATIONS			
	| ;

SUITEDECLARATIONS : DECLARATION tVIR SUITEDECLARATIONS
				| DECLARATION;

DECLARATION : tID 
	{add_symb($1,0,0,1);}
		| tID tEG EXPARITHMETIQUE 
	{ add_symb($1,1,0,1); int args[2]; args[0] = find_symbol($1,depth); args[1] = $3; addInstruction("COP",2,args); current_row_temp--;}
		| tETOILE tID
	{add_symb($2,0,0,1);}
		| tETOILE tID tEG EXPARITHMETIQUE
	{add_symb($2,0,0,1); int args[2]; args[0] = find_symbol($2,depth); args[1] = $4; addInstruction("COP",2,args); current_row_temp--;}
		| tETOILE tID tEG tADDR tID
	{add_symb($2,1,0,1); int args[2]; args[0] = current_row_temp ; args[1]=find_symbol($5,depth); addInstruction("AFC",2,args) ;args[0] = find_symbol($2,depth); args[1] = current_row_temp; addInstruction("PCOPB",2,args);}
		;

AFFECTATIONSCONSTS : AFFECTATIONSCONST tVIR AFFECTATIONSCONSTS
		| AFFECTATIONSCONST;

AFFECTATIONSCONST : tID tEG EXPARITHMETIQUE 
	{ add_symb($1,1,1,1); int args[2]; args[0] = find_symbol($1,depth); args[1] = $3; addInstruction("COP",2,args); current_row_temp--;}
		| tETOILE tID tEG tADDR tID
	{add_symb($2,1,1,1); int args[2]; args[0] = current_row_temp ; args[1]=find_symbol($5,depth); addInstruction("AFC",2,args) ;args[0] = find_symbol($2,depth); args[1] = current_row_temp; addInstruction("PCOPB",2,args);};

AFFECTATIONS : AFFECTATION tVIR { current_row_temp--;} AFFECTATIONS
		| AFFECTATION{ current_row_temp--;} ;

AFFECTATION : tID tEG EXPARITHMETIQUE
	{ int pos = find_symbol($1,depth); 
if(pos==-1){yyerror("Id n'existe pas.");}
else{ if(getSymb(pos)->isConst){yyerror("Attention affectation sur un const.");/*TODO il serait bien d'afficher la ligne*/}
	else{ int args[2]; args[0] = pos; args[1] = $3; addInstruction("COP",2,args); $$ = $3;}}}
		| tETOILE tID tEG EXPARITHMETIQUE 
	{ int pos = find_symbol($2,depth); 
if(pos==-1){yyerror("Id n'existe pas.");}
else{ if(getSymb(pos)->isConst){yyerror("Attention affectation sur un const.");/*TODO il serait bien d'afficher la ligne*/}
	else{ int args[2]; args[0] = pos; args[1] = $4; addInstruction("PCOPB",2,args); $$ = $4;}}}
		| tID tCO tNB tCF tEG EXPARITHMETIQUE
	{ int pos = find_symbol($1,depth); 
if(pos==-1){yyerror("Id n'existe pas.");}
else{ if(0>$3 || getSymb(pos)->size <= $3){yyerror_tab("Accès hors du tableau AFC ",$1,$3);}
else{int args[2]; args[0] = pos + $3; args[1] = $6; addInstruction("COP",2,args); $$ = $3;}}};

INSTRUCTIONS : 	AFFECTATIONS tPV INSTRUCTIONS
			| 	WHILE INSTRUCTIONS
			|	IF INSTRUCTIONS	
			| 	RETURN
			|	tPV INSTRUCTIONS
			| 	PRINT INSTRUCTIONS
			| 	FUNCT INSTRUCTIONS
			|;

FUNCT : tID tPO SUITEPARAMSFUNCT tPF tPV {int jump = jump_function($1,$3); if(jump == -1){yyerror_funct("Fonction inexistante", $1, $3);}else{int args[1]; args[0] = jump; addInstruction("CALL",1,args);}};

SUITEPARAMSFUNCT : EXPARITHMETIQUE tVIR SUITEPARAMSFUNCT {$$ = 1 + $3;}
	| EXPARITHMETIQUE {$$ = 1;};


EXPARITHMETIQUE : EXPARITHMETIQUE tPLUS EXPARITHMETIQUE 
	{ int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("ADD",3,args); $$ = $1;current_row_temp--;}
				| EXPARITHMETIQUE tMOINS EXPARITHMETIQUE 
	{ int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("SOU",3,args); $$ = $1;current_row_temp--;}
				| EXPARITHMETIQUE tETOILE EXPARITHMETIQUE 
	{ int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("MUL",3,args); $$ = $1;current_row_temp--;}
				| EXPARITHMETIQUE tDIV EXPARITHMETIQUE 
	{ int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("DIV",3,args); $$ = $1;current_row_temp--;}
				| tPO EXPARITHMETIQUE tPF 
	{$$ = $2;}
				| tNB 
	{ int args[2]; args[0] = current_row_temp; args[1] = $1; addInstruction("AFC",2,args); $$ = current_row_temp; current_row_temp++;}
				| tID 
	{ int args[2]; args[0] = current_row_temp; args[1] = find_symbol($1,depth); addInstruction("COP",2,args); $$ = current_row_temp; current_row_temp++;}
				| tADDR tID 
	{ int args[2]; args[0] = current_row_temp ; args[1]=find_symbol($2,depth); addInstruction("AFC",2,args) ; $$ = current_row_temp; current_row_temp++;} /*a verifier*/
				| tETOILE tID 
	{ int args[2]; args[0] = current_row_temp; args[1] = find_symbol($2,depth); addInstruction("PCOPB",2,args); $$ = current_row_temp; current_row_temp++;}
				| tID tCO EXPARITHMETIQUE tCF
	{ int args[3]; args[0] = current_row_temp; args[1] = find_symbol($1,depth) ;args[2] = $3; addInstruction("ADD",3,args); 
		args[0] = current_row_temp; args[1] = current_row_temp; addInstruction("PCOPA",2,args);
	$$ = current_row_temp; current_row_temp++;};

EXPCONDITIONNELLE : EXPARITHMETIQUE tOU EXPARITHMETIQUE 
						{int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("OR",3,args); $$= $1;current_row_temp--;}
				| 	EXPARITHMETIQUE tET EXPARITHMETIQUE {	int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("AND",3,args);
										;$$= $1;current_row_temp--;}
				| 	EXPARITHMETIQUE tINFEG EXPARITHMETIQUE { int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("INFEQ",3,args);
										;$$= $1;current_row_temp--;}
				| 	EXPARITHMETIQUE tINF EXPARITHMETIQUE { int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("INF",3,args);
										;$$= $1;current_row_temp--;}
				| 	EXPARITHMETIQUE tSUPEG EXPARITHMETIQUE { int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("SUPEQ",3,args);
										$$= $1;current_row_temp--;}
				| 	EXPARITHMETIQUE tSUP EXPARITHMETIQUE { int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("SUP",3,args);
										;$$= $1;current_row_temp--;}
				| 	EXPARITHMETIQUE tEGALITE EXPARITHMETIQUE {  int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("EQU",3,args);
										;$$= $1;current_row_temp--;}
				| 	tNON EXPARITHMETIQUE{ int args[3]; args[0] = current_row_temp; args[1] = 0; addInstruction("AFC",2,args);
							args[0] = $2; args[1] = $2;args[2] = current_row_temp; addInstruction("EQU",3,args); $$ = $2;}
				| 	EXPARITHMETIQUE {$$=$1;}

				|	AFFECTATION{$$ = $1;};

IF : /*tIF tPO EXPCONDITIONNELLE {current_row_temp--;}tPF { int args[2]; args[0] = $3; $1 = counter; addInstruction("JMF",2,args);} BODY {updateJMF($1,counter-1);}
    | */tIF tPO EXPCONDITIONNELLE {current_row_temp--;}tPF { int args[2]; args[0] = $3; $1 = counter; addInstruction("JMF",2,args);} BODY {updateJMF($1,counter-1); $2 = counter /*juste pour sauvegarde*/; int args[1]; addInstruction("JMP",1,args);} tELSE BODY {updateJMP($2, counter+1);} ;

WHILE : tWHILE {$1 = counter;} tPO EXPCONDITIONNELLE {  $3 = counter /*juste utile pour sauvegarder la val*/; int args[2]; args[0] = $4; addInstruction("JMF",2,args); current_row_temp--;} tPF BODY {int args[1]; args[0] = $1+1; addInstruction("JMP",1,args);updateJMF($3,counter);};

RETURN : tRETURN EXPARITHMETIQUE tPV {/*TODO*/}
		| tRETURN tPV;

PRINT : tPRINT tPO tID tPF tPV {int args[1]; args[0] = find_symbol($3,depth); addInstruction("PRI",1,args);}
	| tPRINT tPO tETOILE tID tPF tPV {int args[1]; args[0] = find_symbol(getSymb(find_symbol($4,depth))->name,depth); addInstruction("PRI",1,args);} /*A verifier*/
	| tPRINT tPO tID tCO tNB tCF tPF tPV {int pos = find_symbol($3,depth); if(0>$5 || getSymb(pos)->size <= $5){yyerror_tab("Accès hors du tableau PRI ",$3,$5);}
else{int args[1]; args[0] = pos + $5; addInstruction("PRI",1,args);}};


%%
int yyerror(char *s) {
 fprintf(stderr,"%s\n",s);
 error = 1;
}

int yyerror_tab(char *s, char * tab, int d) {
 fprintf(stderr,"%s %s[%d]\n",s, tab, d);
 error = 1;
}
int yyerror_funct(char *s, char * funct, int d) {
 fprintf(stderr,"%s : %s (%d params)\n",s, funct, d);
 error = 1;
}
int main(void) {
	counter = 0;	
	yyparse();
	if(!error){
	  f = fopen("assembler.asm","w");
	  writeProgramToFile(f);
	  fclose(f);
	}else{
	  printf("Process executed returning error(s)\n");
	}
}
