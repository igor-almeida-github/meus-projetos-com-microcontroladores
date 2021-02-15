
_main:

;ledchase.c,2 :: 		void main()
;ledchase.c,4 :: 		unsigned char j=0b00000001;    // aparentemente todas as variaveis devem ser declaradas no inicio da main ou do lado de fora, antes da main,
	MOVLW       1
	MOVWF       main_j_L0+0 
;ledchase.c,6 :: 		TRISC =0; // Configure PORTB as output
	CLRF        TRISC+0 
;ledchase.c,9 :: 		for(;;)          // Endless loop
L_main0:
;ledchase.c,11 :: 		PORTC=j;
	MOVF        main_j_L0+0, 0 
	MOVWF       PORTC+0 
;ledchase.c,12 :: 		Delay_Ms(1000); // Wait 1 s
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
;ledchase.c,13 :: 		j=j<<1;
	MOVF        main_j_L0+0, 0 
	MOVWF       R1 
	RLCF        R1, 1 
	BCF         R1, 0 
	MOVF        R1, 0 
	MOVWF       main_j_L0+0 
;ledchase.c,14 :: 		if(j==0)j=1;
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
	MOVLW       1
	MOVWF       main_j_L0+0 
L_main4:
;ledchase.c,15 :: 		}
	GOTO        L_main0
;ledchase.c,29 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
