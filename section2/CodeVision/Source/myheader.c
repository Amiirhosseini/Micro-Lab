
#include ".\source\AllHeaders.h"

extern unsigned char hexvalue[10]= {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; //0 to 9 in 7seg

int Q1(int port_in)
{
int data_in;
                       
switch(port_in)
{
    case port_A:  
        data_in=PINA;
    break ; 
    
    case port_B:  
        data_in=PINB;
    break ;
    
    case port_C:  
        data_in=PINC;
    break ;
    
    case port_D:
        data_in=PINB;
    break;

}
return data_in;
}

void Q2(int data , int port_in)
{
switch(port_in)
{
    case port_A:  
        PORTA=data;
    break ;
    case port_B:  
        PORTB=data;
    break ;
    case port_C:  
        PORTC=data;
    break ;
    case port_D:  
        PORTD=data;
    break ;
}

}

void Q3(int numbers,int time)  
{
int i;
    for (i=0;i<numbers;i++) {
        delay_ms(time);
        Q2(0xFF,port_B);
        delay_ms(time);
        Q2(0x00,port_B);
    
    };  
}

void Q4(void)
{
    int data;
    data= Q1(port_A);
    Q2(data,port_B);
}


void seven_seg_display (int data, int data_port, int enable_data)
{   
int yekan=0;
int dahgan=0;
int sadgan=0;
int hezaargan=0;

yekan = data%10;
data=data/10;
dahgan = data%10;
data=data/10;
sadgan=data%10;
data=data/10;
hezaargan=data%10;
                    
    switch (enable_data) {
    case port_A :   
            switch (data_port) {     
                
                case port_B :
                    PORTA.0=0; 
                    Q2(hexvalue[hezaargan],port_B);
                    delay_ms(10); 
                    PORTA.0=1;
                               
                    PORTA.1=0; 
                    Q2(hexvalue[sadgan],port_B);
                    delay_ms(10); 
                    PORTA.1=1;
                    
                    PORTA.2=0; 
                    Q2(hexvalue[dahgan],port_B);
                    delay_ms(10); 
                    PORTA.2=1;        
                    
                    PORTA.3=0; 
                    Q2(hexvalue[yekan],port_B);
                    delay_ms(10); 
                    PORTA.3=1;
                
                break;
                    
                case port_C : 
                    PORTA.0=0; 
                    Q2(hexvalue[hezaargan],port_C);
                    delay_ms(10); 
                    PORTA.0=1;
                               
                    PORTA.1=0; 
                    Q2(hexvalue[sadgan],port_C);
                    delay_ms(10); 
                    PORTA.1=1;
                    
                    PORTA.2=0; 
                    Q2(hexvalue[dahgan],port_C);
                    delay_ms(10); 
                    PORTA.2=1;        
                    
                    PORTA.3=0; 
                    Q2(hexvalue[yekan],port_C);
                    delay_ms(10); 
                    PORTA.3=1;
                
                break;
                case port_D :
                    PORTA.0=0; 
                    Q2(hexvalue[hezaargan],port_D);
                    delay_ms(10); 
                    PORTA.0=1;
                               
                    PORTA.1=0; 
                    Q2(hexvalue[sadgan],port_D);
                    delay_ms(10); 
                    PORTA.1=1;
                    
                    PORTA.2=0; 
                    Q2(hexvalue[dahgan],port_D);
                    delay_ms(10); 
                    PORTA.2=1;        
                    
                    PORTA.3=0; 
                    Q2(hexvalue[yekan],port_D);
                    delay_ms(10); 
                    PORTA.3=1;
                
                break;
                }; 
        
    break;     
    
    case port_B :
    
                switch (data_port) {
                case port_A : 
                    PORTB.0=0; 
                    Q2(hexvalue[hezaargan],port_A);
                    delay_ms(10); 
                    PORTB.0=1;
                               
                    PORTB.1=0; 
                    Q2(hexvalue[sadgan],port_A);
                    delay_ms(10); 
                    PORTB.1=1;
                    
                    PORTB.2=0; 
                    Q2(hexvalue[dahgan],port_A);
                    delay_ms(10); 
                    PORTB.2=1;        
                    
                    PORTB.3=0; 
                    Q2(hexvalue[yekan],port_A);
                    delay_ms(10); 
                    PORTB.3=1;
                    
                break;     
                    
                case port_C :
                    PORTB.0=0; 
                    Q2(hexvalue[hezaargan],port_C);
                    delay_ms(10); 
                    PORTB.0=1;
                               
                    PORTB.1=0; 
                    Q2(hexvalue[sadgan],port_C);
                    delay_ms(10); 
                    PORTB.1=1;
                    
                    PORTB.2=0; 
                    Q2(hexvalue[dahgan],port_C);
                    delay_ms(10); 
                    PORTB.2=1;        
                    
                    PORTB.3=0; 
                    Q2(hexvalue[yekan],port_C);
                    delay_ms(10); 
                    PORTB.3=1;
                
                break;
                case port_D :
                    PORTB.0=0; 
                    Q2(hexvalue[hezaargan],port_D);
                    delay_ms(10); 
                    PORTB.0=1;
                               
                    PORTB.1=0; 
                    Q2(hexvalue[sadgan],port_D);
                    delay_ms(10); 
                    PORTB.1=1;
                    
                    PORTB.2=0; 
                    Q2(hexvalue[dahgan],port_D);
                    delay_ms(10); 
                    PORTB.2=1;        
                    
                    PORTB.3=0; 
                    Q2(hexvalue[yekan],port_D);
                    delay_ms(10); 
                    PORTB.3=1;
                
                break;
                };
    
    break;
        
    case port_C :
                
                switch (data_port) {
                case port_A : 
                
                    PORTC.0=0; 
                    Q2(hexvalue[hezaargan],port_A);
                    delay_ms(10); 
                    PORTC.0=1;
                               
                    PORTC.1=0; 
                    Q2(hexvalue[sadgan],port_A);
                    delay_ms(10); 
                    PORTC.1=1;
                    
                    PORTC.2=0; 
                    Q2(hexvalue[dahgan],port_A);
                    delay_ms(10); 
                    PORTC.2=1;        
                    
                    PORTC.3=0; 
                    Q2(hexvalue[yekan],port_A);
                    delay_ms(10); 
                    PORTC.3=1; 
                    
                break;     
                
                case port_B : 
                
                    PORTC.0=0; 
                    Q2(hexvalue[hezaargan],port_B);
                    delay_ms(10); 
                    PORTC.0=1;
                               
                    PORTC.1=0; 
                    Q2(hexvalue[sadgan],port_B);
                    delay_ms(10); 
                    PORTC.1=1;
                    
                    PORTC.2=0; 
                    Q2(hexvalue[dahgan],port_B);
                    delay_ms(10); 
                    PORTC.2=1;        
                    
                    PORTC.3=0; 
                    Q2(hexvalue[yekan],port_B);
                    delay_ms(10); 
                    PORTC.3=1;
                    
                break;
                
                case port_D : 
                    PORTC.0=0; 
                    Q2(hexvalue[hezaargan],port_D);
                    delay_ms(10); 
                    PORTC.0=1;
                               
                    PORTC.1=0; 
                    Q2(hexvalue[sadgan],port_D);
                    delay_ms(10); 
                    PORTC.1=1;
                    
                    PORTC.2=0; 
                    Q2(hexvalue[dahgan],port_D);
                    delay_ms(10); 
                    PORTC.2=1;        
                    
                    PORTC.3=0; 
                    Q2(hexvalue[yekan],port_D);
                    delay_ms(10); 
                    PORTC.3=1;
                
                break;
                };
    
    break;
    case port_D :
                switch (data_port) {
                case port_A : 
                    PORTD.0=0; 
                    Q2(hexvalue[hezaargan],port_A);
                    delay_ms(10); 
                    PORTD.0=1;
                               
                    PORTD.1=0; 
                    Q2(hexvalue[sadgan],port_A);
                    delay_ms(10); 
                    PORTD.1=1;
                    
                    PORTD.2=0; 
                    Q2(hexvalue[dahgan],port_A);
                    delay_ms(10); 
                    PORTD.2=1;        
                    
                    PORTD.3=0; 
                    Q2(hexvalue[yekan],port_A);
                    delay_ms(10); 
                    PORTD.3=1;
                    
                break;     
                
                case port_B :
                
                    PORTD.0=0; 
                    Q2(hexvalue[hezaargan],port_B);
                    delay_ms(10); 
                    PORTD.0=1;
                               
                    PORTD.1=0; 
                    Q2(hexvalue[sadgan],port_B);
                    delay_ms(10); 
                    PORTD.1=1;
                    
                    PORTD.2=0; 
                    Q2(hexvalue[dahgan],port_B);
                    delay_ms(10); 
                    PORTD.2=1;        
                    
                    PORTD.3=0; 
                    Q2(hexvalue[yekan],port_B);
                    delay_ms(10); 
                    PORTD.3=1; 
                    
                break;
                    
                case port_C :  
                    
                    PORTD.0=0; 
                    Q2(hexvalue[hezaargan],port_C);
                    delay_ms(10); 
                    PORTD.0=1;
                               
                    PORTD.1=0; 
                    Q2(hexvalue[sadgan],port_C);
                    delay_ms(10); 
                    PORTD.1=1;
                    
                    PORTD.2=0; 
                    Q2(hexvalue[dahgan],port_C);
                    delay_ms(10); 
                    PORTD.2=1;        
                    
                    PORTD.3=0; 
                    Q2(hexvalue[yekan],port_C);
                    delay_ms(10); 
                    PORTD.3=1; 
                
                break;
                };
    break;
    }; 
}