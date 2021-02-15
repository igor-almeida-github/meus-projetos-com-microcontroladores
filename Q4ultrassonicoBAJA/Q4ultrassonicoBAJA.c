// este programa para o PIC16F877A � um medidor de dist�ncia ultrossonico

#define TRIG1 PORTC.RC0
#define TRIG2 PORTC.RC1
#define TRIG3 PORTC.RC2
#define TRIG4 PORTC.RC3

#define ECHO1 PORTB.RB4
#define ECHO2 PORTB.RB5
#define ECHO3 PORTB.RB6
#define ECHO4 PORTB.RB7

unsigned char flags=0;
unsigned int high_level_time1;
unsigned int high_level_time2;
unsigned int high_level_time3;
unsigned int high_level_time4;


#define flagEcho1 flags.b0
#define flagEcho2 flags.b1
#define flagEcho3 flags.b2
#define flagEcho4 flags.b3

unsigned long timeroverflow=0;

unsigned long millis(){
  unsigned long time;
  INTCON.TMR0IE=0;                                                              // Desabilita a interrup��o do timer0
  time=TMR0+(timeroverflow<<8);
  INTCON.TMR0IE=1;                                                              // Habilita a interrup��o do timer0
  time*=0.0512;
  return time;
}

void interrupt(){
       if (INTCON.RBIF){                                                        // Interrup��o gerada pela mudan�a de estado do PORTB;
           INTCON.RBIF=0;
           if (ECHO1==0 && flagEcho1==1){
              flagEcho1=0;
              T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para n�o gerar erro na leitura
              high_level_time1=TMR1L+(TMR1H<<8);
              T1CON.TMR1ON=1;                                                   // Religa o timer
           }

           if (ECHO2==0 && flagEcho2==1){
              flagEcho2=0;
              T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para n�o gerar erro na leitura
              high_level_time2=TMR1L+(TMR1H<<8);
              T1CON.TMR1ON=1;                                                   // Religa o timer
           }

           if (ECHO3==0 && flagEcho3==1){
              flagEcho3=0;
              T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para n�o gerar erro na leitura
              high_level_time3=TMR1L+(TMR1H<<8);
              T1CON.TMR1ON=1;                                                   // Religa o timer
           }

           if (ECHO4==0 && flagEcho4==1){
              flagEcho4=0;
              T1CON.TMR1ON=0;                                                   // Desliga o timer brevemente para n�o gerar erro na leitura
              high_level_time4=TMR1L+(TMR1H<<8);
              T1CON.TMR1ON=1;                                                   // Religa o timer
           }
       }
       else if (PIR1.TMR1IF){                                                   // Interrup��o gerada pelo overflow do timer 1;
           PIR1.TMR1IF=0;
           if (flagEcho1) high_level_time1=0;                                   // Se o echo1 demorar demais para ser recebido e o timer estourar
           if (flagEcho2) high_level_time2=0;                                   // Se o echo2 demorar demais para ser recebido e o timer estourar
           if (flagEcho3) high_level_time3=0;                                   // Se o echo3 demorar demais para ser recebido e o timer estourar
           if (flagEcho4) high_level_time4=0;                                   // Se o echo4 demorar demais para ser recebido e o timer estourar
           flags=0;
       }
       if(INTCON.TMR0IF){                                                       // Ocorreu overflow do timer 0
          INTCON.TMR0IF=0;
          timeroverflow++;
       }
}

