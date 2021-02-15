
_millis:

;mpu6050.c,23 :: 		unsigned long millis(){
;mpu6050.c,25 :: 		PIE1.TMR1IE=0;                                                                // Desabilita a interrupção do timer1
	BCF         PIE1+0, 0 
;mpu6050.c,26 :: 		time=TMR1L;
	MOVF        TMR1L+0, 0 
	MOVWF       millis_time_L0+0 
	MOVLW       0
	MOVWF       millis_time_L0+1 
	MOVWF       millis_time_L0+2 
	MOVWF       millis_time_L0+3 
;mpu6050.c,27 :: 		time+=(TMR1H<<8);
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
;mpu6050.c,28 :: 		time+=(timeroverflow<<16);
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
;mpu6050.c,29 :: 		PIE1.TMR1IE=1;                                                                // Habilita a interrupção do timer1
	BSF         PIE1+0, 0 
;mpu6050.c,30 :: 		time*=0.0016;
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
;mpu6050.c,31 :: 		return time;
;mpu6050.c,32 :: 		}
L_end_millis:
	RETURN      0
; end of _millis

_interrupt:

;mpu6050.c,34 :: 		void interrupt(void){
;mpu6050.c,36 :: 		if ( INTCON.TMR0IF){                                                         // ocorreu overflow do timer 0
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;mpu6050.c,37 :: 		elapsedTime=0;
	CLRF        _elapsedTime+0 
	CLRF        _elapsedTime+1 
;mpu6050.c,38 :: 		T0CON.TMR0ON=0;
	BCF         T0CON+0, 7 
;mpu6050.c,40 :: 		CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
	CLRF        4055, 1
;mpu6050.c,41 :: 		CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
	CLRF        4054, 1
;mpu6050.c,42 :: 		BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
	BCF         4080, 1, 1
;mpu6050.c,43 :: 		BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
	BCF         4082, 2, 1
;mpu6050.c,45 :: 		}
L_interrupt0:
;mpu6050.c,46 :: 		if( INTCON3.INT2IF){                                                          // borda de subida no pino INT0
	BTFSS       INTCON3+0, 1 
	GOTO        L_interrupt1
;mpu6050.c,47 :: 		T0CON.TMR0ON=1;
	BSF         T0CON+0, 7 
;mpu6050.c,48 :: 		elapsedTime=TMR0L;
	MOVF        TMR0L+0, 0 
	MOVWF       _elapsedTime+0 
	MOVLW       0
	MOVWF       _elapsedTime+1 
;mpu6050.c,49 :: 		elapsedTime+=(TMR0H<<8);
	MOVF        TMR0H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	ADDWF       _elapsedTime+0, 1 
	MOVF        R1, 0 
	ADDWFC      _elapsedTime+1, 1 
;mpu6050.c,51 :: 		CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
	CLRF        4055, 1
;mpu6050.c,52 :: 		CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
	CLRF        4054, 1
;mpu6050.c,53 :: 		BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
	BCF         4080, 1, 1
;mpu6050.c,54 :: 		BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
	BCF         4082, 2, 1
;mpu6050.c,56 :: 		}
L_interrupt1:
;mpu6050.c,57 :: 		if(PIR1.TMR1IF){
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt2
;mpu6050.c,58 :: 		timeroverflow++;
	MOVLW       1
	ADDWF       _timeroverflow+0, 1 
	MOVLW       0
	ADDWFC      _timeroverflow+1, 1 
	ADDWFC      _timeroverflow+2, 1 
	ADDWFC      _timeroverflow+3, 1 
;mpu6050.c,59 :: 		PIR1.TMR1IF=0;
	BCF         PIR1+0, 0 
;mpu6050.c,60 :: 		}
L_interrupt2:
;mpu6050.c,63 :: 		}
L_end_interrupt:
L__interrupt11:
	RETFIE      1
; end of _interrupt

_main:

