%{
//declaration : include etc,
#include "source.h"
#include <stdlib.h>
%}

WHITESPACES [ \t\n]+
DIGIT       [0-9]
NUMBER      {DIGIT}+

%%

{WHITESPACES}  { }
"int" 		return(tINT);
"if" 		return(tIF);
"while" 	return(tWHILE);
"return" 	return(tRETURN);
[a-z]+ 		{yylval.variable = yytext; return(tID);}
"{" 		return(tAO);
"}" 		return(tAF);
"(" 		return(tPO);
")" 		return(tPF);	
"+"			return(tPLUS);
"-"			return(tMOINS);
"*"			return(tFOIS);
"/"			return(tDIV);
"%"			return(tMOD);
"="			return(tEG);
"=="		return(tEGALITE);
"||"		return(tOU);
"&&"		return(tET);
">"			return(tSUP);
">="		return(tSUPEG);
"<="		return(tINFEG);
"<"			return(tINF);
"!"			return(tNON);
{NUMBER}	return(tNB);
";"			return(tPV);

%%

