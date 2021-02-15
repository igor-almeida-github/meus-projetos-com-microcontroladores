// Este programa para o PIC16F877A mede o tempo de reação de uma pessoa ao ver um led acender e mostra em um display lcd

// Configuração de qual pino do lcd corresponde a qual porta do MCU
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
// Configuração de input ou output das portas  conforme lcd
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

#define LED PORTD.RD1
#define Switch PORTD.RD2
unsigned char flags=0;
unsigned long overflow=0;
unsigned char no;
unsigned long ElapsedTime;
unsigned char Txt[11];

void interrupt(void){
   overflow++;
   PIR1.TMR1IF=0;                                                               // Limpa a flag de interrupção do timer 1
}

void main() {
   TRISD.RD1=0;                                                                 // Led é OUTPUT
   TRISD.RD0=1;                                                                 // Switch é INPUT
   ADCON1=0x06;                                                                 // Todas as portas são digitais
   T1CON=0x30;                                                                  // Configuração do timer 1, 16bits, prescale de 8, parado, 1.6 us por contagem
   Lcd_Init();                                                                  // Inicializa o LCD conectado ao PORTB
   Lcd_Cmd(_LCD_CLEAR);                                                         // Limpa o lcd
   Lcd_Cmd(_LCD_CURSOR_OFF);                                                    // Desativa o cursor
   LED=0;                                                                       // LED desligado
   srand(10);                                                                   // Inicializa a semente de números aleatórios
   INTCON=0xC0;                                                                 // Habilita as interrupções dos periféricos e globais
   PIE1=1;                                                                      // Habilita a interrupção do timer 1


   for(;;){                                                                     // Loop Infinito
      no=rand()%10+1;                                                           // Número aleatório entre 1 e 10
      Vdelay_ms(no*1000);                                                       // Delay aleatório entre 1 e 10s, Vdelay é para variavel
      overflow=0;
      TMR1H=0;
      TMR1L=0;
      LED=1;                                                                    // Acende o led
      T1CON.TMR1ON=1;                                                           // Dispara o timer 1
      while (Switch);                                                           // Espera até que o botão seja pressionado
      T1CON.TMR1ON=0;                                                           // para o timer 1
      LED=0;                                                                    // Apaga o led
      ElapsedTime=TMR1L;                                                        // LOW byte do timer 1
      ElapsedTime+=(TMR1H<<8);                                                  // HIGH byte do timer 1
      ElapsedTime=(ElapsedTime/10)*16+104857*overflow;                          // Tempo em us
      ElapsedTime=ElapsedTime/1000;                                             // Tempo em ms
      LongWordToStr(ElapsedTime,Txt);                                           // Converte o tempo para string
      Lcd_out(1,1,"Reaction(ms):");
      Lcd_out(2,1,Txt);
      Delay_ms(2000);
      Lcd_cmd(_LCD_CLEAR);
   }
   
}