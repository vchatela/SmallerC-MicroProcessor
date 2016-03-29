LEX = flex
YACC = yacc
YFLAGS = -Wconflicts-sr -d
CC = gcc
objects = y.tab.c interpreteur.h lex.yy.c y.tab.h y.output yacc assembler.asm

prog = interpreteur

yacc: y.tab.c lex.yy.c interpreteur_asm.c gestion_instructions.c
	$(CC) y.tab.c lex.yy.c interpreteur_asm.c gestion_instructions.c -ll -o $(prog)

y.tab.c: interpreteur_asm.yacc
	$(YACC) $(YFLAGS) interpreteur_asm.yacc
	mv y.tab.h interpreteur.h
	
lex.yy.c: interpreteur_asm.lex
	$(LEX) interpreteur_asm.lex

clean:
	rm -f $(objects) $(prog)

debug:
	$(YACC) -v interpreteur_asm.yacc
