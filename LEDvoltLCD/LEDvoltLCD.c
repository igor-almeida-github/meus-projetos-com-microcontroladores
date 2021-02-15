
 // este programa implementa um voltimetro led em um display lcd


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
     unsigned long mV;
     unsigned char op[12];

     char*str;
     TRISB=0xC0;        // Os 6 primeiros bits do PORTB são OUTPUT, os demais são input
     ADCON1=0x0E;       // Todas as portas são dgitais exceto AN0(RA0)
     TRISA.RA0=1;       // A porta do AN0 é input
     ADCON2=0x80;     // Resultado justificado a direita
     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_cmd(_LCD_CURSOR_OFF); // Esconde o cursor
     Lcd_Out(1,1,"VOLTMETER"); // Escreve na posição 1,1
     Delay_ms(2000); 

     for (;;){
        Lcd_Cmd(_LCD_CLEAR);
         // configuração do lcd
          // Limpa o lcd
        mV= Adc_Read(0); // multiplicado por 5000mv e dividido por 1024: deslocado 10 bits para a direita, o que é o mesmo que dividir por 1024
        mV=(mV*4740)>>10; // CUIDADO, SE MULTIPLICAR DUAS VARIAVEIS INTEIRAS O RESULTADO É SEMPRE UM INTEIRO DE 16 BITS, PORTANTO DEPENDENDO DO VALOR PODE DAR OVERFLOW
        Lcd_Out(1,1,"mV = ");
        LongToStr(mV,op); // Converte para string na variavel op
        str=Ltrim(op);     // Remove espaços a frente
        Lcd_Out(1,6,str);
        Delay_ms(500);

     }
}