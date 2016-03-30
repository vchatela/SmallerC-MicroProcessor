#ifndef MAIN_H_
#define MAIN_H_

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <memory.h>
#include <stdlib.h>
#include <stdarg.h>
#include <float.h>
#include "compiler.h"

/*
 * global variable
 */
extern int debug;

/*
 * lex & parse
 */
extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char*);

/*
 * main.c
 */
extern void DumpRow(void); 
extern int GetNextChar(char *b, int maxBuffer);
extern void BeginToken(char*);
extern void PrintError(char *s, ...);

#endif 