#include"table_of_symbol.h"

struct symbol tab_symb[MAX];
int current_row= 0;
int current_row_temp= MAX-1;
int depth= 0;

void up_depth(){
	depth++;
}


void down_depth(){
	depth--;
}

void add_symb(char * name, int init, int isConst, int isPointer){
	struct symbol s;
	s.name = strdup(name);
	s.init = init;
	s.depth = depth;
	s.isConst = isConst;
	s.isPointer = isPointer;

	tab_symb[current_row] = s;
	current_row++;
}

int find_symbol(char * name, int depth){
	int i, d;
	for(i = 0; i < current_row;i++){
		for(d = depth;d>=0;d--){
			if(strcmp(name,tab_symb[i].name) ==0 && tab_symb[i].depth == d){
				return i;
			}
		}
	}
	return -1;
}

void print_table_symb(){
	int i;
	printf("Tab Symbol\n");
	for(i = 0; i < current_row;i++){
		printf("Nom : %s Init : %d Profondeur : %d Const : %d \n", tab_symb[i].name, tab_symb[i].init, tab_symb[i].depth, tab_symb[i].isConst);
	}
	printf("Tab Temporary Symbol\n");
	for(i = MAX-1; i > current_row_temp;i--){
		printf("Nom : %s Init : %d Profondeur : %d Const : %d \n", tab_symb[i].name, tab_symb[i].init, tab_symb[i].depth, tab_symb[i].isConst);
	}
	
}

void delete_depth_at(int dep){
	// BE CAREFULL -> delete only last element in pratice
	int * i = &current_row;
	while(tab_symb[*i].depth==dep){
		free(&tab_symb[*i]);
		current_row--;
	}
}
