LEX = flex
YACC = yacc
YFLAGS = -Wconflicts-sr -d
CC = gcc
objects = y.tab.c lex.yy.c y.tab.h y.output yacc

prog = yacc

yacc: y.tab.c lex.yy.c   
	$(CC) y.tab.c lex.yy.c -ll -o $(prog)

y.tab.c:
	$(YACC) $(YFLAGS) interpreter.yacc
	
lex.yy.c:
	$(LEX) interpreter.lex

clean:
	rm -f $(objects) $(prog)

debug:
	$(YACC) -v source.yacc
