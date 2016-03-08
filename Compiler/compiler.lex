%{
//declaration : include etc,
#include "compiler.h"
#include <stdlib.h>
%}

WHITESPACES [ \t\n]+
DIGIT       [0-9]
NUMBER      {DIGIT}+
EXP         {NUMBER}[eE][+-]?{NUMBER}
REEL        {NUMBER}("."{NUMBER})?{EXP}?
%x comment

%%

{WHITESPACES}  { }
"main"		return(tMAIN);
"const"		return(tCONST);
"int" 		return(tINT);
"if" 		return(tIF);
"else"		return(tELSE);
"while" 	return(tWHILE);
"return" 	return(tRETURN);
"printf"	return(tPRINT);
[a-zA-Z][_a-zA-Z0-9]*	{yylval.variable = strdup(yytext); return(tID);}
"{" 		return(tAO);
"}" 		return(tAF);
"(" 		return(tPO);
")" 		return(tPF);	
"+"		return(tPLUS);
"-"		return(tMOINS);
"*"		return(tETOILE);
"/"		return(tDIV);
"="		return(tEG);
"=="		return(tEGALITE);
"||"		return(tOU);
"&&"		return(tET);
">"		return(tSUP);
">="		return(tSUPEG);
"<="		return(tINFEG);
"<"		return(tINF);
"!"		return(tNON);
{NUMBER}	{yylval.value = atof(yytext); return tNB;}
{REEL}		{yylval.value = atof(yytext); return tNB;}
{EXP}		{yylval.value = atof(yytext); return tNB;}
","		return(tVIR);
";"		return(tPV);
.		return(tERR);

"/*"         BEGIN(comment);
     
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>"*"+"/"        BEGIN(INITIAL);

%%
