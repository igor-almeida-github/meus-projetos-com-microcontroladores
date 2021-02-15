
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;frequencycounter.c,25 :: 		void interrupt(void){
;frequencycounter.c,26 :: 		if (INTCON.TMR0IF){
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;frequencycounter.c,27 :: 		TMR0=6;
	MOVLW      6
	MOVWF      TMR0+0
;frequencycounter.c,28 :: 		cnt0++;
	INCF       _cnt0+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cnt0+1, 1
;frequencycounter.c,29 :: 		INTCON.TMR0IF=0;
	BCF        INTCON+0, 2
;frequencycounter.c,31 :: 		}
L_interrupt0:
;frequencycounter.c,32 :: 		if (PIR1.TMR1IF){
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt1
;frequencycounter.c,33 :: 		TMR1H=0;// inicializa o high byte do timer 1;
	CLRF       TMR1H+0
;frequencycounter.c,34 :: 		TMR1L=0;  // inicializa o low byte do timer 1;
	CLRF       TMR1L+0
;frequencycounter.c,35 :: 		cnt1++;
	INCF       _cnt1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cnt1+1, 1
;frequencycounter.c,36 :: 		PIR1.TMR1IF=0;
	BCF        PIR1+0, 0
;frequencycounter.c,37 :: 		}
L_interrupt1:
;frequencycounter.c,38 :: 		}
L_end_interrupt:
L__interrupt9:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;frequencycounter.c,40 :: 		void main() {
;frequencycounter.c,46 :: 		TRISC.RC0=1;   // pino para ler a forma de onda que se vai medir a frequencia t1ckl
	BSF        TRISC+0, 0
;frequencycounter.c,47 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;frequencycounter.c,50 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;frequencycounter.c,51 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frequencycounter.c,52 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frequencycounter.c,53 :: 		Lcd_Out(1,1,"Frequency"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_frequencycounter+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frequencycounter.c,54 :: 		Lcd_Out(2,1,"Counter"); // Escreve na posição 1,1
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_frequencycounter+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frequencycounter.c,55 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;frequencycounter.c,56 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frequencycounter.c,59 :: 		OPTION_REG=0xC4; // overflow do timer 0 a cada 1.6ms    x625 = 1s
	MOVLW      196
	MOVWF      OPTION_REG+0
;frequencycounter.c,60 :: 		T1CON= 0x06;  // configura o timer 1 como contador no pino t1ckl
	MOVLW      6
	MOVWF      T1CON+0
;frequencycounter.c,63 :: 		INTCON=0xE0; // habilita a interrupção pelo overflow do timer0
	MOVLW      224
	MOVWF      INTCON+0
;frequencycounter.c,64 :: 		PIE1=0x01; // habilita a interrupção pelo overflow do timer 1
	MOVLW      1
	MOVWF      PIE1+0
;frequencycounter.c,67 :: 		for (;;){
L_main3:
;frequencycounter.c,68 :: 		TMR1H=0;// inicializa o high byte do timer 1;
	CLRF       TMR1H+0
;frequencycounter.c,69 :: 		TMR1L=0;  // inicializa o low byte do timer 1;
	CLRF       TMR1L+0
;frequencycounter.c,70 :: 		cnt1=0;
	CLRF       _cnt1+0
	CLRF       _cnt1+1
;frequencycounter.c,71 :: 		cnt0=0;
	CLRF       _cnt0+0
	CLRF       _cnt0+1
;frequencycounter.c,72 :: 		TMR0=6; // inicializa o timer 0;
	MOVLW      6
	MOVWF      TMR0+0
;frequencycounter.c,73 :: 		T1CON.TMR1ON=1; // liga a contagem do timer 1
	BSF        T1CON+0, 0
;frequencycounter.c,74 :: 		while(cnt0<624); // segura até dar 1s 624 pois foi calibrado por
L_main6:
	MOVLW      2
	SUBWF      _cnt0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main11
	MOVLW      112
	SUBWF      _cnt0+0, 0
L__main11:
	BTFSC      STATUS+0, 0
	GOTO       L_main7
	GOTO       L_main6
L_main7:
;frequencycounter.c,75 :: 		T1CON.TMR1ON=0; // desliga a contagem do timer 1
	BCF        T1CON+0, 0
;frequencycounter.c,76 :: 		frequency=TMR1H;
	MOVF       TMR1H+0, 0
	MOVWF      _frequency+0
	CLRF       _frequency+1
	CLRF       _frequency+2
	CLRF       _frequency+3
;frequencycounter.c,77 :: 		frequency=frequency*256+TMR1L;
	MOVF       _frequency+2, 0
	MOVWF      R0+3
	MOVF       _frequency+1, 0
	MOVWF      R0+2
	MOVF       _frequency+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	MOVWF      R5+0
	CLRF       R5+1
	CLRF       R5+2
	CLRF       R5+3
	MOVF       R0+0, 0
	ADDWF      R5+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+1, 0
	ADDWF      R5+1, 1
	MOVF       R0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+2, 0
	ADDWF      R5+2, 1
	MOVF       R0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+3, 0
	ADDWF      R5+3, 1
	MOVF       R5+0, 0
	MOVWF      _frequency+0
	MOVF       R5+1, 0
	MOVWF      _frequency+1
	MOVF       R5+2, 0
	MOVWF      _frequency+2
	MOVF       R5+3, 0
	MOVWF      _frequency+3
;frequencycounter.c,78 :: 		frequency=65536*cnt1+frequency;
	MOVF       _cnt1+1, 0
	MOVWF      R0+3
	MOVF       _cnt1+0, 0
	MOVWF      R0+2
	CLRF       R0+0
	CLRF       R0+1
	MOVF       R5+0, 0
	ADDWF      R0+0, 1
	MOVF       R5+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R5+1, 0
	ADDWF      R0+1, 1
	MOVF       R5+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R5+2, 0
	ADDWF      R0+2, 1
	MOVF       R5+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R5+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _frequency+0
	MOVF       R0+1, 0
	MOVWF      _frequency+1
	MOVF       R0+2, 0
	MOVWF      _frequency+2
	MOVF       R0+3, 0
	MOVWF      _frequency+3
;frequencycounter.c,79 :: 		LongWordToStr(frequency,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_LongWordToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_LongWordToStr_input+1
	MOVF       R0+2, 0
	MOVWF      FARG_LongWordToStr_input+2
	MOVF       R0+3, 0
	MOVWF      FARG_LongWordToStr_input+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_LongWordToStr_output+0
	CALL       _LongWordToStr+0
;frequencycounter.c,80 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frequencycounter.c,81 :: 		Lcd_Out(1,1,"Frequency(Hz)"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_frequencycounter+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frequencycounter.c,82 :: 		point=ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;frequencycounter.c,83 :: 		Lcd_Out(2,1,point);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frequencycounter.c,85 :: 		}
	GOTO       L_main3
;frequencycounter.c,86 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
