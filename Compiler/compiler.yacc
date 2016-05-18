%{
#include<stdio.h>
#include"table_of_symbol.h"
#include"table_of_function.h"
#include"asm.h"
#include "main.h"

#define YYERROR_VERBOSE 1

extern int error;
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
%type <value> INSTRUCTIONS
%type <value> BODY
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
%type <value> SUITEIF

%defines
%locations

%union{int value; char * variable;}

%left tPLUS tMOINS
%right tETOILE tDIV tEG

%start File
%%

File :  /*var globale ?*/  {int args[1]; addInstruction("JMP",1,args);}Prg;

Prg : Dfct Prg
	|Main {if(debug){print_table_funct();}};

Dfct : tINT tID tPO PARAMS tPF {add_funct($2,0,$4,counter);} BODY { if($7==1){addInstruction("RET",0,NULL);}};

Main : tINT tMAIN {add_funct("main",0,0,counter);updateJMP(0, counter);} tPO tPF BODY {};

PARAMS : SUITEPARAMS {$$ = $1;}
		| {$$ = 0;};

SUITEPARAMS : PARAM tVIR SUITEPARAMS {$$ = 1 + $3;}
	| PARAM {$$ = 1;};

PARAM : tINT tID {add_symb($2,1,0,1);}; 
	
BODY : tAO {up_depth();} DECLARATIONS INSTRUCTIONS { if(debug){print_table_symb();}} tAF {delete_depth_at();down_depth(); $$= $4;};

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
	{int symb = find_symbol($5,depth); if(symb==-1){PrintError("Symbol %s does not exist.",$5);}else{add_symb($2,1,0,1); int args[2]; args[0] = current_row_temp ; args[1]=symb; addInstruction("AFC",2,args) ;args[0] = find_symbol($2,depth); args[1] = current_row_temp; addInstruction("PCOPB",2,args);}}
		;

AFFECTATIONSCONSTS : AFFECTATIONSCONST tVIR AFFECTATIONSCONSTS
		| AFFECTATIONSCONST;

AFFECTATIONSCONST : tID tEG EXPARITHMETIQUE 
	{ add_symb($1,1,1,1); int args[2]; args[0] = find_symbol($1,depth); args[1] = $3; addInstruction("COP",2,args); current_row_temp--;}
		| tETOILE tID tEG tADDR tID
	{int symb = find_symbol($5,depth); if(symb==-1){PrintError("Symbol %s does not exist.",$5);}else{add_symb($2,1,1,1); int args[2]; args[0] = current_row_temp ; args[1]= symb; addInstruction("AFC",2,args) ;args[0] = find_symbol($2,depth); args[1] = current_row_temp; addInstruction("PCOPB",2,args);}};

AFFECTATIONS : AFFECTATION tVIR { current_row_temp--;} AFFECTATIONS
		| AFFECTATION{ current_row_temp--;} ;

/** AFFECTATION sur undeclared ! **/
		
AFFECTATION : tID tEG EXPARITHMETIQUE
	{ int pos = find_symbol($1,depth); 
if(pos==-1){PrintError("Symbol %s does not exist.",$1);}
else{ if(getSymb(pos)->isConst){PrintError("Const affectation");}
	else{ int args[2]; args[0] = pos; args[1] = $3; addInstruction("COP",2,args);}}}
		| tETOILE tID tEG EXPARITHMETIQUE 
	{ int pos = find_symbol($2,depth); 
if(pos==-1){PrintError("Symbol %s does not exist.",$2);}
else{ if(getSymb(pos)->isConst){PrintError("Const affectation");}
	else{ int args[2]; args[0] = pos; args[1] = $4; addInstruction("PCOPB",2,args);}}}
		| tID tCO tNB tCF tEG EXPARITHMETIQUE
	{ int pos = find_symbol($1,depth); 
if(pos==-1){PrintError("Symbol %s does not exist.",$1);}
else{ if(0>$3 || getSymb(pos)->size <= $3){PrintError("Out of size of %s[%d]",$1,$3);}
else{int args[2]; args[0] = pos + $3; args[1] = $6; addInstruction("COP",2,args);}}}
		/*| tPLUS tPLUS tID
	{
	int pos = find_symbol($3,depth); if(pos==-1){PrintError("Symbol %s does not exist.",$3);}else{
	  int args[3]; 
	  args[0] = current_row_temp; args[1] = pos; addInstruction("COP",2,args);
	  args[0] = current_row_temp; args[1] = 1; addInstruction("AFC",2,args); current_row_temp++;
	  args[0] = current_row_temp; args[1] = current_row_temp; args[2] = $3; addInstruction("ADD",3,args);
	}
	}
		| tMOINS tMOINS tID
	{
	int pos = find_symbol($3,depth); 
	if(pos==-1){PrintError("Symbol %s does not exist.",$3);}
	else{int args[2]; args[0] = current_row_temp; args[1] = pos; addInstruction("COP",2,args); current_row_temp++;
	
	}
	}	
		| tID tPLUS tPLUS
	{}	
		| tID tMOINS tMOINS 
	{}*/;

INSTRUCTIONS : 	AFFECTATIONS tPV INSTRUCTIONS {$$=0;}
			| 	WHILE INSTRUCTIONS {$$=0;}
			|	IF INSTRUCTIONS {$$=0;}
			| 	RETURN {$$=1;}
			|	tPV INSTRUCTIONS {$$=0;}
			| 	PRINT INSTRUCTIONS {$$=0;}
			| 	FUNCT INSTRUCTIONS {$$=0;}
			| {$$=0;};

FUNCT : tID tPO SUITEPARAMSFUNCT tPF tPV {int jump = jump_function($1,$3); if(jump == -1){PrintError("Unknown function %s with %d args", $1, $3);}else{int args[1]; args[0] = jump; addInstruction("CALL",1,args);}};

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
	{ int pos = find_symbol($1,depth); if(pos==-1){PrintError("Symbol %s does not exist.",$1);}else{int args[2]; args[0] = current_row_temp; args[1] = pos; addInstruction("COP",2,args); $$ = current_row_temp; current_row_temp++;}}
				| tADDR tID 
	{ int pos = find_symbol($2,depth); if(pos==-1){PrintError("Symbol %s does not exist.",$2);}else{int args[2]; args[0] = current_row_temp ; args[1]=pos; addInstruction("AFC",2,args) ; $$ = current_row_temp; current_row_temp++;}} /*a verifier*/
				| tETOILE tID 
	{ int pos = find_symbol($2,depth); if(pos==-1){PrintError("Symbol %s does not exist.",$2);}else{int args[2]; args[0] = current_row_temp; args[1] = pos; addInstruction("PCOPB",2,args); $$ = current_row_temp; current_row_temp++;}}
				| tID tCO EXPARITHMETIQUE tCF
	{ int pos = find_symbol($1,depth); if(pos==-1){PrintError("Symbol %s does not exist.",$1);}else{int args[3]; args[0] = current_row_temp; args[1] = pos ;args[2] = $3; addInstruction("ADD",3,args); 
		args[0] = current_row_temp; args[1] = current_row_temp; addInstruction("PCOPA",2,args);
	$$ = current_row_temp; current_row_temp++;}};

EXPCONDITIONNELLE : EXPCONDITIONNELLE tOU EXPCONDITIONNELLE 
						{int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("OR",3,args); $$= $1;current_row_temp--;}
				| 	EXPCONDITIONNELLE tET EXPCONDITIONNELLE {	int args[3]; args[0] = $1; args[1] = $1;args[2] = $3; addInstruction("AND",3,args);
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

IF : tIF tPO EXPCONDITIONNELLE {current_row_temp--;}tPF { int args[2]; args[0] = $3; $1 = counter; addInstruction("JMF",2,args);} BODY {updateJMF($1,counter);} SUITEIF {suiteIfJMF($1,$9);};

SUITEIF : tELSE {$1=counter; int args[1]; addInstruction("JMP",1,args);} BODY {updateJMP($1, counter); $$ =1;}
    | {$$=0;};

WHILE : tWHILE {$1 = counter;} tPO EXPCONDITIONNELLE {  $3 = counter; int args[2]; args[0] = $4; addInstruction("JMF",2,args); current_row_temp--;} tPF BODY {int args[1]; args[0] = $1+1; addInstruction("JMP",1,args);updateJMF($3,counter);};

RETURN : tRETURN EXPARITHMETIQUE tPV {int args[1]; args[0] = $2; addInstruction("EXT",1,args); addInstruction("RET",0,NULL);}
		| tRETURN tPV {addInstruction("RET",0,NULL);};

PRINT : tPRINT tPO tID tPF tPV {int pos = find_symbol($3,depth); if(pos==-1){PrintError("Symbol %s does not exist.",$3);}else{int args[1]; args[0] = pos; addInstruction("PRI",1,args);}}
	| tPRINT tPO tETOILE tID tPF tPV {int args[1]; args[0] = find_symbol(getSymb(find_symbol($4,depth))->name,depth); addInstruction("PRI",1,args);}
	| tPRINT tPO tID tCO tNB tCF tPF tPV {int pos = find_symbol($3,depth); if(0>$5 || getSymb(pos)->size <= $5){PrintError("Out of size of %s[%d]",$3,$5);} else{int args[1]; args[0] = pos + $5; addInstruction("PRI",1,args);}};


%%
extern
void yyerror(char *s) {
// simple error-message
//  printf("Error '%s'\n", s);
//  a more sophisticated error-function
 PrintError(s);
 error = 1;
}
