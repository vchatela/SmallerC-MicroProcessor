LEX = flex
YACC = yacc
YFLAGS = -Wconflicts-sr -d
CC = gcc
objects = y.tab.c compiler.h lex.yy.c y.tab.h y.output yacc assembler.asm

prog = compiler

yacc: y.tab.c lex.yy.c table_of_symbol.c   
	$(CC) y.tab.c lex.yy.c table_of_symbol.c -ll -o $(prog)

y.tab.c:
	$(YACC) $(YFLAGS) compiler.yacc
	mv y.tab.h compiler.h
	
lex.yy.c:
	$(LEX) compiler.lex

clean:
	rm -f $(objects) $(prog)

debug:
	$(YACC) -v compiler.yacc
