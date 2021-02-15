
_main:

;LCDthermometer.c,21 :: 		void main() {
;LCDthermometer.c,24 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;LCDthermometer.c,25 :: 		TRISA.RB0=1;
	BSF        TRISA+0, 0
;LCDthermometer.c,26 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;LCDthermometer.c,27 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCDthermometer.c,28 :: 		Lcd_cmd(_LCD_CURSOR_OFF); // Esconde o cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCDthermometer.c,29 :: 		Lcd_Out(1,1,"Temperature"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_LCDthermometer+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCDthermometer.c,32 :: 		for (;;){
L_main0:
;LCDthermometer.c,33 :: 		temp=ADc_Read(0); //leitura analógica em escala de 0 a 1023
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
;LCDthermometer.c,34 :: 		temp=temp*5000.0/1024.0; // valor em mV
	MOVLW      0
	MOVWF      R4+0
	MOVLW      64
	MOVWF      R4+1
	MOVLW      28
	MOVWF      R4+2
	MOVLW      139
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      137
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
;LCDthermometer.c,35 :: 		temp=temp/10.0; // Valor em C
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
;LCDthermometer.c,36 :: 		floatToStr(temp,txt);
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
;LCDthermometer.c,37 :: 		Lcd_Out(2,1,txt); // Escreve na posição 2,1
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCDthermometer.c,38 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
;LCDthermometer.c,39 :: 		}
	GOTO       L_main0
;LCDthermometer.c,40 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
