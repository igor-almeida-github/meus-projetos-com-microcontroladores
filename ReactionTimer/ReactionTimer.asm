
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ReactionTimer.c,26 :: 		void interrupt(void){
;ReactionTimer.c,27 :: 		overflow++;
	MOVF       _overflow+0, 0
	MOVWF      R0+0
	MOVF       _overflow+1, 0
	MOVWF      R0+1
	MOVF       _overflow+2, 0
	MOVWF      R0+2
	MOVF       _overflow+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _overflow+0
	MOVF       R0+1, 0
	MOVWF      _overflow+1
	MOVF       R0+2, 0
	MOVWF      _overflow+2
	MOVF       R0+3, 0
	MOVWF      _overflow+3
;ReactionTimer.c,28 :: 		PIR1.TMR1IF=0;                                                               // Limpa a flag de interrupção do timer 1
	BCF        PIR1+0, 0
;ReactionTimer.c,29 :: 		}
L_end_interrupt:
L__interrupt7:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;ReactionTimer.c,31 :: 		void main() {
;ReactionTimer.c,32 :: 		TRISD.RD1=0;                                                                 // Led é OUTPUT
	BCF        TRISD+0, 1
;ReactionTimer.c,33 :: 		TRISD.RD0=1;                                                                 // Switch é INPUT
	BSF        TRISD+0, 0
;ReactionTimer.c,34 :: 		ADCON1=0x06;                                                                 // Todas as portas são digitais
	MOVLW      6
	MOVWF      ADCON1+0
;ReactionTimer.c,35 :: 		T1CON=0x30;                                                                  // Configuração do timer 1, 16bits, prescale de 8, parado, 1.6 us por contagem
	MOVLW      48
	MOVWF      T1CON+0
;ReactionTimer.c,36 :: 		Lcd_Init();                                                                  // Inicializa o LCD conectado ao PORTB
	CALL       _Lcd_Init+0
;ReactionTimer.c,37 :: 		Lcd_Cmd(_LCD_CLEAR);                                                         // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ReactionTimer.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                                                    // Desativa o cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ReactionTimer.c,39 :: 		LED=0;                                                                       // LED desligado
	BCF        PORTD+0, 1
;ReactionTimer.c,40 :: 		srand(10);                                                                   // Inicializa a semente de números aleatórios
	MOVLW      10
	MOVWF      FARG_srand_x+0
	MOVLW      0
	MOVWF      FARG_srand_x+1
	CALL       _srand+0
;ReactionTimer.c,41 :: 		INTCON=0xC0;                                                                 // Habilita as interrupções dos periféricos e globais
	MOVLW      192
	MOVWF      INTCON+0
;ReactionTimer.c,42 :: 		PIE1=1;                                                                      // Habilita a interrupção do timer 1
	MOVLW      1
	MOVWF      PIE1+0
;ReactionTimer.c,45 :: 		for(;;){                                                                     // Loop Infinito
L_main0:
;ReactionTimer.c,46 :: 		no=rand()%10+1;                                                           // Número aleatório entre 1 e 10
	CALL       _rand+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	INCF       R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _no+0
;ReactionTimer.c,47 :: 		Vdelay_ms(no*1000);                                                       // Delay aleatório entre 1 e 10s, Vdelay é para variavel
	MOVLW      0
	MOVWF      R0+1
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       R0+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;ReactionTimer.c,48 :: 		overflow=0;
	CLRF       _overflow+0
	CLRF       _overflow+1
	CLRF       _overflow+2
	CLRF       _overflow+3
;ReactionTimer.c,49 :: 		TMR1H=0;
	CLRF       TMR1H+0
;ReactionTimer.c,50 :: 		TMR1L=0;
	CLRF       TMR1L+0
;ReactionTimer.c,51 :: 		LED=1;                                                                    // Acende o led
	BSF        PORTD+0, 1
;ReactionTimer.c,52 :: 		T1CON.TMR1ON=1;                                                           // Dispara o timer 1
	BSF        T1CON+0, 0
;ReactionTimer.c,53 :: 		while (Switch);                                                           // Espera até que o botão seja pressionado
L_main3:
	BTFSS      PORTD+0, 2
	GOTO       L_main4
	GOTO       L_main3
L_main4:
;ReactionTimer.c,54 :: 		T1CON.TMR1ON=0;                                                           // para o timer 1
	BCF        T1CON+0, 0
;ReactionTimer.c,55 :: 		LED=0;                                                                    // Apaga o led
	BCF        PORTD+0, 1
;ReactionTimer.c,56 :: 		ElapsedTime=TMR1L;                                                        // LOW byte do timer 1
	MOVF       TMR1L+0, 0
	MOVWF      _ElapsedTime+0
	CLRF       _ElapsedTime+1
	CLRF       _ElapsedTime+2
	CLRF       _ElapsedTime+3
;ReactionTimer.c,57 :: 		ElapsedTime+=(TMR1H<<8);                                                  // HIGH byte do timer 1
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVF       _ElapsedTime+0, 0
	ADDWF      R0+0, 1
	MOVF       _ElapsedTime+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _ElapsedTime+1, 0
	ADDWF      R0+1, 1
	MOVF       _ElapsedTime+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _ElapsedTime+2, 0
	ADDWF      R0+2, 1
	MOVF       _ElapsedTime+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _ElapsedTime+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _ElapsedTime+0
	MOVF       R0+1, 0
	MOVWF      _ElapsedTime+1
	MOVF       R0+2, 0
	MOVWF      _ElapsedTime+2
	MOVF       R0+3, 0
	MOVWF      _ElapsedTime+3
;ReactionTimer.c,58 :: 		ElapsedTime=(ElapsedTime/10)*16+104857*overflow;                          // Tempo em us
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVLW      4
	MOVWF      R4+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVF       R4+0, 0
L__main9:
	BTFSC      STATUS+0, 2
	GOTO       L__main10
	RLF        FLOC__main+0, 1
	RLF        FLOC__main+1, 1
	RLF        FLOC__main+2, 1
	RLF        FLOC__main+3, 1
	BCF        FLOC__main+0, 0
	ADDLW      255
	GOTO       L__main9
L__main10:
	MOVLW      153
	MOVWF      R0+0
	MOVLW      153
	MOVWF      R0+1
	MOVLW      1
	MOVWF      R0+2
	MOVLW      0
	MOVWF      R0+3
	MOVF       _overflow+0, 0
	MOVWF      R4+0
	MOVF       _overflow+1, 0
	MOVWF      R4+1
	MOVF       _overflow+2, 0
	MOVWF      R4+2
	MOVF       _overflow+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_U+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     FLOC__main+1, 0
	ADDWF      R0+1, 1
	MOVF       FLOC__main+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     FLOC__main+2, 0
	ADDWF      R0+2, 1
	MOVF       FLOC__main+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     FLOC__main+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _ElapsedTime+0
	MOVF       R0+1, 0
	MOVWF      _ElapsedTime+1
	MOVF       R0+2, 0
	MOVWF      _ElapsedTime+2
	MOVF       R0+3, 0
	MOVWF      _ElapsedTime+3
;ReactionTimer.c,59 :: 		ElapsedTime=ElapsedTime/1000;                                             // Tempo em ms
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _ElapsedTime+0
	MOVF       R0+1, 0
	MOVWF      _ElapsedTime+1
	MOVF       R0+2, 0
	MOVWF      _ElapsedTime+2
	MOVF       R0+3, 0
	MOVWF      _ElapsedTime+3
;ReactionTimer.c,60 :: 		LongWordToStr(ElapsedTime,Txt);                                           // Converte o tempo para string
	MOVF       R0+0, 0
	MOVWF      FARG_LongWordToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_LongWordToStr_input+1
	MOVF       R0+2, 0
	MOVWF      FARG_LongWordToStr_input+2
	MOVF       R0+3, 0
	MOVWF      FARG_LongWordToStr_input+3
	MOVLW      _Txt+0
	MOVWF      FARG_LongWordToStr_output+0
	CALL       _LongWordToStr+0
;ReactionTimer.c,61 :: 		Lcd_out(1,1,"Reaction(ms):");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_ReactionTimer+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ReactionTimer.c,62 :: 		Lcd_out(2,1,Txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ReactionTimer.c,63 :: 		Delay_ms(2000);
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
	NOP
;ReactionTimer.c,64 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ReactionTimer.c,65 :: 		}
	GOTO       L_main0
;ReactionTimer.c,67 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
