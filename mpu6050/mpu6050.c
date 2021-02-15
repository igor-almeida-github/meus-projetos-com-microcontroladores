// Este programa para o pic18f4550 exibe a leitura de umm acelerometro no monitor serial, o acelerometro � ligado a I2C.
#define MPU_addr 0x68                                                           // 7 bits de endere�o do MPU6050, 6:1 + AD0, com AD0 em LOW (0x69 se AD0 estiver em HIGH)

// Endere�os de registradores que n�o est�o no Register-Map para calibra��o
#define MPU6050_RA_XG_OFFS_TC       0x00
#define MPU6050_RA_YG_OFFS_TC       0x01
#define MPU6050_RA_ZG_OFFS_TC       0x02
#define MPU6050_RA_X_FINE_GAIN      0x03
#define MPU6050_RA_Y_FINE_GAIN      0x04
#define MPU6050_RA_Z_FINE_GAIN      0x05
#define MPU6050_RA_XA_OFFS_H        0x06
#define MPU6050_RA_XA_OFFS_L_TC     0x07
#define MPU6050_RA_YA_OFFS_H        0x08
#define MPU6050_RA_YA_OFFS_L_TC     0x09
#define MPU6050_RA_ZA_OFFS_H        0x0A
#define MPU6050_RA_ZA_OFFS_L_TC     0x0B

#define int0 PORTB.RB0

unsigned int elapsedTime=0;
unsigned long timeroverflow=0;

unsigned long millis(){
  unsigned long time;
  PIE1.TMR1IE=0;                                                                // Desabilita a interrup��o do timer1
  time=TMR1L;
  time+=(TMR1H<<8);
  time+=(timeroverflow<<16);
  PIE1.TMR1IE=1;                                                                // Habilita a interrup��o do timer1
  time*=0.0016;
  return time;
}

void interrupt(void){

   if ( INTCON.TMR0IF){                                                         // ocorreu overflow do timer 0
      elapsedTime=0;
      T0CON.TMR0ON=0;
      asm{
            CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrup��o
            CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrup��o
            BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
            BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
        }
   }
   if( INTCON3.INT2IF){                                                          // borda de subida no pino INT0
      T0CON.TMR0ON=1;
      elapsedTime=TMR0L;
      elapsedTime+=(TMR0H<<8);
      asm{
            CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrup��o
            CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrup��o
            BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
            BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
      }
   }
   if(PIR1.TMR1IF){
        timeroverflow++; 
        PIR1.TMR1IF=0;
   }


}

