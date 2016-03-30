int main(){
	int b=3,*c,*d=&c;
	int a = 14, e = 1;
	*c = 9;
	if(a == 11){
	  int h;
	  print(a);
	  a = a + b;
	  print(a);
	} else {
	    print(e);
	}
	if(a==14){
	    print(b);
	}
	if(a==18){
	    print(a);
	}
	while(b <= 8){
	      b = 1 +b;
	}
	print(b);
	return 0;
}