#ifndef __GESTION_SYMBOLES_H__
#define __GESTION_SYMBOLES_H__

#define NB_SYMBOLES_MAX 256

void add(int addr_resultat, int addr_op1, int addr_op2);
void ret();
void call(int addr);
void nop();
void ext(int addr);
void sub(int addr_resultat, int addr_op1, int addr_op2);
void mul(int addr_resultat, int addr_op1, int addr_op2);
void div(int addr_resultat, int addr_op1, int addr_op2);
void cop(int addr_resultat, int addr_op);
void afc(int addr_resultat, int val_const);
void pri(int addr_resultat);
void inf(int addr_resultat, int addr_op1, int addr_op2);
void sup(int addr_resultat, int addr_op1, int addr_op2);
void equ(int addr_resultat, int addr_op1, int addr_op2);
void and(int addr_resultat, int addr_op1, int addr_op2);
void or(int addr_resultat, int addr_op1, int addr_op2);
void jmp(int ligne);
void jmf(int cond, int ligne) ;

void interpreter();

#endif
