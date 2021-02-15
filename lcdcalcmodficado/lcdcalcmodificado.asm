
_main:

;lcdcalcmodificado.c,33 :: 		void main() {
;lcdcalcmodificado.c,34 :: 		unsigned char keytab[]={0,1,2,3,0,4,5,6,0,7,8,9,0,'*',0,'#'};
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
;lcdcalcmodificado.c,38 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;lcdcalcmodificado.c,40 :: 		Keypad_Init();
	CALL       _Keypad_Init+0
;lcdcalcmodificado.c,42 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;lcdcalcmodificado.c,43 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalcmodificado.c,44 :: 		Lcd_Out(1,1,"CALCULATOR"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_lcdcalcmodificado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalcmodificado.c,45 :: 		Delay_ms(1000);
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
;lcdcalcmodificado.c,46 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalcmodificado.c,49 :: 		for (;;){
L_main1:
;lcdcalcmodificado.c,50 :: 		No1=No2=Ans=0;
	CLRF       main_Ans_L0+0
	CLRF       main_Ans_L0+1
	CLRF       main_Ans_L0+2
	CLRF       main_Ans_L0+3
	CLRF       main_No2_L0+0
	CLRF       main_No2_L0+1
	CLRF       main_No2_L0+2
	CLRF       main_No2_L0+3
	CLRF       main_No1_L0+0
	CLRF       main_No1_L0+1
	CLRF       main_No1_L0+2
	CLRF       main_No1_L0+3
;lcdcalcmodificado.c,51 :: 		Lcd_Out(1,1,"No1:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_lcdcalcmodificado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalcmodificado.c,52 :: 		while(1){
L_main4:
;lcdcalcmodificado.c,53 :: 		do
L_main6:
;lcdcalcmodificado.c,54 :: 		key = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;lcdcalcmodificado.c,55 :: 		while(!key);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main6
;lcdcalcmodificado.c,56 :: 		key=keytab[key];
	MOVF       main_key_L0+0, 0
	ADDLW      main_keytab_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_key_L0+0
;lcdcalcmodificado.c,57 :: 		if (key=='#') break;
	MOVF       R1+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main9
	GOTO       L_main5
L_main9:
;lcdcalcmodificado.c,58 :: 		if (key!='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main10
;lcdcalcmodificado.c,59 :: 		Lcd_Chr_Cp(key+'0');
	MOVLW      48
	ADDWF      main_key_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcdcalcmodificado.c,60 :: 		No1=10*No1+key;
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      130
	MOVWF      R0+3
	MOVF       main_No1_L0+0, 0
	MOVWF      R4+0
	MOVF       main_No1_L0+1, 0
	MOVWF      R4+1
	MOVF       main_No1_L0+2, 0
	MOVWF      R4+2
	MOVF       main_No1_L0+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVF       main_key_L0+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_No1_L0+0
	MOVF       R0+1, 0
	MOVWF      main_No1_L0+1
	MOVF       R0+2, 0
	MOVWF      main_No1_L0+2
	MOVF       R0+3, 0
	MOVWF      main_No1_L0+3
;lcdcalcmodificado.c,61 :: 		}
L_main10:
;lcdcalcmodificado.c,62 :: 		}
	GOTO       L_main4
L_main5:
;lcdcalcmodificado.c,64 :: 		Lcd_Out(2,1,"No2:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_lcdcalcmodificado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalcmodificado.c,65 :: 		while(1){
L_main11:
;lcdcalcmodificado.c,66 :: 		do
L_main13:
;lcdcalcmodificado.c,67 :: 		key = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;lcdcalcmodificado.c,68 :: 		while(!key);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
;lcdcalcmodificado.c,69 :: 		key=keytab[key];
	MOVF       main_key_L0+0, 0
	ADDLW      main_keytab_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_key_L0+0
;lcdcalcmodificado.c,70 :: 		if (key=='#') break;
	MOVF       R1+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	GOTO       L_main12
L_main16:
;lcdcalcmodificado.c,71 :: 		if (key!='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main17
;lcdcalcmodificado.c,72 :: 		Lcd_Chr_Cp(key+'0');
	MOVLW      48
	ADDWF      main_key_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcdcalcmodificado.c,73 :: 		No2=10*No2+key;
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      130
	MOVWF      R0+3
	MOVF       main_No2_L0+0, 0
	MOVWF      R4+0
	MOVF       main_No2_L0+1, 0
	MOVWF      R4+1
	MOVF       main_No2_L0+2, 0
	MOVWF      R4+2
	MOVF       main_No2_L0+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVF       main_key_L0+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_No2_L0+0
	MOVF       R0+1, 0
	MOVWF      main_No2_L0+1
	MOVF       R0+2, 0
	MOVWF      main_No2_L0+2
	MOVF       R0+3, 0
	MOVWF      main_No2_L0+3
;lcdcalcmodificado.c,74 :: 		}
L_main17:
;lcdcalcmodificado.c,75 :: 		}
	GOTO       L_main11
L_main12:
;lcdcalcmodificado.c,77 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalcmodificado.c,78 :: 		Op='*';
	MOVLW      42
	MOVWF      main_Op_L0+0
;lcdcalcmodificado.c,79 :: 		Lcd_Out(1,1,"Op:*");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_lcdcalcmodificado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalcmodificado.c,80 :: 		while(1){
L_main18:
;lcdcalcmodificado.c,81 :: 		do
L_main20:
;lcdcalcmodificado.c,82 :: 		key = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;lcdcalcmodificado.c,83 :: 		while(!key);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main20
;lcdcalcmodificado.c,84 :: 		key=keytab[key];
	MOVF       main_key_L0+0, 0
	ADDLW      main_keytab_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_key_L0+0
;lcdcalcmodificado.c,85 :: 		if (key=='#') break;
	MOVF       R1+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	GOTO       L_main19
L_main23:
;lcdcalcmodificado.c,86 :: 		if (key=='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main24
;lcdcalcmodificado.c,87 :: 		if(Op=='*') Op='/';
	MOVF       main_Op_L0+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	MOVLW      47
	MOVWF      main_Op_L0+0
	GOTO       L_main26
L_main25:
;lcdcalcmodificado.c,88 :: 		else if(Op=='/') Op='+';
	MOVF       main_Op_L0+0, 0
	XORLW      47
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVLW      43
	MOVWF      main_Op_L0+0
	GOTO       L_main28
L_main27:
;lcdcalcmodificado.c,89 :: 		else if(Op=='+') Op='-';
	MOVF       main_Op_L0+0, 0
	XORLW      43
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	MOVLW      45
	MOVWF      main_Op_L0+0
	GOTO       L_main30
L_main29:
;lcdcalcmodificado.c,90 :: 		else if(Op=='-') Op='*';
	MOVF       main_Op_L0+0, 0
	XORLW      45
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	MOVLW      42
	MOVWF      main_Op_L0+0
L_main31:
L_main30:
L_main28:
L_main26:
;lcdcalcmodificado.c,91 :: 		}
L_main24:
;lcdcalcmodificado.c,92 :: 		Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);
	MOVLW      16
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalcmodificado.c,93 :: 		Lcd_Chr_Cp(Op);
	MOVF       main_Op_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcdcalcmodificado.c,94 :: 		}
	GOTO       L_main18
L_main19:
;lcdcalcmodificado.c,95 :: 		switch(Op){
	GOTO       L_main32
;lcdcalcmodificado.c,96 :: 		case '*':
L_main34:
;lcdcalcmodificado.c,97 :: 		Ans=No1*No2;
	MOVF       main_No1_L0+0, 0
	MOVWF      R0+0
	MOVF       main_No1_L0+1, 0
	MOVWF      R0+1
	MOVF       main_No1_L0+2, 0
	MOVWF      R0+2
	MOVF       main_No1_L0+3, 0
	MOVWF      R0+3
	MOVF       main_No2_L0+0, 0
	MOVWF      R4+0
	MOVF       main_No2_L0+1, 0
	MOVWF      R4+1
	MOVF       main_No2_L0+2, 0
	MOVWF      R4+2
	MOVF       main_No2_L0+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Ans_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Ans_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Ans_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Ans_L0+3
;lcdcalcmodificado.c,98 :: 		break;
	GOTO       L_main33
;lcdcalcmodificado.c,100 :: 		case '/':
L_main35:
;lcdcalcmodificado.c,101 :: 		Ans=No1/No2;
	MOVF       main_No2_L0+0, 0
	MOVWF      R4+0
	MOVF       main_No2_L0+1, 0
	MOVWF      R4+1
	MOVF       main_No2_L0+2, 0
	MOVWF      R4+2
	MOVF       main_No2_L0+3, 0
	MOVWF      R4+3
	MOVF       main_No1_L0+0, 0
	MOVWF      R0+0
	MOVF       main_No1_L0+1, 0
	MOVWF      R0+1
	MOVF       main_No1_L0+2, 0
	MOVWF      R0+2
	MOVF       main_No1_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Ans_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Ans_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Ans_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Ans_L0+3
;lcdcalcmodificado.c,102 :: 		break;
	GOTO       L_main33
;lcdcalcmodificado.c,104 :: 		case '+':
L_main36:
;lcdcalcmodificado.c,105 :: 		Ans=No1+No2;
	MOVF       main_No1_L0+0, 0
	MOVWF      R0+0
	MOVF       main_No1_L0+1, 0
	MOVWF      R0+1
	MOVF       main_No1_L0+2, 0
	MOVWF      R0+2
	MOVF       main_No1_L0+3, 0
	MOVWF      R0+3
	MOVF       main_No2_L0+0, 0
	MOVWF      R4+0
	MOVF       main_No2_L0+1, 0
	MOVWF      R4+1
	MOVF       main_No2_L0+2, 0
	MOVWF      R4+2
	MOVF       main_No2_L0+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Ans_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Ans_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Ans_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Ans_L0+3
;lcdcalcmodificado.c,106 :: 		break;
	GOTO       L_main33
;lcdcalcmodificado.c,108 :: 		case '-':
L_main37:
;lcdcalcmodificado.c,109 :: 		Ans=No1-No2;
	MOVF       main_No2_L0+0, 0
	MOVWF      R4+0
	MOVF       main_No2_L0+1, 0
	MOVWF      R4+1
	MOVF       main_No2_L0+2, 0
	MOVWF      R4+2
	MOVF       main_No2_L0+3, 0
	MOVWF      R4+3
	MOVF       main_No1_L0+0, 0
	MOVWF      R0+0
	MOVF       main_No1_L0+1, 0
	MOVWF      R0+1
	MOVF       main_No1_L0+2, 0
	MOVWF      R0+2
	MOVF       main_No1_L0+3, 0
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Ans_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Ans_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Ans_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Ans_L0+3
;lcdcalcmodificado.c,110 :: 		break;
	GOTO       L_main33
;lcdcalcmodificado.c,111 :: 		}
L_main32:
	MOVF       main_Op_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main34
	MOVF       main_Op_L0+0, 0
	XORLW      47
	BTFSC      STATUS+0, 2
	GOTO       L_main35
	MOVF       main_Op_L0+0, 0
	XORLW      43
	BTFSC      STATUS+0, 2
	GOTO       L_main36
	MOVF       main_Op_L0+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L_main37
L_main33:
;lcdcalcmodificado.c,112 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalcmodificado.c,113 :: 		FloatToStr(Ans,disp);
	MOVF       main_Ans_L0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       main_Ans_L0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       main_Ans_L0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       main_Ans_L0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_disp_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;lcdcalcmodificado.c,114 :: 		lcd=Ltrim(disp);
	MOVLW      main_disp_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      main_lcd_L0+0
;lcdcalcmodificado.c,115 :: 		Lcd_Out(1,1,"Ans=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_lcdcalcmodificado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalcmodificado.c,116 :: 		Lcd_Out_Cp(lcd);
	MOVF       main_lcd_L0+0, 0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;lcdcalcmodificado.c,117 :: 		Delay_ms(5000);
	MOVLW      127
	MOVWF      R11+0
	MOVLW      212
	MOVWF      R12+0
	MOVLW      49
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
	NOP
;lcdcalcmodificado.c,118 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalcmodificado.c,120 :: 		}
	GOTO       L_main1
;lcdcalcmodificado.c,121 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
