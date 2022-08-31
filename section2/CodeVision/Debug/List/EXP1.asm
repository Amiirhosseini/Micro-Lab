
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
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

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  0x00
	JMP  0x00

_0x20003:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _hexvalue
	.DW  _0x20003*2

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
;Project : EXP2-ATmega16
;Version :
;Date    : 2/27/2022
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
;#include ".\source\AllHeaders.h"
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
;void main(void)
; 0000 001C {

	.CSEG
_main:
; .FSTART _main
; 0000 001D // Declare your local variables here
; 0000 001E 
; 0000 001F // Input/Output Ports initialization
; 0000 0020 // Port A initialization
; 0000 0021 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0022 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0023 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0024 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0025 
; 0000 0026 // Port B initialization
; 0000 0027 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0028 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0029 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 002A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 002B 
; 0000 002C // Port C initialization
; 0000 002D // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 002E DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 002F // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0030 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0031 
; 0000 0032 // Port D initialization
; 0000 0033 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0034 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0035 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0036 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 0037 
; 0000 0038 
; 0000 0039 Q3(5,500);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _Q3
; 0000 003A 
; 0000 003B while (1)
_0x3:
; 0000 003C       {
; 0000 003D         Q4();
	RCALL _Q4
; 0000 003E 
; 0000 003F         seven_seg_display(17,port_C,port_D);
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x0
	RCALL _seven_seg_display
; 0000 0040       }
	RJMP _0x3
; 0000 0041 
; 0000 0042 }
_0x6:
	RJMP _0x6