;mpu6050.c,65 :: 		void main() {
;mpu6050.c,70 :: 		unsigned long ontime=0;
	CLRF        main_ontime_L0+0 
	CLRF        main_ontime_L0+1 
	CLRF        main_ontime_L0+2 
	CLRF        main_ontime_L0+3 
;mpu6050.c,73 :: 		pnt = &ontime;                                                           // Recebe o endereço do primeiro byte de ontime
	MOVLW       main_ontime_L0+0
	MOVWF       main_pnt_L0+0 
	MOVLW       hi_addr(main_ontime_L0+0)
	MOVWF       main_pnt_L0+1 
;mpu6050.c,75 :: 		ADCON1=0x0E;                                                             // Configuração de todas as portas como digitais exceto
	MOVLW       14
	MOVWF       ADCON1+0 
;mpu6050.c,76 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;mpu6050.c,77 :: 		I2C1_Init(100000);                                                       // Inicializa a comunicação i2c 400khz
	MOVLW       50
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;mpu6050.c,78 :: 		UART1_Init(57600);                                                       // Inicializa a UART, 57600 de baud rate
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       86
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;mpu6050.c,79 :: 		TRISB.RB2=1;                                                             // Int2 é input
	BSF         TRISB+0, 2 
;mpu6050.c,80 :: 		Delay_ms(400);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
	NOP
;mpu6050.c,83 :: 		I2C1_Start();                                                            // Transmite o start bit I2C
	CALL        _I2C1_Start+0, 0
;mpu6050.c,84 :: 		I2C1_Wr((MPU_addr<<1)|0);                                                // Envia o endereço do MPU +  W
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,85 :: 		I2C1_Wr(0x6B);                                                           // PWR_MGMT_1: endereço do registro do MPU a ser acessado
	MOVLW       107
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,86 :: 		I2C1_Wr(0x02);                                                           // SLEEP bit off, CLKSEL: PLL com referência no eixo Y do giroscopio pois datasheet diz: it is highly recommended that the device be configured to use one of the gyroscopes (or an external clock source) as the clock reference for improved stability
	MOVLW       2
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,87 :: 		I2C1_Stop();                                                             // Emite o sinal de parada na i2c
	CALL        _I2C1_Stop+0, 0
;mpu6050.c,89 :: 		I2C1_Start();                                                            // Transmite o start bit I2C
	CALL        _I2C1_Start+0, 0
;mpu6050.c,90 :: 		I2C1_Wr((MPU_addr<<1)|0);                                                // Envia o endereço do MPU +  W
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,91 :: 		I2C1_Wr(0x1C);                                                           // ACCEL_CONFIG: endereço do registro do MPU a ser acessado
	MOVLW       28
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,92 :: 		I2C1_Wr((0)<<3);                                                         // AFS_SEL = 0,1,2 ou 3 -> (+-2g, +-4g, +-8g, +-16g)  // +32768 <> -32767
	CLRF        FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,93 :: 		I2C1_Stop();                                                             // Emite o sinal de parada na i2c
	CALL        _I2C1_Stop+0, 0
;mpu6050.c,100 :: 		INTCON=0xE0;                                                             // Habilita a interrupções gerais e a interrupção pelo overflow do timer 0, habilita interrupção dos periféricos
	MOVLW       224
	MOVWF       INTCON+0 
;mpu6050.c,101 :: 		INTCON2.INTEDG2=1;                                                       // Interrupção na borda de subida do pino INT2
	BSF         INTCON2+0, 4 
;mpu6050.c,102 :: 		PIE1.TMR1IE=1;                                                           // Habilita a interrupção do timer1
	BSF         PIE1+0, 0 
;mpu6050.c,103 :: 		INTCON3.INT2IE=1;                                                        // Habilita a interrupção do int2
	BSF         INTCON3+0, 4 
;mpu6050.c,105 :: 		T0CON=0x06;                                                              // Timer0 no modo de 16 bits, prescale 128  //fazer T0CON.TMR0ON=1 para disparar o timer
	MOVLW       6
	MOVWF       T0CON+0 
;mpu6050.c,106 :: 		T0CON.TMR0ON=1;                                                          // Dispara o timer0
	BSF         T0CON+0, 7 
;mpu6050.c,107 :: 		T1CON=0xB5;                                                              // timer 1 no modo de 16 bits, prescale de 8, disparado
	MOVLW       181
	MOVWF       T1CON+0 
;mpu6050.c,108 :: 		for(;;){
L_main4:
;mpu6050.c,110 :: 		I2C1_Start();                                                      // Transmite o start bit I2C
	CALL        _I2C1_Start+0, 0
;mpu6050.c,111 :: 		I2C1_Wr((MPU_addr<<1)|0);                                          // Envia o endereço do MPU +  W
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,112 :: 		I2C1_Wr(0x3B);                                                     // ACCEL_XOUT_H: endereço do registro do MPU a ser lido primeiro
	MOVLW       59
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,113 :: 		I2C1_Repeated_Start();                                             // Sinal I2C repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;mpu6050.c,114 :: 		I2C1_Wr((MPU_addr<<1)|1);                                          // Envia o endereço do MPU +  R
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;mpu6050.c,116 :: 		ACCEL_XOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(1);                             // Lê ACCEL_XOUT_H e ACCEL_XOUT_L, envia acknowledge bit
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+1 
	CLRF        FLOC__main+0 
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	IORWF       FLOC__main+0, 0 
	MOVWF       main_ACCEL_XOUT_L0+0 
	MOVF        FLOC__main+1, 0 
	MOVWF       main_ACCEL_XOUT_L0+1 
	MOVLW       0
	IORWF       main_ACCEL_XOUT_L0+1, 1 
;mpu6050.c,117 :: 		ACCEL_YOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(1);                             // Lê ACCEL_YOUT_H e ACCEL_YOUT_L, envia acknowledge bit
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+1 
	CLRF        FLOC__main+0 
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	IORWF       FLOC__main+0, 0 
	MOVWF       main_ACCEL_YOUT_L0+0 
	MOVF        FLOC__main+1, 0 
	MOVWF       main_ACCEL_YOUT_L0+1 
	MOVLW       0
	IORWF       main_ACCEL_YOUT_L0+1, 1 
;mpu6050.c,118 :: 		ACCEL_ZOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(0);                             // Lê ACCEL_ZOUT_H e ACCEL_ZOUT_L, envia NOT acknowledge bit
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+1 
	CLRF        FLOC__main+0 
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	IORWF       FLOC__main+0, 0 
	MOVWF       main_ACCEL_ZOUT_L0+0 
	MOVF        FLOC__main+1, 0 
	MOVWF       main_ACCEL_ZOUT_L0+1 
	MOVLW       0
	IORWF       main_ACCEL_ZOUT_L0+1, 1 
;mpu6050.c,119 :: 		I2C1_Stop();                                                       // Emite o sinal de parada na i2c
	CALL        _I2C1_Stop+0, 0
;mpu6050.c,120 :: 		ontime=millis();
	CALL        _millis+0, 0
	MOVF        R0, 0 
	MOVWF       main_ontime_L0+0 
	MOVF        R1, 0 
	MOVWF       main_ontime_L0+1 
	MOVF        R2, 0 
	MOVWF       main_ontime_L0+2 
	MOVF        R3, 0 
	MOVWF       main_ontime_L0+3 
;mpu6050.c,122 :: 		ACCEL_XOUT-=643;
	MOVLW       131
	SUBWF       main_ACCEL_XOUT_L0+0, 1 
	MOVLW       2
	SUBWFB      main_ACCEL_XOUT_L0+1, 1 
;mpu6050.c,123 :: 		ACCEL_YOUT+=463;
	MOVLW       207
	ADDWF       main_ACCEL_YOUT_L0+0, 1 
	MOVLW       1
	ADDWFC      main_ACCEL_YOUT_L0+1, 1 
;mpu6050.c,124 :: 		ACCEL_ZOUT-=1764;
	MOVLW       228
	SUBWF       main_ACCEL_ZOUT_L0+0, 1 
	MOVLW       6
	SUBWFB      main_ACCEL_ZOUT_L0+1, 1 
;mpu6050.c,126 :: 		if ( elapsedTime!=0){
	MOVLW       0
	XORWF       _elapsedTime+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVLW       0
	XORWF       _elapsedTime+0, 0 
L__main13:
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
;mpu6050.c,127 :: 		kmh=(59238/elapsedTime);
	MOVF        _elapsedTime+0, 0 
	MOVWF       R4 
	MOVF        _elapsedTime+1, 0 
	MOVWF       R5 
	MOVLW       102
	MOVWF       R0 
	MOVLW       231
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_kmh_L0+0 
;mpu6050.c,128 :: 		}
	GOTO        L_main8
L_main7:
;mpu6050.c,129 :: 		else kmh=0;
	CLRF        main_kmh_L0+0 
L_main8:
;mpu6050.c,130 :: 		volantePot=ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_volantePot_L0+0 
	MOVF        R1, 0 
	MOVWF       main_volantePot_L0+1 
;mpu6050.c,161 :: 		UART1_Write(ACCEL_XOUT>>8);
	MOVF        main_ACCEL_XOUT_L0+1, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       main_ACCEL_XOUT_L0+1, 7 
	MOVLW       255
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,162 :: 		UART1_Write(ACCEL_XOUT);
	MOVF        main_ACCEL_XOUT_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,163 :: 		UART1_Write(ACCEL_YOUT>>8);
	MOVF        main_ACCEL_YOUT_L0+1, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       main_ACCEL_YOUT_L0+1, 7 
	MOVLW       255
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,164 :: 		UART1_Write(ACCEL_YOUT);
	MOVF        main_ACCEL_YOUT_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,165 :: 		UART1_Write(ACCEL_ZOUT>>8);
	MOVF        main_ACCEL_ZOUT_L0+1, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       main_ACCEL_ZOUT_L0+1, 7 
	MOVLW       255
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,166 :: 		UART1_Write(ACCEL_ZOUT);
	MOVF        main_ACCEL_ZOUT_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,167 :: 		UART1_Write(kmh);
	MOVF        main_kmh_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,168 :: 		UART1_Write(volantePot>>8);
	MOVF        main_volantePot_L0+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,169 :: 		UART1_Write(volantePot);
	MOVF        main_volantePot_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,170 :: 		UART1_Write(*(pnt+3));                                             // Byte mais significativo de ontime
	MOVLW       3
	ADDWF       main_pnt_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_pnt_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,171 :: 		UART1_Write(*(pnt+2));
	MOVLW       2
	ADDWF       main_pnt_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_pnt_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,172 :: 		UART1_Write(*(pnt+1));
	MOVLW       1
	ADDWF       main_pnt_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      main_pnt_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,173 :: 		UART1_Write(*pnt);                                               // Byte menos significativo de ontime
	MOVFF       main_pnt_L0+0, FSR0
	MOVFF       main_pnt_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,174 :: 		UART1_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,175 :: 		UART1_Write(0x0A);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;mpu6050.c,176 :: 		}
	GOTO        L_main4
;mpu6050.c,178 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
