#include ".\source\allheaders.h"

void q2(void)
{
    unsigned char input='';
    int a=0;
    unsigned char str[3]="";
    input = getchar(); 
    switch (input){
        case '0':
            a=0;
            break;
        case '1':
            a=1;
            break;
        case '2':
            a=2;
            break;
        case '3':
            a=3;
            break;
        case '4':
            a=4;
            break;
        case '5':
            a=5;
            break;
        case '6':
            a=6;
            break;
        case '7':
            a=7;
            break; 
        case '8':
            a=8;
            break;
        case '9':
            a=9;
            break;
        default:
            a=100;
    }  
    if( a>=0 && a<10){
        puts("\rTx:");
        putchar(input);
        puts("\rRx: Data is a integer and 10*data=");
        a=a*10;
        sprintf(str, "%d", a);
        puts(str);
        puts("\r");
     } 
    
    else if(input=='D'){
        lcd_puts("LCD Deleted");
    } 
    
    else if(input=='H'){
        puts("\rMicro processor Lab in Pandemic of Corona Virus\r");
    }  
    else if(input=='E'){
        puts("\rRx: END of the part\r");
    }
    else { 
        puts("\rTx: ");
        putchar(input);
        puts("\r");
        puts("\rRx: input letter is:");
        putchar(input);
        puts("\r");
    }    

}

void q3(void)
{
    unsigned char my_data[64]="";
    unsigned char in4='';  
    int i=0;
    int a=0;
    int j=0;
    in4 = getchar();
    putchar(in4); 
    my_data[0]='(';
    i++; 
    while (in4!='\r'){ 
        my_data[i]=in4; 
        in4 = getchar();
        putchar(in4);
        i++;    
    }
    my_data[i]=')';  
    for (j=0;my_data[j]!=')';j++){ 
        switch (my_data[j]){
        case '0':
            a=0;
            break;
        case '1':
            a=1;
            break;
        case '2':
            a=2;
            break;
        case '3':
            a=3;
            break;
        case '4':
            a=4;
            break;
        case '5':
            a=5;
            break;
        case '6':
            a=6;
            break;
        case '7':
            a=7;
            break; 
        case '8':
            a=8;
            break;
        case '9':
            a=9;
            break;
        default:
            a=100;
    }     
    }
    if (a>9){
       puts("\rFrame must be 5 integer\r"); 
    }
    else if(i!=6){  
        puts("\rLength of frame not correct\r");
    }
    else { 
        puts("\tFrame is correct\r");
        lcd_puts(my_data);
    }  
}