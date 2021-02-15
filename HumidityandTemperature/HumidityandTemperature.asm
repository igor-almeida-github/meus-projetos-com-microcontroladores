
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;HumidityandTemperature.c,25 :: 		void interrupt(){
;HumidityandTemperature.c,26 :: 		PIR1.TMR2IF=0;                                                              // Limpa a flag de interrupção do timer 2
	BCF        PIR1+0, 1
;HumidityandTemperature.c,27 :: 		overflow=1;                                                                 // Sinalizador de ocorrência de overflow
	MOVLW      1
	MOVWF      _overflow+0
;HumidityandTemperature.c,28 :: 		}
L_end_interrupt:
L__interrupt44:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_WakeUpDHT:

;HumidityandTemperature.c,30 :: 		void WakeUpDHT(void){                                                           // MCU enviando sinal de start para acordar DHT
;HumidityandTemperature.c,31 :: 		DHT_direction=0;                                                        // Pino de dados é OUTPUT
	BCF        TRISD2_bit+0, BitPos(TRISD2_bit+0)
;HumidityandTemperature.c,32 :: 		DHT_pin=0;                                                              // Nível baixo na linha de dados
	BCF        RD2_bit+0, BitPos(RD2_bit+0)
;HumidityandTemperature.c,33 :: 		delay_ms(18);                                                           // Delay exigido pelo datasheet para que o DHT reconheça o sinal de start
	MOVLW      117
	MOVWF      R12+0
	MOVLW      225
	MOVWF      R13+0
L_WakeUpDHT0:
	DECFSZ     R13+0, 1
	GOTO       L_WakeUpDHT0
	DECFSZ     R12+0, 1
	GOTO       L_WakeUpDHT0
;HumidityandTemperature.c,34 :: 		DHT_direction=1;                                                        // Pino de dados torna-se INPUT; resistor de pull up faz a linha retornar a HIGH
	BSF        TRISD2_bit+0, BitPos(TRISD2_bit+0)
;HumidityandTemperature.c,35 :: 		delay_us(2);                                                            // Para dar tempo da linha se estabilizar em HIGH
	MOVLW      3
	MOVWF      R13+0
L_WakeUpDHT1:
	DECFSZ     R13+0, 1
	GOTO       L_WakeUpDHT1
;HumidityandTemperature.c,36 :: 		}
L_end_WakeUpDHT:
	RETURN
; end of _WakeUpDHT

_DHTcheck:

;HumidityandTemperature.c,38 :: 		void DHTcheck(void){                                                            // Sinal de confirmação enviado pelo sensor
;HumidityandTemperature.c,39 :: 		T2CON.TMR2ON=1;                                                         // Dispara o timer 2
	BSF        T2CON+0, 2
;HumidityandTemperature.c,40 :: 		while(DHT_pin&&!(overflow.b0));                                         // Aguarda a resposta do sensor ou overflow do timer(se demorar de mais para receber resposta)
L_DHTcheck2:
	BTFSS      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_DHTcheck3
	BTFSC      _overflow+0, 0
	GOTO       L_DHTcheck3
L__DHTcheck40:
	GOTO       L_DHTcheck2
L_DHTcheck3:
;HumidityandTemperature.c,41 :: 		T2CON.TMR2ON=0;                                                         // Interrompe contagem do timer 2
	BCF        T2CON+0, 2
;HumidityandTemperature.c,42 :: 		TMR2=0;                                                                 // Reseta o timer 2
	CLRF       TMR2+0
;HumidityandTemperature.c,43 :: 		delay_us(2);
	MOVLW      3
	MOVWF      R13+0
L_DHTcheck6:
	DECFSZ     R13+0, 1
	GOTO       L_DHTcheck6
;HumidityandTemperature.c,44 :: 		while(!DHT_pin&&!(overflow.b0));                                        // Aguardando inicio da transmissão
L_DHTcheck7:
	BTFSC      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_DHTcheck8
	BTFSC      _overflow+0, 0
	GOTO       L_DHTcheck8
L__DHTcheck39:
	GOTO       L_DHTcheck7
L_DHTcheck8:
;HumidityandTemperature.c,45 :: 		delay_us(2);
	MOVLW      3
	MOVWF      R13+0
L_DHTcheck11:
	DECFSZ     R13+0, 1
	GOTO       L_DHTcheck11
;HumidityandTemperature.c,46 :: 		while(DHT_pin&&!(overflow.b0));                                         // Aguardando inicio da transmissão
L_DHTcheck12:
	BTFSS      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_DHTcheck13
	BTFSC      _overflow+0, 0
	GOTO       L_DHTcheck13
L__DHTcheck38:
	GOTO       L_DHTcheck12
L_DHTcheck13:
;HumidityandTemperature.c,47 :: 		delay_us(2);
	MOVLW      3
	MOVWF      R13+0
L_DHTcheck16:
	DECFSZ     R13+0, 1
	GOTO       L_DHTcheck16
;HumidityandTemperature.c,48 :: 		}
L_end_DHTcheck:
	RETURN
; end of _DHTcheck

_ReadByteDHT:

