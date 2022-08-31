
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x20003:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x20000:
	.DB  0x41,0x6D,0x69,0x72,0x72,0x65,0x7A,0x61
	.DB  0x48,0x6F,0x73,0x73,0x65,0x69,0x6E,0x69
	.DB  0xA,0x20,0x20,0x20,0x20,0x39,0x38,0x32
	.DB  0x30,0x33,0x36,0x33,0x0,0x57,0x65,0x6C
	.DB  0x63,0x6F,0x6D,0x65,0x20,0x74,0x6F,0x20
	.DB  0x74,0x68,0x65,0x20,0x4D,0x69,0x63,0x72
	.DB  0x6F,0x70,0x72,0x6F,0x63,0x65,0x73,0x73
	.DB  0x6F,0x72,0x20,0x6C,0x61,0x62,0x20,0x63
	.DB  0x6C,0x61,0x73,0x73,0x65,0x73,0x20,0x69
	.DB  0x6E,0x20,0x49,0x73,0x66,0x61,0x68,0x61
	.DB  0x6E,0x20,0x55,0x6E,0x69,0x76,0x65,0x72
	.DB  0x73,0x69,0x74,0x79,0x20,0x6F,0x66,0x20
	.DB  0x54,0x65,0x63,0x68,0x6E,0x6F,0x6C,0x6F
	.DB  0x67,0x79,0x2E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x53,0x70,0x65,0x65,0x64,0x3A
	.DB  0x3F,0x3F,0x28,0x30,0x2D,0x35,0x30,0x72
	.DB  0x29,0x0,0x45,0x45,0x0,0x54,0x69,0x6D
	.DB  0x65,0x3A,0x3F,0x3F,0x28,0x30,0x2D,0x39
	.DB  0x39,0x73,0x29,0x0,0x57,0x3A,0x3F,0x3F
	.DB  0x28,0x30,0x2D,0x39,0x39,0x4B,0x67,0x29
	.DB  0x0,0x54,0x65,0x6D,0x70,0x3A,0x3F,0x3F
	.DB  0x28,0x32,0x30,0x2D,0x38,0x30,0x43,0x29
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _data_key
	.DW  _0x20003*2

	.DW  0x03
	.DW  _0x20031
	.DW  _0x20000*2+146

	.DW  0x03
	.DW  _0x20045
	.DW  _0x20000*2+146

	.DW  0x03
	.DW  _0x20059
	.DW  _0x20000*2+146

	.DW  0x03
	.DW  _0x2006D
	.DW  _0x20000*2+146

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/9/2022
;Author  : Amirreza Hosseini 9820363
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;
;// Alphanumeric LCD functions
;
;#include ".\source\allheaders.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;
;
;// Declare your global variables here
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0024 {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
; 0000 0025 // Place your code here
; 0000 0026 //
; 0000 0027 //PORTC.0=1;
; 0000 0028 //Q3();
; 0000 0029 //PORTC.0=0;
; 0000 002A 
; 0000 002B }
	RETI
