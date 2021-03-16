        CSEG    AT      0
        LJMP    0030H
        
        CSEG    AT      0030H
        LCALL   S_INIT_SERIAL_9600
        MOV     P1,#1
MAIN_PROGRAM_LOOP:
        LCALL   HALF_SEC_DELAY
        CPL     PSW.1          ;ez a bit is szabad
        LCALL   VILLOGO
        JNB     PSW.1,SKIP_FUTOFENY
        LCALL   FUTOFENY
SKIP_FUTOFENY:
        LCALL   S_SERIAL_POLLING_READ
        LCALL   S_SERIAL_POLLING_WRITE
        LJMP    MAIN_PROGRAM_LOOP
END_OF_PROGRAM:
        LJMP    END_OF_PROGRAM
        
        
S_INIT_SERIAL_9600:
        MOV     SCON,#50H       ;Baud generalas
        ANL     TMOD,#0DFH      ;az idozitovel
        ORL     TMOD,#20H       ;lehetseges
        MOV     TH1,#0FDH       ;9600-as baud
        SETB    TR1
        SETB    TI
        RET             

S_SERIAL_POLLING_READ:
        JNB     RI,NEW_DATA_NOT_AVAILABLE_IN_SBUF
        CLR     RI
        MOV     A,SBUF
        SETB    F0      ;PSW.5
NEW_DATA_NOT_AVAILABLE_IN_SBUF:
        RET
        
        
S_SERIAL_POLLING_WRITE:
;Teszteljuk TI es F0 erteket is!
        JNB     F0,NO_NEW_DATA ;van uj adat?
        JNB     TI,NO_NEW_DATA ;az elozo irast befejeztuk?
;ha mindketto teljesul, akkor:
        CLR     TI
        CLR     F0
        MOV     SBUF,A
NO_NEW_DATA:
        RET
        
        
FUTOFENY:
        PUSH    ACC     ;Elmentem az akkumulatort
        MOV     A,P1    ;mert itt mar megvaltozik az erteke
        RL      A
        MOV     P1,A
        POP     ACC     ;visszaallitom az akkumulator erteket
        RET
        
        
VILLOGO:
        PUSH    ACC     ;Elmentem az akkumulatort
        MOV     A,P3    ;mert itt mar megvaltozik az erteke
        CPL     A
        MOV     P3,A
        POP     ACC     ;visszaallitom az akkumulator erteket
        RET
        
        
HALF_SEC_DELAY:	
        MOV	R2,#120
        MOV	R3,#129
        MOV	R4,#4
        DJNZ	R2,$
        DJNZ	R3,$-2
        DJNZ	R4,$-4
        RET
       
        END