;HumidityandTemperature.c,50 :: 		unsigned char ReadByteDHT(void){                                                // Transmissão pelo DHT e recepção pelo MCU iniciada
;HumidityandTemperature.c,52 :: 		buffer =0;                                                              // Inicia o buffer de recepção do byte
	CLRF       _buffer+0
;HumidityandTemperature.c,53 :: 		for (i=1;i<=8;i++){
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_ReadByteDHT17:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ReadByteDHT48
	MOVF       R1+0, 0
	SUBLW      8
L__ReadByteDHT48:
	BTFSS      STATUS+0, 0
	GOTO       L_ReadByteDHT18
;HumidityandTemperature.c,54 :: 		while(!DHT_pin&&!overflow);                                         // tempo em baixo que demarca o início do bit
L_ReadByteDHT20:
	BTFSC      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_ReadByteDHT21
	MOVF       _overflow+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ReadByteDHT21
L__ReadByteDHT42:
	GOTO       L_ReadByteDHT20
L_ReadByteDHT21:
;HumidityandTemperature.c,55 :: 		T2CON.TMR2ON=1;                                                     // Dispara o timer 2
	BSF        T2CON+0, 2
;HumidityandTemperature.c,56 :: 		while(DHT_pin&&!overflow);                                          // Conta o tempo em alto
L_ReadByteDHT24:
	BTFSS      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_ReadByteDHT25
	MOVF       _overflow+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ReadByteDHT25
L__ReadByteDHT41:
	GOTO       L_ReadByteDHT24
L_ReadByteDHT25:
;HumidityandTemperature.c,57 :: 		T2CON.TMR2ON=0;                                                     // Interrompe contagem do timer 2
	BCF        T2CON+0, 2
;HumidityandTemperature.c,58 :: 		buffer=buffer<<1;                                                   // Move os bits para a esquerda
	RLF        _buffer+0, 1
	BCF        _buffer+0, 0
;HumidityandTemperature.c,59 :: 		if (TMR2> 61){                                                      // maior que 48.8us
	MOVF       TMR2+0, 0
	SUBLW      61
	BTFSC      STATUS+0, 0
	GOTO       L_ReadByteDHT28
;HumidityandTemperature.c,60 :: 		buffer|=0x01;                                                    // Bit 1 recebido
	BSF        _buffer+0, 0
;HumidityandTemperature.c,61 :: 		}
L_ReadByteDHT28:
;HumidityandTemperature.c,62 :: 		TMR2=0;                                                             // Reseta o timer 0;
	CLRF       TMR2+0
;HumidityandTemperature.c,63 :: 		if (overflow) break;
	MOVF       _overflow+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_ReadByteDHT29
	GOTO       L_ReadByteDHT18
L_ReadByteDHT29:
;HumidityandTemperature.c,53 :: 		for (i=1;i<=8;i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;HumidityandTemperature.c,64 :: 		}
	GOTO       L_ReadByteDHT17
L_ReadByteDHT18:
;HumidityandTemperature.c,65 :: 		return buffer;
	MOVF       _buffer+0, 0
	MOVWF      R0+0
;HumidityandTemperature.c,66 :: 		}
L_end_ReadByteDHT:
	RETURN
; end of _ReadByteDHT

_main:

;HumidityandTemperature.c,69 :: 		void main() {
;HumidityandTemperature.c,75 :: 		ADCON1=0x06;                                                               // Todas as portas são digitais
	MOVLW      6
	MOVWF      ADCON1+0
;HumidityandTemperature.c,76 :: 		DHT_Direction=1;                                                           // Pino do DHT é input
	BSF        TRISD2_bit+0, BitPos(TRISD2_bit+0)
;HumidityandTemperature.c,79 :: 		Lcd_Init();                                                                // LCD é conectado ao PORTB
	CALL       _Lcd_Init+0
;HumidityandTemperature.c,80 :: 		Lcd_Cmd(_LCD_CLEAR);                                                       // Limpa o lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HumidityandTemperature.c,81 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HumidityandTemperature.c,84 :: 		T2CON=1;                                                                   // Timer 2 prescale 4; postscale 1; desligado T2CON.TMR2ON(liga o timer); 204.8us para overflow, incremento a cada 0.8us
	MOVLW      1
	MOVWF      T2CON+0
;HumidityandTemperature.c,85 :: 		PR2=0xFF;                                                                  // Periodo para overflow de 256 contagens do timer 2
	MOVLW      255
	MOVWF      PR2+0
;HumidityandTemperature.c,88 :: 		INTCON=0xC0;                                                               // Habilita as interrupções globais e as interrupções dos periféricos
	MOVLW      192
	MOVWF      INTCON+0
;HumidityandTemperature.c,89 :: 		PIE1.TMR2IE=1;                                                             // Habilita a interrupção pelo overflow do timer 2
	BSF        PIE1+0, 1
;HumidityandTemperature.c,92 :: 		delay_ms(2000);                                                            // Delay de 1s exigido pelo datasheet
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main30:
	DECFSZ     R13+0, 1
	GOTO       L_main30
	DECFSZ     R12+0, 1
	GOTO       L_main30
	DECFSZ     R11+0, 1
	GOTO       L_main30
	NOP
	NOP
;HumidityandTemperature.c,93 :: 		for(;;){
L_main31:
;HumidityandTemperature.c,94 :: 		WakeUpDHT();                                                            // MCU enviando sinal de start para acordar DHT
	CALL       _WakeUpDHT+0
;HumidityandTemperature.c,95 :: 		DHTcheck();                                                             // Verifica sinal de confirmação enviado pelo sensor
	CALL       _DHTcheck+0
;HumidityandTemperature.c,96 :: 		if (!overflow){
	MOVF       _overflow+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main34
;HumidityandTemperature.c,97 :: 		IntegralRH=ReadByteDHT();                                           // Lê a parte integral da umidade
	CALL       _ReadByteDHT+0
	MOVF       R0+0, 0
	MOVWF      main_IntegralRH_L0+0
;HumidityandTemperature.c,98 :: 		DecimalRH=ReadByteDHT();                                            // Lê a parte decimal da umidade
	CALL       _ReadByteDHT+0
	MOVF       R0+0, 0
	MOVWF      main_DecimalRH_L0+0
;HumidityandTemperature.c,99 :: 		IntegralT=ReadByteDHT();                                            // Lê a parte integral da temperatura
	CALL       _ReadByteDHT+0
	MOVF       R0+0, 0
	MOVWF      main_IntegralT_L0+0
;HumidityandTemperature.c,100 :: 		DecimalT=ReadByteDHT();                                             // Lê a parte decimal da temperatura
	CALL       _ReadByteDHT+0
	MOVF       R0+0, 0
	MOVWF      main_DecimalT_L0+0
;HumidityandTemperature.c,101 :: 		if (!overflow){;
	MOVF       _overflow+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;HumidityandTemperature.c,103 :: 		Lcd_Out(1,1,"HMTY=    ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_HumidityandTemperature+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,104 :: 		Lcd_Out(2,1,"TEMP=    ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_HumidityandTemperature+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,106 :: 		ByteTostr(IntegralRH,TXT);
	MOVF       main_IntegralRH_L0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;HumidityandTemperature.c,107 :: 		pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;HumidityandTemperature.c,108 :: 		Lcd_Out(1,6,pnt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,109 :: 		Lcd_Out(1,8,".");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_HumidityandTemperature+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,110 :: 		ByteTostr(DecimalRH,TXT);
	MOVF       main_DecimalRH_L0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;HumidityandTemperature.c,111 :: 		pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;HumidityandTemperature.c,112 :: 		Lcd_Out(1,9,pnt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,113 :: 		Lcd_Out(1,10,"%");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_HumidityandTemperature+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,116 :: 		ByteTostr(IntegralT,TXT);
	MOVF       main_IntegralT_L0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;HumidityandTemperature.c,117 :: 		pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;HumidityandTemperature.c,118 :: 		Lcd_Out(2,6,pnt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,119 :: 		Lcd_Out(2,8,".");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_HumidityandTemperature+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,120 :: 		ByteTostr(DecimalT,TXT);
	MOVF       main_DecimalT_L0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;HumidityandTemperature.c,121 :: 		pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;HumidityandTemperature.c,122 :: 		Lcd_Out(2,9,pnt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,123 :: 		TXT[0]=0b11011111;                                              // Símbolo º
	MOVLW      223
	MOVWF      main_TXT_L0+0
;HumidityandTemperature.c,124 :: 		TXT[1]='C';
	MOVLW      67
	MOVWF      main_TXT_L0+1
;HumidityandTemperature.c,125 :: 		TXT[2]=' ';
	MOVLW      32
	MOVWF      main_TXT_L0+2
;HumidityandTemperature.c,126 :: 		Lcd_Out(2,10,TXT);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_TXT_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,127 :: 		}
L_main35:
;HumidityandTemperature.c,128 :: 		}
L_main34:
;HumidityandTemperature.c,129 :: 		if (overflow){                                                          // Se ocorreu overflow do timer, resposta do sensor interrompida ou não recebida
	MOVF       _overflow+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main36
;HumidityandTemperature.c,130 :: 		Lcd_Cmd(_LCD_CLEAR);                                                    // Limpa o display LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HumidityandTemperature.c,131 :: 		Lcd_Out(1,1,"ERRO");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_HumidityandTemperature+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HumidityandTemperature.c,133 :: 		}
L_main36:
;HumidityandTemperature.c,134 :: 		overflow=0;                                                             // Reseta variável que indica que ocorreu overflow para realizar uma nova tentativa de comunicação
	CLRF       _overflow+0
;HumidityandTemperature.c,135 :: 		delay_ms(1500);                                                         // Delay necessário para o sensor coletar uma nova amostra
	MOVLW      39
	MOVWF      R11+0
	MOVLW      13
	MOVWF      R12+0
	MOVLW      38
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
	DECFSZ     R11+0, 1
	GOTO       L_main37
	NOP
;HumidityandTemperature.c,137 :: 		}
	GOTO       L_main31
;HumidityandTemperature.c,139 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