void main() {
       // *******************Vari�veis locais***********************************
       int  ACCEL_XOUT,ACCEL_YOUT,ACCEL_ZOUT;
       unsigned char txt[8];
       unsigned char kmh;
       unsigned long ontime=0;
       unsigned int volantePot;
       unsigned char *pnt;                                                      // Pointer para guardar endere�o da ontime
       pnt = &ontime;                                                           // Recebe o endere�o do primeiro byte de ontime
       // ***************Configura��es iniciais*********************************
       ADCON1=0x0E;                                                             // Configura��o de todas as portas como digitais exceto
       ADC_Init();
       I2C1_Init(100000);                                                       // Inicializa a comunica��o i2c 400khz
       UART1_Init(57600);                                                       // Inicializa a UART, 57600 de baud rate
       TRISB.RB2=1;                                                             // Int2 � input
       Delay_ms(400);
       //******************* Configurando MPU6050:******************************
       // Tirando do modo sleep
       I2C1_Start();                                                            // Transmite o start bit I2C
       I2C1_Wr((MPU_addr<<1)|0);                                                // Envia o endere�o do MPU +  W
       I2C1_Wr(0x6B);                                                           // PWR_MGMT_1: endere�o do registro do MPU a ser acessado
       I2C1_Wr(0x02);                                                           // SLEEP bit off, CLKSEL: PLL com refer�ncia no eixo Y do giroscopio pois datasheet diz: it is highly recommended that the device be configured to use one of the gyroscopes (or an external clock source) as the clock reference for improved stability
       I2C1_Stop();                                                             // Emite o sinal de parada na i2c
       // Range do acelerometro
       I2C1_Start();                                                            // Transmite o start bit I2C
       I2C1_Wr((MPU_addr<<1)|0);                                                // Envia o endere�o do MPU +  W
       I2C1_Wr(0x1C);                                                           // ACCEL_CONFIG: endere�o do registro do MPU a ser acessado
       I2C1_Wr((0)<<3);                                                         // AFS_SEL = 0,1,2 ou 3 -> (+-2g, +-4g, +-8g, +-16g)  // +32768 <> -32767
       I2C1_Stop();                                                             // Emite o sinal de parada na i2c

       //***********configura��es de interrup��es*******************************
       //lembrete das flags:
       //INTCON.TMR0IF flag overflow do timer 0
       //INTCON.INT0IF flag ocorrencia de evento no pino INT0
       //configura��es:
       INTCON=0xE0;                                                             // Habilita a interrup��es gerais e a interrup��o pelo overflow do timer 0, habilita interrup��o dos perif�ricos
       INTCON2.INTEDG2=1;                                                       // Interrup��o na borda de subida do pino INT2
       PIE1.TMR1IE=1;                                                           // Habilita a interrup��o do timer1
       INTCON3.INT2IE=1;                                                        // Habilita a interrup��o do int2
       //*****************configura��es_dos_timers******************************
       T0CON=0x06;                                                              // Timer0 no modo de 16 bits, prescale 128  //fazer T0CON.TMR0ON=1 para disparar o timer
       T0CON.TMR0ON=1;                                                          // Dispara o timer0
       T1CON=0xB5;                                                              // timer 1 no modo de 16 bits, prescale de 8, disparado
       for(;;){
             //*********************acelera��o**********************************
             I2C1_Start();                                                      // Transmite o start bit I2C
             I2C1_Wr((MPU_addr<<1)|0);                                          // Envia o endere�o do MPU +  W
             I2C1_Wr(0x3B);                                                     // ACCEL_XOUT_H: endere�o do registro do MPU a ser lido primeiro
             I2C1_Repeated_Start();                                             // Sinal I2C repeated start
             I2C1_Wr((MPU_addr<<1)|1);                                          // Envia o endere�o do MPU +  R

             ACCEL_XOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(1);                             // L� ACCEL_XOUT_H e ACCEL_XOUT_L, envia acknowledge bit
             ACCEL_YOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(1);                             // L� ACCEL_YOUT_H e ACCEL_YOUT_L, envia acknowledge bit
             ACCEL_ZOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(0);                             // L� ACCEL_ZOUT_H e ACCEL_ZOUT_L, envia NOT acknowledge bit
             I2C1_Stop();                                                       // Emite o sinal de parada na i2c
             ontime=millis();
             // Calibrando: removendo offset
             ACCEL_XOUT-=643;
             ACCEL_YOUT+=463;
             ACCEL_ZOUT-=1764;
             //*****************Velocidade**************************************
             if ( elapsedTime!=0){
                kmh=(59238/elapsedTime);
              }
              else kmh=0;
              volantePot=ADC_Read(0);
              
             //***************Comunica��o_Serial_lenta**************************
            /*UART1_Write_text("ACX: ");
             IntToStr(ACCEL_XOUT,txt);
             UART1_Write_text(txt);
             UART1_Write_text("  ");

             UART1_Write_text("ACY: ");
             IntToStr(ACCEL_YOUT,txt);
             UART1_Write_text(txt);
             UART1_Write_text("  ");

             UART1_Write_text("ACZ: ");
             IntToStr(ACCEL_ZOUT,txt);
             UART1_Write_text(txt);
             UART1_Write_text("  ");

             UART1_Write_text("KM/H: ");
             ByteToStr(kmh,txt);
             UART1_Write_text(txt);
             UART1_Write_text("  ");

             UART1_Write_text("TIME: ");
             LongWordToStr(ontime,txt);
             UART1_Write_text(txt);

             UART1_Write(0x0D);
             UART1_Write(0x0A);*/
             
             //***************Comunica��o_serial_r�pida*************************
             UART1_Write(ACCEL_XOUT>>8);
             UART1_Write(ACCEL_XOUT);
             UART1_Write(ACCEL_YOUT>>8);
             UART1_Write(ACCEL_YOUT);
             UART1_Write(ACCEL_ZOUT>>8);
             UART1_Write(ACCEL_ZOUT);
             UART1_Write(kmh);
             UART1_Write(volantePot>>8);
             UART1_Write(volantePot);
             UART1_Write(*(pnt+3));                                             // Byte mais significativo de ontime
             UART1_Write(*(pnt+2));
             UART1_Write(*(pnt+1));
             UART1_Write(*pnt);                                               // Byte menos significativo de ontime
             UART1_Write(0x0D);
             UART1_Write(0x0A);
       }
       
}