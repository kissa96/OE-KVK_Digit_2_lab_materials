        ;Reset vektor (most mar nevezzuk neven)
        CSEG    AT      0000H
        LJMP    0030H            
        ;T0 idozito tulcsordulas vektora
        CSEG    AT      000BH
        LJMP    ISR_TIMER0_OVERFLOW
        ;Soros port megszakitasi vektora
        CSEG    AT      0023H
        LJMP    ISR_SERIAL_PORT
        ;program kezdete
        CSEG    AT      0030H
        
        MOV     P1,#1
        LCALL   INIT_SERIAL_9600
        LCALL   INIT_T0_MODE1_5ms
        LCALL   INIT_INTERRUPTS       
END_OF_PROGRAM:
        MOV     PCON,#01H       ;IDL mode ON
        LJMP    END_OF_PROGRAM

;MEGSZAKITASI RUTINOK MINDIG
;A LEZARO CIKLUS UTAN JONNEK
ISR_TIMER0_OVERFLOW:
        ;Most nekunk kell feltolteni a szamlalot
        MOV     TH0,#(100H-12H) ;=0xEE
        MOV     TL0,#00H  ;=0x00
        DJNZ    R6,ISR_TIMER0_OVERFLOW_END
        ;2Hz
        MOV     R6,#100 ;100*5ms = 0.5 sec
        LCALL   BLINKY_ON_P3
        CPL     F0
        JNB     F0,ISR_TIMER0_OVERFLOW_END
        ;1Hz
        LCALL   CHASER_ON_P1
ISR_TIMER0_OVERFLOW_END:
        RETI
ISR_SERIAL_PORT:
        CLR     TI
        JNB     RI,ISR_SERIAL_NO_NEW_DATA_IN_SBUF
        CLR     RI
        MOV     SBUF,SBUF
        MOV     P2,SBUF
ISR_SERIAL_NO_NEW_DATA_IN_SBUF:
        RETI
;SZUBRUTINOK
INIT_T0_MODE1_5ms:
        ANL     TMOD,#0F0H
        ORL     TMOD,#01H ;mode 1
        MOV     TH0,#(100H-12H)
        MOV     TL0,#00H
        SETB    TR0
        RET       
INIT_SERIAL_9600:
        MOV     SCON,#50H
        ANL     TMOD,#0FH
        ORL     TMOD,#20H
        MOV     TH1,#0FDH
        SETB    TR1
        RET
INIT_INTERRUPTS:
        SETB    ET0     ;Enable Timer0
        SETB    ES
        SETB    EA      ;Enable All
        RET
BLINKY_ON_P3:
        PUSH    ACC
        MOV     A,P3
        CPL     A       ;p3 porton villogo
        MOV     P3,A
        POP     ACC 
        RET
CHASER_ON_P1:
        PUSH    ACC
        MOV     A,P1
        RL      A       ;futofeny balra
        MOV     P1,A
        POP     ACC
        RET
        
        END
