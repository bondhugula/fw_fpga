/*
 * Copyright (C) 2005 Uday Bondhugula
 * Copyright (C) 2005 Ananth Devulapalli
 *
 * Please see the LICENSE file for details.
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <string.h>

#include "timer.h"

unsigned long long cpuHz;
double MHZ = 0;

/* ====================================== RDTSC
======================================*/

#define _rdtsc(lt, ht)                                                         \
  { __asm__ volatile(" rdtsc\n " : "=a"(lt), "=d"(ht)); }
unsigned long long mask = (unsigned long long)0xffffffff;

unsigned long long accum(unsigned int ht, unsigned int lt) {
  return (((unsigned long long)ht & mask) << 32) | ((unsigned long)lt);
}

/* returns the microsecond timestamp */
unsigned long long rdtsc(void) {
  unsigned int lt, ht;

  _rdtsc(lt, ht);
  return accum(ht, lt);
}

unsigned long long evalSpeed(void) {
  unsigned long long val1, val2, finalVal;
  val1 = rdtsc();
  sleep(10);
  val2 = rdtsc();
  finalVal = (((val2 - val1) / 10 + (100000000)) / 200000000) * 200000000;

  return finalVal;
}

/* fatal error */
void error(const char *fmt, ...) {
  va_list ap;

  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fprintf(stderr, ".\n");
  exit(1);
}

/* die with error info */
void error_errno(const char *fmt, ...) {
  va_list ap;

  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fprintf(stderr, ": %m.\n"); /* %m spits errno and msg */
  exit(1);
}

void get_mhz(void) {
  FILE *fp;
  char s[1024], *cp;
  int found = 0;

  if (!(fp = fopen("/proc/cpuinfo", "r")))
    printf("%s: open /proc/cpuinfo", __func__);
  while (fgets(s, sizeof(s), fp)) {
    if (!strncmp(s, "cpu MHz", 7)) {
      found = 1;
      for (cp = s; *cp && *cp != ':'; cp++)
        ;
      if (!*cp)
        error("%s: no colon found in string \"%s\"", __func__, s);
      ++cp;
      if (sscanf(cp, "%lf", &MHZ) != 1)
        error("%s: sscanf got no value from \"%s\"", __func__, cp);
    }
  }
  if (!found)
    error("%s: no line \"cpu MHz\" found", __func__);
  /* round down to an integer */
  MHZ = (double)(int)MHZ;
  printf("CPU Clock Rate = %.4lf MHz\n", MHZ);
  fclose(fp);
}

double getTsc() {
  double val;
  static unsigned long long startval = 0;
  static unsigned long long checkval = 0;
  if (startval == 0) {
    get_mhz();
    cpuHz = ((unsigned long long)MHZ) * 1e6;
    // printf("cpuHz is %lld\n",cpuHz);
    startval = rdtsc();
    checkval = ~startval;
  }
  if (checkval != ~startval) {
    printf("OOPS!\n");
  }
  val = (double)(rdtsc() - startval) / (double)cpuHz;
  return val;
}

/* returns the number of microseconds expired since the first call to this
function */
long ustime() { return (long)(getTsc() * 1.0e6); }

long nstime() { return (long)(getTsc() * 1.0e9); }
