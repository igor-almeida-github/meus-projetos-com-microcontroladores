
 // este programa para o PIC16F877A lê um teclado e funciona como calculadora com um display lcd


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
     ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica

     UART1_Init(9600);//**************************
     Delay_ms(100); //**************************
     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     
     
     for (;;){ 
         No1=No2=Ans=0;
         
         Lcd_Out(1,1,"No1:");
         while(1){
              key = keytest();
              if (key=='#') break;
              if (key!='*'){
                 Lcd_Chr_Cp(key+'0');
                 No1=10*No1+key;
              }
           }
           
         Lcd_Out(2,1,"No2:");
         while(1){
              key = keytest();
              if (key=='#') break;
              if (key!='*'){
                 Lcd_Chr_Cp(key+'0');
                 No2=10*No2+key;
              }
           }
           
         Lcd_Cmd(_LCD_CLEAR);
         Op='*';
         Lcd_Out(1,1,"Op:*");
         while(1){
              key = keytest();
              if (key=='#') break;
              if (key=='*'){
                 if(Op=='*') Op='/';
                 else if(Op=='/') Op='+';
                 else if(Op=='+') Op='-';
                 else if(Op=='-') Op='*';
              }
              Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);
              Lcd_Chr_Cp(Op);
           }
         switch(Op){
            case '*':
            Ans=No1*No2;
            break;
            
            case '/':
            Ans=No1/No2;
            break;
            
            case '+':
            Ans=No1+No2;
            break;

            case '-':
            Ans=No1-No2;
            break;
         }
         Lcd_Cmd(_LCD_CLEAR);
         FloatToStr(Ans,disp);
         lcd=Ltrim(disp);
         Lcd_Out(1,1,"Ans=");
         Lcd_Out_Cp(lcd);
         Delay_ms(5000);
         Lcd_Cmd(_LCD_CLEAR);

     }
}