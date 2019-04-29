/*
 *
 * $Id: fw.c,v 1.23 2005/11/11 03:42:32 osc0414 Exp $
 *
 */
#include <stdio.h>
#include <stdlib.h>

#include "timer.h"

/* default size 8 */
#ifndef SIZE
#define SIZE 8
#endif

#define min(a, b) (a < b) ? a : b;

/* numbers generated b/w 0 and MAX */
#define MAX 32767

unsigned short d[SIZE][SIZE];

#if defined(ROW_DEP) || defined(COL_DEP) || defined(DOUBLY_DEP)
unsigned short e[SIZE][SIZE];
#endif

#ifdef DOUBLY_DEP
unsigned short f[SIZE][SIZE];
#endif

int main() {
  int i, j, k;

#ifdef FABRIC
  int cnt, l;
#endif

#ifdef TIME
  unsigned long begin, end;
#endif

  for (i = 0; i < SIZE; i++)
    for (j = 0; j < SIZE; j++) {
      if (i == j)
        d[i][j] = 0;
      else
        d[i][j] = rand() % MAX + 1;
    }

#if defined(ROW_DEP) || defined(COL_DEP) || defined(DOUBLY_DEP)
  for (i = 0; i < SIZE; i++)
    for (j = 0; j < SIZE; j++) {
      if (i == j)
        e[i][j] = 0;
      else
        e[i][j] = rand() % MAX + 1;
    }
#endif

#ifdef DOUBLY_DEP
  for (i = 0; i < SIZE; i++)
    for (j = 0; j < SIZE; j++) {
      if (i == j)
        f[i][j] = 0;
      else
        f[i][j] = rand() % MAX + 1;
    }
#endif

#ifdef PRINT
  printf("Initial matrix\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j++)
      printf("%04x_", d[i][j]);
    printf("\n");
  }
  printf("\n\n");
#endif

/* Print out test bench for simulating with the I/O interface */
#ifdef FABRIC
#ifdef SELF_DEP
  cnt = 0;
  printf("\n\nrow-wise\n");

  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("ram(%d) <= x\"", cnt);
      for (k = j + 3; k >= j; k--)
        printf("%04x", d[i][k]);
      printf("\";\n");
      cnt++;
    }
    for (j = 0; j < SIZE; j = j + 4) {
      printf("ram(%d) <= x\"", cnt);
      for (k = j + 3; k >= j; k--)
        printf("%04x", d[k][i]);
      printf("\";\n");
      cnt++;
    }
  }
  printf("\n\n\n");
#elif defined(ROW_DEP)
  cnt = 0;
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("ram(%d) <= x\"", cnt);
      for (k = j + 3; k >= j; k--)
        printf("%04x", e[i][k]);
      printf("\";\n");
      cnt++;
    }
    for (j = 0; j < SIZE; j = j + 4) {
      printf("ram(%d) <= x\"", cnt);
      for (k = j + 3; k >= j; k--)
        printf("%04x", d[k][i]);
      printf("\";\n");
      cnt++;
    }
  }
#elif defined(COL_DEP)
  cnt = 0;
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("ram(%d) <= x\"", cnt);
      for (k = j + 3; k >= j; k--)
        printf("%04x", d[i][k]);
      printf("\";\n");
      cnt++;
    }
    for (j = 0; j < SIZE; j = j + 4) {
      printf("ram(%d) <= x\"", cnt);
      for (k = j + 3; k >= j; k--)
        printf("%04x", e[k][i]);
      printf("\";\n");
      cnt++;
    }
  }
#elif defined(DOUBLY_DEP)
  cnt = 0;
