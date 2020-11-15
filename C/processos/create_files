/* prog3.c – múltiplas threads */
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>

#define NTHREADS 2

void *arquivo1a10() {
    FILE *f = fopen("1a10.txt", "w");
    if (f != NULL) {
        fprintf(f, "%s\n", "12345678910");
        fclose(f);
    }
}

void *arquivoAaZ() {
    FILE *f = fopen("AaZ.txt", "w");
    if (f != NULL) {
        fprintf(f, "%s\n", "ABCDEFGHIJKLMNOPQRSTUVXYZ");
        fclose(f);
    }
}

int main()
{
    pthread_t threads[NTHREADS];
    int rc;
    long thId;
    void *status;
    size_t len = 0;
    ssize_t read;

    rc = pthread_create(&threads[0], NULL, arquivo1a10, 0);
    rc = pthread_create(&threads[1], NULL, arquivoAaZ, 0);    

    for (thId = 0; thId < 2; thId++) {
        rc = pthread_join(threads[thId], &status);
        if (rc)
        {
            printf("ERRO: código de retorno de pthread_join() é %d\n", rc);
            exit(-1);
        }
    }

    FILE *fp;
    char * line = NULL;
    fp = fopen("1a10.txt", "r");
    if (fp == NULL)
        exit (EXIT_FAILURE);
    
    while( (read = getline(&line, &len, fp)) ) {
        printf("%s", line);   
    }
    fclose(fp);

    fp = fopen("AaZ.txt", "r");
    if (fp == NULL)
        exit (EXIT_FAILURE);
    
    while( (read = getline(&line, &len, fp)) ) {
        printf("%s", line);   
    }
    fclose(fp);

    pthread_exit(NULL);
    
    return -1;
}
