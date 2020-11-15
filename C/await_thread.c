/*
 Múltiplas threads
 Aguarda execução da thread anterior antes de prosseguir
*/
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>

#define NTHREADS 3

void *printA() {
    printf("AAAAA");
    pthread_exit(NULL);
}

void *printB() {
    printf("BBBBB");
    pthread_exit(NULL);
}

void *printC() {
    printf("CCCCC\n");
    pthread_exit(NULL);
}

int main()
{
    pthread_t threads[NTHREADS];
    int rc;
    long thId;
    void *status;

    rc = pthread_create(&threads[0], NULL, printA, 0);
    rc = pthread_create(&threads[1], NULL, printB, 0);
    rc = pthread_create(&threads[2], NULL, printC, 0);

    for (thId = 0; thId < NTHREADS; thId++) {
        rc = pthread_join(threads[thId], &status);
        if (rc) {
            printf("ERRO: código de retorno de pthread_join() é %d\n", rc);
            exit(-1);
        }
    }
    pthread_exit(NULL);
}