#ifdef OVERLAP
#define NUM_OVERLAP 3
#else
#define NUM_OVERLAP 1
#endif
  for (l = 0; l < NUM_OVERLAP; l++) {
    for (i = 0; i < SIZE; i++) {
      for (j = 0; j < SIZE; j = j + 4) {
        printf("ram(%d) <= x\"", cnt);
        for (k = j + 3; k >= j; k--)
          printf("%04x", e[i][k]);
        printf("\";\n");
        cnt++;
      }
    }
    for (i = 0; i < SIZE; i++) {
      for (j = 0; j < SIZE; j = j + 4) {
        printf("ram(%d) <= x\"", cnt);
        for (k = j + 3; k >= j; k--)
          printf("%04x", f[k][i]);
        printf("\";\n");
        cnt++;
      }
    }
    for (i = 0; i < SIZE; i++) {
      for (j = 0; j < SIZE; j = j + 4) {
        printf("ram(%d) <= x\"", cnt);
        for (k = j + 3; k >= j; k--)
          printf("%04x", d[i][k]);
        printf("\";\n");
        cnt++;
      }
    }
  }

#endif

#endif

#ifdef VERILOG
#ifdef SELF_DEP
  printf("row-wise\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", d[i][k]);
      printf("\b;\n");
    }
    printf("\b\n\n");

    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", d[k][i]);
      printf("\b;\n");
    }
    printf("\b\n\n");
  }
  printf("\n");
#elif defined(DOUBLY_DEP)
  printf("/* Verilog Test Bench */\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", e[i][k]);
      printf("\b;\n");
    }
  }
  printf("\n\n");

  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", f[k][i]);
      printf("\b;\n");
    }
  }
  printf("\n\n");

  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", d[i][k]);
      printf("\b;\n");
    }
  }
  printf("\n\n");

#elif defined(ROW_DEP)
  printf("/* Verilog Test Bench */\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", e[i][k]);
      printf("\b;\n");
    }
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", d[k][i]);
      printf("\b;\n");
    }
  }
  printf("\n\n");

#elif defined(COL_DEP)
  printf("/* Verilog Test Bench */\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", d[i][k]);
      printf("\b;\n");
    }
    for (j = 0; j < SIZE; j = j + 4) {
      printf("#10 fw_in = 64'h");
      for (k = j + 3; k >= j; k--)
        printf("%04x_", e[k][i]);
      printf("\b;\n");
    }
  }
  printf("\n\n");

#else
  printf("Error: No tile type defined\n");
  exit(EXIT_FAILURE);
#endif
#endif

#ifdef TIME
  printf("Calibrating CPU timer...\n");
  begin = nstime();
#endif

#ifdef DOUBLY_DEP
  for (k = 0; k < SIZE; k++) {
    for (i = 0; i < SIZE; i++)
      for (j = 0; j < SIZE; j++)
        d[i][j] = min(d[i][j], f[i][k] + e[k][j]);
  }
#elif defined(ROW_DEP)
  for (k = 0; k < SIZE; k++) {
    for (i = 0; i < SIZE; i++)
      for (j = 0; j < SIZE; j++)
        d[i][j] = min(d[i][j], d[i][k] + e[k][j]);
  }
#elif defined(COL_DEP)
  for (k = 0; k < SIZE; k++) {
    for (i = 0; i < SIZE; i++)
      for (j = 0; j < SIZE; j++)
        d[i][j] = min(d[i][j], e[i][k] + d[k][j]);
  }
#else
  for (k = 0; k < SIZE; k++) {
    for (i = 0; i < SIZE; i++)
      for (j = 0; j < SIZE; j++)
        d[i][j] = min(d[i][j], d[i][k] + d[k][j]);
  }
#endif

#ifdef TIME
  end = nstime();
  printf("FW Latency on CPU: %.2lf us\n", ((double)(end - begin)) / 1.0e3);
  /* so that the compiler doesn't optimize away code */
  for (i = 0; i < SIZE; i++)
    for (j = 0; i < SIZE; i++) {
      k += d[i][j];
    }
  if (k == -1)
    printf("%d\n", k);
#endif

#ifdef PRINT
  printf("\nResult matrix\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j++) {
#ifdef ROW_DEP
      fprintf(stderr, "%04x ", d[j][i]);
#else
      fprintf(stderr, "%04x ", d[i][j]);
#endif
    }
    fprintf(stderr, "\n");
  }
  fprintf(stderr, "\n");

#endif
  return 0;
}