void main() {
     //*********************Vari�veis_locais************************************
     unsigned char txt[11];
     float Test_distance_1_Cm=0;
     float Test_distance_2_Cm=0;
     float Test_distance_3_Cm=0;
     float Test_distance_4_Cm=0;
     unsigned long ontime;

     //*******************Configura��es_iniciais********************************
     UART1_Init(57600);
     ADCON1=0x0E;                                                               //configura��o de portas como digitais - AN0 � anal�gica
     TRISC.RC0=0;                                                               // TRIG1 � output
     TRISB.RB4=1;                                                               // ECHO1 � input
     TRISC.RC1=0;                                                               // TRIG2 � output
     TRISB.RB5=1;                                                               // ECHO2 � input
     TRISC.RC2=0;                                                               // TRIG3 � output
     TRISB.RB6=1;                                                               // ECHO3 � input
     TRISC.RC3=0;                                                               // TRIG4 � output
     TRISB.RB7=1;                                                               // ECHO4 � input
     delay_ms(100);
     TRIG1=0;
     
     //*********************configura��o_dos_timers*****************************
     T1CON=0x30;                                                                // timer 1 prescale 8,clock interno, timer parado
     OPTION_REG=0xC7;                                                           // timer 0 prescale de 256, 8 bits
     //***************Configura��es_das_interrup��es****************************
     INTCON=0xE8;                                                               // interrup��es globais habilitadas, interrup��es dos perifericos habilitadas, interrup��o por mudan�a de estado do port b habilitada, interrup��o por overflow do timer 0 habilitada
     PIE1=0x01;                                                                 // interrup��o do timer 1 habilitada

     for (;;){ //******************LOOP*****************************************
        flags=0x00;
        TRIG1=1;
        TRIG2=1;
        TRIG3=1;
        TRIG4=1;
        Delay_us(10);
        TRIG1=0;
        TRIG2=0;
        TRIG3=0;
        TRIG4=0;
        T1CON.TMR1ON=1;                                                         // inicia o timer
        while((!ECHO1||!ECHO2||!ECHO3||!ECHO4)&&(TMR1H<200));                   // espera a borda de subida nos pinos de echo
        T1CON.TMR1ON=0;                                                         // interrompe a contagem do tempo
        TMR1H=0;
        TMR1L=1;                                                                // Compensa o atraso de 8 ciclos de m�quina entre a borda de subida do echo e o disparo do timer 1
        T1CON.TMR1ON=1;                                                         // inicia o timer
        flags=0x0F;                                                             // Todos os pinos de echo j� est�o em alto
        while(flags!=0x00);                                                     // espera a borda de decida nos pinos echo
        T1CON.TMR1ON=0;                                                         // interrompe a contagem do tempo
        ontime=millis();
        Test_distance_1_Cm = (high_level_time1*0.0272);
        Test_distance_2_Cm = (high_level_time2*0.0272);
        Test_distance_3_Cm = (high_level_time3*0.0272);
        Test_distance_4_Cm = (high_level_time4*0.0272);
        if  (Test_distance_1_Cm>300) Test_distance_1_Cm=0;
        if  (Test_distance_2_Cm>300) Test_distance_2_Cm=0;
        if  (Test_distance_3_Cm>300) Test_distance_3_Cm=0;
        if  (Test_distance_4_Cm>300) Test_distance_4_Cm=0;
        TMR1H=0;
        TMR1L=0;
        //*****************Enviando_a_serial************************************
        floatToStr(Test_distance_1_Cm,txt);
        UART1_Write_Text(txt);
        UART1_Write_Text("     ");
        floatToStr(Test_distance_2_Cm,txt);
        UART1_Write_Text(txt);
        UART1_Write_Text("     ");
        floatToStr(Test_distance_3_Cm,txt);
        UART1_Write_Text(txt);
        UART1_Write_Text("     ");
        floatToStr(Test_distance_4_Cm,txt);
        UART1_Write_Text(txt);
        UART1_Write_Text("     ");
        LongWordToStr(ontime,txt);
        UART1_Write_Text(txt);
        UART1_Write(0x0D);                                                      // CR
        UART1_Write(0x0A);                                                      // LF
        while(ECHO1||ECHO2||ECHO3||ECHO4);                                      // caso o timer tenha da do overflow, algum dos pinos de echo pode estar em high, espera-se aqui at� que todos os pinos retornem a low
     }
}