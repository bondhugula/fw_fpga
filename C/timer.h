/*
 * Copyright (C) 2005 Uday Bondhugula
 * Copyright (C) 2005 Ananth Devulapalli
 *
 * Please see the LICENSE file for details.
 */
#ifndef _TIMER_H
#define _TIMER_H

unsigned long long accum(unsigned int ht, unsigned int lt);
unsigned long long rdtsc(void);
unsigned long long evalSpeed(void);
double getTsc();
long ustime();
long nstime();

#endif // _TIMER_H
