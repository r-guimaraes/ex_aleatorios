#include <stdio.h>

int main() {

	int A,B,C,D;
	scanf("%d %d %d %d", &A, &B, &C, &D);

	int somaCcomD = C + D;
	int somaAcomB = A + B;
	int CeDsaoPositivos = (C > 0) && (D > 0);
	int AehPar = (A % 2 == 0);

	if(B > C && D > A && (somaCcomD > somaAcomB) && CeDsaoPositivos && AehPar) {
		printf("Valores aceitos\n");
	} else {
		printf("Valores nao aceitos\n");
	}

	return 0;
}