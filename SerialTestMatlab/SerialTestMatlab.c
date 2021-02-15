 // este programa para o PIC16F877A foi feito para testar a comunicação serial entre pic e matlab


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

unsigned char disp[20];
char uart_rd=0;

void main() {

     unsigned char txt[11];
     unsigned char*point;
     ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica

     // inicializando display lcd
     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Out(1,1,"Matlab serial"); // Escreve na posição 1,1
     Delay_ms(2000);
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     
     RCSTA<7>=1;  // REMOVER_*****************************
     TRISC.RC7=1; // REMOVER_*****************************
     TRISC.RC6=1; // REMOVER_*****************************
     UART1_Init(9600);// REMOVER_*****************************
     Delay_ms(100); // REMOVER_*****************************

     for (;;){
        
        if (UART1_Data_Ready()) {     // If data is received,
           uart_rd = UART1_Read();
        }
        
        if (uart_rd=='1'){
           Lcd_Out(1,1,"Number 1");
           Delay_ms(3000);
           Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
        }
        
        if (uart_rd=='2'){
           Lcd_Out(1,1,"Number 2");
           Delay_ms(3000);
           Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
        }
        
        if (uart_rd=='3'){
           Lcd_Out(1,1,"Number 3");
           Delay_ms(3000);
           Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
        }

        uart_rd=0;
     }
}