; .FEND
;
;void main(void)
; 0000 002E {
_main:
; .FSTART _main
; 0000 002F // Declare your local variables here
; 0000 0030 
; 0000 0031 // Input/Output Ports initialization
; 0000 0032 // Port A initialization
; 0000 0033 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0034 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0035 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0036 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0037 
; 0000 0038 // Port B initialization
; 0000 0039 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003A DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 003B // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003C PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 003D 
; 0000 003E // Port C initialization
; 0000 003F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0040 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(1)
	OUT  0x14,R30
; 0000 0041 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0
; 0000 0042 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0043 
; 0000 0044 // Port D initialization
; 0000 0045 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0046 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0047 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0048 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0049 
; 0000 004A // External Interrupt(s) initialization
; 0000 004B // INT0: Off
; 0000 004C // INT1: On
; 0000 004D // INT1 Mode: Rising Edge
; 0000 004E // INT2: Off
; 0000 004F //GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
; 0000 0050 //MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
; 0000 0051 //MCUCSR=(0<<ISC2);
; 0000 0052 //GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
; 0000 0053 
; 0000 0054 // Alphanumeric LCD initialization
; 0000 0055 // Connections are specified in the
; 0000 0056 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0057 // RS - PORTA Bit 0
; 0000 0058 // RD - PORTA Bit 1
; 0000 0059 // EN - PORTA Bit 2
; 0000 005A // D4 - PORTA Bit 4
; 0000 005B // D5 - PORTA Bit 5
; 0000 005C // D6 - PORTA Bit 6
; 0000 005D // D7 - PORTA Bit 7
; 0000 005E // Characters/line: 16
; 0000 005F lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0060 
; 0000 0061 // Global enable interrupts
; 0000 0062 //#asm("sei")
; 0000 0063 
; 0000 0064 //Q1();
; 0000 0065 //delay_ms(1000);
; 0000 0066 //lcd_clear();
; 0000 0067 //Q2();
; 0000 0068 
; 0000 0069 Q5();
	RCALL _Q5
; 0000 006A delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 006B Q5_2();
	RCALL _Q5_2
; 0000 006C delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 006D Q5_3();
	RCALL _Q5_3
; 0000 006E delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 006F Q5_4();
	RCALL _Q5_4
; 0000 0070 
; 0000 0071 while (1)
_0x3:
; 0000 0072       {
; 0000 0073       // Place your code here
; 0000 0074 
; 0000 0075      // Q3();
; 0000 0076 
; 0000 0077       }
	RJMP _0x3
; 0000 0078 }
_0x6:
	RJMP _0x6
; .FEND
;
;
;
;#include ".\source\allheaders.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;char data_key[]={
;                '0','1','2','3',
;                '4','5','6','7',
;                '8','9','A','B',
;                'C','D','E','F'};

	.DSEG
