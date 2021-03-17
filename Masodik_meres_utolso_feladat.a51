        CSEG    AT      0
        LJMP    0030H
        
        
        CSEG    AT      0030H
        LCALL   S_INIT_SERIAL_9600
        MOV     P1,#1
MAIN_PROGRAM_LOOP:
        LCALL   S_HALF_SEC_DELAY
        CPL     F0              ;Ez egy szabadon felhasznalhato bit a PSW regiszterben
        LCALL   S_VILLOGO
        JNB     F0,SKIP_FUTOFENY;Csak minden masodik alkalommal 
        LCALL   S_FUTOFENY        ;futtatjuk le a futofeny lepteteset (0.5*2 = 1 sec)
SKIP_FUTOFENY:
        LCALL   S_SERIAL_LOOPBACK_WITH_POLLING
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

S_SERIAL_LOOPBACK_WITH_POLLING:
        JNB     RI,NEW_DATA_NOT_AVAILABLE_IN_SBUF
        CLR     RI
        MOV     SBUF,SBUF
NEW_DATA_NOT_AVAILABLE_IN_SBUF:
        RET
        
S_FUTOFENY:
        PUSH    ACC     ;Elmentem az akkumulatort
        MOV     A,P1    ;mert itt mar megvaltozik az erteke
        RL      A
        MOV     P1,A
        POP     ACC     ;visszaallitom az akkumulator erteket
        RET
S_VILLOGO:
        PUSH    ACC     ;Elmentem az akkumulatort
        MOV     A,P3    ;mert itt mar megvaltozik az erteke
        CPL     A
        MOV     P3,A
        POP     ACC     ;visszaallitom az akkumulator erteket
        RET
        
S_HALF_SEC_DELAY:	
        MOV	R2,#120
	MOV	R3,#129
	MOV	R4,#4
	DJNZ	R2,$
	DJNZ	R3,$-2
	DJNZ	R4,$-4
	RET

 
        END
