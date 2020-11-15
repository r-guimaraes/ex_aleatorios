/* primos.c – identifica todos os numeros primos ate um certo valor*/
// Infinitamente mais performático do que a versão serial
// Quanto maior a carga exigida para execução do programa, mais se torna evidente a superioridade do multithread

#include <pthread.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int verifica_se_primo(long int);
int main(int argc, char *argv[])
{
    long int numero_threads = 0;
    short int result, imprimir;
    int rc;

    if (argc != 3)
    {
        printf("Uso correto: %s <numero> <imprimir=1,nao_imprimir=0>\n\n", argv[0]);
        return 1;
    }
    numero_threads = atol(argv[1]);
    imprimir = atoi(argv[2]);

    pthread_t threads[numero_threads]; 

    for (long int num_int = 1; num_int <= numero_threads; num_int++)
    {

        rc = pthread_create(&threads[num_int], NULL, verifica_se_primo, (void *)num_int);
        if (rc) {
            printf("ERRO: código de retorno de pthread_create() é %d\n", rc);
            exit(-1);
        }
        result = verifica_se_primo(num_int);
        if (imprimir == 1)
            if (result == 1)
                printf("%ld eh primo.\n", num_int);
    }
    pthread_exit(NULL);
    return 0;
}
int verifica_se_primo(long int numero) {
    long int ant;
    for (ant = 2; ant <= (long int)sqrt(numero); ant++)
    {
        if (numero % ant == 0)
            return 0;
    }
    if (ant * ant >= numero)
        return 1;

    pthread_exit(NULL);
}
