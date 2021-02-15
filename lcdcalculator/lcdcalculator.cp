#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/lcdcalculator/lcdcalculator.c"





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










unsigned char KeypadTable(unsigned char port_d){
 int i=0;
 unsigned char Key;
 unsigned char Table1[12]={0b00010001, 0b00100001, 0b01000001, 0b00010010, 0b00100010, 0b01000010, 0b00010100, 0b00100100, 0b01000100, 0b00011000, 0b00101000, 0b01001000};
 unsigned char Table2[12]={1, 2, 3, 4, 5, 6, 7, 8, 9, '*', 0, '#' };
 while(Table1[i]!= port_d){
 i=i+1;
 if (i==12) break;
 }
 Key= Table2[i];
 return(Key);

 }
unsigned char keytest(){
 unsigned char Key;
 PORTD=0x01;
 while((PORTD&(0x70))==0){
 PORTD=(PORTD<<1);
 if ((PORTD&(0x0F))==0) PORTD=0x01;
 }
 Delay_ms(20);
 Key=KeypadTable(PORTD&0x7F);
 while((PORTD&(0x70))!=0) asm nop;
 Delay_ms(20);
 return(Key);
}

void main() {
 unsigned char txt[14];
 char*lcd;
 float No1,No2,Ans;
 unsigned char key,Op,disp[12];
 ADCON1=0x0E;
 TRISD=0xF0;

 RCSTA<7>=1;
 TRISC.RC7=1;
 TRISC.RC6=1;
 UART1_Init(9600);
 Delay_ms(100);

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"CALCULATOR");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);


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
