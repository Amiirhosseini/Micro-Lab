/*
 * GccApplication1.c
 *
 * Created: 1/8/2022 3:57:36 PM
 * Author : Amirreza Hosseini 9820363
 */ 

#define F_CPU 8000000UL			/* Define CPU Frequency e.g. here 8MHz */
#include <avr/io.h>			/* Include AVR std. library file */
#include <util/delay.h>			/* Include Delay header file */
#include <avr/interrupt.h>

#define LCD_Dir  DDRB			/* Define LCD data port direction */
#define LCD_Port PORTB			/* Define LCD data port */
#define RS PB0				/* Define Register Select pin */
#define EN PB1 				/* Define Enable signal pin */


void LCD_Command( unsigned char cmnd )
{
	LCD_Port = (LCD_Port & 0x0F) | (cmnd & 0xF0); /* sending upper nibble */
	LCD_Port &= ~ (1<<RS);		/* RS=0, command reg. */
	LCD_Port |= (1<<EN);		/* Enable pulse */
	_delay_us(1);
	LCD_Port &= ~ (1<<EN);

	_delay_us(200);

	LCD_Port = (LCD_Port & 0x0F) | (cmnd << 4);  /* sending lower nibble */
	LCD_Port |= (1<<EN);
	_delay_us(1);
	LCD_Port &= ~ (1<<EN);
	_delay_ms(2);
}


void LCD_Char( unsigned char data )
{
	LCD_Port = (LCD_Port & 0x0F) | (data & 0xF0); /* sending upper nibble */
	LCD_Port |= (1<<RS);		/* RS=1, data reg. */
	LCD_Port|= (1<<EN);
	_delay_us(1);
	LCD_Port &= ~ (1<<EN);

	_delay_us(200);

	LCD_Port = (LCD_Port & 0x0F) | (data << 4); /* sending lower nibble */
	LCD_Port |= (1<<EN);
	_delay_us(1);
	LCD_Port &= ~ (1<<EN);
	_delay_ms(2);
}

void LCD_Init (void)			/* LCD Initialize function */
{
	LCD_Dir = 0xFF;			/* Make LCD port direction as o/p */
	_delay_ms(20);			/* LCD Power ON delay always >15ms */
	
	LCD_Command(0x02);		/* send for 4 bit initialization of LCD  */
	LCD_Command(0x28);              /* 2 line, 5*7 matrix in 4-bit mode */
	LCD_Command(0x0c);              /* Display on cursor off*/
	LCD_Command(0x06);              /* Increment cursor (shift cursor to right)*/
	LCD_Command(0x01);              /* Clear display screen*/
	_delay_ms(2);
}


void LCD_String (char *str)		/* Send string to LCD function */
{
	int i;
	for(i=0;str[i]!=0;i++)		/* Send each char of string till the NULL */
	{
		LCD_Char (str[i]);
	}
}

void LCD_String_xy (char row, char pos, char *str)	/* Send string to LCD with xy position */
{
	if (row == 0 && pos<16)
	LCD_Command((pos & 0x0F)|0x80);	/* Command of first row and required position<16 */
	else if (row == 1 && pos<16)
	LCD_Command((pos & 0x0F)|0xC0);	/* Command of first row and required position<16 */
	LCD_String(str);		/* Call LCD string function */
}

void LCD_Clear()
{
	LCD_Command (0x01);		/* Clear display */
	_delay_ms(2);
	LCD_Command (0x80);		/* Cursor at home position */
}




/*Interrupt Service Routine for INT0*/
ISR(INT0_vect, ISR_NOBLOCK)
{
	//sei();			/* Enable Global Interrupt */
	LCD_Init();
	LCD_String("in routine 0");
	_delay_ms(100);  	/* Software debouncing control delay */
}

/*Interrupt Service Routine for INT1*/
ISR(INT1_vect, ISR_NOBLOCK)
{
	//sei();			/* Enable Global Interrupt */
	LCD_Init();
	//LCD_Command(0xC0);		/* Go to 2nd line*/
	LCD_String("in routine 1");
	_delay_ms(100);  	/* Software debouncing control delay */
}

/*Interrupt Service Routine for INT2*/
ISR(INT2_vect, ISR_NOBLOCK)
{
	//sei();			/* Enable Global Interrupt */
	LCD_Init();
	LCD_String("in routine 2");
	_delay_ms(100);  	/* Software debouncing control delay */
}


int main()
{

	LCD_Init();			/* Initialization of LCD*/

	LCD_String("AmirrezaHosseini");	/* Write string on 1st line of LCD*/
	LCD_Command(0xC0);		/* Go to 2nd line*/
	LCD_String("9820363");	/* Write string on 2nd line*/ 
	
	_delay_ms(500);
	
	//DDRD=0;			/* PORTD as input */
	//PORTD=0xFF;		/* Make pull up high */
	
	//GICR = 1<<INT0;		/* Enable INT0*/
	
	//SET EXTERNAL INTERRUPT FOR INT0, INT1 AND INT2
	GICR=(1<<7)|(1<<6)|(1<<5);
	MCUCR = 1<<ISC01 | 0<<ISC00 | 0<<ISC11 | 0<<ISC10;  /* Trigger INT0 + INT1 on FALLING + LOW-LATCH edge */
	MCUCSR = 1<<ISC2;  /* Trigger INT2 on rising edge */
	sei();			/* Enable Global Interrupt */
	
	
	while(1)
	{
		LCD_Init();
		//LCD_String("in main");
	}
}

