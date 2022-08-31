#ifndef _alleaders_INCLUDED_
#define _allheaders_INCLUDED_

#include <mega16.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>
#include ".\source\myheader.h"

#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 7
extern unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))


#endif