; .FEND
;
;
;
;#include ".\source\AllHeaders.h"
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
;extern unsigned char hexvalue[10]= {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; //0 to 9 in 7seg

	.DSEG
;
;int Q1(int port_in)
; 0001 0007 {

	.CSEG
_Q1:
; .FSTART _Q1
; 0001 0008 int data_in;
; 0001 0009 
; 0001 000A switch(port_in)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	port_in -> Y+2
;	data_in -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
; 0001 000B {
; 0001 000C     case port_A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20007
; 0001 000D         data_in=PINA;
	IN   R16,25
	RJMP _0x200F4
; 0001 000E     break ;
; 0001 000F 
; 0001 0010     case port_B:
_0x20007:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x200F5
; 0001 0011         data_in=PINB;
; 0001 0012     break ;
; 0001 0013 
; 0001 0014     case port_C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20009
; 0001 0015         data_in=PINC;
	IN   R16,19
	RJMP _0x200F4
; 0001 0016     break ;
; 0001 0017 
; 0001 0018     case port_D:
_0x20009:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20006
; 0001 0019         data_in=PINB;
_0x200F5:
	IN   R16,22
_0x200F4:
	CLR  R17
; 0001 001A     break;
; 0001 001B 
; 0001 001C }
_0x20006:
; 0001 001D return data_in;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000001
; 0001 001E }
; .FEND
;
;void Q2(int data , int port_in)
; 0001 0021 {
_Q2:
; .FSTART _Q2
; 0001 0022 switch(port_in)
	ST   -Y,R27
	ST   -Y,R26
;	data -> Y+2
;	port_in -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0001 0023 {
; 0001 0024     case port_A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2000E
; 0001 0025         PORTA=data;
	LDD  R30,Y+2
	OUT  0x1B,R30
; 0001 0026     break ;
	RJMP _0x2000D
; 0001 0027     case port_B:
_0x2000E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2000F
; 0001 0028         PORTB=data;
	LDD  R30,Y+2
	OUT  0x18,R30
; 0001 0029     break ;
	RJMP _0x2000D
; 0001 002A     case port_C:
_0x2000F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20010
; 0001 002B         PORTC=data;
	LDD  R30,Y+2
	OUT  0x15,R30
; 0001 002C     break ;
	RJMP _0x2000D
; 0001 002D     case port_D:
_0x20010:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2000D
; 0001 002E         PORTD=data;
	LDD  R30,Y+2
	OUT  0x12,R30
; 0001 002F     break ;
; 0001 0030 }
_0x2000D:
; 0001 0031 
; 0001 0032 }
_0x2000001:
	ADIW R28,4
	RET
; .FEND
;
;void Q3(int numbers,int time)
; 0001 0035 {
_Q3:
; .FSTART _Q3
; 0001 0036 int i;
; 0001 0037     for (i=0;i<numbers;i++) {
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	numbers -> Y+4
;	time -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x20013:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x20014
; 0001 0038         delay_ms(time);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _delay_ms
; 0001 0039         Q2(0xFF,port_B);
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RCALL SUBOPT_0x1
; 0001 003A         delay_ms(time);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _delay_ms
; 0001 003B         Q2(0x00,port_B);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x1
; 0001 003C 
; 0001 003D     };
	__ADDWRN 16,17,1
	RJMP _0x20013
_0x20014:
; 0001 003E }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND
;
;void Q4(void)
; 0001 0041 {
_Q4:
; .FSTART _Q4
; 0001 0042     int data;
; 0001 0043     data= Q1(port_A);
	ST   -Y,R17
	ST   -Y,R16
;	data -> R16,R17
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _Q1
	MOVW R16,R30
; 0001 0044     Q2(data,port_B);
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _Q2
; 0001 0045 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;void seven_seg_display (int data, int data_port, int enable_data)
; 0001 0049 {
_seven_seg_display:
; .FSTART _seven_seg_display
; 0001 004A int yekan=0;
; 0001 004B int dahgan=0;
; 0001 004C int sadgan=0;
; 0001 004D int hezaargan=0;
; 0001 004E 
; 0001 004F yekan = data%10;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	data -> Y+12
;	data_port -> Y+10
;	enable_data -> Y+8
;	yekan -> R16,R17
;	dahgan -> R18,R19
;	sadgan -> R20,R21
;	hezaargan -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RCALL SUBOPT_0x2
	CALL __MODW21
	MOVW R16,R30
; 0001 0050 data=data/10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0001 0051 dahgan = data%10;
	CALL __MODW21
	MOVW R18,R30
; 0001 0052 data=data/10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0001 0053 sadgan=data%10;
	CALL __MODW21
	MOVW R20,R30
; 0001 0054 data=data/10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0001 0055 hezaargan=data%10;
	CALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0056 
; 0001 0057     switch (enable_data) {
	LDD  R30,Y+8
	LDD  R31,Y+8+1
; 0001 0058     case port_A :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20018
; 0001 0059             switch (data_port) {
	LDD  R30,Y+10
	LDD  R31,Y+10+1
; 0001 005A 
; 0001 005B                 case port_B :
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2001C
; 0001 005C                     PORTA.0=0;
	RCALL SUBOPT_0x4
; 0001 005D                     Q2(hexvalue[hezaargan],port_B);
	RCALL SUBOPT_0x1
; 0001 005E                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 005F                     PORTA.0=1;
	RCALL SUBOPT_0x6
; 0001 0060 
; 0001 0061                     PORTA.1=0;
; 0001 0062                     Q2(hexvalue[sadgan],port_B);
	RCALL SUBOPT_0x1
; 0001 0063                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 0064                     PORTA.1=1;
	RCALL SUBOPT_0x7
; 0001 0065 
; 0001 0066                     PORTA.2=0;
; 0001 0067                     Q2(hexvalue[dahgan],port_B);
	RCALL SUBOPT_0x1
; 0001 0068                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 0069                     PORTA.2=1;
	RCALL SUBOPT_0x8
; 0001 006A 
; 0001 006B                     PORTA.3=0;
; 0001 006C                     Q2(hexvalue[yekan],port_B);
	LDI  R26,LOW(2)
	RJMP _0x200F6
; 0001 006D                     delay_ms(10);
; 0001 006E                     PORTA.3=1;
; 0001 006F 
; 0001 0070                 break;
; 0001 0071 
; 0001 0072                 case port_C :
_0x2001C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2002D
; 0001 0073                     PORTA.0=0;
	RCALL SUBOPT_0x4
; 0001 0074                     Q2(hexvalue[hezaargan],port_C);
	RCALL SUBOPT_0x9
; 0001 0075                     delay_ms(10);
; 0001 0076                     PORTA.0=1;
	RCALL SUBOPT_0x6
; 0001 0077 
; 0001 0078                     PORTA.1=0;
; 0001 0079                     Q2(hexvalue[sadgan],port_C);
	RCALL SUBOPT_0x9
; 0001 007A                     delay_ms(10);
; 0001 007B                     PORTA.1=1;
	RCALL SUBOPT_0x7
; 0001 007C 
; 0001 007D                     PORTA.2=0;
; 0001 007E                     Q2(hexvalue[dahgan],port_C);
	RCALL SUBOPT_0x9
; 0001 007F                     delay_ms(10);
; 0001 0080                     PORTA.2=1;
	RCALL SUBOPT_0x8
; 0001 0081 
; 0001 0082                     PORTA.3=0;
; 0001 0083                     Q2(hexvalue[yekan],port_C);
	LDI  R26,LOW(3)
	RJMP _0x200F6
; 0001 0084                     delay_ms(10);
; 0001 0085                     PORTA.3=1;
; 0001 0086 
; 0001 0087                 break;
; 0001 0088                 case port_D :
_0x2002D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2001B
; 0001 0089                     PORTA.0=0;
	RCALL SUBOPT_0x4
; 0001 008A                     Q2(hexvalue[hezaargan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 008B                     delay_ms(10);
; 0001 008C                     PORTA.0=1;
	RCALL SUBOPT_0x6
; 0001 008D 
; 0001 008E                     PORTA.1=0;
; 0001 008F                     Q2(hexvalue[sadgan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 0090                     delay_ms(10);
; 0001 0091                     PORTA.1=1;
	RCALL SUBOPT_0x7
; 0001 0092 
; 0001 0093                     PORTA.2=0;
; 0001 0094                     Q2(hexvalue[dahgan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 0095                     delay_ms(10);
; 0001 0096                     PORTA.2=1;
	RCALL SUBOPT_0x8
; 0001 0097 
; 0001 0098                     PORTA.3=0;
; 0001 0099                     Q2(hexvalue[yekan],port_D);
	LDI  R26,LOW(4)
_0x200F6:
	LDI  R27,0
	RCALL SUBOPT_0xA
; 0001 009A                     delay_ms(10);
; 0001 009B                     PORTA.3=1;
	SBI  0x1B,3
; 0001 009C 
; 0001 009D                 break;
; 0001 009E                 };
_0x2001B:
; 0001 009F 
; 0001 00A0     break;
	RJMP _0x20017
; 0001 00A1 
; 0001 00A2     case port_B :
_0x20018:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2004F
; 0001 00A3 
; 0001 00A4                 switch (data_port) {
	RCALL SUBOPT_0xB
; 0001 00A5                 case port_A :
	BRNE _0x20053
; 0001 00A6                     PORTB.0=0;
	RCALL SUBOPT_0xC
; 0001 00A7                     Q2(hexvalue[hezaargan],port_A);
	RCALL SUBOPT_0xD
; 0001 00A8                     delay_ms(10);
; 0001 00A9                     PORTB.0=1;
	RCALL SUBOPT_0xE
; 0001 00AA 
; 0001 00AB                     PORTB.1=0;
; 0001 00AC                     Q2(hexvalue[sadgan],port_A);
	RCALL SUBOPT_0xD
; 0001 00AD                     delay_ms(10);
; 0001 00AE                     PORTB.1=1;
	RCALL SUBOPT_0xF
; 0001 00AF 
; 0001 00B0                     PORTB.2=0;
; 0001 00B1                     Q2(hexvalue[dahgan],port_A);
	RCALL SUBOPT_0xD
; 0001 00B2                     delay_ms(10);
; 0001 00B3                     PORTB.2=1;
	RCALL SUBOPT_0x10
; 0001 00B4 
; 0001 00B5                     PORTB.3=0;
; 0001 00B6                     Q2(hexvalue[yekan],port_A);
	LDI  R26,LOW(1)
	RJMP _0x200F7
; 0001 00B7                     delay_ms(10);
; 0001 00B8                     PORTB.3=1;
; 0001 00B9 
; 0001 00BA                 break;
; 0001 00BB 
; 0001 00BC                 case port_C :
_0x20053:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20064
; 0001 00BD                     PORTB.0=0;
	RCALL SUBOPT_0xC
; 0001 00BE                     Q2(hexvalue[hezaargan],port_C);
	RCALL SUBOPT_0x9
; 0001 00BF                     delay_ms(10);
; 0001 00C0                     PORTB.0=1;
	RCALL SUBOPT_0xE
; 0001 00C1 
; 0001 00C2                     PORTB.1=0;
; 0001 00C3                     Q2(hexvalue[sadgan],port_C);
	RCALL SUBOPT_0x9
; 0001 00C4                     delay_ms(10);
; 0001 00C5                     PORTB.1=1;
	RCALL SUBOPT_0xF
; 0001 00C6 
; 0001 00C7                     PORTB.2=0;
; 0001 00C8                     Q2(hexvalue[dahgan],port_C);
	RCALL SUBOPT_0x9
; 0001 00C9                     delay_ms(10);
; 0001 00CA                     PORTB.2=1;
	RCALL SUBOPT_0x10
; 0001 00CB 
; 0001 00CC                     PORTB.3=0;
; 0001 00CD                     Q2(hexvalue[yekan],port_C);
	LDI  R26,LOW(3)
	RJMP _0x200F7
; 0001 00CE                     delay_ms(10);
; 0001 00CF                     PORTB.3=1;
; 0001 00D0 
; 0001 00D1                 break;
; 0001 00D2                 case port_D :
_0x20064:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20052
; 0001 00D3                     PORTB.0=0;
	RCALL SUBOPT_0xC
; 0001 00D4                     Q2(hexvalue[hezaargan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 00D5                     delay_ms(10);
; 0001 00D6                     PORTB.0=1;
	RCALL SUBOPT_0xE
; 0001 00D7 
; 0001 00D8                     PORTB.1=0;
; 0001 00D9                     Q2(hexvalue[sadgan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 00DA                     delay_ms(10);
; 0001 00DB                     PORTB.1=1;
	RCALL SUBOPT_0xF
; 0001 00DC 
; 0001 00DD                     PORTB.2=0;
; 0001 00DE                     Q2(hexvalue[dahgan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 00DF                     delay_ms(10);
; 0001 00E0                     PORTB.2=1;
	RCALL SUBOPT_0x10
; 0001 00E1 
; 0001 00E2                     PORTB.3=0;
; 0001 00E3                     Q2(hexvalue[yekan],port_D);
	LDI  R26,LOW(4)
_0x200F7:
	LDI  R27,0
	RCALL SUBOPT_0xA
; 0001 00E4                     delay_ms(10);
; 0001 00E5                     PORTB.3=1;
	SBI  0x18,3
; 0001 00E6 
; 0001 00E7                 break;
; 0001 00E8                 };
_0x20052:
; 0001 00E9 
; 0001 00EA     break;
	RJMP _0x20017
; 0001 00EB 
; 0001 00EC     case port_C :
_0x2004F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20086
; 0001 00ED 
; 0001 00EE                 switch (data_port) {
	RCALL SUBOPT_0xB
; 0001 00EF                 case port_A :
	BRNE _0x2008A
; 0001 00F0 
; 0001 00F1                     PORTC.0=0;
	RCALL SUBOPT_0x11
; 0001 00F2                     Q2(hexvalue[hezaargan],port_A);
	RCALL SUBOPT_0xD
; 0001 00F3                     delay_ms(10);
; 0001 00F4                     PORTC.0=1;
	RCALL SUBOPT_0x12
; 0001 00F5 
; 0001 00F6                     PORTC.1=0;
; 0001 00F7                     Q2(hexvalue[sadgan],port_A);
	RCALL SUBOPT_0xD
; 0001 00F8                     delay_ms(10);
; 0001 00F9                     PORTC.1=1;
	RCALL SUBOPT_0x13
; 0001 00FA 
; 0001 00FB                     PORTC.2=0;
; 0001 00FC                     Q2(hexvalue[dahgan],port_A);
	RCALL SUBOPT_0xD
; 0001 00FD                     delay_ms(10);
; 0001 00FE                     PORTC.2=1;
	RCALL SUBOPT_0x14
; 0001 00FF 
; 0001 0100                     PORTC.3=0;
; 0001 0101                     Q2(hexvalue[yekan],port_A);
	LDI  R26,LOW(1)
	RJMP _0x200F8
; 0001 0102                     delay_ms(10);
; 0001 0103                     PORTC.3=1;
; 0001 0104 
; 0001 0105                 break;
; 0001 0106 
; 0001 0107                 case port_B :
_0x2008A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2009B
; 0001 0108 
; 0001 0109                     PORTC.0=0;
	RCALL SUBOPT_0x11
; 0001 010A                     Q2(hexvalue[hezaargan],port_B);
	RCALL SUBOPT_0x1
; 0001 010B                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 010C                     PORTC.0=1;
	RCALL SUBOPT_0x12
; 0001 010D 
; 0001 010E                     PORTC.1=0;
; 0001 010F                     Q2(hexvalue[sadgan],port_B);
	RCALL SUBOPT_0x1
; 0001 0110                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 0111                     PORTC.1=1;
	RCALL SUBOPT_0x13
; 0001 0112 
; 0001 0113                     PORTC.2=0;
; 0001 0114                     Q2(hexvalue[dahgan],port_B);
	RCALL SUBOPT_0x1
; 0001 0115                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 0116                     PORTC.2=1;
	RCALL SUBOPT_0x14
; 0001 0117 
; 0001 0118                     PORTC.3=0;
; 0001 0119                     Q2(hexvalue[yekan],port_B);
	LDI  R26,LOW(2)
	RJMP _0x200F8
; 0001 011A                     delay_ms(10);
; 0001 011B                     PORTC.3=1;
; 0001 011C 
; 0001 011D                 break;
; 0001 011E 
; 0001 011F                 case port_D :
_0x2009B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20089
; 0001 0120                     PORTC.0=0;
	RCALL SUBOPT_0x11
; 0001 0121                     Q2(hexvalue[hezaargan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 0122                     delay_ms(10);
; 0001 0123                     PORTC.0=1;
	RCALL SUBOPT_0x12
; 0001 0124 
; 0001 0125                     PORTC.1=0;
; 0001 0126                     Q2(hexvalue[sadgan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 0127                     delay_ms(10);
; 0001 0128                     PORTC.1=1;
	RCALL SUBOPT_0x13
; 0001 0129 
; 0001 012A                     PORTC.2=0;
; 0001 012B                     Q2(hexvalue[dahgan],port_D);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xA
; 0001 012C                     delay_ms(10);
; 0001 012D                     PORTC.2=1;
	RCALL SUBOPT_0x14
; 0001 012E 
; 0001 012F                     PORTC.3=0;
; 0001 0130                     Q2(hexvalue[yekan],port_D);
	LDI  R26,LOW(4)
_0x200F8:
	LDI  R27,0
	RCALL SUBOPT_0xA
; 0001 0131                     delay_ms(10);
; 0001 0132                     PORTC.3=1;
	SBI  0x15,3
; 0001 0133 
; 0001 0134                 break;
; 0001 0135                 };
_0x20089:
; 0001 0136 
; 0001 0137     break;
	RJMP _0x20017
; 0001 0138     case port_D :
_0x20086:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20017
; 0001 0139                 switch (data_port) {
	RCALL SUBOPT_0xB
; 0001 013A                 case port_A :
	BRNE _0x200C1
; 0001 013B                     PORTD.0=0;
	RCALL SUBOPT_0x15
; 0001 013C                     Q2(hexvalue[hezaargan],port_A);
	RCALL SUBOPT_0xD
; 0001 013D                     delay_ms(10);
; 0001 013E                     PORTD.0=1;
	RCALL SUBOPT_0x16
; 0001 013F 
; 0001 0140                     PORTD.1=0;
; 0001 0141                     Q2(hexvalue[sadgan],port_A);
	RCALL SUBOPT_0xD
; 0001 0142                     delay_ms(10);
; 0001 0143                     PORTD.1=1;
	RCALL SUBOPT_0x17
; 0001 0144 
; 0001 0145                     PORTD.2=0;
; 0001 0146                     Q2(hexvalue[dahgan],port_A);
	RCALL SUBOPT_0xD
; 0001 0147                     delay_ms(10);
; 0001 0148                     PORTD.2=1;
	RCALL SUBOPT_0x18
; 0001 0149 
; 0001 014A                     PORTD.3=0;
; 0001 014B                     Q2(hexvalue[yekan],port_A);
	LDI  R26,LOW(1)
	RJMP _0x200F9
; 0001 014C                     delay_ms(10);
; 0001 014D                     PORTD.3=1;
; 0001 014E 
; 0001 014F                 break;
; 0001 0150 
; 0001 0151                 case port_B :
_0x200C1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x200D2
; 0001 0152 
; 0001 0153                     PORTD.0=0;
	RCALL SUBOPT_0x15
; 0001 0154                     Q2(hexvalue[hezaargan],port_B);
	RCALL SUBOPT_0x1
; 0001 0155                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 0156                     PORTD.0=1;
	RCALL SUBOPT_0x16
; 0001 0157 
; 0001 0158                     PORTD.1=0;
; 0001 0159                     Q2(hexvalue[sadgan],port_B);
	RCALL SUBOPT_0x1
; 0001 015A                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 015B                     PORTD.1=1;
	RCALL SUBOPT_0x17
; 0001 015C 
; 0001 015D                     PORTD.2=0;
; 0001 015E                     Q2(hexvalue[dahgan],port_B);
	RCALL SUBOPT_0x1
; 0001 015F                     delay_ms(10);
	RCALL SUBOPT_0x5
; 0001 0160                     PORTD.2=1;
	RCALL SUBOPT_0x18
; 0001 0161 
; 0001 0162                     PORTD.3=0;
; 0001 0163                     Q2(hexvalue[yekan],port_B);
	LDI  R26,LOW(2)
	RJMP _0x200F9
; 0001 0164                     delay_ms(10);
; 0001 0165                     PORTD.3=1;
; 0001 0166 
; 0001 0167                 break;
; 0001 0168 
; 0001 0169                 case port_C :
_0x200D2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x200C0
; 0001 016A 
; 0001 016B                     PORTD.0=0;
	RCALL SUBOPT_0x15
; 0001 016C                     Q2(hexvalue[hezaargan],port_C);
	RCALL SUBOPT_0x9
; 0001 016D                     delay_ms(10);
; 0001 016E                     PORTD.0=1;
	RCALL SUBOPT_0x16
; 0001 016F 
; 0001 0170                     PORTD.1=0;
; 0001 0171                     Q2(hexvalue[sadgan],port_C);
	RCALL SUBOPT_0x9
; 0001 0172                     delay_ms(10);
; 0001 0173                     PORTD.1=1;
	RCALL SUBOPT_0x17
; 0001 0174 
; 0001 0175                     PORTD.2=0;
; 0001 0176                     Q2(hexvalue[dahgan],port_C);
	RCALL SUBOPT_0x9
; 0001 0177                     delay_ms(10);
; 0001 0178                     PORTD.2=1;
	RCALL SUBOPT_0x18
; 0001 0179 
; 0001 017A                     PORTD.3=0;
; 0001 017B                     Q2(hexvalue[yekan],port_C);
	LDI  R26,LOW(3)
_0x200F9:
	LDI  R27,0
	RCALL SUBOPT_0xA
; 0001 017C                     delay_ms(10);
; 0001 017D                     PORTD.3=1;
	SBI  0x12,3
; 0001 017E 
; 0001 017F                 break;
; 0001 0180                 };
_0x200C0:
; 0001 0181     break;
; 0001 0182     };
_0x20017:
; 0001 0183 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND

	.DSEG
_hexvalue:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RJMP _Q2

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	CALL __DIVW21
	STD  Y+12,R30
	STD  Y+12+1,R31
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	CBI  0x1B,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_hexvalue)
	SBCI R31,HIGH(-_hexvalue)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	SBI  0x1B,0
	CBI  0x1B,1
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	SBI  0x1B,1
	CBI  0x1B,2
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	SBI  0x1B,2
	CBI  0x1B,3
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _Q2
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xA:
	RCALL _Q2
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	CBI  0x18,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_hexvalue)
	SBCI R31,HIGH(-_hexvalue)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	SBI  0x18,0
	CBI  0x18,1
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	SBI  0x18,1
	CBI  0x18,2
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	SBI  0x18,2
	CBI  0x18,3
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	CBI  0x15,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_hexvalue)
	SBCI R31,HIGH(-_hexvalue)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	SBI  0x15,0
	CBI  0x15,1
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	SBI  0x15,1
	CBI  0x15,2
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x14:
	SBI  0x15,2
	CBI  0x15,3
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	CBI  0x12,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_hexvalue)
	SBCI R31,HIGH(-_hexvalue)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	SBI  0x12,0
	CBI  0x12,1
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	SBI  0x12,1
	CBI  0x12,2
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	SBI  0x12,2
	CBI  0x12,3
	LDI  R26,LOW(_hexvalue)
	LDI  R27,HIGH(_hexvalue)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET


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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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
