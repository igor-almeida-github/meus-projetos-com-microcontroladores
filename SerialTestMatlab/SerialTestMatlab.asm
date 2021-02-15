
_main:

;SerialTestMatlab.c,22 :: 		void main() {
;SerialTestMatlab.c,26 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;SerialTestMatlab.c,29 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;SerialTestMatlab.c,30 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SerialTestMatlab.c,31 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SerialTestMatlab.c,32 :: 		Lcd_Out(1,1,"Matlab serial"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_SerialTestMatlab+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SerialTestMatlab.c,33 :: 		Delay_ms(2000);
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
	NOP
;SerialTestMatlab.c,34 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SerialTestMatlab.c,37 :: 		TRISC.RC7=1; // REMOVER_*****************************
	BSF        TRISC+0, 7
;SerialTestMatlab.c,38 :: 		TRISC.RC6=1; // REMOVER_*****************************
	BSF        TRISC+0, 6
;SerialTestMatlab.c,39 :: 		UART1_Init(9600);// REMOVER_*****************************
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;SerialTestMatlab.c,40 :: 		Delay_ms(100); // REMOVER_*****************************
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main1:
	DECFSZ     R13+0, 1
	GOTO       L_main1
	DECFSZ     R12+0, 1
	GOTO       L_main1
	DECFSZ     R11+0, 1
	GOTO       L_main1
	NOP
	NOP
;SerialTestMatlab.c,42 :: 		for (;;){
L_main2:
;SerialTestMatlab.c,44 :: 		if (UART1_Data_Ready()) {     // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
;SerialTestMatlab.c,45 :: 		uart_rd = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;SerialTestMatlab.c,46 :: 		}
L_main5:
;SerialTestMatlab.c,48 :: 		if (uart_rd=='1'){
	MOVF       _uart_rd+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;SerialTestMatlab.c,49 :: 		Lcd_Out(1,1,"Number 1");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_SerialTestMatlab+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SerialTestMatlab.c,50 :: 		Delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;SerialTestMatlab.c,51 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SerialTestMatlab.c,52 :: 		}
L_main6:
;SerialTestMatlab.c,54 :: 		if (uart_rd=='2'){
	MOVF       _uart_rd+0, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;SerialTestMatlab.c,55 :: 		Lcd_Out(1,1,"Number 2");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_SerialTestMatlab+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SerialTestMatlab.c,56 :: 		Delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;SerialTestMatlab.c,57 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SerialTestMatlab.c,58 :: 		}
L_main8:
;SerialTestMatlab.c,60 :: 		if (uart_rd=='3'){
	MOVF       _uart_rd+0, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;SerialTestMatlab.c,61 :: 		Lcd_Out(1,1,"Number 3");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_SerialTestMatlab+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SerialTestMatlab.c,62 :: 		Delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
	NOP
;SerialTestMatlab.c,63 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SerialTestMatlab.c,64 :: 		}
L_main10:
;SerialTestMatlab.c,66 :: 		uart_rd=0;
	CLRF       _uart_rd+0
;SerialTestMatlab.c,67 :: 		}
	GOTO       L_main2
;SerialTestMatlab.c,68 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
