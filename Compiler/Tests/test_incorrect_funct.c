int f(int a, int b){
  int f;
  int g = 3, e = 2;
  if(g == 3){
    g = b + 32;
  }
  else {
    e = e + a;
  }
  return e;
}

int f(int a){
  int f;
  int g = 3, e = 2;
  if(g == 3){
    g = 32;
  }
  else {
    e = e + a;
  }
  return e;
}

int main(){
	int e, b=3;/*,*c,*d=&c;*/
	int a = 14;
	if(a == 3){
	  f(a,b);
	  a = a + b;
	} else {}
	f(32,23,46);
	while(b == 3){
	  int w = 0;
	  b = a +b;
	}
	return 0;
}