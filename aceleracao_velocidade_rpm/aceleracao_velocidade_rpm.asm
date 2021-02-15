
_millis:

;aceleracao_velocidade_rpm.c,8 :: 		unsigned long millis(){
;aceleracao_velocidade_rpm.c,10 :: 		PIE1.TMR1IE=0;                                                                // Desabilita a interrupção do timer1
	BCF         PIE1+0, 0 
;aceleracao_velocidade_rpm.c,11 :: 		time=TMR1L;
	MOVF        TMR1L+0, 0 
	MOVWF       millis_time_L0+0 
	MOVLW       0
	MOVWF       millis_time_L0+1 
	MOVWF       millis_time_L0+2 
	MOVWF       millis_time_L0+3 
;aceleracao_velocidade_rpm.c,12 :: 		time+=(TMR1H<<8);
	MOVF        TMR1H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	ADDWF       millis_time_L0+0, 0 
	MOVWF       R5 
	MOVF        R1, 0 
	ADDWFC      millis_time_L0+1, 0 
	MOVWF       R6 
	MOVLW       0
	ADDWFC      millis_time_L0+2, 0 
	MOVWF       R7 
	MOVLW       0
	ADDWFC      millis_time_L0+3, 0 
	MOVWF       R8 
	MOVF        R5, 0 
	MOVWF       millis_time_L0+0 
	MOVF        R6, 0 
	MOVWF       millis_time_L0+1 
	MOVF        R7, 0 
	MOVWF       millis_time_L0+2 
	MOVF        R8, 0 
	MOVWF       millis_time_L0+3 
;aceleracao_velocidade_rpm.c,13 :: 		time+=(timeroverflow<<16);
	MOVF        _timeroverflow+1, 0 
	MOVWF       R3 
	MOVF        _timeroverflow+0, 0 
	MOVWF       R2 
	CLRF        R0 
	CLRF        R1 
	MOVF        R5, 0 
	ADDWF       R0, 1 
	MOVF        R6, 0 
	ADDWFC      R1, 1 
	MOVF        R7, 0 
	ADDWFC      R2, 1 
	MOVF        R8, 0 
	ADDWFC      R3, 1 
	MOVF        R0, 0 
	MOVWF       millis_time_L0+0 
	MOVF        R1, 0 
	MOVWF       millis_time_L0+1 
	MOVF        R2, 0 
	MOVWF       millis_time_L0+2 
	MOVF        R3, 0 
	MOVWF       millis_time_L0+3 
;aceleracao_velocidade_rpm.c,14 :: 		PIE1.TMR1IE=1;                                                                // Habilita a interrupção do timer1
	BSF         PIE1+0, 0 
;aceleracao_velocidade_rpm.c,15 :: 		time*=0.0016;
	CALL        _longword2double+0, 0
	MOVLW       23
	MOVWF       R4 
	MOVLW       183
	MOVWF       R5 
	MOVLW       81
	MOVWF       R6 
	MOVLW       117
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2longword+0, 0
	MOVF        R0, 0 
	MOVWF       millis_time_L0+0 
	MOVF        R1, 0 
	MOVWF       millis_time_L0+1 
	MOVF        R2, 0 
	MOVWF       millis_time_L0+2 
	MOVF        R3, 0 
	MOVWF       millis_time_L0+3 
;aceleracao_velocidade_rpm.c,16 :: 		return time;
;aceleracao_velocidade_rpm.c,17 :: 		}
L_end_millis:
	RETURN      0
; end of _millis

_interrupt:

