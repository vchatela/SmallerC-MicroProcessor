LEX = flex
YACC = yacc
YFLAGS = -Wconflicts-sr -d
CC = gcc
objects = y.tab.c source.h lex.yy.c y.tab.h y.output yacc

prog = yacc

yacc: y.tab.c lex.yy.c table_of_symbol.c   
	$(CC) y.tab.c lex.yy.c table_of_symbol.c -ll -o $(prog)

y.tab.c:
	$(YACC) $(YFLAGS) source.yacc
	mv y.tab.h source.h
	
lex.yy.c:
	$(LEX) source.lex

clean:
	rm -f $(objects) $(prog)

debug:
	$(YACC) -v source.yacc
