
_ledstrip_write0:

;pythonFitaLed.c,8 :: 		void ledstrip_write0(void){
;pythonFitaLed.c,10 :: 		PORTB.RB2=1; //100ns   1 ciclo de maquina
	BSF         PORTB+0, 2 
;pythonFitaLed.c,11 :: 		asm nop      // desperdiça 100ns
	NOP
;pythonFitaLed.c,12 :: 		asm nop      // desperdiça 100ns
	NOP
;pythonFitaLed.c,13 :: 		PORTB.RB2=0; //100ns
	BCF         PORTB+0, 2 
;pythonFitaLed.c,15 :: 		}
L_end_ledstrip_write0:
	RETURN      0
; end of _ledstrip_write0

_ledstrip_write1:

;pythonFitaLed.c,16 :: 		void ledstrip_write1(void){
;pythonFitaLed.c,18 :: 		PORTB.RB2=1; //100ns   1 ciclo de maquina
	BSF         PORTB+0, 2 
;pythonFitaLed.c,19 :: 		asm nop      // desperdiça 100ns
	NOP
;pythonFitaLed.c,20 :: 		asm nop      // desperdiça 100ns
	NOP
;pythonFitaLed.c,21 :: 		asm nop      // desperdiça 100ns
	NOP
;pythonFitaLed.c,22 :: 		asm nop      // desperdiça 100ns
	NOP
;pythonFitaLed.c,23 :: 		PORTB.RB2=0; //100ns
	BCF         PORTB+0, 2 
;pythonFitaLed.c,25 :: 		}
L_end_ledstrip_write1:
	RETURN      0
; end of _ledstrip_write1

_ledstrip:

;pythonFitaLed.c,26 :: 		void ledstrip(unsigned char red, unsigned char green, unsigned char blue){
;pythonFitaLed.c,30 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	MOVLW       7
	MOVWF       ledstrip_k_L0+0 
L_ledstrip0:
	MOVLW       128
	XORWF       ledstrip_k_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ledstrip1
;pythonFitaLed.c,31 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;pythonFitaLed.c,32 :: 		if ((green &(0x01<<k))==0){ // green and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de green na posição k é 0, caso contrário, ele é 1
	MOVF        ledstrip_k_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__ledstrip33:
	BZ          L__ledstrip34
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__ledstrip33
L__ledstrip34:
	MOVF        R0, 0 
	ANDWF       FARG_ledstrip_green+0, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ledstrip35
	MOVLW       0
	XORWF       R2, 0 
L__ledstrip35:
	BTFSS       STATUS+0, 2 
	GOTO        L_ledstrip3
;pythonFitaLed.c,33 :: 		ledstrip_write0();
	CALL        _ledstrip_write0+0, 0
;pythonFitaLed.c,34 :: 		}
	GOTO        L_ledstrip4
L_ledstrip3:
;pythonFitaLed.c,36 :: 		ledstrip_write1();
	CALL        _ledstrip_write1+0, 0
;pythonFitaLed.c,37 :: 		}
L_ledstrip4:
;pythonFitaLed.c,38 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;pythonFitaLed.c,30 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	DECF        ledstrip_k_L0+0, 1 
;pythonFitaLed.c,39 :: 		}
	GOTO        L_ledstrip0
L_ledstrip1:
;pythonFitaLed.c,41 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	MOVLW       7
	MOVWF       ledstrip_k_L0+0 
L_ledstrip5:
	MOVLW       128
	XORWF       ledstrip_k_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ledstrip6
;pythonFitaLed.c,42 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;pythonFitaLed.c,43 :: 		if ((red &(0x01<<k))==0){  // red and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de red na posição k é 0, caso contrário, ele é 1
	MOVF        ledstrip_k_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__ledstrip36:
	BZ          L__ledstrip37
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__ledstrip36
L__ledstrip37:
	MOVF        R0, 0 
	ANDWF       FARG_ledstrip_red+0, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ledstrip38
	MOVLW       0
	XORWF       R2, 0 
L__ledstrip38:
	BTFSS       STATUS+0, 2 
	GOTO        L_ledstrip8
;pythonFitaLed.c,44 :: 		ledstrip_write0();
	CALL        _ledstrip_write0+0, 0
;pythonFitaLed.c,45 :: 		}
	GOTO        L_ledstrip9
