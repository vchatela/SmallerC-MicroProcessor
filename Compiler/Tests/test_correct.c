int f(){

}

int f(int args){

}

int main(){
	int a = 2,b, *c, *d = &c;
	b = 14;
	*c = a;
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
	}
	print(a);
	return 0;
}
