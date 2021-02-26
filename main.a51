//ASSEMBLER DIRECTIVES
$NOMOD51
$INCLUDE(REG552.INC)

NAME TEMPLATE_CODE


//ALIASES FOR REGISTERS
SBUF	EQU	S0BUF
SCON	EQU	S0CON
IE      EQU     IEN0
IP      EQU     IP0      


//TEMPLATE MACROS
M_FILL_RAM_WITH_ACC MACRO 
        MOV     R0,#0FFH
        MOV     @R0,A
        DJNZ    R0,$-1
        MOV     00H,A
ENDM



//DEFINE SEGMENTS ACROSS DIFFERENT MEMORY SPACES

//VARIABLES FOR XDATA MEMORY SPACE
XDATA_SEG SEGMENT XDATA
RSEG	XDATA_SEG
	X_VAR:	DS	1


//VARIABLES FOR DATA MEMORY SPACE
DATA_SEG SEGMENT DATA		
RSEG	DATA_SEG
	D_VAR:	DS	1
		
	
//VARIABLES FOR BITADDRESSABLE MEMORY SPACE
BDATA_SEG SEGMENT DATA BITADDRESSABLE
RSEG	BDATA_SEG
	BADDR_VAR:	DS	1		
	_A      BIT     BADDR_VAR.0
	_B	BIT	BADDR_VAR.1
	_C	BIT	BADDR_VAR.2
	_D	BIT	BADDR_VAR.3
	_E	BIT	BADDR_VAR.4
	_F	BIT	BADDR_VAR.5
	_G	BIT	BADDR_VAR.6
	_H	BIT	BADDR_VAR.7
		
		
//VARIABLES FOR IDATA SPACE
IDATA_SEG SEGMENT IDATA 
RSEG	IDATA_SEG
	I_VAR:	DS	1

//VARIABLES FOR BIT MEMORY SPACE. SAME SPACE AS BITADDRESSABLE
BIT_SEG	SEGMENT BIT		
RSEG	BIT_SEG
	B_VAR:	DBIT	1
		
		
//READ ONLY VARIABLES FOR CODE SPACE	
CCONST SEGMENT CODE
RSEG	CCONST
        ;ASCII coded character vector
	CCONST_TEMPLATE_TEXT:	DB "Hello World!",3	;ETX to signal end of text (can be 0 instead of 3)


//STACK SEGMENT
?STACK SEGMENT IDATA
RSEG ?STACK
        DS 20 ;Reserve 20 bytes of space for the stack



//START OF PROGRAM	
CSEG	AT	 0      
LJMP	P_USER_PROGRAM_START
/*
  ______   ______   ______   ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/ 
                                                                               
*/
PROGRAM SEGMENT CODE
RSEG PROGRAM  
      
P_USER_PROGRAM_START:
        MOV     SP,#?STACK-1
        MOV     ACC,#69H
        M_FILL_RAM_WITH_ACC





SJMP	$
/*
  ______   ______   ______   ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/ 
                                                                               
*/
//INTERRUPT HANDLING GOES HERE
//Each interrupt routine gets a unique code segment

//EXTERNAL 0
CSEG    AT      03H
LJMP    IRQ_VECT_EXTERNAL_0
IRQ_EXTERNAL_0 SEGMENT CODE
RSEG    IRQ_EXTERNAL_0       
IRQ_VECT_EXTERNAL_0:
        NOP
RETI ;note, RETI is used instead of RET


//TIMER 0
CSEG    AT      0BH
LJMP    IRQ_VECT_TIMER_0_OVERFLOW
IRQ_TIMER_0 SEGMENT CODE
RSEG    IRQ_TIMER_0    
IRQ_VECT_TIMER_0_OVERFLOW:
        NOP
RETI


//EXTERNAL 1
CSEG    AT      13H
LJMP    IRQ_VECT_EXTERNAL_1
IRQ_EXTERNAL_1 SEGMENT CODE
RSEG    IRQ_EXTERNAL_1    
IRQ_VECT_EXTERNAL_1:
        NOP
RETI


//TIMER 1
CSEG    AT      1BH
LJMP    IRQ_VECT_TIMER_1_OVERFLOW
IRQ_TIMER_1 SEGMENT CODE
RSEG    IRQ_TIMER_1       
IRQ_VECT_TIMER_1_OVERFLOW:
        NOP
RETI


//SERIAL
CSEG    AT      23H
LJMP    IRQ_VECT_SERIAL_0_REC_TRANS
IRQ_SERIAL SEGMENT CODE
RSEG    IRQ_SERIAL        
IRQ_VECT_SERIAL_0_REC_TRANS:
        JNB	RI,IRQ_SERIAL_TRANSMIT	
	IRQ_SERIAL_RECEIVE:
		CLR	RI

		JNB	TI,IRQ_SERIAL_GENERIC
	IRQ_SERIAL_TRANSMIT:
		CLR	TI

	IRQ_SERIAL_GENERIC:

RETI
/*
   ______   ______   ______   ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/ 
                                                                               
*/
SUBROUTINES SEGMENT CODE
RSEG SUBROUTINES
//SUBROUTINES GO HERE
S_DELAY:	
        MOV	R2,#236
	MOV	R3,#2
	MOV	R4,#7
	DJNZ	R2,$
	DJNZ	R3,$-2
	DJNZ	R4,$-4
	RET


S_NOP:
        NOP
RET





/*
   ______   ______   ______   ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/ 
                                                                               
*/
END 		