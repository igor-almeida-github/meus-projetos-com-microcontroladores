#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/FrequencyCounter/frequencycounter.c"





sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

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
 TMR1H=0;
 TMR1L=0;
 cnt1++;
 PIR1.TMR1IF=0;
 }
}

void main() {



 unsigned char txt[11];
 unsigned char*point;
 TRISC.RC0=1;
 ADCON1=0x0E;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Frequency");
 Lcd_Out(2,1,"Counter");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);


 OPTION_REG=0xC4;
 T1CON= 0x06;


 INTCON=0xE0;
 PIE1=0x01;


 for (;;){
 TMR1H=0;
 TMR1L=0;
 cnt1=0;
 cnt0=0;
 TMR0=6;
 T1CON.TMR1ON=1;
 while(cnt0<624);
 T1CON.TMR1ON=0;
 frequency=TMR1H;
 frequency=frequency*256+TMR1L;
 frequency=65536*cnt1+frequency;
 LongWordToStr(frequency,txt);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Frequency(Hz)");
 point=ltrim(txt);
 Lcd_Out(2,1,point);

 }
}