;
;void Q1(void)
; 0001 000C {

	.CSEG
; 0001 000D char name_stdnum[30];
; 0001 000E 
; 0001 000F lcd_clear();
;	name_stdnum -> Y+0
; 0001 0010 sprintf(name_stdnum,"AmirrezaHosseini\n    9820363");
; 0001 0011 lcd_puts(name_stdnum);
; 0001 0012 }
;
;void Q2(void)
; 0001 0015 {
; 0001 0016   char text[80];
; 0001 0017   int i=0;
; 0001 0018   char buffer[20];
; 0001 0019 
; 0001 001A   sprintf(text,"Welcome to the Microprocessor lab classes in Isfahan University of Technology.                      ");
;	text -> Y+22
;	i -> R16,R17
;	buffer -> Y+2
; 0001 001B 
; 0001 001C   for(i=0;i<80;i++)
; 0001 001D   {
; 0001 001E          lcd_clear();
; 0001 001F          strncpy(buffer,&text[i],16);
; 0001 0020          lcd_puts(buffer);
; 0001 0021 
; 0001 0022          sprintf(buffer,'');
; 0001 0023          delay_ms(150);
; 0001 0024   }
; 0001 0025 
; 0001 0026 
; 0001 0027 }
;
;
;void Q3(void){
; 0001 002A void Q3(void){
; 0001 002B 
; 0001 002C         lcd_gotoxy(0,0);
; 0001 002D         lcd_putchar( data_key[keypad2()]);
; 0001 002E 
; 0001 002F         delay_ms(150);
; 0001 0030 
; 0001 0031 }
;
;char keypad2(void)
; 0001 0034 {
_keypad2:
; .FSTART _keypad2
; 0001 0035     int r;
; 0001 0036     char key=100;
; 0001 0037     char row[4]={0x10,0x20,0x40,0x80};
; 0001 0038     int c;
; 0001 0039     for (r=0;r<4;r++)
	SBIW R28,4
	LDI  R30,LOW(16)
	ST   Y,R30
	LDI  R30,LOW(32)
	STD  Y+1,R30
	LDI  R30,LOW(64)
	STD  Y+2,R30
	LDI  R30,LOW(128)
	STD  Y+3,R30
	CALL __SAVELOCR6
;	r -> R16,R17
;	key -> R19
;	row -> Y+6
;	c -> R20,R21
	LDI  R19,100
	__GETWRN 16,17,0
_0x20008:
	__CPWRN 16,17,4
	BRGE _0x20009
; 0001 003A     {
; 0001 003B         PORTB=row[r];
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x18,R30
; 0001 003C         c=20;
	__GETWRN 20,21,20
; 0001 003D         delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0001 003E             if (PINB.0==1) c=0;
	SBIS 0x16,0
	RJMP _0x2000A
	__GETWRN 20,21,0
; 0001 003F             if (PINB.1==1) c=1;
_0x2000A:
	SBIS 0x16,1
	RJMP _0x2000B
	__GETWRN 20,21,1
; 0001 0040             if (PINB.2==1) c=2;
_0x2000B:
	SBIS 0x16,2
	RJMP _0x2000C
	__GETWRN 20,21,2
; 0001 0041             if (PINB.3==1) c=3;
_0x2000C:
	SBIS 0x16,3
	RJMP _0x2000D
	__GETWRN 20,21,3
; 0001 0042             if (!(c==20)){
_0x2000D:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x2000E
; 0001 0043         key=(r*4)+c;
	MOV  R30,R16
	LSL  R30
	LSL  R30
	ADD  R30,R20
	MOV  R19,R30
; 0001 0044         PORTB=0xf0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0001 0045             while (PINB.0==1) {}
_0x2000F:
	SBIC 0x16,0
	RJMP _0x2000F
; 0001 0046             while (PINB.1==1) {}
_0x20012:
	SBIC 0x16,1
	RJMP _0x20012
; 0001 0047             while (PINB.2==1) {}
_0x20015:
	SBIC 0x16,2
	RJMP _0x20015
; 0001 0048             while (PINB.3==1) {}
_0x20018:
	SBIC 0x16,3
	RJMP _0x20018
; 0001 0049         }
; 0001 004A         PORTB=0xf0;
_0x2000E:
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0001 004B     }
	__ADDWRN 16,17,1
	RJMP _0x20008
_0x20009:
; 0001 004C 
; 0001 004D     return key;
	MOV  R30,R19
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; 0001 004E }
; .FEND
;
;void Q5(void)
; 0001 0051 {
_Q5:
; .FSTART _Q5
; 0001 0052     char speed[20];
; 0001 0053     int i;
; 0001 0054     char temp='';
; 0001 0055     char temp2='';
; 0001 0056     char temp3[2];
; 0001 0057     int flag=0;
; 0001 0058     int complete=0;
; 0001 0059     char keyret;
; 0001 005A     int total=1000;
; 0001 005B 
; 0001 005C 
; 0001 005D     for(i=0;i<2;i++)
	SBIW R28,27
	LDI  R30,LOW(232)
	ST   Y,R30
	LDI  R30,LOW(3)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	CALL __SAVELOCR6
;	speed -> Y+13
;	i -> R16,R17
;	temp -> R19
;	temp2 -> R18
;	temp3 -> Y+11
;	flag -> R20,R21
;	complete -> Y+9
;	keyret -> Y+8
;	total -> Y+6
	LDI  R19,0
	LDI  R18,0
	__GETWRN 20,21,0
	__GETWRN 16,17,0
_0x2001C:
	__CPWRN 16,17,2
	BRLT PC+2
	RJMP _0x2001D
; 0001 005E     {
; 0001 005F         lcd_clear();
	CALL _lcd_clear
; 0001 0060         lcd_putchar('i');
	LDI  R26,LOW(105)
	CALL _lcd_putchar
; 0001 0061         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0062         lcd_putchar('n');
	LDI  R26,LOW(110)
	CALL _lcd_putchar
; 0001 0063         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0064         lcd_putchar('i');
	LDI  R26,LOW(105)
	CALL _lcd_putchar
; 0001 0065         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0066         lcd_putchar('t');
	LDI  R26,LOW(116)
	CALL _lcd_putchar
; 0001 0067         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0068         lcd_putchar('i');
	LDI  R26,LOW(105)
	CALL _lcd_putchar
; 0001 0069         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 006A         lcd_putchar('a');
	LDI  R26,LOW(97)
	CALL _lcd_putchar
; 0001 006B         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 006C         lcd_putchar('i');
	LDI  R26,LOW(105)
	CALL _lcd_putchar
; 0001 006D         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 006E         lcd_putchar('l');
	LDI  R26,LOW(108)
	CALL _lcd_putchar
; 0001 006F         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0070         lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0001 0071         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0001 0072         lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0001 0073         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0001 0074         lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0001 0075         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0001 0076     }
	__ADDWRN 16,17,1
	RJMP _0x2001C
_0x2001D:
; 0001 0077 
; 0001 0078     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0001 0079 
; 0001 007A     lcd_clear();
	CALL _lcd_clear
; 0001 007B     sprintf(speed,"Speed:??(0-50r)");
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,130
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0001 007C     lcd_puts(speed);
	MOVW R26,R28
	ADIW R26,13
	CALL _lcd_puts
; 0001 007D 
; 0001 007E     while(1)
_0x2001E:
; 0001 007F     {
; 0001 0080         if(flag==0)
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x20021
; 0001 0081         {
; 0001 0082             keyret= keypad2();
	RCALL _keypad2
	STD  Y+8,R30
; 0001 0083             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+8
	CPI  R26,LOW(0x11)
	BRSH _0x20023
	CPI  R26,0
	BRSH _0x20024
_0x20023:
	RJMP _0x20022
_0x20024:
; 0001 0084             {
; 0001 0085                 temp=data_key[keyret];
	LDD  R30,Y+8
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R19,Z
; 0001 0086                 lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0001 0087                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0088                 lcd_puts(&temp);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R19
	CALL _lcd_puts
	POP  R19
; 0001 0089                 flag=1;
	__GETWRN 20,21,1
; 0001 008A             }
; 0001 008B          }
_0x20022:
; 0001 008C 
; 0001 008D         delay_ms(20);
_0x20021:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 008E 
; 0001 008F         if(flag==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x20025
; 0001 0090         {
; 0001 0091              keyret= keypad2();
	RCALL _keypad2
	STD  Y+8,R30
; 0001 0092             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+8
	CPI  R26,LOW(0x11)
	BRSH _0x20027
	CPI  R26,0
	BRSH _0x20028
_0x20027:
	RJMP _0x20026
_0x20028:
; 0001 0093             {
; 0001 0094                 temp2=data_key[keyret];
	LDD  R30,Y+8
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R18,Z
; 0001 0095                 lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0001 0096                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0097                 lcd_puts(&temp2);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R18
	CALL _lcd_puts
	POP  R18
; 0001 0098                 complete=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0001 0099             }
; 0001 009A         }
_0x20026:
; 0001 009B 
; 0001 009C          temp3[0]=temp;
_0x20025:
	__PUTBSR 19,11
; 0001 009D          temp3[1]=temp2;
	MOVW R30,R28
	ADIW R30,12
	ST   Z,R18
; 0001 009E       // sprintf(temp3,"%c%c",temp,temp2);
; 0001 009F       total= atoi(temp3);
	MOVW R26,R28
	ADIW R26,11
	CALL _atoi
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 00A0        if(total<=50 && total>=0 && complete==1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,51
	BRGE _0x2002A
	LDD  R26,Y+7
	TST  R26
	BRMI _0x2002A
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,1
	BREQ _0x2002B
_0x2002A:
	RJMP _0x20029
_0x2002B:
; 0001 00A1        {
; 0001 00A2             break;
	RJMP _0x20020
; 0001 00A3        }
; 0001 00A4        if((total>50 || total<0) && complete==1)
_0x20029:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,51
	BRGE _0x2002D
	LDD  R26,Y+7
	TST  R26
	BRPL _0x2002F
_0x2002D:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,1
	BREQ _0x20030
_0x2002F:
	RJMP _0x2002C
_0x20030:
; 0001 00A5        {
; 0001 00A6             temp='';
	LDI  R19,LOW(0)
; 0001 00A7             temp2='';
	LDI  R18,LOW(0)
; 0001 00A8             sprintf(temp3,'');
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0001 00A9             flag=0;
	__GETWRN 20,21,0
; 0001 00AA             complete=0;
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
; 0001 00AB             total=1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 00AC             lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0001 00AD             lcd_puts("EE");
	__POINTW2MN _0x20031,0
	CALL _lcd_puts
; 0001 00AE        }
; 0001 00AF     }
_0x2002C:
	RJMP _0x2001E
_0x20020:
; 0001 00B0 
; 0001 00B1 }
	CALL __LOADLOCR6
	ADIW R28,33
	RET
; .FEND

	.DSEG
_0x20031:
	.BYTE 0x3
;
;void Q5_2(void)
; 0001 00B4 {

	.CSEG
_Q5_2:
; .FSTART _Q5_2
; 0001 00B5     char time[20];
; 0001 00B6     char temp='';
; 0001 00B7     char temp2='';
; 0001 00B8     char temp3[2];
; 0001 00B9     int flag=0;
; 0001 00BA     int complete=0;
; 0001 00BB     char keyret;
; 0001 00BC     int total=1000;
; 0001 00BD 
; 0001 00BE 
; 0001 00BF      lcd_clear();
	SBIW R28,25
	LDI  R30,LOW(232)
	ST   Y,R30
	LDI  R30,LOW(3)
	STD  Y+1,R30
	CALL __SAVELOCR6
;	time -> Y+11
;	temp -> R17
;	temp2 -> R16
;	temp3 -> Y+9
;	flag -> R18,R19
;	complete -> R20,R21
;	keyret -> Y+8
;	total -> Y+6
	LDI  R17,0
	LDI  R16,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL _lcd_clear
; 0001 00C0     sprintf(time,"Time:??(0-99s)");
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,149
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0001 00C1     lcd_puts(time);
	MOVW R26,R28
	ADIW R26,11
	CALL _lcd_puts
; 0001 00C2 
; 0001 00C3     while(1)
_0x20032:
; 0001 00C4     {
; 0001 00C5         if(flag==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x20035
; 0001 00C6         {
; 0001 00C7             keyret= keypad2();
	RCALL _keypad2
	STD  Y+8,R30
; 0001 00C8             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+8
	CPI  R26,LOW(0x11)
	BRSH _0x20037
	CPI  R26,0
	BRSH _0x20038
_0x20037:
	RJMP _0x20036
_0x20038:
; 0001 00C9             {
; 0001 00CA                 temp=data_key[keyret];
	LDD  R30,Y+8
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R17,Z
; 0001 00CB                 lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0001 00CC                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 00CD                 lcd_puts(&temp);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	CALL _lcd_puts
	POP  R17
; 0001 00CE                 flag=1;
	__GETWRN 18,19,1
; 0001 00CF             }
; 0001 00D0          }
_0x20036:
; 0001 00D1 
; 0001 00D2 
; 0001 00D3         if(flag==1)
_0x20035:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20039
; 0001 00D4         {
; 0001 00D5              keyret= keypad2();
	RCALL _keypad2
	STD  Y+8,R30
; 0001 00D6             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+8
	CPI  R26,LOW(0x11)
	BRSH _0x2003B
	CPI  R26,0
	BRSH _0x2003C
_0x2003B:
	RJMP _0x2003A
_0x2003C:
; 0001 00D7             {
; 0001 00D8                 temp2=data_key[keyret];
	LDD  R30,Y+8
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R16,Z
; 0001 00D9                 lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0001 00DA                 lcd_puts(&temp2);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	CALL _lcd_puts
	POP  R16
; 0001 00DB                 complete=1;
	__GETWRN 20,21,1
; 0001 00DC                 flag=2;
	__GETWRN 18,19,2
; 0001 00DD             }
; 0001 00DE         }
_0x2003A:
; 0001 00DF 
; 0001 00E0          temp3[0]=temp;
_0x20039:
	__PUTBSR 17,9
; 0001 00E1          temp3[1]=temp2;
	MOVW R30,R28
	ADIW R30,10
	ST   Z,R16
; 0001 00E2       // sprintf(temp3,"%c%c",temp,temp2);
; 0001 00E3       total= atoi(temp3);
	MOVW R26,R28
	ADIW R26,9
	CALL _atoi
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 00E4        if(total<=99 && total>=0 && complete==1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x2003E
	LDD  R26,Y+7
	TST  R26
	BRMI _0x2003E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x2003F
_0x2003E:
	RJMP _0x2003D
_0x2003F:
; 0001 00E5        {
; 0001 00E6             break;
	RJMP _0x20034
; 0001 00E7        }
; 0001 00E8        if((total>99 || total<0) && complete==1)
_0x2003D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x20041
	LDD  R26,Y+7
	TST  R26
	BRPL _0x20043
_0x20041:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x20044
_0x20043:
	RJMP _0x20040
_0x20044:
; 0001 00E9        {
; 0001 00EA             temp='';
	LDI  R17,LOW(0)
; 0001 00EB             temp2='';
	LDI  R16,LOW(0)
; 0001 00EC             sprintf(temp3,'');
	MOVW R30,R28
	ADIW R30,9
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0001 00ED             flag=0;
	__GETWRN 18,19,0
; 0001 00EE             complete=0;
	__GETWRN 20,21,0
; 0001 00EF             total=1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 00F0             lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0001 00F1             lcd_puts("EE");
	__POINTW2MN _0x20045,0
	CALL _lcd_puts
; 0001 00F2        }
; 0001 00F3     }
_0x20040:
	RJMP _0x20032
_0x20034:
; 0001 00F4 
; 0001 00F5 }
	RJMP _0x20C0003
; .FEND

	.DSEG
_0x20045:
	.BYTE 0x3
;
;
;
;void Q5_3(void)
; 0001 00FA {

	.CSEG
_Q5_3:
; .FSTART _Q5_3
; 0001 00FB     char w[20];
; 0001 00FC     char temp='';
; 0001 00FD     char temp2='';
; 0001 00FE     char temp3[2];
; 0001 00FF     int flag=0;
; 0001 0100     int complete=0;
; 0001 0101     char keyret;
; 0001 0102     int total=1000;
; 0001 0103 
; 0001 0104 
; 0001 0105     lcd_clear();
	SBIW R28,25
	LDI  R30,LOW(232)
	ST   Y,R30
	LDI  R30,LOW(3)
	STD  Y+1,R30
	CALL __SAVELOCR6
;	w -> Y+11
;	temp -> R17
;	temp2 -> R16
;	temp3 -> Y+9
;	flag -> R18,R19
;	complete -> R20,R21
;	keyret -> Y+8
;	total -> Y+6
	LDI  R17,0
	LDI  R16,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL _lcd_clear
; 0001 0106     sprintf(w,"W:??(0-99Kg)");
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,164
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0001 0107     lcd_puts(w);
	MOVW R26,R28
	ADIW R26,11
	CALL _lcd_puts
; 0001 0108 
; 0001 0109 
; 0001 010A     while(1)
_0x20046:
; 0001 010B     {
; 0001 010C         if(flag==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x20049
; 0001 010D         {
; 0001 010E          delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 010F             keyret= keypad2();
	RCALL _keypad2
	STD  Y+8,R30
; 0001 0110             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+8
	CPI  R26,LOW(0x11)
	BRSH _0x2004B
	CPI  R26,0
	BRSH _0x2004C
_0x2004B:
	RJMP _0x2004A
_0x2004C:
; 0001 0111             {
; 0001 0112                 temp=data_key[keyret];
	LDD  R30,Y+8
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R17,Z
; 0001 0113                 lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0001 0114                 lcd_puts(&temp);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	CALL _lcd_puts
	POP  R17
; 0001 0115                 flag=1;
	__GETWRN 18,19,1
; 0001 0116             }
; 0001 0117          }
_0x2004A:
; 0001 0118 
; 0001 0119 
; 0001 011A         if(flag==1)
_0x20049:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2004D
; 0001 011B         {
; 0001 011C              keyret= keypad2();
	RCALL _keypad2
	STD  Y+8,R30
; 0001 011D             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+8
	CPI  R26,LOW(0x11)
	BRSH _0x2004F
	CPI  R26,0
	BRSH _0x20050
_0x2004F:
	RJMP _0x2004E
_0x20050:
; 0001 011E             {
; 0001 011F                 temp2=data_key[keyret];
	LDD  R30,Y+8
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R16,Z
; 0001 0120                 lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0001 0121                 lcd_puts(&temp2);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _lcd_puts
	POP  R16
; 0001 0122                 complete=1;
	__GETWRN 20,21,1
; 0001 0123             }
; 0001 0124         }
_0x2004E:
; 0001 0125 
; 0001 0126          temp3[0]=temp;
_0x2004D:
	__PUTBSR 17,9
; 0001 0127          temp3[1]=temp2;
	MOVW R30,R28
	ADIW R30,10
	ST   Z,R16
; 0001 0128       // sprintf(temp3,"%c%c",temp,temp2);
; 0001 0129       total= atoi(temp3);
	MOVW R26,R28
	ADIW R26,9
	CALL _atoi
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 012A        if(total<=99 && total>=0 && complete==1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x20052
	LDD  R26,Y+7
	TST  R26
	BRMI _0x20052
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x20053
_0x20052:
	RJMP _0x20051
_0x20053:
; 0001 012B        {
; 0001 012C             flag=0;
	__GETWRN 18,19,0
; 0001 012D             complete=0;
	__GETWRN 20,21,0
; 0001 012E             break;
	RJMP _0x20048
; 0001 012F        }
; 0001 0130        if((total>99 || total<0) && complete==1)
_0x20051:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x20055
	LDD  R26,Y+7
	TST  R26
	BRPL _0x20057
_0x20055:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x20058
_0x20057:
	RJMP _0x20054
_0x20058:
; 0001 0131        {
; 0001 0132             temp='';
	LDI  R17,LOW(0)
; 0001 0133             temp2='';
	LDI  R16,LOW(0)
; 0001 0134             flag=0;
	__GETWRN 18,19,0
; 0001 0135             complete=0;
	__GETWRN 20,21,0
; 0001 0136             total=1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0137             lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0001 0138             lcd_puts("EE");
	__POINTW2MN _0x20059,0
	RCALL _lcd_puts
; 0001 0139        }
; 0001 013A     }
_0x20054:
	RJMP _0x20046
_0x20048:
; 0001 013B 
; 0001 013C }
_0x20C0003:
	CALL __LOADLOCR6
	ADIW R28,31
	RET
; .FEND

	.DSEG
_0x20059:
	.BYTE 0x3
;
;
;void Q5_4(void)
; 0001 0140 {

	.CSEG
_Q5_4:
; .FSTART _Q5_4
; 0001 0141     char TEMP[30];
; 0001 0142     char temp='';
; 0001 0143     char temp2='';
; 0001 0144     char temp3[2];
; 0001 0145     int flag=0;
; 0001 0146     int complete=0;
; 0001 0147     char keyret;
; 0001 0148     int total=1000;
; 0001 0149     int i;
; 0001 014A 
; 0001 014B 
; 0001 014C     lcd_clear();
	SBIW R28,37
	LDI  R30,LOW(232)
	STD  Y+2,R30
	LDI  R30,LOW(3)
	STD  Y+3,R30
	CALL __SAVELOCR6
;	TEMP -> Y+13
;	temp -> R17
;	temp2 -> R16
;	temp3 -> Y+11
;	flag -> R18,R19
;	complete -> R20,R21
;	keyret -> Y+10
;	total -> Y+8
;	i -> Y+6
	LDI  R17,0
	LDI  R16,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RCALL _lcd_clear
; 0001 014D     sprintf(TEMP,"Temp:??(20-80C)");
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,177
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0001 014E     lcd_puts(TEMP);
	MOVW R26,R28
	ADIW R26,13
	RCALL _lcd_puts
; 0001 014F 
; 0001 0150 
; 0001 0151     while(1)
_0x2005A:
; 0001 0152     {
; 0001 0153         delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0154         if(flag==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2005D
; 0001 0155         {
; 0001 0156          delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0157             keyret= keypad2();
	RCALL _keypad2
	STD  Y+10,R30
; 0001 0158             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+10
	CPI  R26,LOW(0x11)
	BRSH _0x2005F
	CPI  R26,0
	BRSH _0x20060
_0x2005F:
	RJMP _0x2005E
_0x20060:
; 0001 0159             {
; 0001 015A                 temp=data_key[keyret];
	LDD  R30,Y+10
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R17,Z
; 0001 015B                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 015C                 lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0001 015D                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 015E                 lcd_puts(&temp);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _lcd_puts
	POP  R17
; 0001 015F                 flag=1;
	__GETWRN 18,19,1
; 0001 0160             }
; 0001 0161          }
_0x2005E:
; 0001 0162 
; 0001 0163         delay_ms(20);
_0x2005D:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0164         if(flag==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20061
; 0001 0165         {
; 0001 0166              keyret= keypad2();
	RCALL _keypad2
	STD  Y+10,R30
; 0001 0167             if(keyret<=16 && keyret>=0)
	LDD  R26,Y+10
	CPI  R26,LOW(0x11)
	BRSH _0x20063
	CPI  R26,0
	BRSH _0x20064
_0x20063:
	RJMP _0x20062
_0x20064:
; 0001 0168             {
; 0001 0169                 temp2=data_key[keyret];
	LDD  R30,Y+10
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R16,Z
; 0001 016A 
; 0001 016B                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 016C                 lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0001 016D                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 016E                 lcd_puts(&temp2);
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _lcd_puts
	POP  R16
; 0001 016F                 complete=1;
	__GETWRN 20,21,1
; 0001 0170             }
; 0001 0171         }
_0x20062:
; 0001 0172 
; 0001 0173          temp3[0]=temp;
_0x20061:
	__PUTBSR 17,11
; 0001 0174          temp3[1]=temp2;
	MOVW R30,R28
	ADIW R30,12
	ST   Z,R16
; 0001 0175       // sprintf(temp3,"%c%c",temp,temp2);
; 0001 0176       total= atoi(temp3);
	MOVW R26,R28
	ADIW R26,11
	CALL _atoi
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0177       delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0178        if(total<=80 && total>=20 && complete==1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CPI  R26,LOW(0x51)
	LDI  R30,HIGH(0x51)
	CPC  R27,R30
	BRGE _0x20066
	SBIW R26,20
	BRLT _0x20066
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x20067
_0x20066:
	RJMP _0x20065
_0x20067:
; 0001 0179        {
; 0001 017A             flag=0;
	__GETWRN 18,19,0
; 0001 017B             complete=0;
	__GETWRN 20,21,0
; 0001 017C             break;
	RJMP _0x2005C
; 0001 017D        }
; 0001 017E        if((total>80 || total<20) && complete==1)
_0x20065:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CPI  R26,LOW(0x51)
	LDI  R30,HIGH(0x51)
	CPC  R27,R30
	BRGE _0x20069
	SBIW R26,20
	BRGE _0x2006B
_0x20069:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x2006C
_0x2006B:
	RJMP _0x20068
_0x2006C:
; 0001 017F        {
; 0001 0180             temp='';
	LDI  R17,LOW(0)
; 0001 0181             temp2='';
	LDI  R16,LOW(0)
; 0001 0182             flag=0;
	__GETWRN 18,19,0
; 0001 0183             complete=0;
	__GETWRN 20,21,0
; 0001 0184             total=1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0185             lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0001 0186             lcd_puts("EE");
	__POINTW2MN _0x2006D,0
	RCALL _lcd_puts
; 0001 0187             delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0188        }
; 0001 0189     }
_0x20068:
	RJMP _0x2005A
_0x2005C:
; 0001 018A 
; 0001 018B     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0001 018C 
; 0001 018D     for(i=0;i<2;i++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x2006F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRLT PC+2
	RJMP _0x20070
; 0001 018E     {
; 0001 018F         lcd_clear();
	RCALL _lcd_clear
; 0001 0190         lcd_putchar('C');
	LDI  R26,LOW(67)
	RCALL _lcd_putchar
; 0001 0191         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0192         lcd_putchar('o');
	LDI  R26,LOW(111)
	RCALL _lcd_putchar
; 0001 0193         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0194         lcd_putchar('m');
	LDI  R26,LOW(109)
	RCALL _lcd_putchar
; 0001 0195         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0196         lcd_putchar('p');
	LDI  R26,LOW(112)
	RCALL _lcd_putchar
; 0001 0197         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 0198         lcd_putchar('l');
	LDI  R26,LOW(108)
	RCALL _lcd_putchar
; 0001 0199         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 019A         lcd_putchar('e');
	LDI  R26,LOW(101)
	RCALL _lcd_putchar
; 0001 019B         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 019C         lcd_putchar('t');
	LDI  R26,LOW(116)
	RCALL _lcd_putchar
; 0001 019D         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 019E         lcd_putchar('e');
	LDI  R26,LOW(101)
	RCALL _lcd_putchar
; 0001 019F         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 01A0         lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0001 01A1         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0001 01A2         lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0001 01A3         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0001 01A4         lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0001 01A5         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0001 01A6     }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2006F
_0x20070:
; 0001 01A7 
; 0001 01A8 }
	CALL __LOADLOCR6
	ADIW R28,43
	RET
; .FEND

	.DSEG
_0x2006D:
	.BYTE 0x3
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0002
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG

	.DSEG
_data_key:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
