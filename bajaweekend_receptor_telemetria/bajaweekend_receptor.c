// Recepetor para acompanhamento remoto das condições do veículo durante o bajaweekend, conta com display lcd
// Desenvolvido

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
     unsigned char txt[15];
     unsigned char b1, b2 = 0;
     unsigned long motor = 0;
     unsigned char tank = 1;
     unsigned int freio = 0;
     ADCON1=0x0F;      //configuração de portas como digitais - AN0 é analógica
     UART1_Init(1200);//**************************
     Delay_ms(100); //**************************
     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_Cmd(_LCD_CURSOR_OFF);
     for (;;){
         while (1){
             if ((UART1_Data_Ready()) &&  (b1 != 0x0D)){                           // Espera chagar dados na serial
                  b1 = UART1_Read();
             }
             if  ((b1 == 0x0D) && UART1_Data_Ready()){
                  b2 = UART1_Read();
             }
             if ((b1 == 0x0D) && (b2 == 0x0A)){
                  break;
             }
             else if ((b1 == 0x0D)&&(b2!=0)){
                  b1 = 0;
                  b2 = 0;
             }
         }
         while(!UART1_Data_Ready());
         *((unsigned char*)&motor+3) =  UART1_Read();
         while(!UART1_Data_Ready());
         *((unsigned char*)&motor+2) =  UART1_Read();
         while(!UART1_Data_Ready());
         *((unsigned char*)&motor+1) =  UART1_Read();
         while(!UART1_Data_Ready());
         *((unsigned char*)&motor) =    UART1_Read();
         while(!UART1_Data_Ready());
         *((unsigned char*)&freio+1) =  UART1_Read();
         while(!UART1_Data_Ready());
         *((unsigned char*)&freio) =   UART1_Read();
         while(!UART1_Data_Ready());
         tank =  UART1_Read();

         Lcd_out(1, 1, "Rt: ");
         LongWordToStr(motor, txt);
         Lcd_out(1, 5, ltrim(txt));
         
         Lcd_out(2, 1, "Brk: ");
         WordToStr(freio, txt);
         Lcd_out(2, 6, ltrim(txt));
         
         if (tank == 1) lcd_out(2, 13,"Full");
         if (tank == 0) lcd_out(2, 13,"Epty");

     }
}
