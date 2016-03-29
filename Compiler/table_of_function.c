#include"table_of_function.h"

struct function tab_funct[MAX];
int current_row_funct= 0;


void add_funct(char * name, int type_ret, int nb_param,int jump){
  struct function f;
  f.name = name;
  f.type_ret = type_ret;
  f.nb_param = nb_param;
  f.jump = jump;
  
  tab_funct[current_row_funct] = f;
  current_row_funct++;
}

void print_table_funct(){
    int i;
    printf("/********** Tab Functions ************/ \n");
    for(i = 0; i < current_row_funct;i++){
	    printf("Nom : %s Type_Ret : %d Nb_param : %d Jump : %d ", tab_funct[i].name, tab_funct[i].type_ret, tab_funct[i].nb_param, tab_funct[i].jump);
	    printf(" \n");
    }
    if(i==0){
	printf("Vide.\n");
    }
  
}

int jump_function(char * name, int nb_param){
  int i;
  for(i = 0; i < current_row_funct; i++){
    if(strcmp(tab_funct[i].name,name)==0 && tab_funct[i].nb_param == nb_param)
      return tab_funct[i].jump; 
  }
  return -1;
}