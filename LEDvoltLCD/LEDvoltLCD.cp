#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/LEDvoltLCD/LEDvoltLCD.c"





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
 unsigned long mV;
 unsigned char op[12];

 char*str;
 TRISB=0xC0;
 ADCON1=0x0E;
 TRISA.RA0=1;
 ADCON2=0x80;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"VOLTMETER");
 Delay_ms(2000);

 for (;;){
 Lcd_Cmd(_LCD_CLEAR);


 mV= Adc_Read(0);
 mV=(mV*4740)>>10;
 Lcd_Out(1,1,"mV = ");
 LongToStr(mV,op);
 str=Ltrim(op);
 Lcd_Out(1,6,str);
 Delay_ms(500);

 }
}
