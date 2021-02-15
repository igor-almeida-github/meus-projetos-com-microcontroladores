
 // este programa para o PIC16F877A exibe a temperatura em um display LCD


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


void main() {
     float temp;
     char txt[14];
     ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
     TRISA.RB0=1;
     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_cmd(_LCD_CURSOR_OFF); // Esconde o cursor
     Lcd_Out(1,1,"Temperature"); // Escreve na posição 1,1


     for (;;){
         temp=ADc_Read(0); //leitura analógica em escala de 0 a 1023
         temp=temp*5000.0/1024.0; // valor em mV
         temp=temp/10.0; // Valor em C
         floatToStr(temp,txt);
         Lcd_Out(2,1,txt); // Escreve na posição 2,1
         Delay_ms(500);
     }
}