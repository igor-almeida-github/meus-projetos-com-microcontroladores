// Este programa para o PIC16F877A � um controlador de temperatura On-Off, envolvendo um lcd, um teclado, um buzzer, um rel� e um sensor de temperatura

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

#define relay PORTE.RE0

//********************Keypad_fun��es********************************************
unsigned const char Table1[12]={0b00010001, 0b00100001,  0b01000001,   0b00010010, 0b00100010,  0b01000010,   0b00010100, 0b00100100,  0b01000100,  0b00011000, 0b00101000,  0b01001000};
unsigned const char Table2[12]={1,          2,           3,            4,          5,           6,            7,           8,           9,           '*',         0,           '#'  };

unsigned char KeypadTable(unsigned char port_d){                                // Procura nas tabelas a tecla pressionada de acordo com o PORTD
     int i=0;
     unsigned char Key;
     while(Table1[i]!= port_d){
        i=i+1;
        if (i==12) break;                                                       // Tecla inv�lida encontrada, condi��o inesperada.
     }
     if (i!=12) Key= Table2[i];                                                 // Se a tecla encrontrada for v�lida
     else Key='N';
     return(Key);

 }
unsigned char keytest(){                                                        // Essa fun��o testa o teclado e retorna a tecla pressionada (Blocking call)
     unsigned char Key;
     PORTD=0x01;
     while((PORTD&(0x70))==0){                                                  // PORTD and 0b01110000
         PORTD=(PORTD<<1);
         if ((PORTD&(0x0F))==0) PORTD=0x01;
     }
     Delay_ms(20);
     Key=KeypadTable(PORTD&0x7F);                                               // PORTD and 0b01111111 pois o estado do rd7 � desconhecido visto que ele � input
     while((PORTD&(0x70))!=0);                                                  // Espera soltar a tecla
     Delay_ms(20);
     return(Key);
}


void main() {
      //*****************Declara��o_de_vari�veis_locais*************************
      unsigned char key,txt[8];
      float  PlantTemp;
      unsigned char *pnt;                                                       // Pointer
      unsigned char SP=0;                                                       // Setpoint inicializado como 0�C
      //*****************Configura��es_iniciais*********************************
      ADCON1=0x0E;                                                              // Todas as portas s�o digitais exceto AN0
      TRISD=0xF0;                                                               // A,B,C,D s�o OUTPUT e 1 2 3 s�o input.
      TRISE.RE0=0;                                                              // Pino do rel� � OUTPUT
      relay=1;                                                                  // Rel� come�a desligado
      PR2=249;                                                                  // Per�odo de 200us
      CCPR1L=0x7D;                                                              // Duty cyle de 100us (CCPR1L<<2)|CCP1CON<5:4>=500
      TRISC.RC2=0;                                                              // CCP1 pin � OUTPUT
      T2CON=0x05;                                                               // Timer 2 1:1 postascale, 4 prescale
      Lcd_Init();                                                               // LCD inicializa o lcd conectado ao PORTB
      Lcd_Cmd(_LCD_CLEAR);                                                      // Limpa o lcd
      Lcd_Cmd(_LCD_CURSOR_OFF);                                                 // Deliga o cursor
      Lcd_Out(1,1,"TEMPERATURE");
      Lcd_Out(2,1,"CONTROL (ON-OFF)");
      Delay_ms(2000);
      Lcd_Cmd(_LCD_CLEAR);                                                      // Limpa o lcd
      Lcd_Out(1,1,"Enter Set Point");
      Lcd_Out(2,1,"SP:");
      Lcd_Cmd(_LCD_BLINK_CURSOR_ON);                                            // Pisca o cursor
      //***************************Recebe_o_setpoint_do_usu�rio*****************
     do {
          key=keytest();                                                        // Espera e l� uma tecla
          if(key!='N'&&key!='#'&&key!='*'){
               SP = SP*10+key;
               Lcd_Chr_Cp(key+'0');
          }
      }
      while(key!='#'||SP==0);                                                   // Fa�a enquanto a tecla '#' n�o for pressionada ou valor do setpoint n�o for inserido
      Lcd_Cmd(_LCD_CURSOR_OFF);                                                 // Desliga o cursor
      Lcd_Cmd(_LCD_CLEAR);                                                      // Limpa o lcd
      ByteToStr(SP,txt);
      Lcd_Out(1,1,"SP = ");
      pnt=ltrim(txt);
      Lcd_Out_Cp(pnt);
      Lcd_chr_Cp(0xDF);                                                         // S�mbolo de graus �
      Lcd_chr_Cp('C');
      Lcd_Out(2,1,"ENTER to cont.");
      do {
          key=keytest();                                                        // Espera e l� uma tecla
      }
      while(key!='#');

      for(;;){
           Lcd_Out(2,1,"                ");                                     // Limpa a segunda linha do LCD
           PlantTemp=(500.0*ADC_Read(0))/1023;                                  // L� adc0 e converte pra �C
           floatToStr(PlantTemp,txt);
           pnt=strchr(txt, '.');
           *(pnt+2)='\0';                                                       // insere caracter null duas casas decimais depois da virgula, deixando a string com somente uma casa decimal a ser exibida
           pnt=ltrim(txt);
           Lcd_Out(2,1,pnt);
           Lcd_chr_Cp(0xDF);                                                    // S�mbolo de graus �
           Lcd_chr_Cp('C');
           if(SP-PlantTemp>3) relay=0;                                          //rel� liga
           else if (SP-PlantTemp<=0) relay=1;                                   //rel� desliga
           if (abs(SP-PlantTemp)>5){
              CCP1CON=0x0C;                                                     // PWM ativado, buzzer tocando
           }
           else {
              CCP1CON=0x00;                                                     // PWM desativado, reseta m�dulo CCPx
           }
           Delay_ms(300);
      }

}