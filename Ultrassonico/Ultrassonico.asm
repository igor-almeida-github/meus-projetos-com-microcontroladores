
_main:

;Ultrassonico.c,23 :: 		void main() {
;Ultrassonico.c,26 :: 		float Test_distanceCm=0;
;Ultrassonico.c,28 :: 		TRISC.RC0=0;   // TRIG é output
	BCF        TRISC+0, 0
;Ultrassonico.c,29 :: 		TRISC.RC1=1;   // ECHO é input
	BSF        TRISC+0, 1
;Ultrassonico.c,31 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;Ultrassonico.c,34 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;Ultrassonico.c,35 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Ultrassonico.c,36 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Ultrassonico.c,37 :: 		Lcd_Out(1,1,"Ultrassonic"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Ultrassonico+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Ultrassonico.c,38 :: 		Lcd_Out(2,1,"Measument"); // Escreve na posição 1,1
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Ultrassonico+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Ultrassonico.c,39 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;Ultrassonico.c,40 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Ultrassonico.c,41 :: 		TRIG=0;
	BCF        PORTC+0, 0
;Ultrassonico.c,43 :: 		T1CON=0x30; // timer 1 prescale 8,clock interno, timer parado
	MOVLW      48
	MOVWF      T1CON+0
;Ultrassonico.c,44 :: 		INTCON=0x60; // interrupção dos perifericos habilitada
	MOVLW      96
	MOVWF      INTCON+0
;Ultrassonico.c,45 :: 		PIE1=0x01; // interrupção do timer 1 habilitada
	MOVLW      1
	MOVWF      PIE1+0
;Ultrassonico.c,46 :: 		Lcd_Out(1,1,"Distancia(Cm):"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Ultrassonico+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Ultrassonico.c,47 :: 		for (;;){
L_main1:
;Ultrassonico.c,48 :: 		TRIG=1;
	BSF        PORTC+0, 0
;Ultrassonico.c,49 :: 		Delay_us(10);
	MOVLW      16
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	NOP
;Ultrassonico.c,50 :: 		TRIG=0;
	BCF        PORTC+0, 0
;Ultrassonico.c,51 :: 		while(!ECHO);   // espera a borda de subida no pino de echo
L_main5:
	BTFSC      PORTC+0, 1
	GOTO       L_main6
	GOTO       L_main5
L_main6:
;Ultrassonico.c,52 :: 		T1CON.TMR1ON=1; // inicia o timer
	BSF        T1CON+0, 0
;Ultrassonico.c,53 :: 		while(ECHO);    // espera a borda de decida no pino echo
L_main7:
	BTFSS      PORTC+0, 1
	GOTO       L_main8
	GOTO       L_main7
L_main8:
;Ultrassonico.c,54 :: 		T1CON.TMR1ON=0; // interrompe a contagem do tempo
	BCF        T1CON+0, 0
;Ultrassonico.c,55 :: 		high_level_time=TMR1L+(TMR1H<<8);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;Ultrassonico.c,56 :: 		Test_distanceCm = (high_level_time*0.0272);
	CALL       _word2double+0
	MOVLW      137
	MOVWF      R4+0
	MOVLW      210
	MOVWF      R4+1
	MOVLW      94
	MOVWF      R4+2
	MOVLW      121
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
;Ultrassonico.c,57 :: 		TMR1H=0;
	CLRF       TMR1H+0
;Ultrassonico.c,58 :: 		TMR1L=0;
	CLRF       TMR1L+0
;Ultrassonico.c,59 :: 		floatToStr(Test_distanceCm,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Ultrassonico.c,60 :: 		point=ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      main_point_L0+0
;Ultrassonico.c,61 :: 		Lcd_Out(2,1,"                ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Ultrassonico+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Ultrassonico.c,62 :: 		Lcd_Out(2,1,point);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       main_point_L0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Ultrassonico.c,63 :: 		Delay_ms(40);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
;Ultrassonico.c,67 :: 		}
	GOTO       L_main1
;Ultrassonico.c,68 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
