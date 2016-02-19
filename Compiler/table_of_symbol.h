
#ifndef TABLE_SYMBOL_H
#define TABLE_SYMBOL_H

struct symbol{
	char * name;
	int init;
	int depth;
	int isConst;
	// enum type t;
};

void init_tab();
void add_symb(char * name, int init, int isConst);
void remove_symb();
void print_table();
int change_value(char * who, int val);
void up_depth();
void down_depth();


#endif
