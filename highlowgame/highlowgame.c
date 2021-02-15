 // este programa para o PIC16F877A gera um numero aleatorio e compara com um numero informado pelo usuario.

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

char keypadPort at PORTD;  // teclado conectado no portd

// A_out PORTD.RD0
// B_out PORTD.RD1
// C_out PORTD.RD2
// D_out PORTD.RD3

// IN_1 PORTD.RD4
// IN_2 PORTD.RD5
// IN_3 PORTD.RD6



void main() {
     unsigned char keytab[]={0,1,2,3,0,4,5,6,0,7,8,9,0,'*',0,'#'};
     int dif;
     unsigned int aleatorio;
     unsigned long player=0;
     unsigned char key;
     ADCON1=0x0E;      //configuração de portas como digitais - AN0 é analógica
     Keypad_Init();    // inicializa o keypad

     Lcd_Init(); // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd
     Lcd_Out(1,1,"High/Low Game"); // Escreve na posição 1,1
     Delay_ms(2000);
     Lcd_Cmd(_LCD_CLEAR); // Limpa o lcd

     srand(5);
     Lcd_Out(1,1,"Guess Now..");
     Lcd_Out(2,1,"");
     aleatorio=rand();
     
     for (;;){

         while(1){ // Recebe o numero do usuario e imprime na segunda linha do diplay lcd
              do
                key = Keypad_Key_Click();
              while(!key);           // enquanto a tecla nao for pressionada
              key=keytab[key];
              if (key=='#') break;
              if (key!='*'){
                 Lcd_Chr_Cp(key+'0');      // escreve na posição do cursor
                 player=10*player+key;
              }
              if (player>32767) break;
           }
           Lcd_out(2,1,"                "); // Limpa a segunda linha do display lcd
           
           if (player==aleatorio){
                   Lcd_out(2,1,"Well Done!!!");
                   Delay_ms(1000);
                   aleatorio=rand();
           }
           else if (player>aleatorio){
                   Lcd_out(2,1,"HIGH - Try Again");
                   Delay_ms(1000);
           }
           else if (player<aleatorio){
                   Lcd_out(2,1,"LOW - Try Again!");
                   Delay_ms(1000);
           }
           Lcd_out(2,1,"                ");
           Lcd_out(2,1,"");
           player=0;
      }
}