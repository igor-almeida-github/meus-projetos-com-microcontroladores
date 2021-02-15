
_main:

;highlowgame.c,31 :: 		void main() {
;highlowgame.c,32 :: 		unsigned char keytab[]={0,1,2,3,0,4,5,6,0,7,8,9,0,'*',0,'#'};
	CLRF       main_keytab_L0+0
	MOVLW      1
	MOVWF      main_keytab_L0+1
	MOVLW      2
	MOVWF      main_keytab_L0+2
	MOVLW      3
	MOVWF      main_keytab_L0+3
	CLRF       main_keytab_L0+4
	MOVLW      4
	MOVWF      main_keytab_L0+5
	MOVLW      5
	MOVWF      main_keytab_L0+6
	MOVLW      6
	MOVWF      main_keytab_L0+7
	CLRF       main_keytab_L0+8
	MOVLW      7
	MOVWF      main_keytab_L0+9
	MOVLW      8
	MOVWF      main_keytab_L0+10
	MOVLW      9
	MOVWF      main_keytab_L0+11
	CLRF       main_keytab_L0+12
	MOVLW      42
	MOVWF      main_keytab_L0+13
	CLRF       main_keytab_L0+14
	MOVLW      35
	MOVWF      main_keytab_L0+15
	CLRF       main_player_L0+0
	CLRF       main_player_L0+1
	CLRF       main_player_L0+2
	CLRF       main_player_L0+3
;highlowgame.c,37 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;highlowgame.c,38 :: 		Keypad_Init();    // inicializa o keypad
	CALL       _Keypad_Init+0
;highlowgame.c,40 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;highlowgame.c,41 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;highlowgame.c,42 :: 		Lcd_Out(1,1,"High/Low Game"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,43 :: 		Delay_ms(2000);
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
;highlowgame.c,44 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;highlowgame.c,46 :: 		srand(5);
	MOVLW      5
	MOVWF      FARG_srand_x+0
	MOVLW      0
	MOVWF      FARG_srand_x+1
	CALL       _srand+0
;highlowgame.c,47 :: 		Lcd_Out(1,1,"Guess Now..");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,48 :: 		Lcd_Out(2,1,"");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,49 :: 		aleatorio=rand();
	CALL       _rand+0
	MOVF       R0+0, 0
	MOVWF      main_aleatorio_L0+0
	MOVF       R0+1, 0
	MOVWF      main_aleatorio_L0+1
;highlowgame.c,51 :: 		for (;;){
L_main1:
;highlowgame.c,53 :: 		while(1){ // Recebe o numero do usuario e imprime na segunda linha do diplay lcd
L_main4:
;highlowgame.c,54 :: 		do
L_main6:
;highlowgame.c,55 :: 		key = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;highlowgame.c,56 :: 		while(!key);           // enquanto a tecla nao for pressionada
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main6
;highlowgame.c,57 :: 		key=keytab[key];
	MOVF       main_key_L0+0, 0
	ADDLW      main_keytab_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_key_L0+0
;highlowgame.c,58 :: 		if (key=='#') break;
	MOVF       R1+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main9
	GOTO       L_main5
L_main9:
;highlowgame.c,59 :: 		if (key!='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main10
;highlowgame.c,60 :: 		Lcd_Chr_Cp(key+'0');      // escreve na posição do cursor
	MOVLW      48
	ADDWF      main_key_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;highlowgame.c,61 :: 		player=10*player+key;
	MOVLW      10
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       main_player_L0+0, 0
	MOVWF      R4+0
	MOVF       main_player_L0+1, 0
	MOVWF      R4+1
	MOVF       main_player_L0+2, 0
	MOVWF      R4+2
	MOVF       main_player_L0+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_U+0
	MOVF       main_key_L0+0, 0
	MOVWF      main_player_L0+0
	CLRF       main_player_L0+1
	CLRF       main_player_L0+2
	CLRF       main_player_L0+3
	MOVF       R0+0, 0
	ADDWF      main_player_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+1, 0
	ADDWF      main_player_L0+1, 1
	MOVF       R0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+2, 0
	ADDWF      main_player_L0+2, 1
	MOVF       R0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+3, 0
	ADDWF      main_player_L0+3, 1
;highlowgame.c,62 :: 		}
L_main10:
;highlowgame.c,63 :: 		if (player>32767) break;
	MOVF       main_player_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVF       main_player_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVF       main_player_L0+1, 0
	SUBLW      127
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVF       main_player_L0+0, 0
	SUBLW      255
L__main21:
	BTFSC      STATUS+0, 0
	GOTO       L_main11
	GOTO       L_main5
L_main11:
;highlowgame.c,64 :: 		}
	GOTO       L_main4
L_main5:
;highlowgame.c,65 :: 		Lcd_out(2,1,"                "); // Limpa a segunda linha do display lcd
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,67 :: 		if (player==aleatorio){
	MOVLW      0
	MOVWF      R0+0
	XORWF      main_player_L0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main22
	MOVF       R0+0, 0
	XORWF      main_player_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main22
	MOVF       main_aleatorio_L0+1, 0
	XORWF      main_player_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main22
	MOVF       main_player_L0+0, 0
	XORWF      main_aleatorio_L0+0, 0
L__main22:
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;highlowgame.c,68 :: 		Lcd_out(2,1,"Well Done!!!");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,69 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
;highlowgame.c,70 :: 		aleatorio=rand();
	CALL       _rand+0
	MOVF       R0+0, 0
	MOVWF      main_aleatorio_L0+0
	MOVF       R0+1, 0
	MOVWF      main_aleatorio_L0+1
;highlowgame.c,71 :: 		}
	GOTO       L_main14
L_main12:
;highlowgame.c,72 :: 		else if (player>aleatorio){
	MOVF       main_player_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       main_player_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       main_player_L0+1, 0
	SUBWF      main_aleatorio_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       main_player_L0+0, 0
	SUBWF      main_aleatorio_L0+0, 0
L__main23:
	BTFSC      STATUS+0, 0
	GOTO       L_main15
;highlowgame.c,73 :: 		Lcd_out(2,1,"HIGH - Try Again");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,74 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	DECFSZ     R11+0, 1
	GOTO       L_main16
	NOP
;highlowgame.c,75 :: 		}
	GOTO       L_main17
L_main15:
;highlowgame.c,76 :: 		else if (player<aleatorio){
	MOVLW      0
	SUBWF      main_player_L0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVLW      0
	SUBWF      main_player_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVF       main_aleatorio_L0+1, 0
	SUBWF      main_player_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVF       main_aleatorio_L0+0, 0
	SUBWF      main_player_L0+0, 0
L__main24:
	BTFSC      STATUS+0, 0
	GOTO       L_main18
;highlowgame.c,77 :: 		Lcd_out(2,1,"LOW - Try Again!");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,78 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	DECFSZ     R11+0, 1
	GOTO       L_main19
	NOP
;highlowgame.c,79 :: 		}
L_main18:
L_main17:
L_main14:
;highlowgame.c,80 :: 		Lcd_out(2,1,"                ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,81 :: 		Lcd_out(2,1,"");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_highlowgame+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;highlowgame.c,82 :: 		player=0;
	CLRF       main_player_L0+0
	CLRF       main_player_L0+1
	CLRF       main_player_L0+2
	CLRF       main_player_L0+3
;highlowgame.c,83 :: 		}
	GOTO       L_main1
;highlowgame.c,84 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
