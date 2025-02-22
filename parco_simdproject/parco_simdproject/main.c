#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#include <math.h>

extern void x86(int n, double* A, double* B, double* result);
extern void xmm(int n, double* A, double* B, double* result);
extern void ymm(int n, double* A, double* B, double* result);

void dotproduct_c(double* A, double* B, double* result, int n) {
    *result = 0.0;
    for (int i = 0; i < n; i++) {
        *result += A[i] * B[i];
    }
}

int main() {
    int n = 1<<20;

    double* A = (double*)malloc(n * sizeof(double));
    double* B = (double*)malloc(n * sizeof(double));
    double result_c = 0, result_asm = 0, result_xmm = 0, result_ymm = 0;

    if (!A || !B) {
        printf("Memory allocation failed. Exiting.\n");
        free(A);
        free(B);
        return 1;
    }

    // Initialize vectors A and B
    srand(42);
    for (int i = 0; i < n; i++) {
        //A[i] = (double)(rand() % 100) / 10.0;
        //B[i] = (double)(rand() % 100) / 10.0;
        A[i] = 1.0;
        B[i] = 2.0;
    }

    // Time the C function
    clock_t start_c = clock();
    double total_time_c = 0.0;
    for (int i = 0; i < 30; i++) {
        clock_t start_iter = clock();
        dotproduct_c(A, B, &result_c, n);
        clock_t end_iter = clock();
        total_time_c += (double)(end_iter - start_iter) / CLOCKS_PER_SEC;
    }
    clock_t end_c = clock();
    double avg_time_c = total_time_c / 30.0;

    // Time the ASM function
    clock_t start_asm = clock();
    double total_time_asm = 0.0;
    for (int i = 0; i < 30; i++) {
        clock_t start_iter = clock();
        x86(n, A, B, &result_asm);
        clock_t end_iter = clock();
        total_time_asm += (double)(end_iter - start_iter) / CLOCKS_PER_SEC;
    }
    clock_t end_asm = clock();
    double avg_time_asm = total_time_asm / 30.0;

    // Time the ASM function w/ XMM register
    clock_t start_asm_xmm = clock();
    double total_time_asm_XMM = 0.0;
    for (int i = 0; i < 30; i++) {
        clock_t start_iter = clock();
        xmm(n, A, B, &result_xmm);
        clock_t end_iter = clock();
        total_time_asm_XMM += (double)(end_iter - start_iter) / CLOCKS_PER_SEC;
    }
    clock_t end_asm_xmm = clock();
    double avg_time_xmm = total_time_asm_XMM / 30.0;

    // Time the YMM function
    clock_t start_ymm = clock();
    double total_time_ymm = 0.0;
    for (int i = 0; i < 30; i++) {
        clock_t start_iter = clock();
        ymm(n, A, B, &result_ymm);
        clock_t end_iter = clock();
        total_time_ymm += (double)(end_iter - start_iter) / CLOCKS_PER_SEC;
    }
    clock_t end_ymm = clock();
    double avg_time_ymm = total_time_ymm / 30.0;

    printf("\nResults for n = %d:\n", n);
    printf("C kernel average time: %.8f seconds\n", avg_time_c);
    printf("ASM kernel average time: %.8f seconds\n", avg_time_asm);
    printf("XMM kernel average time: %.8f seconds\n", avg_time_xmm);
    printf("YMM kernel average time: %.8f seconds\n", avg_time_ymm);

    printf("C result: %.6f\n", result_c);
    printf("ASM result: %.6f\n", result_asm);
    printf("XMM result: %.6f\n", result_xmm);
    printf("YMM result: %.6f\n", result_ymm);


    // Compare results 
    // ASM 
    if (fabs(result_c - result_asm) < 1e-6)
        printf("Results matched. No errors found between C and ASM.\n");
    else
        printf("Mismatch between C and ASM results.\n");

    // XMM
    if (fabs(result_c - result_xmm) < 1e-6)
        printf("Results matched. No errors found between C and XMM.\n");
    else
        printf("Mismatch between C and XMM results.\n");

    // YMM
    if (fabs(result_c - result_ymm) < 1e-6)
        printf("Results matched. No errors found between C and YMM.\n");
    else
        printf("Mismatch between C and YMM results.\n");

    free(A);
    free(B);

    return 0;
}
