#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/LCDthermometer/LCDthermometer.c"





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
 float temp;
 char txt[14];
 ADCON1=0x0E;
 TRISA.RB0=1;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Temperature");


 for (;;){
 temp=ADc_Read(0);
 temp=temp*5000.0/1024.0;
 temp=temp/10.0;
 floatToStr(temp,txt);
 Lcd_Out(2,1,txt);
 Delay_ms(500);
 }
}
