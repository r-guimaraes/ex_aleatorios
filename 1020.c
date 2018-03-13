#include <stdio.h>
#include <stdlib.h>

typedef struct Pos {
	int x;
	int y;
} ps;

int validarEntrada(int n);

int main() {
	ps p1;
	ps p2;
	int dias, anos, meses, d;
	
	printf("Exercício 1020 de URI ONLINE JUDGE\n\n");
	printf("Entre número de dias: ");
	scanf("%d", &dias);

	anos = dias / 365;
	meses = ((dias % 365) / 30);
	d = dias - (anos * 365) - (meses * 30);


	printf("%d ano (s)\n", anos);
	printf("%d mes (es)\n", meses);
	printf("%d dia (s)\n", d);

	return 0;

	/*
	printf("Entre a segunda posição: ");
	scanf("%d", &p1.y);

	printf("Entre a terceira posição: ");
	scanf("%d", &p2.x);

	printf("Entre a quarta posição: ");
	scanf("%d", &p2.y);

	printf("X1 ==> %d, %d\n", p1.x, p1.y );
	printf("X2 ==> %d, %d\n", p2.x, p2.y );


	int a = validarEntrada(p1.x);

	printf("%d\n", a);

	return 0; */
}

int validarEntrada(int num) {
	if( num < 1 && num > 8) {
		printf("Erro ... \n");
		return -1;
		exit(0);
	}
	printf("To vazando ... \n");
}
