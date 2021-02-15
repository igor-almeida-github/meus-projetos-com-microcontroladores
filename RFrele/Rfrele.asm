
_main:

;Rfrele.c,2 :: 		void main() {
;Rfrele.c,4 :: 		OSCCON=0x61;                                                                // HFINTOSC habilitado, frequência de clock de 4mhz
	MOVLW      97
	MOVWF      OSCCON+0
;Rfrele.c,5 :: 		ANSEL=0x00;                                                                 // Todas as portas são digitais AN0 até AN7
	CLRF       ANSEL+0
;Rfrele.c,6 :: 		ANSELH=0x02;                                                                // AN8, AN10, AN11, AN12, AN13 são digitais, AN9 é analógica (LDR)
	MOVLW      2
	MOVWF      ANSELH+0
;Rfrele.c,7 :: 		TRISB=0x1F;                                                                 // SER(dados), SRCLK(clock do SR) e RCLK(clock do latch) são OUTPUT, o resto é input
	MOVLW      31
	MOVWF      TRISB+0
;Rfrele.c,8 :: 		TRISC.RC2 = 0;                                                              // Pino de pwm para o transistor de controle do brilho dos leds
	BCF        TRISC+0, 2
;Rfrele.c,9 :: 		TRISA.RA1 = 0;
	BCF        TRISA+0, 1
;Rfrele.c,10 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	NOP
	NOP
;Rfrele.c,11 :: 		UART1_Init(2400);               // Initialize UART module at 9600 bps
	MOVLW      103
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Rfrele.c,12 :: 		PORTA.RA1 = 1;
	BSF        PORTA+0, 1
;Rfrele.c,13 :: 		receive = 0;
	CLRF       main_receive_L0+0
;Rfrele.c,14 :: 		for(;;){
L_main1:
;Rfrele.c,15 :: 		if (UART1_Data_Ready() == 1) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;Rfrele.c,16 :: 		receive = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_receive_L0+0
;Rfrele.c,17 :: 		}
L_main4:
;Rfrele.c,18 :: 		if (receive == 1){
	MOVF       main_receive_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;Rfrele.c,19 :: 		PORTA.RA1 = !PORTA.RA1;
	MOVLW      2
	XORWF      PORTA+0, 1
;Rfrele.c,20 :: 		if (PORTA.RA1){
	BTFSS      PORTA+0, 1
	GOTO       L_main6
;Rfrele.c,21 :: 		UART1_Write_Text("Desligado");
	MOVLW      ?lstr1_Rfrele+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Rfrele.c,22 :: 		}
	GOTO       L_main7
L_main6:
;Rfrele.c,24 :: 		UART1_Write_Text("Ligado");
	MOVLW      ?lstr2_Rfrele+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Rfrele.c,25 :: 		}
L_main7:
;Rfrele.c,26 :: 		UART1_Write(0x0D);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Rfrele.c,27 :: 		UART1_Write(0x0A);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Rfrele.c,28 :: 		}
L_main5:
;Rfrele.c,29 :: 		receive = 0;
	CLRF       main_receive_L0+0
;Rfrele.c,30 :: 		}
	GOTO       L_main1
;Rfrele.c,31 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
