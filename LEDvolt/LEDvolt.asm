
_main:

;LEDvolt.c,11 :: 		void main() {
;LEDvolt.c,14 :: 		TRISB=0xE0;        // Os 5 primeiros bits do PORTB são OUTPUT, os demais são input
	MOVLW       224
	MOVWF       TRISB+0 
;LEDvolt.c,15 :: 		ADCON1=0x0E;       // Todas as portas são dgitais exceto AN0(RA0)
	MOVLW       14
	MOVWF       ADCON1+0 
;LEDvolt.c,16 :: 		TRISA.RA0=1;       // A porta do AN0 é input
	BSF         TRISA+0, 0 
;LEDvolt.c,17 :: 		ADCON2=0x80;     // Resultado justificado a direita
	MOVLW       128
	MOVWF       ADCON2+0 
;LEDvolt.c,22 :: 		UART1_Init(4800);//**************************
	BSF         BAUDCON+0, 3, 0
	MOVLW       1
	MOVWF       SPBRGH+0 
	MOVLW       160
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;LEDvolt.c,23 :: 		Delay_ms(100); //**************************
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
	NOP
;LEDvolt.c,24 :: 		for (;;){
L_main1:
;LEDvolt.c,26 :: 		mV= Adc_Read(0); // multiplicado por 5000mv e dividido por 1024: deslocado 10 bits para a direita, o que é o mesmo que dividir por 1024
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_mV_L0+0 
	MOVF        R1, 0 
	MOVWF       main_mV_L0+1 
	MOVLW       0
	MOVWF       main_mV_L0+2 
	MOVWF       main_mV_L0+3 
;LEDvolt.c,27 :: 		mV=(mV*4760)>>10; // CUIDADO, SE MULTIPLICAR DUAS VARIAVEIS INTEIRAS O RESULTADO É SEMPRE UM INTEIRO DE 16 BITS, PORTANTO DEPENDENDO DO VALOR PODE DAR OVERFLOW
	MOVF        main_mV_L0+0, 0 
	MOVWF       R0 
	MOVF        main_mV_L0+1, 0 
	MOVWF       R1 
	MOVF        main_mV_L0+2, 0 
	MOVWF       R2 
	MOVF        main_mV_L0+3, 0 
	MOVWF       R3 
	MOVLW       152
	MOVWF       R4 
	MOVLW       18
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R8 
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        R8, 0 
L__main16:
	BZ          L__main17
	RRCF        R7, 1 
	RRCF        R6, 1 
	RRCF        R5, 1 
	RRCF        R4, 1 
	BCF         R7, 7 
	ADDLW       255
	GOTO        L__main16
L__main17:
	MOVF        R4, 0 
	MOVWF       main_mV_L0+0 
	MOVF        R5, 0 
	MOVWF       main_mV_L0+1 
	MOVF        R6, 0 
	MOVWF       main_mV_L0+2 
	MOVF        R7, 0 
	MOVWF       main_mV_L0+3 
;LEDvolt.c,30 :: 		if (mV>0) LED01V=1; else LED01V=0;
	MOVF        R7, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main18
	MOVF        R6, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main18
	MOVF        R5, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main18
	MOVF        R4, 0 
	SUBLW       0
L__main18:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
	BSF         PORTB+0, 0 
	GOTO        L_main5
L_main4:
	BCF         PORTB+0, 0 
L_main5:
;LEDvolt.c,31 :: 		if (mV>=1000) LED12V=1 ; else LED12V=0;
	MOVLW       0
	SUBWF       main_mV_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main19
	MOVLW       0
	SUBWF       main_mV_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main19
	MOVLW       3
	SUBWF       main_mV_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main19
	MOVLW       232
	SUBWF       main_mV_L0+0, 0 
L__main19:
	BTFSS       STATUS+0, 0 
	GOTO        L_main6
	BSF         PORTB+0, 1 
	GOTO        L_main7
L_main6:
	BCF         PORTB+0, 1 
L_main7:
;LEDvolt.c,32 :: 		if (mV>=2000) LED23V=1;  else LED23V=0;
	MOVLW       0
	SUBWF       main_mV_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main20
	MOVLW       0
	SUBWF       main_mV_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main20
	MOVLW       7
	SUBWF       main_mV_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main20
	MOVLW       208
	SUBWF       main_mV_L0+0, 0 
L__main20:
	BTFSS       STATUS+0, 0 
	GOTO        L_main8
	BSF         PORTB+0, 2 
	GOTO        L_main9
L_main8:
	BCF         PORTB+0, 2 
L_main9:
;LEDvolt.c,33 :: 		if (mV>=3000) LED34V=1;  else LED34V=0;
	MOVLW       0
	SUBWF       main_mV_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main21
	MOVLW       0
	SUBWF       main_mV_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main21
	MOVLW       11
	SUBWF       main_mV_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main21
	MOVLW       184
	SUBWF       main_mV_L0+0, 0 
L__main21:
	BTFSS       STATUS+0, 0 
	GOTO        L_main10
	BSF         PORTB+0, 3 
	GOTO        L_main11
L_main10:
	BCF         PORTB+0, 3 
L_main11:
;LEDvolt.c,34 :: 		if (mV>=4000) LED45V=1; else LED45V=0;
	MOVLW       0
	SUBWF       main_mV_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main22
	MOVLW       0
	SUBWF       main_mV_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main22
	MOVLW       15
	SUBWF       main_mV_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main22
	MOVLW       160
	SUBWF       main_mV_L0+0, 0 
L__main22:
	BTFSS       STATUS+0, 0 
	GOTO        L_main12
	BSF         PORTB+0, 4 
	GOTO        L_main13
L_main12:
	BCF         PORTB+0, 4 
L_main13:
;LEDvolt.c,35 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main14:
	DECFSZ      R13, 1, 1
	BRA         L_main14
	DECFSZ      R12, 1, 1
	BRA         L_main14
	NOP
;LEDvolt.c,37 :: 		}
	GOTO        L_main1
;LEDvolt.c,38 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
