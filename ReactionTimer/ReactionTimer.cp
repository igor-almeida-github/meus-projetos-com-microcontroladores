#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/ReactionTimer/ReactionTimer.c"



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



unsigned char flags=0;
unsigned long overflow=0;
unsigned char no;
unsigned long ElapsedTime;
unsigned char Txt[11];

void interrupt(void){
 overflow++;
 PIR1.TMR1IF=0;
}

void main() {
 TRISD.RD1=0;
 TRISD.RD0=1;
 ADCON1=0x06;
 T1CON=0x30;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
  PORTD.RD1 =0;
 srand(10);
 INTCON=0xC0;
 PIE1=1;


 for(;;){
 no=rand()%10+1;
 Vdelay_ms(no*1000);
 overflow=0;
 TMR1H=0;
 TMR1L=0;
  PORTD.RD1 =1;
 T1CON.TMR1ON=1;
 while ( PORTD.RD2 );
 T1CON.TMR1ON=0;
  PORTD.RD1 =0;
 ElapsedTime=TMR1L;
 ElapsedTime+=(TMR1H<<8);
 ElapsedTime=(ElapsedTime/10)*16+104857*overflow;
 ElapsedTime=ElapsedTime/1000;
 LongWordToStr(ElapsedTime,Txt);
 Lcd_out(1,1,"Reaction(ms):");
 Lcd_out(2,1,Txt);
 Delay_ms(2000);
 Lcd_cmd(_LCD_CLEAR);
 }

}
