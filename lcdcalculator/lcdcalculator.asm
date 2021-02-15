
_KeypadTable:

;lcdcalculator.c,29 :: 		unsigned char KeypadTable(unsigned char port_d){ // procura nas tabelas a tecla pressionada de acordo com o PORTD
;lcdcalculator.c,30 :: 		int i=0;
	CLRF       KeypadTable_i_L0+0
	CLRF       KeypadTable_i_L0+1
	MOVLW      17
	MOVWF      KeypadTable_Table1_L0+0
	MOVLW      33
	MOVWF      KeypadTable_Table1_L0+1
	MOVLW      65
	MOVWF      KeypadTable_Table1_L0+2
	MOVLW      18
	MOVWF      KeypadTable_Table1_L0+3
	MOVLW      34
	MOVWF      KeypadTable_Table1_L0+4
	MOVLW      66
	MOVWF      KeypadTable_Table1_L0+5
	MOVLW      20
	MOVWF      KeypadTable_Table1_L0+6
	MOVLW      36
	MOVWF      KeypadTable_Table1_L0+7
	MOVLW      68
	MOVWF      KeypadTable_Table1_L0+8
	MOVLW      24
	MOVWF      KeypadTable_Table1_L0+9
	MOVLW      40
	MOVWF      KeypadTable_Table1_L0+10
	MOVLW      72
	MOVWF      KeypadTable_Table1_L0+11
	MOVLW      1
	MOVWF      KeypadTable_Table2_L0+0
	MOVLW      2
	MOVWF      KeypadTable_Table2_L0+1
	MOVLW      3
	MOVWF      KeypadTable_Table2_L0+2
	MOVLW      4
	MOVWF      KeypadTable_Table2_L0+3
	MOVLW      5
	MOVWF      KeypadTable_Table2_L0+4
	MOVLW      6
	MOVWF      KeypadTable_Table2_L0+5
	MOVLW      7
	MOVWF      KeypadTable_Table2_L0+6
	MOVLW      8
	MOVWF      KeypadTable_Table2_L0+7
	MOVLW      9
	MOVWF      KeypadTable_Table2_L0+8
	MOVLW      42
	MOVWF      KeypadTable_Table2_L0+9
	CLRF       KeypadTable_Table2_L0+10
	MOVLW      35
	MOVWF      KeypadTable_Table2_L0+11
;lcdcalculator.c,34 :: 		while(Table1[i]!= port_d){
L_KeypadTable0:
	MOVF       KeypadTable_i_L0+0, 0
	ADDLW      KeypadTable_Table1_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      FARG_KeypadTable_port_d+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_KeypadTable1
;lcdcalculator.c,35 :: 		i=i+1;
	INCF       KeypadTable_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       KeypadTable_i_L0+1, 1
;lcdcalculator.c,36 :: 		if (i==12) break;                                                       // Tecla não encontrada, condição inesperada.
	MOVLW      0
	XORWF      KeypadTable_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__KeypadTable42
	MOVLW      12
	XORWF      KeypadTable_i_L0+0, 0
L__KeypadTable42:
	BTFSS      STATUS+0, 2
	GOTO       L_KeypadTable2
	GOTO       L_KeypadTable1
L_KeypadTable2:
;lcdcalculator.c,37 :: 		}
	GOTO       L_KeypadTable0
L_KeypadTable1:
;lcdcalculator.c,38 :: 		Key= Table2[i];
	MOVF       KeypadTable_i_L0+0, 0
	ADDLW      KeypadTable_Table2_L0+0
	MOVWF      FSR
;lcdcalculator.c,39 :: 		return(Key);
	MOVF       INDF+0, 0
	MOVWF      R0+0
;lcdcalculator.c,41 :: 		}
L_end_KeypadTable:
	RETURN
; end of _KeypadTable

_keytest:

;lcdcalculator.c,42 :: 		unsigned char keytest(){  // essa função testa o teclado e retorna a tecla pressionada
;lcdcalculator.c,44 :: 		PORTD=0x01;
	MOVLW      1
	MOVWF      PORTD+0
;lcdcalculator.c,45 :: 		while((PORTD&(0x70))==0){  // PORTD and 0b01110000
L_keytest3:
	MOVLW      112
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keytest4
;lcdcalculator.c,46 :: 		PORTD=(PORTD<<1);
	MOVF       PORTD+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      PORTD+0
;lcdcalculator.c,47 :: 		if ((PORTD&(0x0F))==0) PORTD=0x01;
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keytest5
	MOVLW      1
	MOVWF      PORTD+0
L_keytest5:
;lcdcalculator.c,48 :: 		}
	GOTO       L_keytest3
L_keytest4:
;lcdcalculator.c,49 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_keytest6:
	DECFSZ     R13+0, 1
	GOTO       L_keytest6
	DECFSZ     R12+0, 1
	GOTO       L_keytest6
	NOP
	NOP
;lcdcalculator.c,50 :: 		Key=KeypadTable(PORTD&0x7F); // PORTD and 0b01111111 pois o estado do rd7 é desconhecido visto que ele é input
	MOVLW      127
	ANDWF      PORTD+0, 0
	MOVWF      FARG_KeypadTable_port_d+0
	CALL       _KeypadTable+0
	MOVF       R0+0, 0
	MOVWF      keytest_Key_L0+0
;lcdcalculator.c,51 :: 		while((PORTD&(0x70))!=0) asm nop;
L_keytest7:
	MOVLW      112
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_keytest8
	NOP
	GOTO       L_keytest7
L_keytest8:
;lcdcalculator.c,52 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_keytest9:
	DECFSZ     R13+0, 1
	GOTO       L_keytest9
	DECFSZ     R12+0, 1
	GOTO       L_keytest9
	NOP
	NOP
;lcdcalculator.c,53 :: 		return(Key);
	MOVF       keytest_Key_L0+0, 0
	MOVWF      R0+0
;lcdcalculator.c,54 :: 		}
L_end_keytest:
	RETURN
; end of _keytest

_main:

;lcdcalculator.c,56 :: 		void main() {
;lcdcalculator.c,61 :: 		ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;lcdcalculator.c,62 :: 		TRISD=0xF0;       // A,B,C,D são OUTPUT e 1 2 3 são input.
	MOVLW      240
	MOVWF      TRISD+0
;lcdcalculator.c,65 :: 		TRISC.RC7=1;//**************************
	BSF        TRISC+0, 7
;lcdcalculator.c,66 :: 		TRISC.RC6=1;//**************************
	BSF        TRISC+0, 6
;lcdcalculator.c,67 :: 		UART1_Init(9600);//**************************
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;lcdcalculator.c,68 :: 		Delay_ms(100); //**************************
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
	NOP
;lcdcalculator.c,70 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;lcdcalculator.c,71 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalculator.c,72 :: 		Lcd_Out(1,1,"CALCULATOR"); // Escreve na posição 1,1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_lcdcalculator+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalculator.c,73 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
;lcdcalculator.c,74 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalculator.c,77 :: 		for (;;){
L_main12:
;lcdcalculator.c,78 :: 		No1=No2=Ans=0;
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
;lcdcalculator.c,80 :: 		Lcd_Out(1,1,"No1:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_lcdcalculator+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalculator.c,81 :: 		while(1){
L_main15:
;lcdcalculator.c,82 :: 		key = keytest();
	CALL       _keytest+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;lcdcalculator.c,83 :: 		if (key=='#') break;
	MOVF       R0+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	GOTO       L_main16
L_main17:
;lcdcalculator.c,84 :: 		if (key!='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main18
;lcdcalculator.c,85 :: 		Lcd_Chr_Cp(key+'0');
	MOVLW      48
	ADDWF      main_key_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcdcalculator.c,86 :: 		No1=10*No1+key;
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
;lcdcalculator.c,87 :: 		}
L_main18:
;lcdcalculator.c,88 :: 		}
	GOTO       L_main15
L_main16:
;lcdcalculator.c,90 :: 		Lcd_Out(2,1,"No2:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_lcdcalculator+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalculator.c,91 :: 		while(1){
L_main19:
;lcdcalculator.c,92 :: 		key = keytest();
	CALL       _keytest+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;lcdcalculator.c,93 :: 		if (key=='#') break;
	MOVF       R0+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	GOTO       L_main20
L_main21:
;lcdcalculator.c,94 :: 		if (key!='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main22
;lcdcalculator.c,95 :: 		Lcd_Chr_Cp(key+'0');
	MOVLW      48
	ADDWF      main_key_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcdcalculator.c,96 :: 		No2=10*No2+key;
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
;lcdcalculator.c,97 :: 		}
L_main22:
;lcdcalculator.c,98 :: 		}
	GOTO       L_main19
L_main20:
;lcdcalculator.c,100 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalculator.c,101 :: 		Op='*';
	MOVLW      42
	MOVWF      main_Op_L0+0
;lcdcalculator.c,102 :: 		Lcd_Out(1,1,"Op:*");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_lcdcalculator+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalculator.c,103 :: 		while(1){
L_main23:
;lcdcalculator.c,104 :: 		key = keytest();
	CALL       _keytest+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;lcdcalculator.c,105 :: 		if (key=='#') break;
	MOVF       R0+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	GOTO       L_main24
L_main25:
;lcdcalculator.c,106 :: 		if (key=='*'){
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main26
;lcdcalculator.c,107 :: 		if(Op=='*') Op='/';
	MOVF       main_Op_L0+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVLW      47
	MOVWF      main_Op_L0+0
	GOTO       L_main28
L_main27:
;lcdcalculator.c,108 :: 		else if(Op=='/') Op='+';
	MOVF       main_Op_L0+0, 0
	XORLW      47
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	MOVLW      43
	MOVWF      main_Op_L0+0
	GOTO       L_main30
L_main29:
;lcdcalculator.c,109 :: 		else if(Op=='+') Op='-';
	MOVF       main_Op_L0+0, 0
	XORLW      43
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	MOVLW      45
	MOVWF      main_Op_L0+0
	GOTO       L_main32
L_main31:
;lcdcalculator.c,110 :: 		else if(Op=='-') Op='*';
	MOVF       main_Op_L0+0, 0
	XORLW      45
	BTFSS      STATUS+0, 2
	GOTO       L_main33
	MOVLW      42
	MOVWF      main_Op_L0+0
L_main33:
L_main32:
L_main30:
L_main28:
;lcdcalculator.c,111 :: 		}
L_main26:
;lcdcalculator.c,112 :: 		Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);
	MOVLW      16
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalculator.c,113 :: 		Lcd_Chr_Cp(Op);
	MOVF       main_Op_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcdcalculator.c,114 :: 		}
	GOTO       L_main23
L_main24:
;lcdcalculator.c,115 :: 		switch(Op){
	GOTO       L_main34
;lcdcalculator.c,116 :: 		case '*':
L_main36:
;lcdcalculator.c,117 :: 		Ans=No1*No2;
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
;lcdcalculator.c,118 :: 		break;
	GOTO       L_main35
;lcdcalculator.c,120 :: 		case '/':
L_main37:
;lcdcalculator.c,121 :: 		Ans=No1/No2;
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
;lcdcalculator.c,122 :: 		break;
	GOTO       L_main35
;lcdcalculator.c,124 :: 		case '+':
L_main38:
;lcdcalculator.c,125 :: 		Ans=No1+No2;
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
;lcdcalculator.c,126 :: 		break;
	GOTO       L_main35
;lcdcalculator.c,128 :: 		case '-':
L_main39:
;lcdcalculator.c,129 :: 		Ans=No1-No2;
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
;lcdcalculator.c,130 :: 		break;
	GOTO       L_main35
;lcdcalculator.c,131 :: 		}
L_main34:
	MOVF       main_Op_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main36
	MOVF       main_Op_L0+0, 0
	XORLW      47
	BTFSC      STATUS+0, 2
	GOTO       L_main37
	MOVF       main_Op_L0+0, 0
	XORLW      43
	BTFSC      STATUS+0, 2
	GOTO       L_main38
	MOVF       main_Op_L0+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L_main39
L_main35:
;lcdcalculator.c,132 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalculator.c,133 :: 		FloatToStr(Ans,disp);
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
;lcdcalculator.c,134 :: 		lcd=Ltrim(disp);
	MOVLW      main_disp_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      main_lcd_L0+0
;lcdcalculator.c,135 :: 		Lcd_Out(1,1,"Ans=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_lcdcalculator+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcdcalculator.c,136 :: 		Lcd_Out_Cp(lcd);
	MOVF       main_lcd_L0+0, 0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;lcdcalculator.c,137 :: 		Delay_ms(5000);
	MOVLW      127
	MOVWF      R11+0
	MOVLW      212
	MOVWF      R12+0
	MOVLW      49
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
	NOP
;lcdcalculator.c,138 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcdcalculator.c,140 :: 		}
	GOTO       L_main12
;lcdcalculator.c,141 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
