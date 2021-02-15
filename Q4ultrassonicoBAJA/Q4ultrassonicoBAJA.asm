
_millis:

;Q4ultrassonicoBAJA.c,27 :: 		unsigned long millis(){
;Q4ultrassonicoBAJA.c,29 :: 		INTCON.TMR0IE=0;                                                              // Desabilita a interrupção do timer0
	BCF        INTCON+0, 5
;Q4ultrassonicoBAJA.c,30 :: 		time=TMR0+(timeroverflow<<8);
	MOVF       _timeroverflow+2, 0
	MOVWF      R4+3
	MOVF       _timeroverflow+1, 0
	MOVWF      R4+2
	MOVF       _timeroverflow+0, 0
	MOVWF      R4+1
	CLRF       R4+0
	MOVF       TMR0+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R4+0, 0
	ADDWF      R0+0, 1
	MOVF       R4+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+1, 0
	ADDWF      R0+1, 1
	MOVF       R4+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+2, 0
	ADDWF      R0+2, 1
	MOVF       R4+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+3, 0
	ADDWF      R0+3, 1
;Q4ultrassonicoBAJA.c,31 :: 		INTCON.TMR0IE=1;                                                              // Habilita a interrupção do timer0
	BSF        INTCON+0, 5
;Q4ultrassonicoBAJA.c,32 :: 		time*=0.0512;
	CALL       _longword2double+0
	MOVLW      23
	MOVWF      R4+0
	MOVLW      183
	MOVWF      R4+1
	MOVLW      81
	MOVWF      R4+2
	MOVLW      122
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2longword+0
;Q4ultrassonicoBAJA.c,33 :: 		return time;
;Q4ultrassonicoBAJA.c,34 :: 		}
L_end_millis:
	RETURN
