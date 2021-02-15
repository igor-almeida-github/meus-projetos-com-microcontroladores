
_main:

;LEDvoltLCD.c,20 :: 		void main() {
;LEDvoltLCD.c,25 :: 		TRISB=0xC0;        // Os 6 primeiros bits do PORTB são OUTPUT, os demais são input
	MOVLW       192
	MOVWF       TRISB+0 
;LEDvoltLCD.c,26 :: 		ADCON1=0x0E;       // Todas as portas são dgitais exceto AN0(RA0)
	MOVLW       14
	MOVWF       ADCON1+0 
;LEDvoltLCD.c,27 :: 		TRISA.RA0=1;       // A porta do AN0 é input
	BSF         TRISA+0, 0 
;LEDvoltLCD.c,28 :: 		ADCON2=0x80;     // Resultado justificado a direita
	MOVLW       128
	MOVWF       ADCON2+0 
;LEDvoltLCD.c,29 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL        _Lcd_Init+0, 0
;LEDvoltLCD.c,30 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LEDvoltLCD.c,31 :: 		Lcd_cmd(_LCD_CURSOR_OFF); // Esconde o cursor
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LEDvoltLCD.c,32 :: 		Lcd_Out(1,1,"VOLTMETER"); // Escreve na posição 1,1
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_LEDvoltLCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_LEDvoltLCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LEDvoltLCD.c,33 :: 		Delay_ms(2000);
	MOVLW       41
	MOVWF       R11, 0
	MOVLW       150
	MOVWF       R12, 0
	MOVLW       127
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
;LEDvoltLCD.c,35 :: 		for (;;){
L_main1:
;LEDvoltLCD.c,36 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LEDvoltLCD.c,39 :: 		mV= Adc_Read(0); // multiplicado por 5000mv e dividido por 1024: deslocado 10 bits para a direita, o que é o mesmo que dividir por 1024
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_mV_L0+0 
	MOVF        R1, 0 
	MOVWF       main_mV_L0+1 
	MOVLW       0
	MOVWF       main_mV_L0+2 
	MOVWF       main_mV_L0+3 
;LEDvoltLCD.c,40 :: 		mV=(mV*4740)>>10; // CUIDADO, SE MULTIPLICAR DUAS VARIAVEIS INTEIRAS O RESULTADO É SEMPRE UM INTEIRO DE 16 BITS, PORTANTO DEPENDENDO DO VALOR PODE DAR OVERFLOW
	MOVF        main_mV_L0+0, 0 
	MOVWF       R0 
	MOVF        main_mV_L0+1, 0 
	MOVWF       R1 
	MOVF        main_mV_L0+2, 0 
	MOVWF       R2 
	MOVF        main_mV_L0+3, 0 
	MOVWF       R3 
	MOVLW       132
	MOVWF       R4 
	MOVLW       18
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       main_mV_L0+0 
	MOVF        R1, 0 
	MOVWF       main_mV_L0+1 
	MOVF        R2, 0 
	MOVWF       main_mV_L0+2 
	MOVF        R3, 0 
	MOVWF       main_mV_L0+3 
	MOVF        R4, 0 
L__main6:
	BZ          L__main7
	RRCF        main_mV_L0+3, 1 
	RRCF        main_mV_L0+2, 1 
	RRCF        main_mV_L0+1, 1 
	RRCF        main_mV_L0+0, 1 
	BCF         main_mV_L0+3, 7 
	ADDLW       255
	GOTO        L__main6
L__main7:
;LEDvoltLCD.c,41 :: 		Lcd_Out(1,1,"mV = ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_LEDvoltLCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_LEDvoltLCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LEDvoltLCD.c,42 :: 		LongToStr(mV,op); // Converte para string na variavel op
	MOVF        main_mV_L0+0, 0 
	MOVWF       FARG_LongToStr_input+0 
	MOVF        main_mV_L0+1, 0 
	MOVWF       FARG_LongToStr_input+1 
	MOVF        main_mV_L0+2, 0 
	MOVWF       FARG_LongToStr_input+2 
	MOVF        main_mV_L0+3, 0 
	MOVWF       FARG_LongToStr_input+3 
	MOVLW       main_op_L0+0
	MOVWF       FARG_LongToStr_output+0 
	MOVLW       hi_addr(main_op_L0+0)
	MOVWF       FARG_LongToStr_output+1 
	CALL        _LongToStr+0, 0
;LEDvoltLCD.c,43 :: 		str=Ltrim(op);     // Remove espaços a frente
	MOVLW       main_op_L0+0
	MOVWF       FARG_Ltrim_string+0 
	MOVLW       hi_addr(main_op_L0+0)
	MOVWF       FARG_Ltrim_string+1 
	CALL        _Ltrim+0, 0
;LEDvoltLCD.c,44 :: 		Lcd_Out(1,6,str);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LEDvoltLCD.c,45 :: 		Delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
	NOP
	NOP
;LEDvoltLCD.c,47 :: 		}
	GOTO        L_main1
;LEDvoltLCD.c,48 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
