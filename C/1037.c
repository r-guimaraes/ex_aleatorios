#include <stdio.h>
#include <stdlib.h>

int main() {
	float entrada;

	scanf("%f", &entrada);

	if( (entrada < 0) || (entrada > 100.0) ) {
		printf("Fora de intervalo\n");
		exit(0);
	} else {
		if( (entrada >= 0) && ( entrada <= 25.0 ) ) {
			printf("Intervalo [0,25]\n"); 
		} else if( (entrada > 25.0) && (entrada <= 50.0) ) {
			printf("Intervalo (25,50]\n"); 
		} else if( (entrada > 50.0) && (entrada <= 75.0) ) {
			printf("Intervalo (50,75]\n"); 
		} else {
			printf("Intervalo (75,100]\n"); 	
		}
	}

	return 0;
}