L_ledstrip8:
;pythonFitaLed.c,47 :: 		ledstrip_write1();
	CALL        _ledstrip_write1+0, 0
;pythonFitaLed.c,48 :: 		}
L_ledstrip9:
;pythonFitaLed.c,49 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;pythonFitaLed.c,41 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	DECF        ledstrip_k_L0+0, 1 
;pythonFitaLed.c,50 :: 		}
	GOTO        L_ledstrip5
L_ledstrip6:
;pythonFitaLed.c,52 :: 		for (k=7;k>=0;k--){   // enviando bit mais significante primeiro
	MOVLW       7
	MOVWF       ledstrip_k_L0+0 
L_ledstrip10:
	MOVLW       128
	XORWF       ledstrip_k_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ledstrip11
;pythonFitaLed.c,53 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;pythonFitaLed.c,54 :: 		if ((blue &(0x01<<k))==0){   // blue and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de blue na posição k é 0, caso contrário, ele é 1
	MOVF        ledstrip_k_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__ledstrip39:
	BZ          L__ledstrip40
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__ledstrip39
L__ledstrip40:
	MOVF        R0, 0 
	ANDWF       FARG_ledstrip_blue+0, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ledstrip41
	MOVLW       0
	XORWF       R2, 0 
L__ledstrip41:
	BTFSS       STATUS+0, 2 
	GOTO        L_ledstrip13
;pythonFitaLed.c,55 :: 		ledstrip_write0();
	CALL        _ledstrip_write0+0, 0
;pythonFitaLed.c,56 :: 		}
	GOTO        L_ledstrip14
L_ledstrip13:
;pythonFitaLed.c,58 :: 		ledstrip_write1();
	CALL        _ledstrip_write1+0, 0
;pythonFitaLed.c,59 :: 		}
L_ledstrip14:
;pythonFitaLed.c,60 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;pythonFitaLed.c,52 :: 		for (k=7;k>=0;k--){   // enviando bit mais significante primeiro
	DECF        ledstrip_k_L0+0, 1 
;pythonFitaLed.c,61 :: 		}
	GOTO        L_ledstrip10
L_ledstrip11:
;pythonFitaLed.c,63 :: 		}
L_end_ledstrip:
	RETURN      0
; end of _ledstrip

_interrupt:

;pythonFitaLed.c,65 :: 		void interrupt(void){
;pythonFitaLed.c,66 :: 		if(PIR1.RCIF){
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt15
;pythonFitaLed.c,67 :: 		matriz[indice_matriz] = RCREG;
	MOVLW       _matriz+0
	ADDWF       _indice_matriz+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      _indice_matriz+1, 0 
	MOVWF       FSR1H 
	MOVF        RCREG+0, 0 
	MOVWF       POSTINC1+0 
;pythonFitaLed.c,68 :: 		indice_matriz++;
	INFSNZ      _indice_matriz+0, 1 
	INCF        _indice_matriz+1, 1 
;pythonFitaLed.c,69 :: 		TMR0L = 0;
	CLRF        TMR0L+0 
;pythonFitaLed.c,70 :: 		}
L_interrupt15:
;pythonFitaLed.c,71 :: 		if(INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt16
;pythonFitaLed.c,72 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;pythonFitaLed.c,73 :: 		indice_matriz = 0;
	CLRF        _indice_matriz+0 
	CLRF        _indice_matriz+1 
;pythonFitaLed.c,74 :: 		}
L_interrupt16:
;pythonFitaLed.c,75 :: 		}
L_end_interrupt:
L__interrupt43:
	RETFIE      1
; end of _interrupt

_main:

