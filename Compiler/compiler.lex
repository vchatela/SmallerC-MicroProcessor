%option noyywrap
%{
//declaration : include etc,
#include "compiler.h"
#include <stdlib.h>

#define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
      result = YY_NULL; \
    }
%}
%option yylineno
WHITESPACES [ \t\n]+
DIGIT       [0-9]
NUMBER      [-]?{DIGIT}+
EXP         [-]?{NUMBER}[eE][+-]?{NUMBER}
REEL        [-]?{NUMBER}("."{NUMBER})?{EXP}?
%x comment
        
%%

{WHITESPACES}  { BeginToken(yytext); }
"main"		{BeginToken(yytext); return(tMAIN);}
"const"		{BeginToken(yytext); return(tCONST);}
"int" 		{BeginToken(yytext); return(tINT);}
"if" 		{BeginToken(yytext); return(tIF);}
"else"		{BeginToken(yytext); return(tELSE);}
"while" 	{BeginToken(yytext); return(tWHILE);}
"return" 	{BeginToken(yytext); return(tRETURN);}
"print"		{BeginToken(yytext); return(tPRINT);}
[a-zA-Z][_a-zA-Z0-9]*	{BeginToken(yytext); yylval.variable = strdup(yytext); return(tID);}
"{" 		{BeginToken(yytext); return(tAO);}
"}" 		{BeginToken(yytext); return(tAF);}
"["		{BeginToken(yytext); return(tCO);}
"]"		{BeginToken(yytext); return(tCF);}
"(" 		{BeginToken(yytext); return(tPO);}
")" 		{BeginToken(yytext); return(tPF);}	
"+"		{BeginToken(yytext); return(tPLUS);}
"-"		{BeginToken(yytext); return(tMOINS);}
"*"		{BeginToken(yytext); return(tETOILE);}
"/"		{BeginToken(yytext); return(tDIV);}
"=="		{BeginToken(yytext); return(tEGALITE);}
"="		{BeginToken(yytext); return(tEG);}
"||"		{BeginToken(yytext); return(tOU);}
"&&"		{BeginToken(yytext); return(tET);}
">"		{BeginToken(yytext); return(tSUP);}
">="		{BeginToken(yytext); return(tSUPEG);}
"<="		{BeginToken(yytext); return(tINFEG);}
"<"		{BeginToken(yytext); return(tINF);}
"!"		{BeginToken(yytext); return(tNON);}
{NUMBER}	{BeginToken(yytext); yylval.value = atof(yytext); return tNB;}
{REEL}		{BeginToken(yytext); yylval.value = atof(yytext); return tNB;}
{EXP}		{BeginToken(yytext); yylval.value = atof(yytext); return tNB;}
","		{BeginToken(yytext); return(tVIR);}
";"		{BeginToken(yytext); return(tPV);}
"&"		{BeginToken(yytext); return(tADDR);}
.		{BeginToken(yytext); return(tERR);}

"/*"         BEGIN(comment);
     
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>"*"+"/"        BEGIN(INITIAL);

%%
