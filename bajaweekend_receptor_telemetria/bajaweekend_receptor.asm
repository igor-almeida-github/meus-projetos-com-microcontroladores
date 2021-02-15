
_main:

;bajaweekend_receptor.c,18 :: 		void main() {
;bajaweekend_receptor.c,20 :: 		unsigned char b1, b2 = 0;
	CLRF        main_b2_L0+0 
	CLRF        main_motor_L0+0 
	CLRF        main_motor_L0+1 
	CLRF        main_motor_L0+2 
	CLRF        main_motor_L0+3 
	MOVLW       1
	MOVWF       main_tank_L0+0 
	CLRF        main_freio_L0+0 
	CLRF        main_freio_L0+1 
;bajaweekend_receptor.c,24 :: 		ADCON1=0x0F;      //configuração de portas como digitais - AN0 é analógica
	MOVLW       15
	MOVWF       ADCON1+0 
;bajaweekend_receptor.c,25 :: 		UART1_Init(1200);//**************************
	BSF         BAUDCON+0, 3, 0
	MOVLW       6
	MOVWF       SPBRGH+0 
	MOVLW       130
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;bajaweekend_receptor.c,26 :: 		Delay_ms(100); //**************************
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
	NOP
;bajaweekend_receptor.c,27 :: 		Lcd_Init(); // LCD é conectado ao PORTB
	CALL        _Lcd_Init+0, 0
;bajaweekend_receptor.c,28 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;bajaweekend_receptor.c,29 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;bajaweekend_receptor.c,30 :: 		for (;;){
L_main1:
;bajaweekend_receptor.c,31 :: 		while (1){
L_main4:
;bajaweekend_receptor.c,32 :: 		if ((UART1_Data_Ready()) &&  (b1 != 0x0D)){                           // Espera chagar dados na serial
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main8
	MOVF        main_b1_L0+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L_main8
L__main38:
;bajaweekend_receptor.c,33 :: 		b1 = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_b1_L0+0 
;bajaweekend_receptor.c,34 :: 		}
L_main8:
;bajaweekend_receptor.c,35 :: 		if  ((b1 == 0x0D) && UART1_Data_Ready()){
	MOVF        main_b1_L0+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
L__main37:
;bajaweekend_receptor.c,36 :: 		b2 = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_b2_L0+0 
;bajaweekend_receptor.c,37 :: 		}
L_main11:
;bajaweekend_receptor.c,38 :: 		if ((b1 == 0x0D) && (b2 == 0x0A)){
	MOVF        main_b1_L0+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
	MOVF        main_b2_L0+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
L__main36:
;bajaweekend_receptor.c,39 :: 		break;
	GOTO        L_main5
;bajaweekend_receptor.c,40 :: 		}
L_main14:
;bajaweekend_receptor.c,41 :: 		else if ((b1 == 0x0D)&&(b2!=0)){
	MOVF        main_b1_L0+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_main18
	MOVF        main_b2_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
L__main35:
;bajaweekend_receptor.c,42 :: 		b1 = 0;
	CLRF        main_b1_L0+0 
;bajaweekend_receptor.c,43 :: 		b2 = 0;
	CLRF        main_b2_L0+0 
;bajaweekend_receptor.c,44 :: 		}
L_main18:
;bajaweekend_receptor.c,45 :: 		}
	GOTO        L_main4
L_main5:
;bajaweekend_receptor.c,46 :: 		while(!UART1_Data_Ready());
L_main19:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main20
	GOTO        L_main19
L_main20:
;bajaweekend_receptor.c,47 :: 		*((unsigned char*)&motor+3) =  UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_motor_L0+3 
;bajaweekend_receptor.c,48 :: 		while(!UART1_Data_Ready());
L_main21:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main22
	GOTO        L_main21
L_main22:
;bajaweekend_receptor.c,49 :: 		*((unsigned char*)&motor+2) =  UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_motor_L0+2 
;bajaweekend_receptor.c,50 :: 		while(!UART1_Data_Ready());
L_main23:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main24
	GOTO        L_main23
L_main24:
;bajaweekend_receptor.c,51 :: 		*((unsigned char*)&motor+1) =  UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_motor_L0+1 
;bajaweekend_receptor.c,52 :: 		while(!UART1_Data_Ready());
L_main25:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main26
	GOTO        L_main25
L_main26:
;bajaweekend_receptor.c,53 :: 		*((unsigned char*)&motor) =    UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_motor_L0+0 
;bajaweekend_receptor.c,54 :: 		while(!UART1_Data_Ready());
L_main27:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main28
	GOTO        L_main27
L_main28:
;bajaweekend_receptor.c,55 :: 		*((unsigned char*)&freio+1) =  UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_freio_L0+1 
;bajaweekend_receptor.c,56 :: 		while(!UART1_Data_Ready());
L_main29:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main30
	GOTO        L_main29
L_main30:
;bajaweekend_receptor.c,57 :: 		*((unsigned char*)&freio) =   UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_freio_L0+0 
;bajaweekend_receptor.c,58 :: 		while(!UART1_Data_Ready());
L_main31:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
	GOTO        L_main31
L_main32:
;bajaweekend_receptor.c,59 :: 		tank =  UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_tank_L0+0 
;bajaweekend_receptor.c,61 :: 		Lcd_out(1, 1, "Rt: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_bajaweekend_receptor+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_bajaweekend_receptor+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;bajaweekend_receptor.c,62 :: 		LongWordToStr(motor, txt);
	MOVF        main_motor_L0+0, 0 
	MOVWF       FARG_LongWordToStr_input+0 
	MOVF        main_motor_L0+1, 0 
	MOVWF       FARG_LongWordToStr_input+1 
	MOVF        main_motor_L0+2, 0 
	MOVWF       FARG_LongWordToStr_input+2 
	MOVF        main_motor_L0+3, 0 
	MOVWF       FARG_LongWordToStr_input+3 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_LongWordToStr_output+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_LongWordToStr_output+1 
	CALL        _LongWordToStr+0, 0
;bajaweekend_receptor.c,63 :: 		Lcd_out(1, 5, ltrim(txt));
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Ltrim_string+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_Ltrim_string+1 
	CALL        _Ltrim+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;bajaweekend_receptor.c,65 :: 		Lcd_out(2, 1, "Brk: ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_bajaweekend_receptor+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_bajaweekend_receptor+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;bajaweekend_receptor.c,66 :: 		WordToStr(freio, txt);
	MOVF        main_freio_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        main_freio_L0+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;bajaweekend_receptor.c,67 :: 		Lcd_out(2, 6, ltrim(txt));
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Ltrim_string+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_Ltrim_string+1 
	CALL        _Ltrim+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;bajaweekend_receptor.c,69 :: 		if (tank == 1) lcd_out(2, 13,"Full");
	MOVF        main_tank_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main33
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_bajaweekend_receptor+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_bajaweekend_receptor+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main33:
;bajaweekend_receptor.c,70 :: 		if (tank == 0) lcd_out(2, 13,"Epty");
	MOVF        main_tank_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main34
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_bajaweekend_receptor+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_bajaweekend_receptor+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main34:
;bajaweekend_receptor.c,72 :: 		}
	GOTO        L_main1
;bajaweekend_receptor.c,73 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
