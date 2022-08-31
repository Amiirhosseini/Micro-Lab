#include ".\source\allheaders.h"



void q1(void)
{
    unsigned char name[64]="";
    unsigned char in='';  
    int i=0;
    in = getchar();
    putchar(in); 
    name[0]='(';
    name[1]='<';
    name[2]='<';
    name[3]='>';
    name[4]='>';
    name[5]=')';
    i=i+6;
    while (in!='\r'){ 
        name[i]=in; 
        in = getchar();
        putchar(in);
        i++;    
    }
    name[i]='(';
    name[i+1]='<';
    name[i+2]='<';
    name[i+3]='>';
    name[i+4]='>';
    name[i+5]=')'; 
    name[i+6]='\r';  
    puts(name);    
}
