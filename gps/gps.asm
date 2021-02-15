
_main:

;gps.c,21 :: 		void main() {
;gps.c,23 :: 		unsigned char txt[]="$GPGLL,";
	MOVLW      36
	MOVWF      main_txt_L0+0
	MOVLW      71
	MOVWF      main_txt_L0+1
	MOVLW      80
	MOVWF      main_txt_L0+2
	MOVLW      71
	MOVWF      main_txt_L0+3
	MOVLW      76
	MOVWF      main_txt_L0+4
	MOVLW      76
	MOVWF      main_txt_L0+5
	MOVLW      44
	MOVWF      main_txt_L0+6
	CLRF       main_txt_L0+7
	CLRF       main_i_L0+0
;gps.c,28 :: 		ADCON1=0x07;                                                                // Todas as portas são digitais
	MOVLW      7
	MOVWF      ADCON1+0
;gps.c,29 :: 		UART1_Init(9600);                                                           // Inicia a comunicação serial com 9600 de baud rate
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;gps.c,30 :: 		Lcd_Init();                                                                 // LCD inicializa o lcd conectado ao PORTB
	CALL       _Lcd_Init+0
;gps.c,31 :: 		Lcd_Cmd(_LCD_CLEAR);                                                        // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,32 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                                                   // Deliga o cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,33 :: 		delay_ms(100);                                                              // Espera módulo UART se estabilizar
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
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
;gps.c,34 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,35 :: 		Lcd_out(1,1,"GPS...");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_gps+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;gps.c,36 :: 		delay_ms(2000);
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
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
;gps.c,37 :: 		uart1_write(0x0F);
	MOVLW      15
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;gps.c,38 :: 		for(;;){                                                                    // Loop infinito
L_main2:
;gps.c,40 :: 		i=0;
	CLRF       main_i_L0+0
;gps.c,41 :: 		while(i<7){                                                             // Enquanto a mensagem $GPGLL não for recebida por completo
L_main5:
	MOVLW      7
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main6
;gps.c,42 :: 		if(UART1_Data_Ready()){                                             // Se houver dados disponíveis para a leitura na uart
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main7
;gps.c,43 :: 		if (UART1_Read()==txt[i]){                                      // Se um caracter recebido for igual a sequência "$GPGLL"
	CALL       _UART1_Read+0
	MOVF       main_i_L0+0, 0
	ADDLW      main_txt_L0+0
	MOVWF      FSR
	MOVF       R0+0, 0
	XORWF      INDF+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;gps.c,44 :: 		i++;                                                        // Incrementa para testar novo caracter da sequência
	INCF       main_i_L0+0, 1
;gps.c,45 :: 		}
	GOTO       L_main9
L_main8:
;gps.c,46 :: 		else i=0;                                                       // Se um caracter recebido for diferente da sequência de caracteres na string "$GPGLL", inicia-se novamente a busca desde o '$'
	CLRF       main_i_L0+0
L_main9:
;gps.c,47 :: 		}
L_main7:
;gps.c,48 :: 		}
	GOTO       L_main5
L_main6:
;gps.c,50 :: 		UART1_Read_Text(LAT, ",", 255);                                         // Latitude
	MOVLW      main_LAT_L0+0
	MOVWF      FARG_UART1_Read_Text_Output+0
	MOVLW      ?lstr2_gps+0
	MOVWF      FARG_UART1_Read_Text_Delimiter+0
	MOVLW      255
	MOVWF      FARG_UART1_Read_Text_Attempts+0
	CALL       _UART1_Read_Text+0
;gps.c,51 :: 		while(!UART1_Data_Ready());
L_main10:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main11
	GOTO       L_main10
L_main11:
;gps.c,52 :: 		LAT[10]=UART1_Read();                                                   // N ou S
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_LAT_L0+10
;gps.c,53 :: 		while(!UART1_Data_Ready());
L_main12:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main13
	GOTO       L_main12
L_main13:
;gps.c,54 :: 		UART1_Read();                                                           // ,
	CALL       _UART1_Read+0
;gps.c,55 :: 		while(!UART1_Data_Ready());
L_main14:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	GOTO       L_main14
L_main15:
;gps.c,56 :: 		UART1_Read_Text(LON, ",", 255);                                         // Longitude
	MOVLW      main_LON_L0+0
	MOVWF      FARG_UART1_Read_Text_Output+0
	MOVLW      ?lstr3_gps+0
	MOVWF      FARG_UART1_Read_Text_Delimiter+0
	MOVLW      255
	MOVWF      FARG_UART1_Read_Text_Attempts+0
	CALL       _UART1_Read_Text+0
;gps.c,57 :: 		while(!UART1_Data_Ready());
L_main16:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	GOTO       L_main16
L_main17:
;gps.c,58 :: 		LON[11]=UART1_Read();                                                   // E ou W
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_LON_L0+11
;gps.c,59 :: 		while(!UART1_Data_Ready());
L_main18:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	GOTO       L_main18
L_main19:
;gps.c,60 :: 		UART1_Read();                                                           // ,
	CALL       _UART1_Read+0
;gps.c,61 :: 		UART1_Read_Text(UTC, ",", 255);                                         // Coordinated Universal Time
	MOVLW      main_UTC_L0+0
	MOVWF      FARG_UART1_Read_Text_Output+0
	MOVLW      ?lstr4_gps+0
	MOVWF      FARG_UART1_Read_Text_Delimiter+0
	MOVLW      255
	MOVWF      FARG_UART1_Read_Text_Attempts+0
	CALL       _UART1_Read_Text+0
;gps.c,62 :: 		UART1_Read_Text(ack, "*", 255);                                         // Para verificar se os dados são válidos
	MOVLW      main_ack_L0+0
	MOVWF      FARG_UART1_Read_Text_Output+0
	MOVLW      ?lstr5_gps+0
	MOVWF      FARG_UART1_Read_Text_Delimiter+0
	MOVLW      255
	MOVWF      FARG_UART1_Read_Text_Attempts+0
	CALL       _UART1_Read_Text+0
;gps.c,63 :: 		if(ack[0]=='A'&&ack[2]=='A'){                                           // Se as coordenadas são válidas
	MOVF       main_ack_L0+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVF       main_ack_L0+2, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_main22
L__main36:
;gps.c,64 :: 		GoogleMapstext[0]=LAT[0];
	MOVF       main_LAT_L0+0, 0
	MOVWF      main_GoogleMapstext_L0+0
;gps.c,65 :: 		GoogleMapstext[1]=LAT[1];
	MOVF       main_LAT_L0+1, 0
	MOVWF      main_GoogleMapstext_L0+1
;gps.c,66 :: 		GoogleMapstext[2]=0xB0;                                           // Símbolo de graus º
	MOVLW      176
	MOVWF      main_GoogleMapstext_L0+2
;gps.c,67 :: 		for (i=2;i<10;i++)GoogleMapstext[i+1]=LAT[i];
	MOVLW      2
	MOVWF      main_i_L0+0
L_main23:
	MOVLW      10
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main24
	MOVF       main_i_L0+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      main_GoogleMapstext_L0+0
	MOVWF      R1+0
	MOVF       main_i_L0+0, 0
	ADDLW      main_LAT_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       main_i_L0+0, 1
	GOTO       L_main23
L_main24:
;gps.c,68 :: 		GoogleMapstext[11]=0x27;                                          // Símbolo de minutos '
	MOVLW      39
	MOVWF      main_GoogleMapstext_L0+11
;gps.c,69 :: 		GoogleMapstext[12]=LAT[10];
	MOVF       main_LAT_L0+10, 0
	MOVWF      main_GoogleMapstext_L0+12
;gps.c,70 :: 		GoogleMapstext[13]=LON[0];
	MOVF       main_LON_L0+0, 0
	MOVWF      main_GoogleMapstext_L0+13
;gps.c,71 :: 		GoogleMapstext[14]=LON[1];
	MOVF       main_LON_L0+1, 0
	MOVWF      main_GoogleMapstext_L0+14
;gps.c,72 :: 		GoogleMapstext[15]=LON[2];
	MOVF       main_LON_L0+2, 0
	MOVWF      main_GoogleMapstext_L0+15
;gps.c,73 :: 		GoogleMapstext[16]=0xB0;                                          // Símbolo de graus º
	MOVLW      176
	MOVWF      main_GoogleMapstext_L0+16
;gps.c,74 :: 		for(i=3;i<11;i++)GoogleMapstext[i+14]=LON[i];
	MOVLW      3
	MOVWF      main_i_L0+0
L_main26:
	MOVLW      11
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main27
	MOVLW      14
	ADDWF      main_i_L0+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      main_GoogleMapstext_L0+0
	MOVWF      R1+0
	MOVF       main_i_L0+0, 0
	ADDLW      main_LON_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       main_i_L0+0, 1
	GOTO       L_main26
L_main27:
;gps.c,75 :: 		GoogleMapstext[25]=0x27;                                          // Símbolo de minutos '
	MOVLW      39
	MOVWF      main_GoogleMapstext_L0+25
;gps.c,76 :: 		GoogleMapstext[26]=LON[11];
	MOVF       main_LON_L0+11, 0
	MOVWF      main_GoogleMapstext_L0+26
;gps.c,77 :: 		GoogleMapstext[27]=0x0D;                                          // CR
	MOVLW      13
	MOVWF      main_GoogleMapstext_L0+27
;gps.c,78 :: 		GoogleMapstext[28]=0x0A;                                          // LF
	MOVLW      10
	MOVWF      main_GoogleMapstext_L0+28
;gps.c,79 :: 		GoogleMapstext[29]='\0';
	CLRF       main_GoogleMapstext_L0+29
;gps.c,80 :: 		UART1_Write_Text(GoogleMapstext);
	MOVLW      main_GoogleMapstext_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;gps.c,81 :: 		GoogleMapstext[2]=0xDF;
	MOVLW      223
	MOVWF      main_GoogleMapstext_L0+2
;gps.c,82 :: 		GoogleMapstext[16]=0xDF;
	MOVLW      223
	MOVWF      main_GoogleMapstext_L0+16
;gps.c,84 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,85 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW      2
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,86 :: 		for (i=0;i<13;i++) Lcd_Chr_Cp(GoogleMapstext[i]);
	CLRF       main_i_L0+0
L_main29:
	MOVLW      13
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main30
	MOVF       main_i_L0+0, 0
	ADDLW      main_GoogleMapstext_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
	INCF       main_i_L0+0, 1
	GOTO       L_main29
L_main30:
;gps.c,87 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW      2
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,88 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,89 :: 		for (i=13;i<27;i++) Lcd_Chr_Cp(GoogleMapstext[i]);
	MOVLW      13
	MOVWF      main_i_L0+0
L_main32:
	MOVLW      27
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main33
	MOVF       main_i_L0+0, 0
	ADDLW      main_GoogleMapstext_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
	INCF       main_i_L0+0, 1
	GOTO       L_main32
L_main33:
;gps.c,90 :: 		}
	GOTO       L_main35
L_main22:
;gps.c,92 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;gps.c,93 :: 		Lcd_out(1,1,"No Signal");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_gps+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;gps.c,94 :: 		}
L_main35:
;gps.c,96 :: 		}
	GOTO       L_main2
;gps.c,97 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
