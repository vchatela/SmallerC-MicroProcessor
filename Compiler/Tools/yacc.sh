yacc -d source.yacc
mv y.tab.h source.h
flex source.lex
gcc y.tab.c lex.yy.c -ll -o yacc
