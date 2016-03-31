
int f(){
  if(0==0){
    return 4;
  }
   return -1;
}

int f(int args){

}

int main(){
	int a = 2,b, *c, *d = &c;
	int tab[12];
	b = 14;
	*c = a;
	tab[3] = -19;
	print(*c);
	print(*d);
	if(a==14 || b ==2){
	 f(1); 
	}
	else{
	  a = b +3;
	}
	if(a == 17 && b == 14){
	  a = b - 3;
	  print(tab[3]);
	}
	print(a);
	return 0;
}