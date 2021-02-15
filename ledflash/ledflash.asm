
_main:

;ledflash.c,3 :: 		void main()
;ledflash.c,6 :: 		TRISB =0; // Configure PORTB as output
	CLRF        TRISB+0 
;ledflash.c,8 :: 		for(;;)          // Endless loop
L_main0:
;ledflash.c,12 :: 		PORTB.RB0 = 0;            // RB0 = 0
	BCF         PORTB+0, 0 
;ledflash.c,13 :: 		Delay_Ms(20); // Wait 1 s
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
;ledflash.c,14 :: 		PORTB.RB0 = 1; // RB0 = 1
	BSF         PORTB+0, 0 
;ledflash.c,15 :: 		Delay_Ms(20); // Wait 1 s
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	NOP
;ledflash.c,16 :: 		}
	GOTO        L_main0
;ledflash.c,19 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
