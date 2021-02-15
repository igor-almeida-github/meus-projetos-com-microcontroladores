
_KeypadTable:

;onOffTemperatureControl.c,24 :: 		unsigned char KeypadTable(unsigned char port_d){                                // Procura nas tabelas a tecla pressionada de acordo com o PORTD
;onOffTemperatureControl.c,25 :: 		int i=0;
	CLRF       KeypadTable_i_L0+0
	CLRF       KeypadTable_i_L0+1
;onOffTemperatureControl.c,27 :: 		while(Table1[i]!= port_d){
L_KeypadTable0:
	MOVF       KeypadTable_i_L0+0, 0
	ADDLW      _Table1+0
	MOVWF      R0+0
	MOVLW      hi_addr(_Table1+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      KeypadTable_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORWF      FARG_KeypadTable_port_d+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_KeypadTable1
;onOffTemperatureControl.c,28 :: 		i=i+1;
	INCF       KeypadTable_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       KeypadTable_i_L0+1, 1
;onOffTemperatureControl.c,29 :: 		if (i==12) break;                                                       // Tecla inválida encontrada, condição inesperada.
	MOVLW      0
	XORWF      KeypadTable_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__KeypadTable36
	MOVLW      12
	XORWF      KeypadTable_i_L0+0, 0
L__KeypadTable36:
	BTFSS      STATUS+0, 2
	GOTO       L_KeypadTable2
	GOTO       L_KeypadTable1
L_KeypadTable2:
;onOffTemperatureControl.c,30 :: 		}
	GOTO       L_KeypadTable0
L_KeypadTable1:
;onOffTemperatureControl.c,31 :: 		if (i!=12) Key= Table2[i];                                                 // Se a tecla encrontrada for válida
	MOVLW      0
	XORWF      KeypadTable_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__KeypadTable37
	MOVLW      12
	XORWF      KeypadTable_i_L0+0, 0
L__KeypadTable37:
	BTFSC      STATUS+0, 2
	GOTO       L_KeypadTable3
	MOVF       KeypadTable_i_L0+0, 0
	ADDLW      _Table2+0
	MOVWF      R0+0
	MOVLW      hi_addr(_Table2+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      KeypadTable_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R2+0
	GOTO       L_KeypadTable4
L_KeypadTable3:
;onOffTemperatureControl.c,32 :: 		else Key='N';
	MOVLW      78
	MOVWF      R2+0
L_KeypadTable4:
;onOffTemperatureControl.c,33 :: 		return(Key);
	MOVF       R2+0, 0
	MOVWF      R0+0
;onOffTemperatureControl.c,35 :: 		}
L_end_KeypadTable:
	RETURN
; end of _KeypadTable

_keytest:

;onOffTemperatureControl.c,36 :: 		unsigned char keytest(){                                                        // Essa função testa o teclado e retorna a tecla pressionada (Blocking call)
;onOffTemperatureControl.c,38 :: 		PORTD=0x01;
	MOVLW      1
	MOVWF      PORTD+0
;onOffTemperatureControl.c,39 :: 		while((PORTD&(0x70))==0){                                                  // PORTD and 0b01110000
L_keytest5:
	MOVLW      112
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keytest6
;onOffTemperatureControl.c,40 :: 		PORTD=(PORTD<<1);
	MOVF       PORTD+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      PORTD+0
;onOffTemperatureControl.c,41 :: 		if ((PORTD&(0x0F))==0) PORTD=0x01;
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keytest7
	MOVLW      1
	MOVWF      PORTD+0
L_keytest7:
;onOffTemperatureControl.c,42 :: 		}
	GOTO       L_keytest5
L_keytest6:
;onOffTemperatureControl.c,43 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_keytest8:
	DECFSZ     R13+0, 1
	GOTO       L_keytest8
	DECFSZ     R12+0, 1
	GOTO       L_keytest8
	NOP
	NOP
;onOffTemperatureControl.c,44 :: 		Key=KeypadTable(PORTD&0x7F);                                               // PORTD and 0b01111111 pois o estado do rd7 é desconhecido visto que ele é input
	MOVLW      127
	ANDWF      PORTD+0, 0
	MOVWF      FARG_KeypadTable_port_d+0
	CALL       _KeypadTable+0
	MOVF       R0+0, 0
	MOVWF      keytest_Key_L0+0
;onOffTemperatureControl.c,45 :: 		while((PORTD&(0x70))!=0);                                                  // Espera soltar a tecla
L_keytest9:
	MOVLW      112
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_keytest10
	GOTO       L_keytest9
L_keytest10:
;onOffTemperatureControl.c,46 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_keytest11:
	DECFSZ     R13+0, 1
	GOTO       L_keytest11
	DECFSZ     R12+0, 1
	GOTO       L_keytest11
	NOP
	NOP
;onOffTemperatureControl.c,47 :: 		return(Key);
	MOVF       keytest_Key_L0+0, 0
	MOVWF      R0+0
;onOffTemperatureControl.c,48 :: 		}
L_end_keytest:
	RETURN
; end of _keytest

_main:

;onOffTemperatureControl.c,51 :: 		void main() {
;onOffTemperatureControl.c,56 :: 		unsigned char SP=0;                                                       // Setpoint inicializado como 0ºC
	CLRF       main_SP_L0+0
;onOffTemperatureControl.c,58 :: 		ADCON1=0x0E;                                                              // Todas as portas são digitais exceto AN0
	MOVLW      14
	MOVWF      ADCON1+0
;onOffTemperatureControl.c,59 :: 		TRISD=0xF0;                                                               // A,B,C,D são OUTPUT e 1 2 3 são input.
	MOVLW      240
	MOVWF      TRISD+0
;onOffTemperatureControl.c,60 :: 		TRISE.RE0=0;                                                              // Pino do relé é OUTPUT
	BCF        TRISE+0, 0
;onOffTemperatureControl.c,61 :: 		relay=1;                                                                  // Relé começa desligado
	BSF        PORTE+0, 0
;onOffTemperatureControl.c,62 :: 		PR2=249;                                                                  // Período de 200us
	MOVLW      249
	MOVWF      PR2+0
;onOffTemperatureControl.c,63 :: 		CCPR1L=0x7D;                                                              // Duty cyle de 100us (CCPR1L<<2)|CCP1CON<5:4>=500
	MOVLW      125
	MOVWF      CCPR1L+0
;onOffTemperatureControl.c,64 :: 		TRISC.RC2=0;                                                              // CCP1 pin é OUTPUT
	BCF        TRISC+0, 2
;onOffTemperatureControl.c,65 :: 		T2CON=0x05;                                                               // Timer 2 1:1 postascale, 4 prescale
	MOVLW      5
	MOVWF      T2CON+0
;onOffTemperatureControl.c,66 :: 		Lcd_Init();                                                               // LCD inicializa o lcd conectado ao PORTB
	CALL       _Lcd_Init+0
;onOffTemperatureControl.c,67 :: 		Lcd_Cmd(_LCD_CLEAR);                                                      // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;onOffTemperatureControl.c,68 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                                                 // Deliga o cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;onOffTemperatureControl.c,69 :: 		Lcd_Out(1,1,"TEMPERATURE");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,70 :: 		Lcd_Out(2,1,"CONTROL (ON-OFF)");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,71 :: 		Delay_ms(2000);
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
	NOP
;onOffTemperatureControl.c,72 :: 		Lcd_Cmd(_LCD_CLEAR);                                                      // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;onOffTemperatureControl.c,73 :: 		Lcd_Out(1,1,"Enter Set Point");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,74 :: 		Lcd_Out(2,1,"SP:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,75 :: 		Lcd_Cmd(_LCD_BLINK_CURSOR_ON);                                            // Pisca o cursor
	MOVLW      15
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;onOffTemperatureControl.c,77 :: 		do {
L_main13:
;onOffTemperatureControl.c,78 :: 		key=keytest();                                                        // Espera e lê uma tecla
	CALL       _keytest+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;onOffTemperatureControl.c,79 :: 		if(key!='N'&&key!='#'&&key!='*'){
	MOVF       R0+0, 0
	XORLW      78
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       main_key_L0+0, 0
	XORLW      35
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       main_key_L0+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L_main18
L__main34:
;onOffTemperatureControl.c,80 :: 		SP = SP*10+key;
	MOVF       main_SP_L0+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       main_key_L0+0, 0
	ADDWF      R0+0, 0
	MOVWF      main_SP_L0+0
;onOffTemperatureControl.c,81 :: 		Lcd_Chr_Cp(key+'0');
	MOVLW      48
	ADDWF      main_key_L0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;onOffTemperatureControl.c,82 :: 		}
L_main18:
;onOffTemperatureControl.c,84 :: 		while(key!='#'||SP==0);                                                   // Faça enquanto a tecla '#' não for pressionada ou valor do setpoint não for inserido
	MOVF       main_key_L0+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main13
	MOVF       main_SP_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
L__main33:
;onOffTemperatureControl.c,85 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                                                 // Desliga o cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;onOffTemperatureControl.c,86 :: 		Lcd_Cmd(_LCD_CLEAR);                                                      // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;onOffTemperatureControl.c,87 :: 		ByteToStr(SP,txt);
	MOVF       main_SP_L0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;onOffTemperatureControl.c,88 :: 		Lcd_Out(1,1,"SP = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,89 :: 		pnt=ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;onOffTemperatureControl.c,90 :: 		Lcd_Out_Cp(pnt);
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;onOffTemperatureControl.c,91 :: 		Lcd_chr_Cp(0xDF);                                                         // Símbolo de graus º
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;onOffTemperatureControl.c,92 :: 		Lcd_chr_Cp('C');
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;onOffTemperatureControl.c,93 :: 		Lcd_Out(2,1,"ENTER to cont.");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,94 :: 		do {
L_main21:
;onOffTemperatureControl.c,95 :: 		key=keytest();                                                        // Espera e lê uma tecla
	CALL       _keytest+0
	MOVF       R0+0, 0
	MOVWF      main_key_L0+0
;onOffTemperatureControl.c,97 :: 		while(key!='#');
	MOVF       R0+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main21
;onOffTemperatureControl.c,99 :: 		for(;;){
L_main24:
;onOffTemperatureControl.c,100 :: 		Lcd_Out(2,1,"                ");                                     // Limpa a segunda linha do LCD
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_onOffTemperatureControl+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,101 :: 		PlantTemp=(500.0*ADC_Read(0))/1023;                                  // Lê adc0 e converte pra ºC
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_PlantTemp_L0+0
	MOVF       R0+1, 0
	MOVWF      main_PlantTemp_L0+1
	MOVF       R0+2, 0
	MOVWF      main_PlantTemp_L0+2
	MOVF       R0+3, 0
	MOVWF      main_PlantTemp_L0+3
;onOffTemperatureControl.c,102 :: 		floatToStr(PlantTemp,txt);
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
;onOffTemperatureControl.c,103 :: 		pnt=strchr(txt, '.');
	MOVLW      main_txt_L0+0
	MOVWF      FARG_strchr_ptr+0
	MOVLW      46
	MOVWF      FARG_strchr_chr+0
	CALL       _strchr+0
;onOffTemperatureControl.c,104 :: 		*(pnt+2)='\0';                                                       // insere caracter null duas casas decimais depois da virgula, deixando a string com somente uma casa decimal a ser exibida
	MOVLW      2
	ADDWF      R0+0, 0
	MOVWF      FSR
	CLRF       INDF+0
;onOffTemperatureControl.c,105 :: 		pnt=ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;onOffTemperatureControl.c,106 :: 		Lcd_Out(2,1,pnt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;onOffTemperatureControl.c,107 :: 		Lcd_chr_Cp(0xDF);                                                    // Símbolo de graus º
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;onOffTemperatureControl.c,108 :: 		Lcd_chr_Cp('C');
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;onOffTemperatureControl.c,109 :: 		if(SP-PlantTemp>3) relay=0;                                          //relé liga
	MOVF       main_SP_L0+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVF       main_PlantTemp_L0+0, 0
	MOVWF      R4+0
	MOVF       main_PlantTemp_L0+1, 0
	MOVWF      R4+1
	MOVF       main_PlantTemp_L0+2, 0
	MOVWF      R4+2
	MOVF       main_PlantTemp_L0+3, 0
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      64
	MOVWF      R0+2
	MOVLW      128
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main27
	BCF        PORTE+0, 0
	GOTO       L_main28
L_main27:
;onOffTemperatureControl.c,110 :: 		else if (SP-PlantTemp<=0) relay=1;                                   //relé desliga
	MOVF       main_SP_L0+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVF       main_PlantTemp_L0+0, 0
	MOVWF      R4+0
	MOVF       main_PlantTemp_L0+1, 0
	MOVWF      R4+1
	MOVF       main_PlantTemp_L0+2, 0
	MOVWF      R4+2
	MOVF       main_PlantTemp_L0+3, 0
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	CLRF       R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main29
	BSF        PORTE+0, 0
L_main29:
L_main28:
;onOffTemperatureControl.c,111 :: 		if (abs(SP-PlantTemp)>5){
	MOVF       main_SP_L0+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVF       main_PlantTemp_L0+0, 0
	MOVWF      R4+0
	MOVF       main_PlantTemp_L0+1, 0
	MOVWF      R4+1
	MOVF       main_PlantTemp_L0+2, 0
	MOVWF      R4+2
	MOVF       main_PlantTemp_L0+3, 0
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      FARG_abs_a+0
	MOVF       R0+1, 0
	MOVWF      FARG_abs_a+1
	CALL       _abs+0
	MOVLW      128
	MOVWF      R2+0
	MOVLW      128
	XORWF      R0+1, 0
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVF       R0+0, 0
	SUBLW      5
L__main40:
	BTFSC      STATUS+0, 0
	GOTO       L_main30
;onOffTemperatureControl.c,112 :: 		CCP1CON=0x0C;                                                     // PWM ativado, buzzer tocando
	MOVLW      12
	MOVWF      CCP1CON+0
;onOffTemperatureControl.c,113 :: 		}
	GOTO       L_main31
L_main30:
;onOffTemperatureControl.c,115 :: 		CCP1CON=0x00;                                                     // PWM desativado, reseta módulo CCPx
	CLRF       CCP1CON+0
;onOffTemperatureControl.c,116 :: 		}
L_main31:
;onOffTemperatureControl.c,117 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
	DECFSZ     R12+0, 1
	GOTO       L_main32
	DECFSZ     R11+0, 1
	GOTO       L_main32
	NOP
	NOP
;onOffTemperatureControl.c,118 :: 		}
	GOTO       L_main24
;onOffTemperatureControl.c,120 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
