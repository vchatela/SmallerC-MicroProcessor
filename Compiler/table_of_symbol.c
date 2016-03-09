#include"table_of_symbol.h"

struct symbol * tab_symb;
int current_row;
int current_row_temp;
int depth;

void init_tab_symb(){
	tab_symb = malloc(sizeof(struct symbol)*MAX);
	if(tab_symb == NULL){
		perror("Error in malloc");
		exit(-1);
	}	
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
	s.name = strdup(name);
	s.init = init;
	s.depth = depth;
	s.isConst = isConst;

	tab_symb[current_row] = s;
	current_row++;
}

int find_symbol(char * name, int depth){
	int i;
	for(i = 0; i < current_row;i++){
		if(strcmp(name,tab_symb[i].name) ==0 && tab_symb[i].depth == depth){
			return i;
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
