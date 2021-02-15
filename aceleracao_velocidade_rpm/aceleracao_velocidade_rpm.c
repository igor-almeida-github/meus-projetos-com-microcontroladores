// Este programa para o pic18f4550 envia dados de aceleração e velocidade para o monitor serial.
// Desenvolvido para a equipe UFV baja


unsigned int elapsedTimeVel=0;
unsigned int elapsedTimeRpm=0;
unsigned long timeroverflow=0;

unsigned long millis(){
  unsigned long time;
  PIE1.TMR1IE=0;                                                                // Desabilita a interrupção do timer1
  time=TMR1L;
  time+=(TMR1H<<8);
  time+=(timeroverflow<<16);
  PIE1.TMR1IE=1;                                                                // Habilita a interrupção do timer1
  time*=0.0016;
  return time;
}

void interrupt(void){

   if ( INTCON.TMR0IF){                                                         // ocorreu overflow do timer 0
      elapsedTimeVel=0;
      T0CON.TMR0ON=0;
      asm{
            CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
            CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
            BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
            BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
        }
   }
   if( INTCON3.INT2IF){                                                          // borda de subida no pino INT0
      T0CON.TMR0ON=1;
      elapsedTimeVel=TMR0L;
      elapsedTimeVel+=(TMR0H<<8);
      asm{
            CLRF 0xFD7                                                          //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
            CLRF 0xFD6                                                          //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
            BCF  0xFF0,1                                                        //INTCON3.INT2IF=0;
            BCF  0xFF2,2                                                        //INTCON.TMR0IF=0;
      }
   }
   if(PIR1.TMR1IF){
        timeroverflow++;
        PIR1.TMR1IF=0;
   }
   //Medindo a roatação
   if ( PIR2.TMR3IF){                                                         // ocorreu overflow do timer 0
      elapsedTimeRpm=0;
      T3CON.TMR3ON=0;
      INTCON3.INT1IF=0;
      TMR3H=0;
      TMR3L=0;
      PIR2.TMR3IF=0;
   }
   
   if(INTCON3.INT1IF){
      T3CON.TMR3ON=1;
      elapsedTimeRpm=TMR3L;
      elapsedTimeRpm+=(TMR3H<<8);
      INTCON3.INT1IF=0;
      TMR3H=0;
      TMR3L=0;
      PIR2.TMR3IF=0;
   }


}

void main() {
       // *******************Variáveis locais***********************************
       int  ACCEL_XOUT,ACCEL_YOUT,ACCEL_ZOUT;
       unsigned char txt[8];
       unsigned char kmh;
       unsigned long ontime=0;
       unsigned char *pnt;                                                      // Pointer para guardar endereço da ontime
       float rpm=0;
       pnt = &ontime;                                                           // Recebe o endereço do primeiro byte de ontime
       // ***************Configurações iniciais*********************************
       ADCON1=0x0F;                                                             // Configuração de todas as portas como digitais
       UART1_Init(57600);                                                       // Inicializa a UART, 57600 de baud rate
       TRISB.RB2=1;                                                             // Int2 é input(velocidade)
       TRISB.RB1=1;                                                             // Int1 é input(rpm)
       Delay_ms(400);
       //******************* Configurando MPU6050:******************************


       //***********configurações de interrupções*******************************
       //lembrete das flags:
       //INTCON.TMR0IF flag overflow do timer 0
       //INTCON.INT0IF flag ocorrencia de evento no pino INT0
       //configurações:
       INTCON=0xE0;                                                             // Habilita a interrupções gerais e a interrupção pelo overflow do timer 0, habilita interrupção dos periféricos
       INTCON2.INTEDG2=1;                                                       // Interrupção na borda de subida do pino INT2 (velocidade)
       INTCON.INTEDG1=1;                                                        // Interrupção na borda de subida do pino INT1 (rotação)
       PIE1.TMR1IE=1;                                                           // Habilita a interrupção do timer1
       INTCON3.INT2IE=1;                                                        // Habilita a interrupção do int2 (velocidade)
       INTCON3.INT1IE=1;                                                        // Habilita a interrupção do int1 (rotação)
       PIE2.TMR3IE=1;                                                           // Habilita a interrupção do timer 3  (rotação)
       //*****************configurações_dos_timers******************************
       T0CON=0x06;                                                              // Timer0 no modo de 16 bits, prescale 128  //fazer T0CON.TMR0ON=1 para disparar o timer
       T0CON.TMR0ON=1;                                                          // Dispara o timer0
       T1CON=0xB5;                                                              // timer 1 no modo de 16 bits, prescale de 8, disparado
       T3CON=0xBD;                                                              // Time 3 no modo de 16 bits, prescale de 8, disparado
       for(;;){
             //*********************aceleração**********************************

             ontime=millis();
             // Calibrando: removendo offset

             //*****************Velocidade**************************************
             if ( elapsedTimeVel!=0){
                kmh=elapsedTimeVel;
              }
              else kmh=0;
             //******************RPM********************************************
             if ( elapsedTimeRpm!=0){
                rpm=(elapsedTimeRpm);
              }
              else rpm=0;

             //***************Comunicação_serial_rápida*************************
             UART1_Write(*(&rpm+1));
             UART1_Write(*(&rpm));
             UART1_Write(*(&kmh+1));
             UART1_Write(*(&kmh));
             UART1_Write(*(pnt+3));                                             // Byte mais significativo de ontime
             UART1_Write(*(pnt+2));
             UART1_Write(*(pnt+1));
             UART1_Write(*pnt);                                                 // Byte menos significativo de ontime
             UART1_Write(0x0D);
             UART1_Write(0x0A);
       }

}
