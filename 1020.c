#include <stdio.h>
#include <stdlib.h>
#define ANO 365
#define MES 30

int main() {
	int dias, anos, meses, d;
	scanf("%d", &dias);

	anos = dias / ANO;
	meses = ((dias % ANO) / MES);
	d = dias - (anos * ANO) - (meses * MES);

	printf("%d ano(s)\n", anos);
	printf("%d mes(es)\n", meses);
	printf("%d dia(s)\n", d);

	return 0;
}
