#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/Ultrassonico/Ultrassonico.c"





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




void main() {
 unsigned char txt[11];
 unsigned char*point;
 float Test_distanceCm=0;
 unsigned int high_level_time;
 TRISC.RC0=0;
 TRISC.RC1=1;

 ADCON1=0x0E;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Ultrassonic");
 Lcd_Out(2,1,"Measument");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);
  PORTC.RC0 =0;

 T1CON=0x30;
 INTCON=0x60;
 PIE1=0x01;
 Lcd_Out(1,1,"Distancia(Cm):");
 for (;;){
  PORTC.RC0 =1;
 Delay_us(10);
  PORTC.RC0 =0;
 while(! PORTC.RC1 );
 T1CON.TMR1ON=1;
 while( PORTC.RC1 );
 T1CON.TMR1ON=0;
 high_level_time=TMR1L+(TMR1H<<8);
 Test_distanceCm = (high_level_time*0.0272);
 TMR1H=0;
 TMR1L=0;
 floatToStr(Test_distanceCm,txt);
 point=ltrim(txt);
 Lcd_Out(2,1,"                ");
 Lcd_Out(2,1,point);
 Delay_ms(40);



 }
}