;pythonFitaLed.c,77 :: 		void main() {
;pythonFitaLed.c,82 :: 		ADCON1   =0x0F;                       // Todas as portas são digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;pythonFitaLed.c,83 :: 		TRISB.RB2=0;                          // RB2 é output
	BCF         TRISB+0, 2 
;pythonFitaLed.c,84 :: 		PORTB.RB2=0;                          // RB2 inicia em 0
	BCF         PORTB+0, 2 
;pythonFitaLed.c,85 :: 		TRISD.RD1 = 0;                        // *************** teste
	BCF         TRISD+0, 1 
;pythonFitaLed.c,87 :: 		Delay_ms(1);                                    // reset da fita
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_main17:
	DECFSZ      R13, 1, 1
	BRA         L_main17
	DECFSZ      R12, 1, 1
	BRA         L_main17
	NOP
	NOP
;pythonFitaLed.c,88 :: 		for(led=0; led<150; led++) ledstrip(0,0,0);     // Apaga todos os leds
	CLRF        main_led_L0+0 
	CLRF        main_led_L0+1 
L_main18:
	MOVLW       128
	XORWF       main_led_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main45
	MOVLW       150
	SUBWF       main_led_L0+0, 0 
L__main45:
	BTFSC       STATUS+0, 0 
	GOTO        L_main19
	CLRF        FARG_ledstrip_red+0 
	CLRF        FARG_ledstrip_green+0 
	CLRF        FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
	INFSNZ      main_led_L0+0, 1 
	INCF        main_led_L0+1, 1 
	GOTO        L_main18
L_main19:
;pythonFitaLed.c,89 :: 		Delay_ms(1000);
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_main21:
	DECFSZ      R13, 1, 1
	BRA         L_main21
	DECFSZ      R12, 1, 1
	BRA         L_main21
	DECFSZ      R11, 1, 1
	BRA         L_main21
	NOP
	NOP
;pythonFitaLed.c,91 :: 		UART1_Init(115200);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       86
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;pythonFitaLed.c,94 :: 		INTCON = 0xE0;                                                             // Interrupção global ativada; Interrupções dos periféricos ativadas; Interrupção do timer 0 ativada
	MOVLW       224
	MOVWF       INTCON+0 
;pythonFitaLed.c,95 :: 		PIE1 = 0x20;                                                               // Interrupção da recepção EUSART ativada
	MOVLW       32
	MOVWF       PIE1+0 
;pythonFitaLed.c,97 :: 		T0CON = 0xC4;                                                              // Timer 0 no modo 8 bits; habilitado; prescale 32; temporizando 819.2 us
	MOVLW       196
	MOVWF       T0CON+0 
;pythonFitaLed.c,100 :: 		for(;;){
L_main22:
;pythonFitaLed.c,101 :: 		PORTD.RD1 = 1;
	BSF         PORTD+0, 1 
;pythonFitaLed.c,102 :: 		while(indice_matriz != 450);
L_main25:
	MOVF        _indice_matriz+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main46
	MOVLW       194
	XORWF       _indice_matriz+0, 0 
L__main46:
	BTFSC       STATUS+0, 2 
	GOTO        L_main26
	GOTO        L_main25
L_main26:
;pythonFitaLed.c,103 :: 		PORTD.RD1 = 0;
	BCF         PORTD+0, 1 
;pythonFitaLed.c,104 :: 		indice_matriz = 0;
	CLRF        _indice_matriz+0 
	CLRF        _indice_matriz+1 
;pythonFitaLed.c,105 :: 		for(led=0; led<150; led++){
	CLRF        main_led_L0+0 
	CLRF        main_led_L0+1 
L_main27:
	MOVLW       128
	XORWF       main_led_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main47
	MOVLW       150
	SUBWF       main_led_L0+0, 0 
L__main47:
	BTFSC       STATUS+0, 0 
	GOTO        L_main28
;pythonFitaLed.c,106 :: 		ledstrip(matriz[3*led], matriz[3*led+1], matriz[3*led+2]);
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        main_led_L0+0, 0 
	MOVWF       R4 
	MOVF        main_led_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _matriz+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_red+0 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVLW       _matriz+0
	ADDWF       R2, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R3, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_green+0 
	MOVLW       2
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _matriz+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
;pythonFitaLed.c,105 :: 		for(led=0; led<150; led++){
	INFSNZ      main_led_L0+0, 1 
	INCF        main_led_L0+1, 1 
;pythonFitaLed.c,107 :: 		}
	GOTO        L_main27
L_main28:
;pythonFitaLed.c,108 :: 		}
	GOTO        L_main22
;pythonFitaLed.c,110 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
