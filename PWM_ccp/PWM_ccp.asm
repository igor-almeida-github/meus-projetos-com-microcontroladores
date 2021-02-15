
_main:

;PWM_ccp.c,1 :: 		void main() {
;PWM_ccp.c,3 :: 		ADCON1=0x0F;                                                              // As referências de tensão do AD são VDD e VSS; Desabilita as portas analógicas
	MOVLW       15
	MOVWF       ADCON1+0 
;PWM_ccp.c,4 :: 		TRISC.RC2=0;                                                              // CCP1 pin é OUTPUT
	BCF         TRISC+0, 2 
;PWM_ccp.c,6 :: 		T2CON=0x04;                                                               // Prescale de 1; Timer 2 on
	MOVLW       4
	MOVWF       T2CON+0 
;PWM_ccp.c,7 :: 		PR2=0xF9;                                                                 // Carrega 249 no PR2, período de 50us
	MOVLW       249
	MOVWF       PR2+0 
;PWM_ccp.c,9 :: 		CCP1CON=0x0C;                                                             // Modo de PWM, CCP1CON<5:4> = 00
	MOVLW       12
	MOVWF       CCP1CON+0 
;PWM_ccp.c,10 :: 		CCPR1L=0x7D;                                                              // 50% de Duty Cycle
	MOVLW       125
	MOVWF       CCPR1L+0 
;PWM_ccp.c,11 :: 		for (;;){
L_main0:
;PWM_ccp.c,25 :: 		while(CCPR1L<0xF9){                                                                // Loop Infinito
L_main3:
	MOVLW       249
	SUBWF       CCPR1L+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
;PWM_ccp.c,26 :: 		CCPR1L++;
	MOVF        CCPR1L+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       CCPR1L+0 
;PWM_ccp.c,27 :: 		delay_ms(5);
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
;PWM_ccp.c,28 :: 		}
	GOTO        L_main3
L_main4:
;PWM_ccp.c,29 :: 		while (CCPR1L>1) {
L_main6:
	MOVF        CCPR1L+0, 0 
	SUBLW       1
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
;PWM_ccp.c,30 :: 		CCPR1L--;
	DECF        CCPR1L+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       CCPR1L+0 
;PWM_ccp.c,31 :: 		delay_ms(5);
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	DECFSZ      R12, 1, 1
	BRA         L_main8
	NOP
;PWM_ccp.c,32 :: 		}
	GOTO        L_main6
L_main7:
;PWM_ccp.c,33 :: 		}
	GOTO        L_main0
;PWM_ccp.c,34 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
