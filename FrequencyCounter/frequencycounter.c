
 // este programa para o PIC16F877A é um frequêncimetro com precisão de 1hz


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

unsigned int cnt0=0;
unsigned int cnt1=0;
unsigned long frequency;


void interrupt(void){
     if (INTCON.TMR0IF){ 
        TMR0=6;
        cnt0++;
        INTCON.TMR0IF=0;

     }
     if (PIR1.TMR1IF){
        TMR1H=0;// inicializa o high byte do timer 1;
        TMR1L=0;  // inicializa o low byte do timer 1;
        cnt1++;
        PIR1.TMR1IF=0;
     }
}

void main() {
     //PIR1.TMR1IF interrupt flag do timer 1
     //INTCON.TMR0IF interrupt flag do timer 0
     //T1CON.TMR1ON começa e para a contagem do timer 1
     unsigned char txt[11];
     unsigned char*point;
     TRISC.RC0=1;   // pino para ler a forma de onda que se vai medir a frequencia t1ckl
     ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
     
     // inicializando display lcd
     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Out(1,1,"Frequency"); // Escreve na posição 1,1
     Lcd_Out(2,1,"Counter"); // Escreve na posição 1,1
     Delay_ms(1000);
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     
     //configuração dos timers
     OPTION_REG=0xC4; // overflow do timer 0 a cada 1.6ms    x625 = 1s
     T1CON= 0x06;  // configura o timer 1 como contador no pino t1ckl
     
     //habilitando as interrupções
     INTCON=0xE0; // habilita a interrupção pelo overflow do timer0
     PIE1=0x01; // habilita a interrupção pelo overflow do timer 1


     for (;;){
        TMR1H=0;// inicializa o high byte do timer 1;
        TMR1L=0;  // inicializa o low byte do timer 1;
        cnt1=0;
        cnt0=0;
        TMR0=6; // inicializa o timer 0;
        T1CON.TMR1ON=1; // liga a contagem do timer 1
        while(cnt0<624); // segura até dar 1s 624 pois foi calibrado por
        T1CON.TMR1ON=0; // desliga a contagem do timer 1
        frequency=TMR1H;
        frequency=frequency*256+TMR1L;
        frequency=65536*cnt1+frequency;
        LongWordToStr(frequency,txt);
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"Frequency(Hz)"); // Escreve na posição 1,1
        point=ltrim(txt);
        Lcd_Out(2,1,point);
     
     }
}