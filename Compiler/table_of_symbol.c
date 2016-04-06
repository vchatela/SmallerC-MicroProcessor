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
	int i, pos = -1;
	int max_d = -1;
	for(i = 0; i < current_row;i++){
		if(strcmp(name,tab_symb[i].name) ==0 && tab_symb[i].depth<= depth){
			if(max_d< tab_symb[i].depth){			
				max_d = tab_symb[i].depth;
				pos = i;
			}
		}
	}
	/*après premier tour de boucle on aura la valeur max de depth pour l'actuel name du coup pas besoin de deux boucles !! */
	
	return pos;
}

void print_table_symb(){
	int i;
	printf("\n\n");
	printf("/********** Tab Symbol ************/ \n");
	for(i = 0; i < current_row;i++){
		printf("Nom : %s Init : %d Profondeur : %d Const : %d ", tab_symb[i].name, tab_symb[i].init, tab_symb[i].depth, tab_symb[i].isConst);
		if(tab_symb[i].size != 1){
			printf(" Size : %d",tab_symb[i].size);
		}
		printf(" \n");
	}
	if(i==0){
	    printf("Vide.\n");
	}
	printf("/********** Tab Temporary Symbol ************/ \n");
	for(i = current_row; i < current_row_temp;i++){
		printf("Nom : %d\n", i);
	}
	if(i==current_row){
	    printf("Vide.");
	}
	printf("\n\n");
}

void delete_depth_at(){
	// BE CAREFULL -> delete only last element in pratice
	current_row_temp = current_row;
	while(tab_symb[current_row_temp-1].depth==depth){
		current_row--;
		current_row_temp--;
	}
}
