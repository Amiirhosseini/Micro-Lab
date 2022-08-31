
#include ".\source\allheaders.h"


int sadom=0;
int dahom=0;
int sanie=0;
int dahsanie=0;
int daqiqe=0;
int dah_daqiqe=0;
int saat=0;
int dahsaat=0;

int start=0;
int stop=0;


int parking=1000;

void Q1_time0(void)
{
   char temp[30];
    // Reinitialize Timer 0 value
    TCNT0=0xB0;
    // Place your code here
    if(start==1)
    {
        sadom=sadom+1;
        
        if(sadom==9 && dahom==5 && sanie==9 && dahsanie==5 && daqiqe==9)
        {
            dah_daqiqe=dah_daqiqe+1;
            dahom=0;
            sadom=0;
            sanie=0;
            dahsanie=0; 
            daqiqe=0;
        }
        
        if(sadom==9 && dahom==5 && sanie==9 && dahsanie==5)
        {
            daqiqe=daqiqe+1;
            dahom=0;
            sadom=0;
            sanie=0;
            dahsanie=0;
        }
        
        if(sadom==9 && dahom==5 && sanie==9)
        {
            dahsanie=dahsanie+1;
            dahom=0;
            sadom=0;
            sanie=0;
        }
        if(sadom==9 && dahom==5)
        {
            sanie=sanie+1;
            dahom=0;
            sadom=0;
        }
        if(sadom==9)
        {
            dahom=dahom+1;
            sadom=0;
        }
        
        
        
        sprintf(temp,"%d%d:%d%d:%d%d:%d%d",dahsaat,saat,dah_daqiqe,daqiqe,dahsanie,sanie,dahom,sadom);
        lcd_gotoxy(0,0); 
      // lcd_clear();
        lcd_puts(temp);
    }



}


void Q1_int1(void)
{
   if(PINB.4==0) //Start pushed
    {
        start=1;
        stop=0;
        
   // lcd_clear();
   // lcd_puts("start");
    }
    if(PINB.5==0) //stoped pushed
    {
        start=0;
        stop=stop+1;
    } 
    
    if(stop==2)
    {     
    
         char temp[30];
         sadom=0;
         dahom=0;
         sanie=0;
         dahsanie=0;
         daqiqe=0;
         dah_daqiqe=0;

         start=0;
         stop=0; 
         
          sprintf(temp,"%d%d:%d%d:%d%d:%d%d",dahsaat,saat,dah_daqiqe,daqiqe,dahsanie,sanie,dahom,sadom);
       lcd_gotoxy(0,0); 
       //lcd_clear();
        lcd_puts(temp);
    }

}


void Q2(void)
{
    char temp[30];
    int isfull=0;

    if(PINB.3==0) //car in selected
    {
     if(!(parking>=1000))
     {
        parking = parking + 1;
     }   
    }
    
    if(PINB.7==0) //car out selected
    {
     if(!(parking<=0))
     {
        parking = parking - 1;
     } 
    }
    
    if(parking==0)
    {   
       isfull=1;
     //  lcd_clear();
       lcd_gotoxy(0,1);
       sprintf(temp,"CE:FULL ");
       lcd_puts(temp); 
    }
    
    if(isfull==0)
    {
   // lcd_clear();
    lcd_gotoxy(0,1);
    sprintf(temp,"CE:%d ",parking);
    lcd_puts(temp); 
    }


}

void Q3(void)
{
    unsigned long int ferekans; 
    char show[30];
    ferekans=PINA;
  
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 8000.000 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Toggle on compare match
    // OC1B output: Toggle on compare match
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 8.192 ms
    // Output Pulse(s):
    // OC1A Period: 16.384 ms Width: 8.192 ms
    // OC1B Period: 16.384 ms Width: 8.192 ms
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    
    lcd_gotoxy(8,1);
    sprintf(show,"F:%d",ferekans);
    lcd_puts(show);

}