int main(){
	int a = 2,b, *c, *d = &c;
	b = 14;
	*c = a;
	print(*c);
	print(*d);
	a = b +3;
	print(a);
	return 0;
}
