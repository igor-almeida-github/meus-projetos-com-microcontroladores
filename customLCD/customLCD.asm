
_CustomChar:

;customLCD.c,21 :: 		void CustomChar(char pos_row, char pos_char) {
;customLCD.c,23 :: 		Lcd_Cmd(64);
	MOVLW      64
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;customLCD.c,24 :: 		for (i = 0; i<=7; i++) Lcd_Chr_CP(character[i]);
	CLRF       CustomChar_i_L0+0
L_CustomChar0:
	MOVF       CustomChar_i_L0+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_CustomChar1
	MOVF       CustomChar_i_L0+0, 0
	ADDLW      _character+0
	MOVWF      R0+0
	MOVLW      hi_addr(_character+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
	INCF       CustomChar_i_L0+0, 1
	GOTO       L_CustomChar0
L_CustomChar1:
;customLCD.c,25 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW      2
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;customLCD.c,26 :: 		Lcd_Chr(pos_row, pos_char, 0);
	MOVF       FARG_CustomChar_pos_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_CustomChar_pos_char+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	CLRF       FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;customLCD.c,27 :: 		}
L_end_CustomChar:
	RETURN
; end of _CustomChar

_CustomChar1:

;customLCD.c,30 :: 		void CustomChar1(char pos_row, char pos_char) {
;customLCD.c,32 :: 		Lcd_Cmd(64);
	MOVLW      64
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;customLCD.c,33 :: 		for (i = 0; i<=7; i++) Lcd_Chr_CP(character1[i]);
	CLRF       CustomChar1_i_L0+0
L_CustomChar13:
	MOVF       CustomChar1_i_L0+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_CustomChar14
	MOVF       CustomChar1_i_L0+0, 0
	ADDLW      _character1+0
	MOVWF      R0+0
	MOVLW      hi_addr(_character1+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
	INCF       CustomChar1_i_L0+0, 1
	GOTO       L_CustomChar13
L_CustomChar14:
;customLCD.c,34 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW      2
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;customLCD.c,35 :: 		Lcd_Chr(pos_row, pos_char, 0);
	MOVF       FARG_CustomChar1_pos_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_CustomChar1_pos_char+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	CLRF       FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;customLCD.c,36 :: 		}
L_end_CustomChar1:
	RETURN
; end of _CustomChar1

_main:

;customLCD.c,37 :: 		void main() {
;customLCD.c,39 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;customLCD.c,40 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;customLCD.c,41 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;customLCD.c,42 :: 		Lcd_cmd(_LCD_CURSOR_OFF); // Esconde o cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;customLCD.c,44 :: 		Lcd_Out(1,1,"The man who "); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_customLCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;customLCD.c,45 :: 		Lcd_Out(2,1,"can't be moved "); // Escreve na posição 1,1
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_customLCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;customLCD.c,47 :: 		for (;;){
L_main6:
;customLCD.c,48 :: 		CustomChar(2,16);
	MOVLW      2
	MOVWF      FARG_CustomChar_pos_row+0
	MOVLW      16
	MOVWF      FARG_CustomChar_pos_char+0
	CALL       _CustomChar+0
;customLCD.c,49 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
;customLCD.c,50 :: 		CustomChar1(2,16);
	MOVLW      2
	MOVWF      FARG_CustomChar1_pos_row+0
	MOVLW      16
	MOVWF      FARG_CustomChar1_pos_char+0
	CALL       _CustomChar1+0
;customLCD.c,51 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
;customLCD.c,52 :: 		}
	GOTO       L_main6
;customLCD.c,53 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
