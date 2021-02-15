
_main:

;advancedlogicprobe.c,8 :: 		void main() {
;advancedlogicprobe.c,10 :: 		ADCON1=0x0F;      //para fazer que todas as portas sejam digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;advancedlogicprobe.c,11 :: 		TRISA.RA0 = 0;    //RED_LED é output
	BCF         TRISA+0, 0 
;advancedlogicprobe.c,12 :: 		TRISA.RA1 = 0;    //GREEN_LED é OUTPUT
	BCF         TRISA+0, 1 
;advancedlogicprobe.c,13 :: 		TRISB.RB4 = 0;    //PROBEOUT é OUTPUT
	BCF         TRISB+0, 4 
;advancedlogicprobe.c,14 :: 		TRISB.RB2 = 1;    //PROBEIN é INPUT
	BSF         TRISB+0, 2 
;advancedlogicprobe.c,16 :: 		for (;;){
L_main0:
;advancedlogicprobe.c,17 :: 		PROBEOUT=1;
	BSF         PORTB+0, 4 
;advancedlogicprobe.c,18 :: 		Delay_ms(1); // Para esperar o transistor chavear
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
;advancedlogicprobe.c,19 :: 		leitura1=PROBEIN;
	BTFSC       PORTB+0, 2 
	GOTO        L__main16
	BCF         _leitura1+0, BitPos(_leitura1+0) 
	GOTO        L__main17
L__main16:
	BSF         _leitura1+0, BitPos(_leitura1+0) 
L__main17:
;advancedlogicprobe.c,20 :: 		PROBEOUT=0;
	BCF         PORTB+0, 4 
;advancedlogicprobe.c,21 :: 		Delay_ms(1); // Para esperar o transistor chavear
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	NOP
;advancedlogicprobe.c,22 :: 		leitura0=PROBEIN;
	BTFSC       PORTB+0, 2 
	GOTO        L__main18
	BCF         _leitura0+0, BitPos(_leitura0+0) 
	GOTO        L__main19
L__main18:
	BSF         _leitura0+0, BitPos(_leitura0+0) 
L__main19:
;advancedlogicprobe.c,23 :: 		if  (leitura1==0 && leitura0==0){ // ponta de prova em nivel baixo
	BTFSC       _leitura1+0, BitPos(_leitura1+0) 
	GOTO        L_main7
	BTFSC       _leitura0+0, BitPos(_leitura0+0) 
	GOTO        L_main7
L__main14:
;advancedlogicprobe.c,24 :: 		RED_LED=1;
	BSF         PORTA+0, 0 
;advancedlogicprobe.c,25 :: 		GREEN_LED=0;
	BCF         PORTA+0, 1 
;advancedlogicprobe.c,26 :: 		}
	GOTO        L_main8
L_main7:
;advancedlogicprobe.c,27 :: 		else if  (leitura1==1 && leitura0==1){ // ponta de prova em nivel alto
	BTFSS       _leitura1+0, BitPos(_leitura1+0) 
	GOTO        L_main11
	BTFSS       _leitura0+0, BitPos(_leitura0+0) 
	GOTO        L_main11
L__main13:
;advancedlogicprobe.c,28 :: 		RED_LED=0;
	BCF         PORTA+0, 0 
;advancedlogicprobe.c,29 :: 		GREEN_LED=1;
	BSF         PORTA+0, 1 
;advancedlogicprobe.c,30 :: 		}
	GOTO        L_main12
L_main11:
;advancedlogicprobe.c,32 :: 		RED_LED=0;
	BCF         PORTA+0, 0 
;advancedlogicprobe.c,33 :: 		GREEN_LED=0;
	BCF         PORTA+0, 1 
;advancedlogicprobe.c,34 :: 		}
L_main12:
L_main8:
;advancedlogicprobe.c,36 :: 		}
	GOTO        L_main0
;advancedlogicprobe.c,37 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