;aceleracao_velocidade_rpm.c,19 :: 		void interrupt(void){
;aceleracao_velocidade_rpm.c,21 :: 		if ( INTCON.TMR0IF){                                                         // ocorreu overflow do timer 0
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;aceleracao_velocidade_rpm.c,22 :: 		elapsedTimeVel=0;
	CLRF        _elapsedTimeVel+0 
	CLRF        _elapsedTimeVel+1 
;aceleracao_velocidade_rpm.c,23 :: 		T0CON.TMR0ON=0;
	BCF         T0CON+0, 7 
;aceleracao_velocidade_rpm.c,25 :: 		CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
	CLRF        4055, 1
;aceleracao_velocidade_rpm.c,26 :: 		CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
	CLRF        4054, 1
;aceleracao_velocidade_rpm.c,27 :: 		BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
	BCF         4080, 1, 1
;aceleracao_velocidade_rpm.c,28 :: 		BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
	BCF         4082, 2, 1
;aceleracao_velocidade_rpm.c,30 :: 		}
L_interrupt0:
;aceleracao_velocidade_rpm.c,31 :: 		if( INTCON3.INT2IF){                                                          // borda de subida no pino INT0
	BTFSS       INTCON3+0, 1 
	GOTO        L_interrupt1
;aceleracao_velocidade_rpm.c,32 :: 		T0CON.TMR0ON=1;
	BSF         T0CON+0, 7 
;aceleracao_velocidade_rpm.c,33 :: 		elapsedTimeVel=TMR0L;
	MOVF        TMR0L+0, 0 
	MOVWF       _elapsedTimeVel+0 
	MOVLW       0
	MOVWF       _elapsedTimeVel+1 
;aceleracao_velocidade_rpm.c,34 :: 		elapsedTimeVel+=(TMR0H<<8);
	MOVF        TMR0H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	ADDWF       _elapsedTimeVel+0, 1 
	MOVF        R1, 0 
	ADDWFC      _elapsedTimeVel+1, 1 
;aceleracao_velocidade_rpm.c,36 :: 		CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
	CLRF        4055, 1
;aceleracao_velocidade_rpm.c,37 :: 		CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
	CLRF        4054, 1
;aceleracao_velocidade_rpm.c,38 :: 		BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
	BCF         4080, 1, 1
;aceleracao_velocidade_rpm.c,39 :: 		BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
	BCF         4082, 2, 1
;aceleracao_velocidade_rpm.c,41 :: 		}
L_interrupt1:
;aceleracao_velocidade_rpm.c,42 :: 		if(PIR1.TMR1IF){
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt2
;aceleracao_velocidade_rpm.c,43 :: 		timeroverflow++;
	MOVLW       1
	ADDWF       _timeroverflow+0, 1 
	MOVLW       0
	ADDWFC      _timeroverflow+1, 1 
	ADDWFC      _timeroverflow+2, 1 
	ADDWFC      _timeroverflow+3, 1 
;aceleracao_velocidade_rpm.c,44 :: 		PIR1.TMR1IF=0;
	BCF         PIR1+0, 0 
;aceleracao_velocidade_rpm.c,45 :: 		}
L_interrupt2:
;aceleracao_velocidade_rpm.c,47 :: 		if ( PIR2.TMR3IF){                                                         // ocorreu overflow do timer 0
	BTFSS       PIR2+0, 1 
	GOTO        L_interrupt3
;aceleracao_velocidade_rpm.c,48 :: 		elapsedTimeRpm=0;
	CLRF        _elapsedTimeRpm+0 
	CLRF        _elapsedTimeRpm+1 
;aceleracao_velocidade_rpm.c,49 :: 		T3CON.TMR3ON=0;
	BCF         T3CON+0, 0 
;aceleracao_velocidade_rpm.c,50 :: 		INTCON3.INT1IF=0;
	BCF         INTCON3+0, 0 
;aceleracao_velocidade_rpm.c,51 :: 		TMR3H=0;
	CLRF        TMR3H+0 
;aceleracao_velocidade_rpm.c,52 :: 		TMR3L=0;
	CLRF        TMR3L+0 
;aceleracao_velocidade_rpm.c,53 :: 		PIR2.TMR3IF=0;
	BCF         PIR2+0, 1 
;aceleracao_velocidade_rpm.c,54 :: 		}
L_interrupt3:
;aceleracao_velocidade_rpm.c,56 :: 		if(INTCON3.INT1IF){
	BTFSS       INTCON3+0, 0 
	GOTO        L_interrupt4
;aceleracao_velocidade_rpm.c,57 :: 		T3CON.TMR3ON=1;
	BSF         T3CON+0, 0 
;aceleracao_velocidade_rpm.c,58 :: 		elapsedTimeRpm=TMR3L;
	MOVF        TMR3L+0, 0 
	MOVWF       _elapsedTimeRpm+0 
	MOVLW       0
	MOVWF       _elapsedTimeRpm+1 
;aceleracao_velocidade_rpm.c,59 :: 		elapsedTimeRpm+=(TMR3H<<8);
	MOVF        TMR3H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	ADDWF       _elapsedTimeRpm+0, 1 
	MOVF        R1, 0 
	ADDWFC      _elapsedTimeRpm+1, 1 
;aceleracao_velocidade_rpm.c,60 :: 		INTCON3.INT1IF=0;
	BCF         INTCON3+0, 0 
;aceleracao_velocidade_rpm.c,61 :: 		TMR3H=0;
	CLRF        TMR3H+0 
;aceleracao_velocidade_rpm.c,62 :: 		TMR3L=0;
	CLRF        TMR3L+0 
;aceleracao_velocidade_rpm.c,63 :: 		PIR2.TMR3IF=0;
	BCF         PIR2+0, 1 
;aceleracao_velocidade_rpm.c,64 :: 		}
L_interrupt4:
;aceleracao_velocidade_rpm.c,67 :: 		}
L_end_interrupt:
L__interrupt15:
	RETFIE      1