; end of _millis

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Q4ultrassonicoBAJA.c,36 :: 		void interrupt(){
;Q4ultrassonicoBAJA.c,37 :: 		if (INTCON.RBIF){                                                        // Interrupção gerada pela mudança de estado do PORTB;
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt0
;Q4ultrassonicoBAJA.c,38 :: 		INTCON.RBIF=0;
	BCF        INTCON+0, 0
;Q4ultrassonicoBAJA.c,39 :: 		if (ECHO1==0 && flagEcho1==1){
	BTFSC      PORTB+0, 4
	GOTO       L_interrupt3
	BTFSS      _flags+0, 0
	GOTO       L_interrupt3
L__interrupt44:
;Q4ultrassonicoBAJA.c,40 :: 		flagEcho1=0;
	BCF        _flags+0, 0
;Q4ultrassonicoBAJA.c,41 :: 		T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para não gerar erro na leitura
	BCF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,42 :: 		high_level_time1=TMR1L+(TMR1H<<8);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	ADDWF      TMR1L+0, 0
	MOVWF      _high_level_time1+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _high_level_time1+1
;Q4ultrassonicoBAJA.c,43 :: 		T1CON.TMR1ON=1;                                                   // Religa o timer
	BSF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,44 :: 		}
L_interrupt3:
;Q4ultrassonicoBAJA.c,46 :: 		if (ECHO2==0 && flagEcho2==1){
	BTFSC      PORTB+0, 5
	GOTO       L_interrupt6
	BTFSS      _flags+0, 1
	GOTO       L_interrupt6
L__interrupt43:
;Q4ultrassonicoBAJA.c,47 :: 		flagEcho2=0;
	BCF        _flags+0, 1
;Q4ultrassonicoBAJA.c,48 :: 		T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para não gerar erro na leitura
	BCF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,49 :: 		high_level_time2=TMR1L+(TMR1H<<8);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	ADDWF      TMR1L+0, 0
	MOVWF      _high_level_time2+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _high_level_time2+1
;Q4ultrassonicoBAJA.c,50 :: 		T1CON.TMR1ON=1;                                                   // Religa o timer
	BSF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,51 :: 		}
L_interrupt6:
;Q4ultrassonicoBAJA.c,53 :: 		if (ECHO3==0 && flagEcho3==1){
	BTFSC      PORTB+0, 6
	GOTO       L_interrupt9
	BTFSS      _flags+0, 2
	GOTO       L_interrupt9
L__interrupt42:
;Q4ultrassonicoBAJA.c,54 :: 		flagEcho3=0;
	BCF        _flags+0, 2
;Q4ultrassonicoBAJA.c,55 :: 		T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para não gerar erro na leitura
	BCF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,56 :: 		high_level_time3=TMR1L+(TMR1H<<8);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	ADDWF      TMR1L+0, 0
	MOVWF      _high_level_time3+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _high_level_time3+1
;Q4ultrassonicoBAJA.c,57 :: 		T1CON.TMR1ON=1;                                                   // Religa o timer
	BSF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,58 :: 		}
L_interrupt9:
;Q4ultrassonicoBAJA.c,60 :: 		if (ECHO4==0 && flagEcho4==1){
	BTFSC      PORTB+0, 7
	GOTO       L_interrupt12
	BTFSS      _flags+0, 3
	GOTO       L_interrupt12
L__interrupt41:
;Q4ultrassonicoBAJA.c,61 :: 		flagEcho4=0;
	BCF        _flags+0, 3
;Q4ultrassonicoBAJA.c,62 :: 		T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para não gerar erro na leitura
	BCF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,63 :: 		high_level_time4=TMR1L+(TMR1H<<8);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	ADDWF      TMR1L+0, 0
	MOVWF      _high_level_time4+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _high_level_time4+1
;Q4ultrassonicoBAJA.c,64 :: 		T1CON.TMR1ON=1;                                                   // Religa o timer
	BSF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,65 :: 		}
L_interrupt12:
;Q4ultrassonicoBAJA.c,66 :: 		}
	GOTO       L_interrupt13
L_interrupt0:
;Q4ultrassonicoBAJA.c,67 :: 		else if (PIR1.TMR1IF){                                                   // Interrupção gerada pelo overflow do timer 1;
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt14
;Q4ultrassonicoBAJA.c,68 :: 		PIR1.TMR1IF=0;
	BCF        PIR1+0, 0
;Q4ultrassonicoBAJA.c,69 :: 		if (flagEcho1) high_level_time1=0;                                   // Se o echo1 demorar demais para ser recebido e o timer estourar
	BTFSS      _flags+0, 0
	GOTO       L_interrupt15
	CLRF       _high_level_time1+0
	CLRF       _high_level_time1+1
L_interrupt15:
;Q4ultrassonicoBAJA.c,70 :: 		if (flagEcho2) high_level_time2=0;                                   // Se o echo2 demorar demais para ser recebido e o timer estourar
	BTFSS      _flags+0, 1
	GOTO       L_interrupt16
	CLRF       _high_level_time2+0
	CLRF       _high_level_time2+1
L_interrupt16:
;Q4ultrassonicoBAJA.c,71 :: 		if (flagEcho3) high_level_time3=0;                                   // Se o echo3 demorar demais para ser recebido e o timer estourar
	BTFSS      _flags+0, 2
	GOTO       L_interrupt17
	CLRF       _high_level_time3+0
	CLRF       _high_level_time3+1
L_interrupt17:
;Q4ultrassonicoBAJA.c,72 :: 		if (flagEcho4) high_level_time4=0;                                   // Se o echo4 demorar demais para ser recebido e o timer estourar
	BTFSS      _flags+0, 3
	GOTO       L_interrupt18
	CLRF       _high_level_time4+0
	CLRF       _high_level_time4+1
L_interrupt18:
;Q4ultrassonicoBAJA.c,73 :: 		flags=0;
	CLRF       _flags+0
;Q4ultrassonicoBAJA.c,74 :: 		}
L_interrupt14:
L_interrupt13:
;Q4ultrassonicoBAJA.c,75 :: 		if(INTCON.TMR0IF){                                                       // Ocorreu overflow do timer 0
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt19
;Q4ultrassonicoBAJA.c,76 :: 		INTCON.TMR0IF=0;
	BCF        INTCON+0, 2
;Q4ultrassonicoBAJA.c,77 :: 		timeroverflow++;
	MOVF       _timeroverflow+0, 0
	MOVWF      R0+0
	MOVF       _timeroverflow+1, 0
	MOVWF      R0+1
	MOVF       _timeroverflow+2, 0
	MOVWF      R0+2
	MOVF       _timeroverflow+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _timeroverflow+0
	MOVF       R0+1, 0
	MOVWF      _timeroverflow+1
	MOVF       R0+2, 0
	MOVWF      _timeroverflow+2
	MOVF       R0+3, 0
	MOVWF      _timeroverflow+3
;Q4ultrassonicoBAJA.c,78 :: 		}
L_interrupt19:
;Q4ultrassonicoBAJA.c,79 :: 		}
L_end_interrupt:
L__interrupt50:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Q4ultrassonicoBAJA.c,81 :: 		void main() {
;Q4ultrassonicoBAJA.c,84 :: 		float Test_distance_1_Cm=0;
	CLRF       main_Test_distance_1_Cm_L0+0
	CLRF       main_Test_distance_1_Cm_L0+1
	CLRF       main_Test_distance_1_Cm_L0+2
	CLRF       main_Test_distance_1_Cm_L0+3
	CLRF       main_Test_distance_2_Cm_L0+0
	CLRF       main_Test_distance_2_Cm_L0+1
	CLRF       main_Test_distance_2_Cm_L0+2
	CLRF       main_Test_distance_2_Cm_L0+3
	CLRF       main_Test_distance_3_Cm_L0+0
	CLRF       main_Test_distance_3_Cm_L0+1
	CLRF       main_Test_distance_3_Cm_L0+2
	CLRF       main_Test_distance_3_Cm_L0+3
	CLRF       main_Test_distance_4_Cm_L0+0
	CLRF       main_Test_distance_4_Cm_L0+1
	CLRF       main_Test_distance_4_Cm_L0+2
	CLRF       main_Test_distance_4_Cm_L0+3
;Q4ultrassonicoBAJA.c,91 :: 		UART1_Init(57600);
	MOVLW      21
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Q4ultrassonicoBAJA.c,92 :: 		ADCON1=0x0E;                                                               //configuração de portas como digitais - AN0 é analógica
	MOVLW      14
	MOVWF      ADCON1+0
;Q4ultrassonicoBAJA.c,93 :: 		TRISC.RC0=0;                                                               // TRIG1 é output
	BCF        TRISC+0, 0
;Q4ultrassonicoBAJA.c,94 :: 		TRISB.RB4=1;                                                               // ECHO1 é input
	BSF        TRISB+0, 4
;Q4ultrassonicoBAJA.c,95 :: 		TRISC.RC1=0;                                                               // TRIG2 é output
	BCF        TRISC+0, 1
;Q4ultrassonicoBAJA.c,96 :: 		TRISB.RB5=1;                                                               // ECHO2 é input
	BSF        TRISB+0, 5
;Q4ultrassonicoBAJA.c,97 :: 		TRISC.RC2=0;                                                               // TRIG3 é output
	BCF        TRISC+0, 2
;Q4ultrassonicoBAJA.c,98 :: 		TRISB.RB6=1;                                                               // ECHO3 é input
	BSF        TRISB+0, 6
;Q4ultrassonicoBAJA.c,99 :: 		TRISC.RC3=0;                                                               // TRIG4 é output
	BCF        TRISC+0, 3
;Q4ultrassonicoBAJA.c,100 :: 		TRISB.RB7=1;                                                               // ECHO4 é input
	BSF        TRISB+0, 7
;Q4ultrassonicoBAJA.c,101 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
	NOP
;Q4ultrassonicoBAJA.c,102 :: 		TRIG1=0;
	BCF        PORTC+0, 0
;Q4ultrassonicoBAJA.c,105 :: 		T1CON=0x30;                                                                // timer 1 prescale 8,clock interno, timer parado
	MOVLW      48
	MOVWF      T1CON+0
;Q4ultrassonicoBAJA.c,106 :: 		OPTION_REG=0xC7;                                                           // timer 0 prescale de 256, 8 bits
	MOVLW      199
	MOVWF      OPTION_REG+0
;Q4ultrassonicoBAJA.c,108 :: 		INTCON=0xE8;                                                               // interrupções globais habilitadas, interrupções dos perifericos habilitadas, interrupção por mudança de estado do port b habilitada, interrupção por overflow do timer 0 habilitada
	MOVLW      232
	MOVWF      INTCON+0
;Q4ultrassonicoBAJA.c,109 :: 		PIE1=0x01;                                                                 // interrupção do timer 1 habilitada
	MOVLW      1
	MOVWF      PIE1+0
;Q4ultrassonicoBAJA.c,111 :: 		for (;;){ //******************LOOP*****************************************
L_main21:
;Q4ultrassonicoBAJA.c,112 :: 		flags=0x00;
	CLRF       _flags+0
;Q4ultrassonicoBAJA.c,113 :: 		TRIG1=1;
	BSF        PORTC+0, 0
;Q4ultrassonicoBAJA.c,114 :: 		TRIG2=1;
	BSF        PORTC+0, 1
;Q4ultrassonicoBAJA.c,115 :: 		TRIG3=1;
	BSF        PORTC+0, 2
;Q4ultrassonicoBAJA.c,116 :: 		TRIG4=1;
	BSF        PORTC+0, 3
;Q4ultrassonicoBAJA.c,117 :: 		Delay_us(10);
	MOVLW      16
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	NOP
;Q4ultrassonicoBAJA.c,118 :: 		TRIG1=0;
	BCF        PORTC+0, 0
;Q4ultrassonicoBAJA.c,119 :: 		TRIG2=0;
	BCF        PORTC+0, 1
;Q4ultrassonicoBAJA.c,120 :: 		TRIG3=0;
	BCF        PORTC+0, 2
;Q4ultrassonicoBAJA.c,121 :: 		TRIG4=0;
	BCF        PORTC+0, 3
;Q4ultrassonicoBAJA.c,122 :: 		T1CON.TMR1ON=1;                                                         // inicia o timer
	BSF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,123 :: 		while((!ECHO1||!ECHO2||!ECHO3||!ECHO4)&&(TMR1H<200));                   // espera a borda de subida nos pinos de echo
L_main25:
	BTFSS      PORTB+0, 4
	GOTO       L__main47
	BTFSS      PORTB+0, 5
	GOTO       L__main47
	BTFSS      PORTB+0, 6
	GOTO       L__main47
	BTFSS      PORTB+0, 7
	GOTO       L__main47
	GOTO       L_main26
L__main47:
	MOVLW      200
	SUBWF      TMR1H+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main26
L__main46:
	GOTO       L_main25
L_main26:
;Q4ultrassonicoBAJA.c,124 :: 		T1CON.TMR1ON=0;                                                         // interrompe a contagem do tempo
	BCF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,125 :: 		TMR1H=0;
	CLRF       TMR1H+0
;Q4ultrassonicoBAJA.c,126 :: 		TMR1L=1;                                                                // Compensa o atraso de 8 ciclos de máquina entre a borda de subida do echo e o disparo do timer 1
	MOVLW      1
	MOVWF      TMR1L+0
;Q4ultrassonicoBAJA.c,127 :: 		T1CON.TMR1ON=1;                                                         // inicia o timer
	BSF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,128 :: 		flags=0x0F;                                                             // Todos os pinos de echo já estão em alto
	MOVLW      15
	MOVWF      _flags+0
;Q4ultrassonicoBAJA.c,129 :: 		while(flags!=0x00);                                                     // espera a borda de decida nos pinos echo
L_main31:
	MOVF       _flags+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	GOTO       L_main31
L_main32:
;Q4ultrassonicoBAJA.c,130 :: 		T1CON.TMR1ON=0;                                                         // interrompe a contagem do tempo
	BCF        T1CON+0, 0
;Q4ultrassonicoBAJA.c,131 :: 		ontime=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      main_ontime_L0+0
	MOVF       R0+1, 0
	MOVWF      main_ontime_L0+1
	MOVF       R0+2, 0
	MOVWF      main_ontime_L0+2
	MOVF       R0+3, 0
	MOVWF      main_ontime_L0+3
;Q4ultrassonicoBAJA.c,132 :: 		Test_distance_1_Cm = (high_level_time1*0.0272);
	MOVF       _high_level_time1+0, 0
	MOVWF      R0+0
	MOVF       _high_level_time1+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      137
	MOVWF      R4+0
	MOVLW      210
	MOVWF      R4+1
	MOVLW      94
	MOVWF      R4+2
	MOVLW      121
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
	MOVF       FLOC__main+0, 0
	MOVWF      main_Test_distance_1_Cm_L0+0
	MOVF       FLOC__main+1, 0
	MOVWF      main_Test_distance_1_Cm_L0+1
	MOVF       FLOC__main+2, 0
	MOVWF      main_Test_distance_1_Cm_L0+2
	MOVF       FLOC__main+3, 0
	MOVWF      main_Test_distance_1_Cm_L0+3
;Q4ultrassonicoBAJA.c,133 :: 		Test_distance_2_Cm = (high_level_time2*0.0272);
	MOVF       _high_level_time2+0, 0
	MOVWF      R0+0
	MOVF       _high_level_time2+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      137
	MOVWF      R4+0
	MOVLW      210
	MOVWF      R4+1
	MOVLW      94
	MOVWF      R4+2
	MOVLW      121
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Test_distance_2_Cm_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Test_distance_2_Cm_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Test_distance_2_Cm_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Test_distance_2_Cm_L0+3
;Q4ultrassonicoBAJA.c,134 :: 		Test_distance_3_Cm = (high_level_time3*0.0272);
	MOVF       _high_level_time3+0, 0
	MOVWF      R0+0
	MOVF       _high_level_time3+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      137
	MOVWF      R4+0
	MOVLW      210
	MOVWF      R4+1
	MOVLW      94
	MOVWF      R4+2
	MOVLW      121
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Test_distance_3_Cm_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Test_distance_3_Cm_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Test_distance_3_Cm_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Test_distance_3_Cm_L0+3
;Q4ultrassonicoBAJA.c,135 :: 		Test_distance_4_Cm = (high_level_time4*0.0272);
	MOVF       _high_level_time4+0, 0
	MOVWF      R0+0
	MOVF       _high_level_time4+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      137
	MOVWF      R4+0
	MOVLW      210
	MOVWF      R4+1
	MOVLW      94
	MOVWF      R4+2
	MOVLW      121
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_Test_distance_4_Cm_L0+0
	MOVF       R0+1, 0
	MOVWF      main_Test_distance_4_Cm_L0+1
	MOVF       R0+2, 0
	MOVWF      main_Test_distance_4_Cm_L0+2
	MOVF       R0+3, 0
	MOVWF      main_Test_distance_4_Cm_L0+3
;Q4ultrassonicoBAJA.c,136 :: 		if  (Test_distance_1_Cm>300) Test_distance_1_Cm=0;
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      22
	MOVWF      R0+2
	MOVLW      135
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main33
	CLRF       main_Test_distance_1_Cm_L0+0
	CLRF       main_Test_distance_1_Cm_L0+1
	CLRF       main_Test_distance_1_Cm_L0+2
	CLRF       main_Test_distance_1_Cm_L0+3
L_main33:
;Q4ultrassonicoBAJA.c,137 :: 		if  (Test_distance_2_Cm>300) Test_distance_2_Cm=0;
	MOVF       main_Test_distance_2_Cm_L0+0, 0
	MOVWF      R4+0
	MOVF       main_Test_distance_2_Cm_L0+1, 0
	MOVWF      R4+1
	MOVF       main_Test_distance_2_Cm_L0+2, 0
	MOVWF      R4+2
	MOVF       main_Test_distance_2_Cm_L0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      22
	MOVWF      R0+2
	MOVLW      135
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
	CLRF       main_Test_distance_2_Cm_L0+0
	CLRF       main_Test_distance_2_Cm_L0+1
	CLRF       main_Test_distance_2_Cm_L0+2
	CLRF       main_Test_distance_2_Cm_L0+3
L_main34:
;Q4ultrassonicoBAJA.c,138 :: 		if  (Test_distance_3_Cm>300) Test_distance_3_Cm=0;
	MOVF       main_Test_distance_3_Cm_L0+0, 0
	MOVWF      R4+0
	MOVF       main_Test_distance_3_Cm_L0+1, 0
	MOVWF      R4+1
	MOVF       main_Test_distance_3_Cm_L0+2, 0
	MOVWF      R4+2
	MOVF       main_Test_distance_3_Cm_L0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      22
	MOVWF      R0+2
	MOVLW      135
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main35
	CLRF       main_Test_distance_3_Cm_L0+0
	CLRF       main_Test_distance_3_Cm_L0+1
	CLRF       main_Test_distance_3_Cm_L0+2
	CLRF       main_Test_distance_3_Cm_L0+3
L_main35:
;Q4ultrassonicoBAJA.c,139 :: 		if  (Test_distance_4_Cm>300) Test_distance_4_Cm=0;
	MOVF       main_Test_distance_4_Cm_L0+0, 0
	MOVWF      R4+0
	MOVF       main_Test_distance_4_Cm_L0+1, 0
	MOVWF      R4+1
	MOVF       main_Test_distance_4_Cm_L0+2, 0
	MOVWF      R4+2
	MOVF       main_Test_distance_4_Cm_L0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      22
	MOVWF      R0+2
	MOVLW      135
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main36
	CLRF       main_Test_distance_4_Cm_L0+0
	CLRF       main_Test_distance_4_Cm_L0+1
	CLRF       main_Test_distance_4_Cm_L0+2
	CLRF       main_Test_distance_4_Cm_L0+3
L_main36:
;Q4ultrassonicoBAJA.c,140 :: 		TMR1H=0;
	CLRF       TMR1H+0
;Q4ultrassonicoBAJA.c,141 :: 		TMR1L=0;
	CLRF       TMR1L+0
;Q4ultrassonicoBAJA.c,143 :: 		floatToStr(Test_distance_1_Cm,txt);
	MOVF       main_Test_distance_1_Cm_L0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       main_Test_distance_1_Cm_L0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       main_Test_distance_1_Cm_L0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       main_Test_distance_1_Cm_L0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Q4ultrassonicoBAJA.c,144 :: 		UART1_Write_Text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,145 :: 		UART1_Write_Text("     ");
	MOVLW      ?lstr1_Q4ultrassonicoBAJA+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,146 :: 		floatToStr(Test_distance_2_Cm,txt);
	MOVF       main_Test_distance_2_Cm_L0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       main_Test_distance_2_Cm_L0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       main_Test_distance_2_Cm_L0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       main_Test_distance_2_Cm_L0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Q4ultrassonicoBAJA.c,147 :: 		UART1_Write_Text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,148 :: 		UART1_Write_Text("     ");
	MOVLW      ?lstr2_Q4ultrassonicoBAJA+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,149 :: 		floatToStr(Test_distance_3_Cm,txt);
	MOVF       main_Test_distance_3_Cm_L0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       main_Test_distance_3_Cm_L0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       main_Test_distance_3_Cm_L0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       main_Test_distance_3_Cm_L0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Q4ultrassonicoBAJA.c,150 :: 		UART1_Write_Text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,151 :: 		UART1_Write_Text("     ");
	MOVLW      ?lstr3_Q4ultrassonicoBAJA+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,152 :: 		floatToStr(Test_distance_4_Cm,txt);
	MOVF       main_Test_distance_4_Cm_L0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       main_Test_distance_4_Cm_L0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       main_Test_distance_4_Cm_L0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       main_Test_distance_4_Cm_L0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Q4ultrassonicoBAJA.c,153 :: 		UART1_Write_Text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,154 :: 		UART1_Write_Text("     ");
	MOVLW      ?lstr4_Q4ultrassonicoBAJA+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,155 :: 		LongWordToStr(ontime,txt);
	MOVF       main_ontime_L0+0, 0
	MOVWF      FARG_LongWordToStr_input+0
	MOVF       main_ontime_L0+1, 0
	MOVWF      FARG_LongWordToStr_input+1
	MOVF       main_ontime_L0+2, 0
	MOVWF      FARG_LongWordToStr_input+2
	MOVF       main_ontime_L0+3, 0
	MOVWF      FARG_LongWordToStr_input+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_LongWordToStr_output+0
	CALL       _LongWordToStr+0
;Q4ultrassonicoBAJA.c,156 :: 		UART1_Write_Text(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Q4ultrassonicoBAJA.c,157 :: 		UART1_Write(0x0D);                                                      // CR
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Q4ultrassonicoBAJA.c,158 :: 		UART1_Write(0x0A);                                                      // LF
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Q4ultrassonicoBAJA.c,159 :: 		while(ECHO1||ECHO2||ECHO3||ECHO4);                                      // caso o timer tenha da do overflow, algum dos pinos de echo pode estar em high, espera-se aqui até que todos os pinos retornem a low
L_main37:
	BTFSC      PORTB+0, 4
	GOTO       L__main45
	BTFSC      PORTB+0, 5
	GOTO       L__main45
	BTFSC      PORTB+0, 6
	GOTO       L__main45
	BTFSC      PORTB+0, 7
	GOTO       L__main45
	GOTO       L_main38
L__main45:
	GOTO       L_main37
L_main38:
;Q4ultrassonicoBAJA.c,160 :: 		}
	GOTO       L_main21
;Q4ultrassonicoBAJA.c,161 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
