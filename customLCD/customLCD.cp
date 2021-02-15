#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/customLCD/customLCD.c"





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

const char character[] = {14,21,14,4,14,21,4,10};
void CustomChar(char pos_row, char pos_char) {
 char i;
 Lcd_Cmd(64);
 for (i = 0; i<=7; i++) Lcd_Chr_CP(character[i]);
 Lcd_Cmd(_LCD_RETURN_HOME);
 Lcd_Chr(pos_row, pos_char, 0);
}
const char character1[] = {14,21,14,4,13,12,18,9};

void CustomChar1(char pos_row, char pos_char) {
 char i;
 Lcd_Cmd(64);
 for (i = 0; i<=7; i++) Lcd_Chr_CP(character1[i]);
 Lcd_Cmd(_LCD_RETURN_HOME);
 Lcd_Chr(pos_row, pos_char, 0);
}
void main() {

 ADCON1=0x0E;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_cmd(_LCD_CURSOR_OFF);

 Lcd_Out(1,1,"The man who ");
 Lcd_Out(2,1,"can't be moved ");

 for (;;){
 CustomChar(2,16);
 Delay_ms(500);
 CustomChar1(2,16);
 Delay_ms(500);
 }
}
