#ifndef TABLE_FUNCTION_H
#define TABLE_FUNCTION_H

#include<stdio.h>
#include<string.h>
#include<stdlib.h> 

#define MAX 256

struct function{
	char * name;
	int type_ret; /*0 : int - 1 : * int*/
	int nb_param;
	int jump;
};

void add_funct(char * name, int type_ret, int nb_param,int jump);
void print_table_funct();
int jump_function(char * name, int nb_param);

#endif