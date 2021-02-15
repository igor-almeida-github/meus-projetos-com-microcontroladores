
_main:

;ledrandom.c,3 :: 		void main()
;ledrandom.c,6 :: 		TRISC =0; // Configure PORTC as output
	CLRF        TRISC+0 
;ledrandom.c,7 :: 		srand(10);
	MOVLW       10
	MOVWF       FARG_srand_x+0 
	MOVLW       0
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
;ledrandom.c,9 :: 		for(;;)          // Endless loop
L_main0:
;ledrandom.c,11 :: 		p=rand()/128;
	CALL        _rand+0, 0
;ledrandom.c,12 :: 		RC1_bit=1;
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;ledrandom.c,13 :: 		Delay_Ms(100); // Wait 1 s
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
;ledrandom.c,14 :: 		}
	GOTO        L_main0
;ledrandom.c,15 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