; end of _interrupt

_main:

;aceleracao_velocidade_rpm.c,69 :: 		void main() {
;aceleracao_velocidade_rpm.c,74 :: 		unsigned long ontime=0;
	CLRF        main_ontime_L0+0 
	CLRF        main_ontime_L0+1 
	CLRF        main_ontime_L0+2 
	CLRF        main_ontime_L0+3 
	CLRF        main_rpm_L0+0 
	CLRF        main_rpm_L0+1 
	CLRF        main_rpm_L0+2 
	CLRF        main_rpm_L0+3 
;aceleracao_velocidade_rpm.c,77 :: 		pnt = &ontime;                                                           // Recebe o endereço do primeiro byte de ontime
	MOVLW       main_ontime_L0+0
	MOVWF       main_pnt_L0+0 
	MOVLW       hi_addr(main_ontime_L0+0)
	MOVWF       main_pnt_L0+1 
;aceleracao_velocidade_rpm.c,79 :: 		ADCON1=0x0F;                                                             // Configuração de todas as portas como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;aceleracao_velocidade_rpm.c,80 :: 		UART1_Init(57600);                                                       // Inicializa a UART, 57600 de baud rate
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       86
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;aceleracao_velocidade_rpm.c,81 :: 		TRISB.RB2=1;                                                             // Int2 é input(velocidade)
	BSF         TRISB+0, 2 
;aceleracao_velocidade_rpm.c,82 :: 		TRISB.RB1=1;                                                             // Int1 é input(rpm)
	BSF         TRISB+0, 1 
;aceleracao_velocidade_rpm.c,83 :: 		Delay_ms(400);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
	NOP
;aceleracao_velocidade_rpm.c,92 :: 		INTCON=0xE0;                                                             // Habilita a interrupções gerais e a interrupção pelo overflow do timer 0, habilita interrupção dos periféricos
	MOVLW       224
	MOVWF       INTCON+0 
;aceleracao_velocidade_rpm.c,93 :: 		INTCON2.INTEDG2=1;                                                       // Interrupção na borda de subida do pino INT2 (velocidade)
	BSF         INTCON2+0, 4 
;aceleracao_velocidade_rpm.c,94 :: 		INTCON.INTEDG1=1;                                                        // Interrupção na borda de subida do pino INT1 (rotação)
	BSF         INTCON+0, 5 
;aceleracao_velocidade_rpm.c,95 :: 		PIE1.TMR1IE=1;                                                           // Habilita a interrupção do timer1
	BSF         PIE1+0, 0 
;aceleracao_velocidade_rpm.c,96 :: 		INTCON3.INT2IE=1;                                                        // Habilita a interrupção do int2 (velocidade)
	BSF         INTCON3+0, 4 
;aceleracao_velocidade_rpm.c,97 :: 		INTCON3.INT1IE=1;                                                        // Habilita a interrupção do int1 (rotação)
	BSF         INTCON3+0, 3 
;aceleracao_velocidade_rpm.c,98 :: 		PIE2.TMR3IE=1;                                                           // Habilita a interrupção do timer 3  (rotação)
	BSF         PIE2+0, 1 
;aceleracao_velocidade_rpm.c,100 :: 		T0CON=0x06;                                                              // Timer0 no modo de 16 bits, prescale 128  //fazer T0CON.TMR0ON=1 para disparar o timer
	MOVLW       6
	MOVWF       T0CON+0 
;aceleracao_velocidade_rpm.c,101 :: 		T0CON.TMR0ON=1;                                                          // Dispara o timer0
	BSF         T0CON+0, 7 
;aceleracao_velocidade_rpm.c,102 :: 		T1CON=0xB5;                                                              // timer 1 no modo de 16 bits, prescale de 8, disparado
	MOVLW       181
	MOVWF       T1CON+0 
;aceleracao_velocidade_rpm.c,103 :: 		T3CON=0xBD;                                                              // Time 3 no modo de 16 bits, prescale de 8, disparado
	MOVLW       189
	MOVWF       T3CON+0 
;aceleracao_velocidade_rpm.c,104 :: 		for(;;){
L_main6:
;aceleracao_velocidade_rpm.c,107 :: 		ontime=millis();
	CALL        _millis+0, 0
	MOVF        R0, 0 
	MOVWF       main_ontime_L0+0 
	MOVF        R1, 0 
	MOVWF       main_ontime_L0+1 
	MOVF        R2, 0 
	MOVWF       main_ontime_L0+2 
	MOVF        R3, 0 
	MOVWF       main_ontime_L0+3 
;aceleracao_velocidade_rpm.c,111 :: 		if ( elapsedTimeVel!=0){
	MOVLW       0
	XORWF       _elapsedTimeVel+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main17
	MOVLW       0
	XORWF       _elapsedTimeVel+0, 0 
L__main17:
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
;aceleracao_velocidade_rpm.c,112 :: 		kmh=elapsedTimeVel;
	MOVF        _elapsedTimeVel+0, 0 
	MOVWF       main_kmh_L0+0 
;aceleracao_velocidade_rpm.c,113 :: 		}
	GOTO        L_main10
L_main9:
;aceleracao_velocidade_rpm.c,114 :: 		else kmh=0;
	CLRF        main_kmh_L0+0 
L_main10:
;aceleracao_velocidade_rpm.c,116 :: 		if ( elapsedTimeRpm!=0){
	MOVLW       0
	XORWF       _elapsedTimeRpm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main18
	MOVLW       0
	XORWF       _elapsedTimeRpm+0, 0 
L__main18:
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
;aceleracao_velocidade_rpm.c,117 :: 		rpm=(elapsedTimeRpm);
	MOVF        _elapsedTimeRpm+0, 0 
	MOVWF       R0 
	MOVF        _elapsedTimeRpm+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        R0, 0 
	MOVWF       main_rpm_L0+0 
	MOVF        R1, 0 
	MOVWF       main_rpm_L0+1 
	MOVF        R2, 0 
	MOVWF       main_rpm_L0+2 
	MOVF        R3, 0 
	MOVWF       main_rpm_L0+3 
;aceleracao_velocidade_rpm.c,118 :: 		}
	GOTO        L_main12
L_main11:
;aceleracao_velocidade_rpm.c,119 :: 		else rpm=0;
	CLRF        main_rpm_L0+0 
	CLRF        main_rpm_L0+1 
	CLRF        main_rpm_L0+2 
	CLRF        main_rpm_L0+3 
L_main12:
;aceleracao_velocidade_rpm.c,122 :: 		UART1_Write(*(&rpm+1));
	MOVF        main_rpm_L0+4, 0 
	MOVWF       R0 
	MOVF        main_rpm_L0+5, 0 
	MOVWF       R1 
	MOVF        main_rpm_L0+6, 0 
	MOVWF       R2 
	MOVF        main_rpm_L0+7, 0 
	MOVWF       R3 
	CALL        _double2byte+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,123 :: 		UART1_Write(*(&rpm));
	MOVF        main_rpm_L0+0, 0 
	MOVWF       R0 
	MOVF        main_rpm_L0+1, 0 
	MOVWF       R1 
	MOVF        main_rpm_L0+2, 0 
	MOVWF       R2 
	MOVF        main_rpm_L0+3, 0 
	MOVWF       R3 
	CALL        _double2byte+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,124 :: 		UART1_Write(*(&kmh+1));
	MOVF        main_kmh_L0+1, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,125 :: 		UART1_Write(*(&kmh));
	MOVF        main_kmh_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,126 :: 		UART1_Write(*(pnt+3));                                             // Byte mais significativo de ontime
	MOVLW       3
	ADDWF       main_pnt_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_pnt_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,127 :: 		UART1_Write(*(pnt+2));
	MOVLW       2
	ADDWF       main_pnt_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_pnt_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,128 :: 		UART1_Write(*(pnt+1));
	MOVLW       1
	ADDWF       main_pnt_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_pnt_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,129 :: 		UART1_Write(*pnt);                                                 // Byte menos significativo de ontime
	MOVFF       main_pnt_L0+0, FSR0
	MOVFF       main_pnt_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,130 :: 		UART1_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,131 :: 		UART1_Write(0x0A);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;aceleracao_velocidade_rpm.c,132 :: 		}
	GOTO        L_main6
;aceleracao_velocidade_rpm.c,134 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
