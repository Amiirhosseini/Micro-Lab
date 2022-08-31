
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
;Global 'const' stored in FLASH: No
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
	JMP  _timer1_ovf_isr
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

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_images_gh:
	.DB  0x95,0x0,0x3D,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xF3,0xE1,0xC0,0x80,0x1,0x1,0x3,0x7
	.DB  0x7,0xE,0x1C,0x10,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x3,0x1F,0xFF,0x7,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x1,0x3,0x1
	.DB  0x0,0x0,0x0,0x0,0xE3,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x3F,0x3F
	.DB  0x3F,0x3F,0x3F,0x3D,0x3F,0x3F,0x3F,0x3F
	.DB  0x7F,0x3F,0x1E,0x1C,0x1C,0x18,0x10,0x0
	.DB  0x0,0x0,0x0,0x0,0x80,0xC0,0xE0,0xF0
	.DB  0xF0,0xF0,0xF1,0xF0,0xF0,0xE0,0xE0,0xC0
	.DB  0xC0,0x80,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x3,0x7,0x7,0x7,0x7,0x7,0x7
	.DB  0x7,0xF,0xF,0x1F,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xF0,0xE0,0xC0,0xC0,0xC0,0x80,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xF,0x7F,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFE,0xFC,0xF8,0x38,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x10,0x38,0x38
	.DB  0x3C,0x3F,0x7F,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x3E,0x1C
	.DB  0xC,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x3,0x7,0x7,0xF,0xF,0xF,0x1F,0x1F
	.DB  0x3F,0x3F,0x3F,0x1F,0x1F,0xF,0x7,0x7
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x3,0x3F,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x7F,0x7F,0x7F,0x7F,0x7F,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFC,0xF8,0xF0,0xF0,0xF0
	.DB  0xE0,0xE0,0xF0,0xF0,0xF0,0xF8,0xFC,0x7C
	.DB  0x3E,0x1F,0xF,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xE0,0xF0,0xE0
	.DB  0xC0,0x80,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x38,0x78,0xF8,0xF8,0xF8,0xFC
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x1F,0x3
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x3,0x7,0xF
	.DB  0x1F,0x3F,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x1F
	.DB  0x7,0x3,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x81,0xFF,0x7,0x2F,0x3F,0x1F
	.DB  0xE,0x6,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0xC0,0xF0
	.DB  0xFC,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0xF,0x3F,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x7F,0x3,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x1F
	.DB  0x1F,0x7,0x7,0x7,0x3,0x3,0x3,0x3
	.DB  0x7,0x7,0x7,0x7,0xF,0xF,0xF,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1E,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x7,0x1F,0x1F,0x1F,0x1F,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x18,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

