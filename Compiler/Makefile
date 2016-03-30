LEX = flex
YACC = yacc
YFLAGS = -Wconflicts-sr -d
CC = gcc
objects = y.tab.c compiler.h lex.yy.c y.tab.h y.output yacc assembler.asm

prog = compiler

yacc: y.tab.c lex.yy.c table_of_symbol.c table_of_function.c main.c   
	$(CC) y.tab.c lex.yy.c table_of_symbol.c main.c table_of_function.c asm.c -ll -o $(prog)

y.tab.c: compiler.yacc
	$(YACC) $(YFLAGS) compiler.yacc
	mv y.tab.h compiler.h
	
lex.yy.c: compiler.lex
	$(LEX) compiler.lex

clean:
	rm -f $(objects) $(prog)

debug:
	$(YACC) -v compiler.yacc
