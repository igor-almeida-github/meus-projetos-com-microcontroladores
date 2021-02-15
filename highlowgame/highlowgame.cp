#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/highlowgame/highlowgame.c"



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

char keypadPort at PORTD;
#line 31 "C:/Users/igor_/Documents/PIC/Mikroc/highlowgame/highlowgame.c"
void main() {
 unsigned char keytab[]={0,1,2,3,0,4,5,6,0,7,8,9,0,'*',0,'#'};
 int dif;
 unsigned int aleatorio;
 unsigned long player=0;
 unsigned char key;
 ADCON1=0x0E;
 Keypad_Init();

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"High/Low Game");
 Delay_ms(2000);
 Lcd_Cmd(_LCD_CLEAR);

 srand(5);
 Lcd_Out(1,1,"Guess Now..");
 Lcd_Out(2,1,"");
 aleatorio=rand();

 for (;;){

 while(1){
 do
 key = Keypad_Key_Click();
 while(!key);
 key=keytab[key];
 if (key=='#') break;
 if (key!='*'){
 Lcd_Chr_Cp(key+'0');
 player=10*player+key;
 }
 if (player>32767) break;
 }
 Lcd_out(2,1,"                ");

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
