#include ".\source\allheaders.h"


// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}


void Q1(void)
{
// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: Free Running
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);


while(1)
{
    int i=0;
    int j=0;
    int k=0; 
    char data=0;
    char show[30]; 
    
    for(;i<8;i++)
    {
      data=read_adc(i);
      lcd_gotoxy(4*k,j);
      
      memset(show,0,strlen(show));
      
      sprintf(show,"%d" ,data);
      lcd_puts(show); 
      
      
      k++;
      if(i==3)
      {
        j=1;
        k=0;
      }     
      
      
    } 
    
    delay_ms(10);
    
}
    
}

void Q2(void)
{
    int i=0;
    int j=0;
    int k=0; 
    char data[8]={0};
    char show[30]; 
    int diff=0;
    
    for(;i<8;i++)
    {   
       // delay_ms(100);
        lcd_gotoxy(4*k,j);
        
        diff= abs((data[i]/adc_data[i])-adc_data[i]);
        
        memset(show,0,strlen(show));
        
       if(diff>=0.05)
        {     
        
            data[i]=adc_data[i];
            sprintf(show,"%d" ,data[i]);
            lcd_puts(show); 
            
        } 

        
        
        k++;
      if(i==3)
      {
        j=1;
        k=0;
      }     
      
      
        diff=0;
    }


}


void Q3(void)
{
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Phase correct PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 0.51 ms
// Output Pulse(s):
// OC0 Period: 0.51 ms Width: 0.052 ms
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=adc_data[0];

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);


}
