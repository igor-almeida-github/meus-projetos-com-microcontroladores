
_main:

;Logicprobe.c,5 :: 		void main() {
;Logicprobe.c,7 :: 		ADCON1=0x0F;      // para fazer ra0 ser porta digital
	MOVLW       15
	MOVWF       ADCON1+0 
;Logicprobe.c,8 :: 		TRISA.RA0 = 1;    //PROBE2 é INPUT
	BSF         TRISA+0, 0 
;Logicprobe.c,9 :: 		TRISB.RB0 = 0;    //RED_LED é OUTPUT
	BCF         TRISB+0, 0 
;Logicprobe.c,10 :: 		TRISB.RB1 = 0;    //GREEN_LED é OUTPUT
	BCF         TRISB+0, 1 
;Logicprobe.c,11 :: 		for (;;){
L_main0:
;Logicprobe.c,12 :: 		if  (PROBE==0 ){
	BTFSC       PORTA+0, 0 
	GOTO        L_main3
;Logicprobe.c,13 :: 		RED_LED=1;
	BSF         PORTB+0, 0 
;Logicprobe.c,14 :: 		GREEN_LED=0;
	BCF         PORTB+0, 1 
;Logicprobe.c,15 :: 		}
	GOTO        L_main4
L_main3:
;Logicprobe.c,18 :: 		RED_LED=0;
	BCF         PORTB+0, 0 
;Logicprobe.c,19 :: 		GREEN_LED=1;
	BSF         PORTB+0, 1 
;Logicprobe.c,20 :: 		}
L_main4:
;Logicprobe.c,21 :: 		}
	GOTO        L_main0
;Logicprobe.c,22 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
