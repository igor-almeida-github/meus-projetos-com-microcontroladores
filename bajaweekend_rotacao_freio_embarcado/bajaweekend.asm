
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;bajaweekend.c,5 :: 		void interrupt(void){
;bajaweekend.c,6 :: 		if(INTCON.INTF){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;bajaweekend.c,7 :: 		motor++;                                                               // Conta o número de voltas do motor
	MOVF       _motor+0, 0
	MOVWF      R0+0
	MOVF       _motor+1, 0
	MOVWF      R0+1
	MOVF       _motor+2, 0
	MOVWF      R0+2
	MOVF       _motor+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _motor+0
	MOVF       R0+1, 0
	MOVWF      _motor+1
	MOVF       R0+2, 0
	MOVWF      _motor+2
	MOVF       R0+3, 0
	MOVWF      _motor+3
;bajaweekend.c,8 :: 		INTCON.INTF = 0;
	BCF        INTCON+0, 1
;bajaweekend.c,9 :: 		}
L_interrupt0:
;bajaweekend.c,10 :: 		if(PIR1.TMR1IF){                                                           // Lê o estado do tanque 1 vez a cada 65.536 ms
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt1
;bajaweekend.c,11 :: 		if (PORTB.RB3) full++;
	BTFSS      PORTB+0, 3
	GOTO       L_interrupt2
	INCF       _full+0, 1
	GOTO       L_interrupt3
L_interrupt2:
;bajaweekend.c,12 :: 		else empty++;
	INCF       _empty+0, 1
L_interrupt3:
;bajaweekend.c,13 :: 		if ( empty + full > 77){                                               // Após 77 amostras (aproximadamente 5 segundos)
	MOVF       _full+0, 0
	ADDWF      _empty+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt22
	MOVF       R1+0, 0
	SUBLW      77
L__interrupt22:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt4
;bajaweekend.c,14 :: 		if (empty > full) tank = 0;                                        // Se a maior parte das amstras indicar que está vazio, então o tanque está vazio
	MOVF       _empty+0, 0
	SUBWF      _full+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt5
	CLRF       _tank+0
	GOTO       L_interrupt6
L_interrupt5:
;bajaweekend.c,15 :: 		else tank = 1;                                                     // Caso contrário, está cheio
	MOVLW      1
	MOVWF      _tank+0
L_interrupt6:
;bajaweekend.c,16 :: 		empty = 0;
	CLRF       _empty+0
;bajaweekend.c,17 :: 		full = 0;
	CLRF       _full+0
;bajaweekend.c,18 :: 		}
L_interrupt4:
;bajaweekend.c,19 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;bajaweekend.c,20 :: 		}
L_interrupt1:
;bajaweekend.c,21 :: 		}
L_end_interrupt:
L__interrupt21:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;bajaweekend.c,23 :: 		void main() {
;bajaweekend.c,25 :: 		unsigned char anterior = 0;
	CLRF       main_anterior_L0+0
	CLRF       main_freio_L0+0
	CLRF       main_freio_L0+1
;bajaweekend.c,27 :: 		PCON.OSCF = 1;                                                           // 4 MHZ interno
	BSF        PCON+0, 3
;bajaweekend.c,28 :: 		OPTION_REG.INTEDG = 0;
	BCF        OPTION_REG+0, 6
;bajaweekend.c,29 :: 		INTCON = 0xD0;                                                           // Gie habilitado, Interrupções dos periféricos habilitadas, INT habilitado
	MOVLW      208
	MOVWF      INTCON+0
;bajaweekend.c,30 :: 		PIE1 = 0x01;                                                             // Habilita interrupção pelo overflow do timer 1
	MOVLW      1
	MOVWF      PIE1+0
;bajaweekend.c,31 :: 		T1CON = 0x01;                                                            // Dispara o timer 1 com prescale de 1, overflow a cada 65.536 ms
	MOVLW      1
	MOVWF      T1CON+0
;bajaweekend.c,32 :: 		UART1_Init(1200);
	MOVLW      207
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;bajaweekend.c,33 :: 		for(;;){
L_main7:
;bajaweekend.c,34 :: 		if ((PORTB.RB5 == 1) && (anterior == 0)){                            // Borda de subida do freio detectada, switch debounce
	BTFSS      PORTB+0, 5
	GOTO       L_main12
	MOVF       main_anterior_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main12
L__main19:
;bajaweekend.c,35 :: 		freio++;
	INCF       main_freio_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_freio_L0+1, 1
;bajaweekend.c,36 :: 		anterior = 1;
	MOVLW      1
	MOVWF      main_anterior_L0+0
;bajaweekend.c,37 :: 		delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	NOP
	NOP
;bajaweekend.c,38 :: 		}
L_main12:
;bajaweekend.c,39 :: 		if ((PORTB.RB5 == 0) && (anterior == 1)){                            // Borda de descida do freio detectada, switch debounce
	BTFSC      PORTB+0, 5
	GOTO       L_main16
	MOVF       main_anterior_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main16
L__main18:
;bajaweekend.c,40 :: 		anterior = 0;
	CLRF       main_anterior_L0+0
;bajaweekend.c,41 :: 		delay_ms(7);
	MOVLW      10
	MOVWF      R12+0
	MOVLW      21
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	NOP
	NOP
;bajaweekend.c,42 :: 		}
L_main16:
;bajaweekend.c,43 :: 		INTCON.GIE = 0;
	BCF        INTCON+0, 7
;bajaweekend.c,44 :: 		motor_2 = motor;                                                     // Variável buffer, para não ocorrer mudança na variável que conta o numero de giros durante a transmissão, uma vez que a variável motor pode ser alterada a qualquer momento
	MOVF       _motor+0, 0
	MOVWF      main_motor_2_L0+0
	MOVF       _motor+1, 0
	MOVWF      main_motor_2_L0+1
	MOVF       _motor+2, 0
	MOVWF      main_motor_2_L0+2
	MOVF       _motor+3, 0
	MOVWF      main_motor_2_L0+3
;bajaweekend.c,45 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;bajaweekend.c,48 :: 		UART1_Write(*((unsigned char*)&motor_2+3));
	MOVF       main_motor_2_L0+3, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,49 :: 		UART1_Write(*((unsigned char*)&motor_2+2));
	MOVF       main_motor_2_L0+2, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,50 :: 		UART1_Write(*((unsigned char*)&motor_2+1));
	MOVF       main_motor_2_L0+1, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,51 :: 		UART1_Write(*((unsigned char*)&motor_2));
	MOVF       main_motor_2_L0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,53 :: 		UART1_Write(*((unsigned char*)&freio+1));
	MOVF       main_freio_L0+1, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,54 :: 		UART1_Write(*((unsigned char*)&freio));
	MOVF       main_freio_L0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,56 :: 		UART1_Write(tank);
	MOVF       _tank+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,58 :: 		UART1_Write(0x0D);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,59 :: 		UART1_Write(0x0A);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;bajaweekend.c,61 :: 		}
	GOTO       L_main7
;bajaweekend.c,63 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
