#include<stdio.h>
#include<string.h>
#include<stdlib.h> 
#include"table_of_symbol.h"

#define MAX 256

struct symbol * tab_symb;
int current_row;
int current_row_temp;
int depth;

void init_tab(){
	tab_symb = malloc(sizeof(struct symbol)*MAX);	
	current_row = 0;
current_row_temp = MAX-1;
	depth = 0;
}

void up_depth(){
	depth++;
}


void down_depth(){
	depth--;
}

void add_symb(char * name, int init, int isConst){
	struct symbol s;
	s.name = name;
	s.init = init;
	s.depth = depth;
	s.isConst = isConst;

	tab_symb[current_row] = s;
	current_row++;
}

int find_symbol(char * name){
	int i;
	for(i = 0; i < current_row;i++){
		if(strcmp(name,tab_symb[i].name)){
			return i;
		}
	}
	return -1;
}

void print_table(){
	int i;
	for(i = 0; i < current_row;i++){
		printf("Nom : %s Init : %d Profondeur : %d Const : %d \n", tab_symb[i].name, tab_symb[i].init, tab_symb[i].depth, tab_symb[i].isConst);
	}
}

void delete_depth_at(){
//TODO things about organization
	int i;
	for(i = 0; i < current_row;i++){
		if(tab_symb[i].depth==depth){
			//supp la var
		}
	}
}
