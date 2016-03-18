#include"table_of_symbol.h"

struct symbol tab_symb[MAX];
int current_row= 0;
int current_row_temp= 0;
int depth= 0;

void up_depth(){
	depth++;
}


void down_depth(){
	depth--;
}

struct symbol * getSymb(int row){
	if(row > current_row || row <0)
		return NULL;
	return &(tab_symb[row]);
}

void add_symb(char * name, int init, int isConst, int size){
	struct symbol s;
	s.name = strdup(name);
	s.init = init;
	s.depth = depth;
	s.isConst = isConst;
	s.size = size;

	tab_symb[current_row] = s;
	current_row++;
	current_row_temp++;
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
		printf("Nom : %s Init : %d Profondeur : %d Const : %d ", tab_symb[i].name, tab_symb[i].init, tab_symb[i].depth, tab_symb[i].isConst);
		if(tab_symb[i].size != 1){
			printf(" Size : %d",tab_symb[i].size);
		}
		else {
			printf(" \n");
		}
	}
	printf("Tab Temporary Symbol\n");
	for(i = current_row; i < current_row_temp;i++){
		printf("Nom : %d\n", i);
	}
	
}

void delete_depth_at(int dep){
	// BE CAREFULL -> delete only last element in pratice
	int * i = &current_row;
	while(tab_symb[*i].depth==dep){
		free(&tab_symb[*i]);
		current_row--;
		current_row_temp--;
	}
}
