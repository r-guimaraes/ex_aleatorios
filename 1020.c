#include <stdio.h>
#include <stdlib.h>

int main() {
	int dias, anos, meses, d;
	scanf("%d", &dias);

	anos = dias / 365;
	meses = ((dias % 365) / 30);
	d = dias - (anos * 365) - (meses * 30);

	printf("%d ano(s)\n", anos);
	printf("%d mes(es)\n", meses);
	printf("%d dia(s)\n", d);

	return 0;
}
