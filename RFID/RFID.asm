
_mssp_SPI_init:

;RFID.c,20 :: 		void mssp_SPI_init(){                                                           // Função que inicializa a mssp pra trabalhar com comunicação SPI
;RFID.c,27 :: 		TRISC.RC5   = 0;                                                            // SDO é OUTPUT
	BCF        TRISC+0, 5
;RFID.c,28 :: 		TRISC.RC3   = 0;                                                            // SCK é OUTPUT
	BCF        TRISC+0, 3
;RFID.c,29 :: 		SSPSTAT.SMP = 0;                                                            // Dados de entrada são amostrados no meio do tempo dos dados de saída
	BCF        SSPSTAT+0, 7
;RFID.c,30 :: 		SSPSTAT.CKE = 0;                                                            // A transmissão ocorre na transição do estado do clock ocioso para ativo
	BCF        SSPSTAT+0, 6
;RFID.c,31 :: 		SSPCON      = 0x32;                                                         // Habilita os pinos da SSP, clock ocioso em HIGH level, Master Mode Fosc/64
	MOVLW      50
	MOVWF      SSPCON+0
;RFID.c,32 :: 		}
L_end_mssp_SPI_init:
	RETURN
; end of _mssp_SPI_init

_SpiWrite:

;RFID.c,34 :: 		void SpiWrite(unsigned char SPIData){
;RFID.c,35 :: 		while(!SS);                                                                 // Aguarda enquanto a transmissão/recepção anterior não tiver terminado
L_SpiWrite0:
	BTFSC      PORTD+0, 0
	GOTO       L_SpiWrite1
	GOTO       L_SpiWrite0
L_SpiWrite1:
;RFID.c,36 :: 		SS=0;                                                                       // Slave selecionado
	BCF        PORTD+0, 0
;RFID.c,37 :: 		SSPBUF=SPIData;                                                             // Inicia nova transmissão/Recepção
	MOVF       FARG_SpiWrite_SPIData+0, 0
	MOVWF      SSPBUF+0
;RFID.c,38 :: 		}
L_end_SpiWrite:
	RETURN
; end of _SpiWrite

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;RFID.c,40 :: 		void interrupt (void){
;RFID.c,41 :: 		if (PIR1.SSPIF){
	BTFSS      PIR1+0, 3
	GOTO       L_interrupt2
;RFID.c,42 :: 		PIR1.SSPIF = 0;                                                         // Limpa a flag de interrupção da SSP
	BCF        PIR1+0, 3
;RFID.c,43 :: 		SS         = 1;                                                         // Slave não selecionado
	BSF        PORTD+0, 0
;RFID.c,44 :: 		}
L_interrupt2:
;RFID.c,45 :: 		}
L_end_interrupt:
L__interrupt14:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;RFID.c,48 :: 		void main() {
;RFID.c,50 :: 		Lcd_Init();                                                                // Inicializa o LCD
	CALL       _Lcd_Init+0
;RFID.c,51 :: 		TRISD.RD0  = 0;                                                            // SS é OUTPUT
	BCF        TRISD+0, 0
;RFID.c,52 :: 		SS         = 1;                                                            // Slave não selecionado
	BSF        PORTD+0, 0
;RFID.c,53 :: 		ADCON1     = 0x07;                                                         // Todas as portas são digitais
	MOVLW      7
	MOVWF      ADCON1+0
;RFID.c,54 :: 		mssp_SPI_init();                                                           // Inicializa a mssp para comunicação SPI
	CALL       _mssp_SPI_init+0
;RFID.c,55 :: 		Uart1_init(9600);                                                          // Inicializa o módulo UART com 9600 de baud rate
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;RFID.c,57 :: 		INTCON     = 0xC0;                                                         // Interrupções globais habilitadas, Interrupções dos periféricos habilitadas
	MOVLW      192
	MOVWF      INTCON+0
;RFID.c,58 :: 		PIE1.SSPIE = 1;                                                            // Habilita interrução do módulo MSSP
	BSF        PIE1+0, 3
;RFID.c,60 :: 		delay_ms(2000);
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
	NOP
;RFID.c,62 :: 		for(;;){                                                                   // Loop infinito
L_main4:
;RFID.c,63 :: 		while(!UART1_Data_Ready());                                            // Espera um byte chegar na UART
L_main7:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main8
	GOTO       L_main7
L_main8:
;RFID.c,64 :: 		SpiWrite(UART1_Read());
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      FARG_SpiWrite_SPIData+0
	CALL       _SpiWrite+0
;RFID.c,65 :: 		while(!SS);
L_main9:
	BTFSC      PORTD+0, 0
	GOTO       L_main10
	GOTO       L_main9
L_main10:
;RFID.c,66 :: 		UART1_Write(SSPBUF);
	MOVF       SSPBUF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;RFID.c,67 :: 		}
	GOTO       L_main4
;RFID.c,69 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
