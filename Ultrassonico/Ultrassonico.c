
 // este programa para o PIC16F877A � um medidor de dist�ncia ultrossonico


      // Configura��o de qual pino do lcd corresponde a qual porta do MCU
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
// Configura��o de input ou output das portas  conforme lcd
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

#define TRIG PORTC.RC0
#define ECHO PORTC.RC1

void main() {
     unsigned char txt[11];
     unsigned char*point;
     float Test_distanceCm=0;
     unsigned int high_level_time;
     TRISC.RC0=0;   // TRIG � output
     TRISC.RC1=1;   // ECHO � input
     
     ADCON1=0x0E;      //configura��o de portas como digitais - AN0 � anal�gica

     // inicializando display lcd
     Lcd_Init(); // LCD � conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Out(1,1,"Ultrassonic"); // Escreve na posi��o 1,1
     Lcd_Out(2,1,"Measument"); // Escreve na posi��o 1,1
     Delay_ms(1000);
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     TRIG=0;
     //configura��o dos timers
      T1CON=0x30; // timer 1 prescale 8,clock interno, timer parado
      INTCON=0x60; // interrup��o dos perifericos habilitada
      PIE1=0x01; // interrup��o do timer 1 habilitada
     Lcd_Out(1,1,"Distancia(Cm):"); // Escreve na posi��o 1,1
     for (;;){
        TRIG=1;
        Delay_us(10);
        TRIG=0;
        while(!ECHO);   // espera a borda de subida no pino de echo
        T1CON.TMR1ON=1; // inicia o timer
        while(ECHO);    // espera a borda de decida no pino echo
        T1CON.TMR1ON=0; // interrompe a contagem do tempo
        high_level_time=TMR1L+(TMR1H<<8);
        Test_distanceCm = (high_level_time*0.0272);
        TMR1H=0;
        TMR1L=0;
        floatToStr(Test_distanceCm,txt);
        point=ltrim(txt);
        Lcd_Out(2,1,"                ");
        Lcd_Out(2,1,point);
        Delay_ms(40);
        
        // PIR1.TMR1IF  flag de interrup���o do timer 1

     }
}