#ifndef TABLE_SYMBOL_H
#define TABLE_SYMBOL_H

#include<stdio.h>
#include<string.h>
#include<stdlib.h> 

#define MAX 256

struct symbol{
	char * name;
	int init;
	int depth;
	int isConst;
	int size;
};

struct symbol * getSymb(int row);

void add_symb(char * name, int init, int isConst, int size);

void print_table();

int find_symbol(char * name, int depth);

void up_depth();
void down_depth();

void delete_depth_at(int dep);


#endif
