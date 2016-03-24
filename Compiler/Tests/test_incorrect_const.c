int main(){
	const int a = 2;
	const int * c = &a;
	c = &c;
	a = a +3;	
	return 0;
}