_0x3:
	.DB  0x87,0x0,0xEB,0x0,0xED,0x0,0xEB,0x0
	.DB  0x87,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x83,0x0,0xEF,0x0,0xEF,0x0,0x83,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x87,0x0,0xEB,0x0,0xED,0x0
	.DB  0xEB,0x0,0x87,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x83,0x0,0xEF,0x0,0xEF,0x0
	.DB  0x83,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x87,0x0,0xEB,0x0
	.DB  0xED,0x0,0xEB,0x0,0x87,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x83,0x0,0xEF,0x0
	.DB  0xEF,0x0,0x83,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x87,0x0
	.DB  0xEB,0x0,0xED,0x0,0xEB,0x0,0x87,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x83,0x0
	.DB  0xEF,0x0,0xEF,0x0,0x83,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x87,0x0,0xEB,0x0,0xED,0x0,0xEB,0x0
	.DB  0x87,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x83,0x0,0xEF,0x0,0xEF,0x0,0x83,0x0
	.DB  0x83,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x87,0x0,0xEB,0x0,0xED,0x0
	.DB  0xEB,0x0,0x87,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x83,0x0,0xEF,0x0,0xEF,0x0
	.DB  0xEF,0x0,0x83,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x87,0x0,0xEB,0x0
	.DB  0xED,0x0,0xEB,0x0,0x87,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x83,0x0,0xEF,0x0
	.DB  0xEF,0x0,0xEF,0x0,0x83,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x87,0x0
	.DB  0xEB,0x0,0xED,0x0,0xEB,0x0,0x87,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x83,0x0
	.DB  0x83,0x0,0xEF,0x0,0xEF,0x0,0x83,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x87,0x0,0xEB,0x0,0xED,0x0,0xEB,0x0
	.DB  0x87,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x83,0x0,0xEF,0x0,0xEF,0x0
	.DB  0x83,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x87,0x0,0xEB,0x0,0xED,0x0
	.DB  0xEB,0x0,0x87,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x83,0x0,0xEF,0x0
	.DB  0xEF,0x0,0x83,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x87,0x0,0xEB,0x0
	.DB  0xED,0x0,0xEB,0x0,0x87,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x83,0x0
	.DB  0xEF,0x0,0xEF,0x0,0x83,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x87,0x0
	.DB  0xEB,0x0,0xED,0x0,0xEB,0x0,0x87,0x0
	.DB  0x87,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x83,0x0,0xEF,0x0,0xEF,0x0,0x83,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x87,0x0,0xEB,0x0,0xED,0x0,0xEB,0x0
	.DB  0xEB,0x0,0x87,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x83,0x0,0xEF,0x0,0xEF,0x0
	.DB  0x83,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x87,0x0,0xEB,0x0,0xED,0x0
	.DB  0xED,0x0,0xEB,0x0,0x87,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x83,0x0,0xEF,0x0
	.DB  0xEF,0x0,0x83,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x87,0x0,0xEB,0x0
	.DB  0xEB,0x0,0xED,0x0,0xEB,0x0,0x87,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x83,0x0
	.DB  0xEF,0x0,0xEF,0x0,0x83,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x87,0x0
	.DB  0x87,0x0,0xEB,0x0,0xED,0x0,0xEB,0x0
	.DB  0x87,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x83,0x0,0xEF,0x0,0xEF,0x0,0x83,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x21F
	.DW  _Untitled8x8
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

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
;? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/18/2020
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
;#include "./source/headers.h"
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
;// Graphic Display functions
;
;GLCDINIT_t glcd_init_data;
;
;// Declare your global variables here
;
;unsigned long int x;
;unsigned long int y;
;unsigned int s = 0;
;unsigned int m = 0;
;unsigned int h = 0;
;
;const unsigned short Untitled8x8[] = {
;        0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF,
;        0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF,
;        0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF,
;        0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF,
;        0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83,
;        0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF,
;        0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF,
;        0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83,
;        0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF,
;        0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF,
;        0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF,
;        0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB, 0x87,
;        0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED, 0xEB,
;        0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB, 0xED,
;        0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87, 0xEB,
;        0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF, 0x87,
;        0x87, 0xEB, 0xED, 0xEB, 0x87, 0xFF, 0xFF, 0xFF, 0x83, 0xEF, 0xEF, 0x83, 0xFF, 0xFF, 0xFF, 0xFF,
;        };

	.DSEG
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 003C {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003D // Reinitialize Timer1 value
; 0000 003E TCNT1H=0x85EE >> 8;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 003F TCNT1L=0x85EE & 0xff;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 0040 // Place your code here
; 0000 0041 question3();
	CALL _question3
; 0000 0042 
; 0000 0043 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0046 {
_main:
; .FSTART _main
; 0000 0047     // Declare your local variables here
; 0000 0048     // Variable used to store graphic display
; 0000 0049     init_board();
	CALL _init_board
; 0000 004A     glcd_init(&glcd_init_data);
	LDI  R26,LOW(_glcd_init_data)
	LDI  R27,HIGH(_glcd_init_data)
	CALL _glcd_init
; 0000 004B 
; 0000 004C     // Global enable interrupts
; 0000 004D     question2();
	CALL _question2
; 0000 004E     delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 004F     // Global enable interrupts
; 0000 0050     #asm("sei")
	sei
; 0000 0051     delay_ms(10000);  //question3
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL _delay_ms
; 0000 0052     #asm("cli")
	cli
; 0000 0053     question1();
	CALL _question1
; 0000 0054 }
_0x4:
	RJMP _0x4
; .FEND
;
;
;
;#include "./source/headers.h"
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
;#include "./source/clock.h"
;
;
;//global variable
;
;float status_degree;
;
;//function definition
;
;void Draw_clock_hand(int xcoordinate,int ycoordinate)
; 0001 000F {

	.CSEG
; 0001 0010     glcd_line(64,32,xcoordinate,ycoordinate);
;	xcoordinate -> Y+2
;	ycoordinate -> Y+0
; 0001 0011     delay_us(10);
; 0001 0012 }
;
;float degree_to_radian(float degree)
; 0001 0015 {
; 0001 0016     float radian;
; 0001 0017     radian=(degree*(0.0174));
;	degree -> Y+4
;	radian -> Y+0
; 0001 0018     return radian;
; 0001 0019 }
;
;
;int min_x_coordinate_finder(unsigned int min,unsigned int radius,float degree)
; 0001 001D {
; 0001 001E     int xcoordinate,intermediate;
; 0001 001F     float actualdegree;
; 0001 0020     float radian;
; 0001 0021     actualdegree= (90-(degree*min));
;	min -> Y+18
;	radius -> Y+16
;	degree -> Y+12
;	xcoordinate -> R16,R17
;	intermediate -> R18,R19
;	actualdegree -> Y+8
;	radian -> Y+4
; 0001 0022     status_degree=actualdegree;
; 0001 0023     radian= degree_to_radian(actualdegree);
; 0001 0024     intermediate= radius*(cos(radian));
; 0001 0025     xcoordinate= (64+intermediate);
; 0001 0026     return xcoordinate;
; 0001 0027 }
;
;
;int min_y_coordinate_finder(unsigned int min,unsigned int radius,float degree)
; 0001 002B {
; 0001 002C     int ycoordinate,intermediate;
; 0001 002D     float actualdegree;
; 0001 002E     float radian;
; 0001 002F     actualdegree= (90-(degree*min));
;	min -> Y+18
;	radius -> Y+16
;	degree -> Y+12
;	ycoordinate -> R16,R17
;	intermediate -> R18,R19
;	actualdegree -> Y+8
;	radian -> Y+4
; 0001 0030     status_degree=actualdegree;
; 0001 0031     radian= degree_to_radian(actualdegree);
; 0001 0032     intermediate= radius*(sin(radian));
; 0001 0033     ycoordinate= (32-intermediate);
; 0001 0034     return ycoordinate;
; 0001 0035 }
;
;int sec_x_coordinate_finder(unsigned int sec,unsigned int radius,float degree)
; 0001 0038 {
; 0001 0039     int ycoordinate,intermediate;
; 0001 003A     float actualdegree;
; 0001 003B     float radian;
; 0001 003C     actualdegree= (90-(degree*sec));
;	sec -> Y+18
;	radius -> Y+16
;	degree -> Y+12
;	ycoordinate -> R16,R17
;	intermediate -> R18,R19
;	actualdegree -> Y+8
;	radian -> Y+4
; 0001 003D     radian= degree_to_radian(actualdegree);
; 0001 003E     intermediate= radius*(cos(radian));
; 0001 003F     ycoordinate= (64+intermediate);
; 0001 0040     return ycoordinate;
; 0001 0041 }
;
;int sec_y_coordinate_finder(unsigned int sec,unsigned int radius,float degree)
; 0001 0044 {
; 0001 0045     int ycoordinate,intermediate;
; 0001 0046     float actualdegree;
; 0001 0047     float radian;
; 0001 0048     actualdegree= (90-(degree*sec));
;	sec -> Y+18
;	radius -> Y+16
;	degree -> Y+12
;	ycoordinate -> R16,R17
;	intermediate -> R18,R19
;	actualdegree -> Y+8
;	radian -> Y+4
; 0001 0049     radian= degree_to_radian(actualdegree);
; 0001 004A     intermediate= radius*(sin(radian));
; 0001 004B     ycoordinate= (32-intermediate);
; 0001 004C     return ycoordinate;
; 0001 004D }
;
;int hr_x_coordinate_finder(unsigned int hr,unsigned int radius,float degree)
; 0001 0050 {
; 0001 0051     int xcoordinate,intermediate;
; 0001 0052     float actualdegree;
; 0001 0053     float radian;
; 0001 0054     actualdegree= (90-(degree*hr));
;	hr -> Y+18
;	radius -> Y+16
;	degree -> Y+12
;	xcoordinate -> R16,R17
;	intermediate -> R18,R19
;	actualdegree -> Y+8
;	radian -> Y+4
; 0001 0055     actualdegree= (actualdegree-((90-status_degree)/12));
; 0001 0056     radian= degree_to_radian(actualdegree);
; 0001 0057     intermediate= radius*(cos(radian));
; 0001 0058     xcoordinate= (64+intermediate);
; 0001 0059     return xcoordinate;
; 0001 005A }
;
;int hr_y_coordinate_finder(unsigned int hr,unsigned int radius,float degree)
; 0001 005D {
; 0001 005E     int ycoordinate,intermediate;
; 0001 005F     float actualdegree;
; 0001 0060     float radian;
; 0001 0061     actualdegree= (90-(degree*hr));
;	hr -> Y+18
;	radius -> Y+16
;	degree -> Y+12
;	ycoordinate -> R16,R17
;	intermediate -> R18,R19
;	actualdegree -> Y+8
;	radian -> Y+4
; 0001 0062     actualdegree= (actualdegree-((90-status_degree)/12));
; 0001 0063     radian= degree_to_radian(actualdegree);
; 0001 0064     intermediate= radius*(sin(radian));
; 0001 0065     ycoordinate= (32-intermediate);
; 0001 0066     return ycoordinate;
; 0001 0067 }
;
;
;
;
;
;void Draw_clock(unsigned int hr,unsigned int min,unsigned int sec)
; 0001 006E {
; 0001 006F 
; 0001 0070     int hr_x_coordinate,hr_y_coordinate,min_x_coordinate,min_y_coordinate,sec_x_coordinate,sec_y_coordinate;
; 0001 0071 
; 0001 0072     if(hr>=12 && hr<=24) hr=hr-12;
;	hr -> Y+16
;	min -> Y+14
;	sec -> Y+12
;	hr_x_coordinate -> R16,R17
;	hr_y_coordinate -> R18,R19
;	min_x_coordinate -> R20,R21
;	min_y_coordinate -> Y+10
;	sec_x_coordinate -> Y+8
;	sec_y_coordinate -> Y+6
; 0001 0073 
; 0001 0074 
; 0001 0075 
; 0001 0076     if(sec==60)
; 0001 0077     {
; 0001 0078         sec=0;
; 0001 0079         min=min+1;
; 0001 007A         if(min==60)
; 0001 007B         {
; 0001 007C             min=0;
; 0001 007D 
; 0001 007E             hr=hr+1;
; 0001 007F         }
; 0001 0080     }
; 0001 0081 
; 0001 0082     glcd_circle(64,32,30);
; 0001 0083 
; 0001 0084     hr_x_coordinate= hr_x_coordinate_finder(hr,HR_RADIUS,30);
; 0001 0085     hr_y_coordinate= hr_y_coordinate_finder(hr,HR_RADIUS,30);
; 0001 0086     Draw_clock_hand(hr_x_coordinate,hr_y_coordinate);
; 0001 0087 
; 0001 0088     delay_us(5);
; 0001 0089     min_x_coordinate=min_x_coordinate_finder(min,MIN_RADIUS,6);
; 0001 008A     min_y_coordinate=min_y_coordinate_finder(min,MIN_RADIUS,6);
; 0001 008B     Draw_clock_hand(min_x_coordinate,min_y_coordinate);
; 0001 008C 
; 0001 008D     delay_us(5);
; 0001 008E     sec_x_coordinate=sec_x_coordinate_finder(sec,SEC_RADIUS,6);
; 0001 008F     sec_y_coordinate=sec_y_coordinate_finder(sec,SEC_RADIUS,6);
; 0001 0090     Draw_clock_hand(sec_x_coordinate,sec_y_coordinate);
; 0001 0091     //glcd_clear();
; 0001 0092 }
;/****************************************************************************
;Image data created by the LCD Vision V1.05 font & image editor/converter
;(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Graphic LCD controller: KS0108 128x64 CS1,CS2
;Image width: 212 pixels
;Image height: 181 pixels
;Color depth: 1 bits/pixel
;Imported image file name: images_gh.bmp
;
;Exported monochrome image data size:
;1163 bytes for displays organized as horizontal rows of bytes
;1196 bytes for displays organized as rows of vertical bytes.
;****************************************************************************/
;
;flash unsigned char images_gh[]=
;{
;/* Image width: 149 pixels */
;0x95, 0x00,
;/* Image height: 61 pixels */
;0x3D, 0x00,
;#ifndef _GLCD_DATA_BYTEY_
;/* Image data for monochrome displays organized
;   as horizontal rows of bytes */
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F, 0x1F,
;0xC0, 0x03, 0x0E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0x3C, 0xC0, 0x03, 0x04, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0x78, 0x80, 0x03,
;0x00, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F,
;0x60, 0x80, 0x01, 0x00, 0xFE, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xC0, 0x80, 0x01, 0x00, 0xFE,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F, 0x00, 0x00,
;0x01, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x7F, 0x00, 0x00, 0x01, 0x00, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x01, 0x00,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01,
;0x00, 0x02, 0x80, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFB, 0x03, 0x00, 0x00, 0x00, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0x00, 0x00,
;0x00, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x3F, 0xC0, 0x0F, 0x00, 0x00,
;0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0xE0,
;0x3F, 0x00, 0x00, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0x80, 0x00, 0xF0, 0xFF, 0x00, 0x00, 0xF8, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x0F, 0x00, 0x00, 0xF8, 0xFF, 0x03,
;0x00, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x07, 0x00, 0x00,
;0xF8, 0xFF, 0x03, 0x00, 0xF8, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x07, 0x00, 0x00, 0xF8, 0xFF, 0x07, 0x00, 0xF8,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x07, 0x00, 0x00, 0xF8, 0xFF,
;0x0F, 0x00, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x07, 0x00,
;0x00, 0xF8, 0xFF, 0x3F, 0x00, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x0F, 0x00, 0x00, 0xF0, 0xFF, 0x3F, 0x80,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0x00, 0x00, 0xF0,
;0xFF, 0x3F, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x00, 0x00, 0xF0, 0xFF, 0x1F, 0x00, 0xF0, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x03, 0x00, 0xE0, 0xFF, 0x1F,
;0x00, 0xE0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x07, 0x00,
;0xE0, 0xFF, 0x1F, 0x00, 0x80, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x0F, 0x00, 0xE0, 0xFF, 0x1F, 0x00, 0x80,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x3F, 0x00, 0xC0, 0xFF,
;0x1F, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F,
;0x00, 0x00, 0xFF, 0x07, 0x00, 0x00, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0x00, 0x00, 0xF8, 0x03, 0x00,
;0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0x00, 0x00,
;0xE0, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x07, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x07, 0x00,
;0x0E, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x07, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x0F, 0xC0, 0x07, 0x00,
;0x00, 0x00, 0x80, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xE0, 0x07, 0x00, 0x00, 0x00, 0xFC, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFC, 0x03, 0x40, 0x00, 0x00,
;0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01,
;0xE0, 0x00, 0x00, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x00, 0xE0, 0x01, 0x00, 0xF8, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0xFF, 0xE0, 0xFF, 0xFF, 0x7F, 0x00, 0xE0, 0x03,
;0x00, 0xF0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0x0F, 0x80, 0xFF, 0xFF, 0x3F,
;0x00, 0xE0, 0x07, 0x00, 0xF0, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x07, 0x00,
;0xFF, 0xFF, 0x1F, 0x00, 0xC0, 0x1F, 0x00, 0xF0,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0x03, 0x00, 0xFE, 0xFF, 0x0F, 0x00, 0xC0,
;0x1F, 0x00, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0x03, 0x00, 0xFC, 0xFF,
;0x07, 0x00, 0x40, 0x0F, 0x00, 0xF8, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x03,
;0x00, 0xF8, 0xFF, 0x07, 0x00, 0x40, 0x06, 0x00,
;0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0x01, 0x00, 0xF0, 0xFF, 0x03, 0x00,
;0x40, 0x03, 0x00, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0xE0,
;0xFF, 0x03, 0x00, 0x40, 0x00, 0x00, 0xFE, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0x01, 0x00, 0xE0, 0xFF, 0x01, 0x00, 0x60, 0x00,
;0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0x01, 0x00, 0xC0, 0xFF, 0x01,
;0x00, 0x20, 0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x01, 0x00,
;0x80, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0xFE,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF,
;0xFF, 0x01, 0x00, 0x80, 0xFF, 0x00, 0x00, 0x00,
;0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x80, 0xFF,
;0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x01,
;0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00,
;0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF,
;0xFF, 0xFF, 0x01, 0x00, 0x00, 0xFF, 0x00, 0x00,
;0x00, 0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00,
;0xFE, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF,
;0x01, 0x00, 0x00, 0x7E, 0x00, 0x00, 0x00, 0x00,
;0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x7C, 0x00,
;0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0xFF, 0xFF, 0xFF, 0x03, 0x00,
;0x00, 0x7C, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0x1F, 0xFE,
;0xFF, 0x03, 0x00, 0x00, 0x7C, 0x00, 0x00, 0x00,
;0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0x1F, 0x03, 0xE0, 0xFF, 0x03, 0x00, 0x00, 0x78,
;0x00, 0x00, 0x00, 0x00, 0x80, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0x03, 0x00, 0xFF, 0x03,
;0x00, 0x00, 0x78, 0x00, 0x00, 0x00, 0x00, 0x80,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F,
;#else
;/* Image data for monochrome displays organized
;   as rows of vertical bytes */
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xF3, 0xE1, 0xC0, 0x80,
;0x01, 0x01, 0x03, 0x07, 0x07, 0x0E, 0x1C, 0x10,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x1F,
;0xFF, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x01, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00,
;0xE3, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0x7F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3D,
;0x3F, 0x3F, 0x3F, 0x3F, 0x7F, 0x3F, 0x1E, 0x1C,
;0x1C, 0x18, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x80, 0xC0, 0xE0, 0xF0, 0xF0, 0xF0, 0xF1, 0xF0,
;0xF0, 0xE0, 0xE0, 0xC0, 0xC0, 0x80, 0x80, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x07, 0x07,
;0x07, 0x07, 0x07, 0x07, 0x07, 0x0F, 0x0F, 0x1F,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF0, 0xE0, 0xC0,
;0xC0, 0xC0, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x7F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFC, 0xF8, 0x38,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x10, 0x38, 0x38, 0x3C, 0x3F, 0x7F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x3E, 0x1C, 0x0C, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x07, 0x0F,
;0x0F, 0x0F, 0x1F, 0x1F, 0x3F, 0x3F, 0x3F, 0x1F,
;0x1F, 0x0F, 0x07, 0x07, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x3F,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x7F, 0x7F, 0x7F,
;0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC,
;0xF8, 0xF0, 0xF0, 0xF0, 0xE0, 0xE0, 0xF0, 0xF0,
;0xF0, 0xF8, 0xFC, 0x7C, 0x3E, 0x1F, 0x0F, 0x01,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0xE0, 0xF0, 0xE0, 0xC0, 0x80, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x78,
;0xF8, 0xF8, 0xF8, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x1F, 0x03, 0x01, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x01, 0x03, 0x07, 0x0F, 0x1F, 0x3F, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0x7F, 0x1F, 0x07, 0x03, 0x01, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x81, 0xFF,
;0x07, 0x2F, 0x3F, 0x1F, 0x0E, 0x06, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x80, 0xC0, 0xF0, 0xFC, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x01, 0x0F, 0x3F, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x03, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
;0xFF, 0xFF, 0xFF, 0x1F, 0x1F, 0x07, 0x07, 0x07,
;0x03, 0x03, 0x03, 0x03, 0x07, 0x07, 0x07, 0x07,
;0x0F, 0x0F, 0x0F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1E, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0x1F, 0x1F,
;0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x18, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F,
;#endif
;};
;
;#include "./source/headers.h"
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
;void init_board(){
; 0003 0003 void init_board(){

	.CSEG
_init_board:
; .FSTART _init_board
; 0003 0004 // controller initialization data
; 0003 0005 
; 0003 0006 
; 0003 0007 // Input/Output Ports initialization
; 0003 0008 // Port A initialization
; 0003 0009 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0003 000A DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0003 000B // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0003 000C PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0003 000D 
; 0003 000E // Port B initialization
; 0003 000F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0003 0010 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0003 0011 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0003 0012 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0003 0013 
; 0003 0014 // Port C initialization
; 0003 0015 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0003 0016 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0003 0017 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0003 0018 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0003 0019 
; 0003 001A // Port D initialization
; 0003 001B // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0003 001C DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0003 001D // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0003 001E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0003 001F 
; 0003 0020 // Timer/Counter 0 initialization
; 0003 0021 // Clock source: System Clock
; 0003 0022 // Clock value: Timer 0 Stopped
; 0003 0023 // Mode: Normal top=0xFF
; 0003 0024 // OC0 output: Disconnected
; 0003 0025 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0003 0026 TCNT0=0x00;
	OUT  0x32,R30
; 0003 0027 OCR0=0x00;
	OUT  0x3C,R30
; 0003 0028 
; 0003 0029 // Timer/Counter 1 initialization
; 0003 002A // Clock source: System Clock
; 0003 002B // Clock value: 31.250 kHz
; 0003 002C // Mode: Normal top=0xFFFF
; 0003 002D // OC1A output: Disconnected
; 0003 002E // OC1B output: Disconnected
; 0003 002F // Noise Canceler: Off
; 0003 0030 // Input Capture on Falling Edge
; 0003 0031 // Timer Period: 1 s
; 0003 0032 // Timer1 Overflow Interrupt: On
; 0003 0033 // Input Capture Interrupt: Off
; 0003 0034 // Compare A Match Interrupt: Off
; 0003 0035 // Compare B Match Interrupt: Off
; 0003 0036 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0003 0037 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0003 0038 TCNT1H=0x85;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0003 0039 TCNT1L=0xEE;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0003 003A ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0003 003B ICR1L=0x00;
	OUT  0x26,R30
; 0003 003C OCR1AH=0x00;
	OUT  0x2B,R30
; 0003 003D OCR1AL=0x00;
	OUT  0x2A,R30
; 0003 003E OCR1BH=0x00;
	OUT  0x29,R30
; 0003 003F OCR1BL=0x00;
	OUT  0x28,R30
; 0003 0040 
; 0003 0041 // Timer/Counter 2 initialization
; 0003 0042 // Clock source: System Clock
; 0003 0043 // Clock value: Timer2 Stopped
; 0003 0044 // Mode: Normal top=0xFF
; 0003 0045 // OC2 output: Disconnected
; 0003 0046 ASSR=0<<AS2;
	OUT  0x22,R30
; 0003 0047 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0003 0048 TCNT2=0x00;
	OUT  0x24,R30
; 0003 0049 OCR2=0x00;
	OUT  0x23,R30
; 0003 004A 
; 0003 004B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0003 004C TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0003 004D 
; 0003 004E // External Interrupt(s) initialization
; 0003 004F // INT0: Off
; 0003 0050 // INT1: Off
; 0003 0051 // INT2: Off
; 0003 0052 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0003 0053 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0003 0054 
; 0003 0055 // USART initialization
; 0003 0056 // USART disabled
; 0003 0057 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0003 0058 
; 0003 0059 // Analog Comparator initialization
; 0003 005A // Analog Comparator: Off
; 0003 005B // The Analog Comparator's positive input is
; 0003 005C // connected to the AIN0 pin
; 0003 005D // The Analog Comparator's negative input is
; 0003 005E // connected to the AIN1 pin
; 0003 005F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0003 0060 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0003 0061 
; 0003 0062 // ADC initialization
; 0003 0063 // ADC disabled
; 0003 0064 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0003 0065 
; 0003 0066 // SPI initialization
; 0003 0067 // SPI disabled
; 0003 0068 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0003 0069 
; 0003 006A // TWI initialization
; 0003 006B // TWI disabled
; 0003 006C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0003 006D 
; 0003 006E // Graphic Display Controller initialization
; 0003 006F // The KS0108 connections are specified in the
; 0003 0070 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0003 0071 // DB0 - PORTC Bit 0
; 0003 0072 // DB1 - PORTC Bit 1
; 0003 0073 // DB2 - PORTC Bit 2
; 0003 0074 // DB3 - PORTC Bit 3
; 0003 0075 // DB4 - PORTC Bit 4
; 0003 0076 // DB5 - PORTC Bit 5
; 0003 0077 // DB6 - PORTC Bit 6
; 0003 0078 // DB7 - PORTC Bit 7
; 0003 0079 // E - PORTD Bit 0
; 0003 007A // RD /WR - PORTD Bit 1
; 0003 007B // RS - PORTD Bit 2
; 0003 007C // /RST - PORTD Bit 3
; 0003 007D // CS1 - PORTD Bit 4
; 0003 007E // CS2 - PORTD Bit 5
; 0003 007F 
; 0003 0080 // Specify the current font for displaying text
; 0003 0081 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	STS  _glcd_init_data,R30
	STS  _glcd_init_data+1,R31
; 0003 0082 // No function is used for reading
; 0003 0083 // image data from external memory
; 0003 0084 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_init_data,2
; 0003 0085 // No function is used for writing
; 0003 0086 // image data to external memory
; 0003 0087 glcd_init_data.writexmem=NULL;
	__PUTW1MN _glcd_init_data,4
; 0003 0088 
; 0003 0089 }
	RET
; .FEND
;#include "./source/headers.h"
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
;void question1(){
; 0004 0003 void question1(){

	.CSEG
_question1:
; .FSTART _question1
; 0004 0004     int r = 0;
; 0004 0005     int c = 0;
; 0004 0006     int max_column = 8;
; 0004 0007     int min_column = 0;
; 0004 0008     int i=0;
; 0004 0009     while(1){
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	r -> R16,R17
;	c -> R18,R19
;	max_column -> R20,R21
;	min_column -> Y+8
;	i -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,8
_0x80003:
; 0004 000A         for(i=0;i<150;i++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x80007:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	BRGE _0x80008
; 0004 000B                 PORTD = 0x80;
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0004 000C                 PORTB = Untitled8x8[r];
	MOVW R30,R16
	LDI  R26,LOW(_Untitled8x8)
	LDI  R27,HIGH(_Untitled8x8)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x0
; 0004 000D                 PORTA = 1<<c;
; 0004 000E 
; 0004 000F                 delay_ms(3);
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
; 0004 0010 
; 0004 0011                 PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0004 0012                 PORTB = Untitled8x8[r+8];
	MOVW R26,R16
	LSL  R26
	ROL  R27
	__ADDW2MN _Untitled8x8,16
	CALL SUBOPT_0x0
; 0004 0013                 PORTA = 1<<c;
; 0004 0014 
; 0004 0015                 r++;
	__ADDWRN 16,17,1
; 0004 0016                 if (r == max_column)
	__CPWRR 20,21,16,17
	BRNE _0x80009
; 0004 0017                 {
; 0004 0018                     r = min_column;
	__GETWRS 16,17,8
; 0004 0019                 }
; 0004 001A                 c = (c+1)%8;
_0x80009:
	MOVW R30,R18
	ADIW R30,1
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	MOVW R18,R30
; 0004 001B                 delay_ms(3);
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
; 0004 001C 
; 0004 001D         }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x80007
_0x80008:
; 0004 001E 
; 0004 001F           if (max_column == 248)
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x8000A
; 0004 0020           {
; 0004 0021             max_column = 8;
	__GETWRN 20,21,8
; 0004 0022             min_column = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0004 0023             r=0;
	__GETWRN 16,17,0
; 0004 0024             c=0;
	__GETWRN 18,19,0
; 0004 0025                     //break;
; 0004 0026           }
; 0004 0027 
; 0004 0028           else
	RJMP _0x8000B
_0x8000A:
; 0004 0029           {
; 0004 002A              max_column =  max_column + 16;
	__ADDWRN 20,21,16
; 0004 002B              min_column = min_column + 16;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,16
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0004 002C           }
_0x8000B:
; 0004 002D 
; 0004 002E     }
	RJMP _0x80003
; 0004 002F }
; .FEND
;
;void question2(){
; 0004 0031 void question2(){
_question2:
; .FSTART _question2
; 0004 0032     glcd_putimagef(0,0,images_gh,GLCD_PUTCOPY);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(_images_gh*2)
	LDI  R31,HIGH(_images_gh*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_putimagef
; 0004 0033 }
	RET
; .FEND
;
;void question3(){
; 0004 0035 void question3(){
_question3:
; .FSTART _question3
; 0004 0036 
; 0004 0037     s++;
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	CALL SUBOPT_0x1
; 0004 0038         if(s == 60)
	CALL SUBOPT_0x2
	SBIW R26,60
	BRNE _0x8000C
; 0004 0039         {
; 0004 003A             m++;
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	CALL SUBOPT_0x1
; 0004 003B             s = 0;
	LDI  R30,LOW(0)
	STS  _s,R30
	STS  _s+1,R30
; 0004 003C         }
; 0004 003D         if(m == 60)
_0x8000C:
	CALL SUBOPT_0x3
	SBIW R26,60
	BRNE _0x8000D
; 0004 003E         {
; 0004 003F             h++;
	LDI  R26,LOW(_h)
	LDI  R27,HIGH(_h)
	CALL SUBOPT_0x1
; 0004 0040             m = 0;
	LDI  R30,LOW(0)
	STS  _m,R30
	STS  _m+1,R30
; 0004 0041         }
; 0004 0042         if(h == 12){
_0x8000D:
	CALL SUBOPT_0x4
	SBIW R26,12
	BRNE _0x8000E
; 0004 0043             h = 0;
	LDI  R30,LOW(0)
	STS  _h,R30
	STS  _h+1,R30
; 0004 0044 
; 0004 0045         }
; 0004 0046 
; 0004 0047         glcd_clear();
_0x8000E:
	RCALL _glcd_clear
; 0004 0048 
; 0004 0049         glcd_circle(63, 31, 30);
	CALL SUBOPT_0x5
	LDI  R26,LOW(30)
	CALL _glcd_circle
; 0004 004A         glcd_setlinestyle(3,4);
	LDI  R30,LOW(3)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(4)
	__PUTB1MN _glcd_state,9
; 0004 004B         glcd_circle(63, 31, 2);
	CALL SUBOPT_0x5
	LDI  R26,LOW(2)
	CALL _glcd_circle
; 0004 004C         glcd_setlinestyle(1,GLCD_LINE_SOLID);
	CALL SUBOPT_0x6
; 0004 004D 
; 0004 004E         x = 25*cos(s*6);
	CALL SUBOPT_0x7
	CALL _cos
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0004 004F         y = 25*sin(s*6);
	CALL SUBOPT_0x7
	CALL _sin
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
; 0004 0050 
; 0004 0051         glcd_line(63,31,x+63,31-y);
	CALL SUBOPT_0xB
; 0004 0052 
; 0004 0053         x = 20*cos(m*6);
	CALL SUBOPT_0xC
	CALL _cos
	CALL SUBOPT_0xD
	CALL SUBOPT_0x9
; 0004 0054         y = 20*sin(m*6);
	CALL SUBOPT_0xC
	CALL _sin
	CALL SUBOPT_0xD
	CALL SUBOPT_0xA
; 0004 0055 
; 0004 0056         glcd_line(63,31,x+63,31-y);
	CALL SUBOPT_0xB
; 0004 0057 
; 0004 0058         x = 15*cos(h*6);
	CALL SUBOPT_0xE
	CALL _cos
	CALL SUBOPT_0xF
	CALL SUBOPT_0x9
; 0004 0059         y = 15*sin(h*6);
	CALL SUBOPT_0xE
	CALL _sin
	CALL SUBOPT_0xF
	CALL SUBOPT_0xA
; 0004 005A 
; 0004 005B         glcd_line(63,31,x+63,31-y);
	CALL SUBOPT_0xB
; 0004 005C 
; 0004 005D 
; 0004 005E }
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
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	SBI  0x12,0
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	CBI  0x12,0
	CBI  0x12,4
	CBI  0x12,5
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,19
	CBI  0x12,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x12,1
	CBI  0x12,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	SBI  0x12,4
	RJMP _0x2000004
_0x2000003:
	CBI  0x12,4
_0x2000004:
	SBRS R17,1
	RJMP _0x2000005
	SBI  0x12,5
	RJMP _0x2000006
_0x2000005:
	CBI  0x12,5
_0x2000006:
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	RJMP _0x2100008
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x10
	RJMP _0x2100008
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	RJMP _0x2100008
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	SBI  0x12,2
	CALL SUBOPT_0x10
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x12,1
	SBI  0x12,2
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x11
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
	RJMP _0x2100008
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x11,0
	SBI  0x11,1
	SBI  0x11,2
	SBI  0x11,3
	SBI  0x12,3
	SBI  0x11,4
	SBI  0x11,5
	RCALL _ks0108_disable_G100
	CBI  0x12,3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x12,3
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AC
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	CALL SUBOPT_0x6
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x12
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x200001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x200001C
_0x200001D:
	RJMP _0x2100009
_0x200001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x200001F
	OR   R17,R16
	RJMP _0x2000020
_0x200001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G100
_0x2100009:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
_glcd_getpixel:
; .FSTART _glcd_getpixel
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRSH _0x2000022
	LD   R26,Y
	CPI  R26,LOW(0x40)
	BRLO _0x2000021
_0x2000022:
	LDI  R30,LOW(0)
	RJMP _0x2100008
_0x2000021:
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _ks0108_rdbyte_G100
	MOV  R1,R30
	LD   R30,Y
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	BREQ _0x2000024
	LDI  R30,LOW(1)
	RJMP _0x2000025
_0x2000024:
	LDI  R30,LOW(0)
_0x2000025:
_0x2100008:
	ADIW R28,2
	RET
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x12
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x2100007
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x2100007
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x2100007
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x13
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x14
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x13
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x14
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x13
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x11
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x17
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x12
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x18
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x19
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x1A
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x17
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x18
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x1B
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AD
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x19
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x1A
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x17
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x18
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x1B
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x2100007:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x1C
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2100003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x1C
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2100003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x2100003
; .FEND
_glcd_imagesize:
; .FSTART _glcd_imagesize
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+2
	CPI  R26,LOW(0x80)
	BRSH _0x2020008
	LDD  R26,Y+1
	CPI  R26,LOW(0x40)
	BRLO _0x2020007
_0x2020008:
	__GETD1N 0x0
	LDD  R17,Y+0
	JMP  _0x2100002
_0x2020007:
	LDD  R30,Y+1
	ANDI R30,LOW(0x7)
	MOV  R17,R30
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	STD  Y+1,R30
	CPI  R17,0
	BREQ _0x202000A
	SUBI R30,-LOW(1)
	STD  Y+1,R30
_0x202000A:
	LDD  R26,Y+2
	CLR  R27
	CLR  R24
	CLR  R25
	LDD  R30,Y+1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __MULD12U
	__ADDD1N 4
	LDD  R17,Y+0
	JMP  _0x2100002
; .FEND
_glcd_putimagef:
; .FSTART _glcd_putimagef
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRSH _0x2020038
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	LPM  R16,Z+
	CALL SUBOPT_0x1D
	LPM  R17,Z+
	CALL SUBOPT_0x1D
	LPM  R18,Z+
	CALL SUBOPT_0x1D
	LPM  R19,Z+
	STD  Y+5,R30
	STD  Y+5+1,R31
	LDD  R30,Y+8
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	ST   -Y,R16
	ST   -Y,R18
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+11
	RCALL _glcd_block
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_imagesize
	CALL __LOADLOCR4
	JMP  _0x2100004
_0x2020038:
	__GETD1N 0x0
	CALL __LOADLOCR4
	JMP  _0x2100004
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
	JMP  _0x2100002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2100003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x2100006
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	CALL SUBOPT_0x1E
	BRSH _0x202004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	CALL SUBOPT_0x1E
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x1F
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	CALL SUBOPT_0x1E
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x20
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x21
_0x2020060:
	ST   -Y,R17
	CALL SUBOPT_0x1F
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x20
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x21
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x1F
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x2100006:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_plot8_G101:
; .FSTART _glcd_plot8_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R30,Y+13
	STD  Y+8,R30
	__GETB1MN _glcd_state,8
	STD  Y+7,R30
	LDS  R30,_glcd_state
	STD  Y+6,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x22
	LDD  R30,Y+16
	CALL SUBOPT_0x23
	LDD  R30,Y+16
	CALL SUBOPT_0x24
	BREQ _0x2020073
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020075
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x25
	BRLT _0x2020077
	CALL SUBOPT_0x26
	BRGE _0x2020078
_0x2020077:
	RJMP _0x2020076
_0x2020078:
_0x2020073:
	TST  R19
	BRMI _0x2020079
	CALL SUBOPT_0x27
_0x2020079:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x202007B
	__CPWRN 18,19,2
	BRGE _0x202007C
_0x202007B:
	RJMP _0x202007A
_0x202007C:
	CALL SUBOPT_0x28
	BRNE _0x202007D
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x202007D:
_0x202007A:
_0x2020076:
_0x2020075:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x202007F
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020081
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x29
	BRLT _0x2020083
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x2A
	BRGE _0x2020084
_0x2020083:
	RJMP _0x2020082
_0x2020084:
_0x202007F:
	CALL SUBOPT_0x2B
	BRLO _0x2020085
	CALL SUBOPT_0x2C
	BRNE _0x2020086
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x2020086:
_0x2020085:
_0x2020082:
_0x2020081:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x2020087
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x2020089
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x202008B
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x29
	BRLT _0x202008D
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x2A
	BRGE _0x202008E
_0x202008D:
	RJMP _0x202008C
_0x202008E:
_0x2020089:
	TST  R19
	BRMI _0x202008F
	CALL SUBOPT_0x27
_0x202008F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x2020091
	__CPWRN 18,19,2
	BRGE _0x2020092
_0x2020091:
	RJMP _0x2020090
_0x2020092:
	CALL SUBOPT_0x28
	BRNE _0x2020093
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x2020093:
_0x2020090:
_0x202008C:
_0x202008B:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x2020095
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020097
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x25
	BRLT _0x2020099
	CALL SUBOPT_0x26
	BRGE _0x202009A
_0x2020099:
	RJMP _0x2020098
_0x202009A:
_0x2020095:
	CALL SUBOPT_0x2B
	BRLO _0x202009B
	CALL SUBOPT_0x2C
	BRNE _0x202009C
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x202009C:
_0x202009B:
_0x2020098:
_0x2020097:
_0x2020087:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x22
	LDD  R30,Y+15
	CALL SUBOPT_0x23
	LDD  R30,Y+15
	CALL SUBOPT_0x24
	BREQ _0x202009E
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200A0
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20200A2
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20200A3
_0x20200A2:
	RJMP _0x20200A1
_0x20200A3:
_0x202009E:
	TST  R19
	BRMI _0x20200A4
	CALL SUBOPT_0x27
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20200A5
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2D
	BRNE _0x20200A6
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20200A6:
_0x20200A5:
_0x20200A4:
_0x20200A1:
_0x20200A0:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x20200A8
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200AA
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x25
	BRLT _0x20200AC
	CALL SUBOPT_0x26
	BRGE _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
_0x20200A8:
	CALL SUBOPT_0x2B
	BRLO _0x20200AE
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2E
	BRNE _0x20200AF
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20200AF:
_0x20200AE:
_0x20200AB:
_0x20200AA:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x20200B0
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x20200B2
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200B4
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x25
	BRLT _0x20200B6
	CALL SUBOPT_0x26
	BRGE _0x20200B7
_0x20200B6:
	RJMP _0x20200B5
_0x20200B7:
_0x20200B2:
	TST  R19
	BRMI _0x20200B8
	CALL SUBOPT_0x27
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20200BA
	__CPWRN 16,17,2
	BRGE _0x20200BB
_0x20200BA:
	RJMP _0x20200B9
_0x20200BB:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x2D
	BRNE _0x20200BC
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20200BC:
_0x20200B9:
_0x20200B8:
_0x20200B5:
_0x20200B4:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x20200BE
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200C0
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x29
	BRLT _0x20200C2
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x2A
	BRGE _0x20200C3
_0x20200C2:
	RJMP _0x20200C1
_0x20200C3:
_0x20200BE:
	CALL SUBOPT_0x2B
	BRLO _0x20200C5
	__CPWRN 16,17,2
	BRGE _0x20200C6
_0x20200C5:
	RJMP _0x20200C4
_0x20200C6:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x2E
	BRNE _0x20200C7
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20200C7:
_0x20200C4:
_0x20200C1:
_0x20200C0:
_0x20200B0:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
_glcd_line2_G101:
; .FSTART _glcd_line2_G101
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipx
	MOV  R17,R30
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	MOV  R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	MOV  R19,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	MOV  R18,R30
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R19
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_line
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
_glcd_quadrant_G101:
; .FSTART _glcd_quadrant_G101
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R26,Y+9
	CPI  R26,LOW(0x80)
	BRSH _0x20200C9
	LDD  R26,Y+8
	CPI  R26,LOW(0x40)
	BRLO _0x20200C8
_0x20200C9:
	RJMP _0x2100005
_0x20200C8:
	__GETBRMN 21,_glcd_state,8
_0x20200CB:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200CD
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20200CE
	RJMP _0x2100005
_0x20200CE:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
	STD  Y+7,R30
	SUBI R30,-LOW(1)
	MOV  R16,R30
	LDI  R31,0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	CALL __LSLW2
	CALL __ASRW2
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x20200D0:
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x20200D2
	CALL SUBOPT_0x2F
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line2_G101
	CALL SUBOPT_0x2F
	ST   -Y,R16
	MOV  R26,R17
	RCALL _glcd_line2_G101
	RJMP _0x20200D3
_0x20200D2:
	CALL SUBOPT_0x2F
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _glcd_plot8_G101
_0x20200D3:
	SUBI R17,-1
	TST  R19
	BRPL _0x20200D4
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x202011C
_0x20200D4:
	SUBI R16,1
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
_0x202011C:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20200D0
	RJMP _0x20200CB
_0x20200CD:
_0x2100005:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_glcd_circle:
; .FSTART _glcd_circle
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R26,LOW(143)
	RCALL _glcd_quadrant_G101
	JMP  _0x2100002
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0x30
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	JMP  _0x2100001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	RJMP _0x2100001
; .FEND
_sin:
; .FSTART _sin
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	CALL SUBOPT_0x31
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x32
	RCALL _floor
	CALL SUBOPT_0x31
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x32
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060017
	CALL SUBOPT_0x33
	__GETD2N 0x3F000000
	CALL SUBOPT_0x34
	LDI  R17,LOW(1)
_0x2060017:
	CALL SUBOPT_0x31
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060018
	CALL SUBOPT_0x31
	__GETD1N 0x3F000000
	CALL SUBOPT_0x34
_0x2060018:
	CPI  R17,0
	BREQ _0x2060019
	CALL SUBOPT_0x33
	CALL __ANEGF1
	__PUTD1S 5
_0x2060019:
	CALL SUBOPT_0x33
	CALL SUBOPT_0x31
	CALL __MULF12
	__PUTD1S 1
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x35
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x31
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x35
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	LDD  R17,Y+0
_0x2100004:
	ADIW R28,9
	RET
; .FEND
_cos:
; .FSTART _cos
	CALL SUBOPT_0x30
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	RJMP _0x2100001
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2100003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20A0007
	CPI  R30,LOW(0xA)
	BRNE _0x20A0008
_0x20A0007:
	LDS  R17,_glcd_state
	RJMP _0x20A0009
_0x20A0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20A000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20A0009
_0x20A000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20A0005
	__GETBRMN 17,_glcd_state,16
_0x20A0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20A000E
	CPI  R17,0
	BREQ _0x20A000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x20A000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2100002
_0x20A000E:
	CPI  R17,0
	BRNE _0x20A0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x20A0011:
_0x20A0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20A0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2100002
_0x20A0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20A0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2100002
_0x20A0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20A0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2100002
_0x20A0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2100002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20A001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20A001B
_0x20A001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20A001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20A001B
_0x20A001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20A001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20A001B:
_0x2100001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_Untitled8x8:
	.BYTE 0x220
_glcd_init_data:
	.BYTE 0x6
_x:
	.BYTE 0x4
_y:
	.BYTE 0x4
_s:
	.BYTE 0x2
_m:
	.BYTE 0x2
_h:
	.BYTE 0x2
_status_degree:
	.BYTE 0x4
_ks0108_coord_G100:
	.BYTE 0x3
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LD   R30,X
	OUT  0x18,R30
	MOV  R30,R18
	LDI  R26,LOW(1)
	CALL __LSLB12
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_s
	LDS  R27,_s+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDS  R26,_m
	LDS  R27,_m+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R26,_h
	LDS  R27,_h+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDI  R30,LOW(31)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD2N 0x41C80000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	CALL __CFD1U
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	CALL __CFD1U
	CALL __PUTDP1
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	LDS  R30,_x
	SUBI R30,-LOW(63)
	ST   -Y,R30
	LDS  R26,_y
	LDI  R30,LOW(31)
	SUB  R30,R26
	MOV  R26,R30
	JMP  _glcd_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x3
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD2N 0x41A00000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x4
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD2N 0x41700000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	CBI  0x12,1
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LD   R30,Y
	OUT  0x15,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	STD  Y+5,R30
	STD  Y+5+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDD  R30,Y+8
	ANDI R30,LOW(0x81)
	CPI  R30,LOW(0x81)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x25:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R16
	MOV  R26,R18
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	ST   -Y,R16
	MOV  R26,R20
	CALL _glcd_setpixel
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	ST   -Y,R30
	MOV  R26,R20
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x31:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__PUTD1S 5
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	CALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	__GETD2S 1
	CALL __MULF12
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

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
