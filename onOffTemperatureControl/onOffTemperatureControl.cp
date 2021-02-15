#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/onOffTemperatureControl/onOffTemperatureControl.c"



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




unsigned const char Table1[12]={0b00010001, 0b00100001, 0b01000001, 0b00010010, 0b00100010, 0b01000010, 0b00010100, 0b00100100, 0b01000100, 0b00011000, 0b00101000, 0b01001000};
unsigned const char Table2[12]={1, 2, 3, 4, 5, 6, 7, 8, 9, '*', 0, '#' };

unsigned char KeypadTable(unsigned char port_d){
 int i=0;
 unsigned char Key;
 while(Table1[i]!= port_d){
 i=i+1;
 if (i==12) break;
 }
 if (i!=12) Key= Table2[i];
 else Key='N';
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
 while((PORTD&(0x70))!=0);
 Delay_ms(20);
 return(Key);
}


void main() {

 unsigned char key,txt[8];
 float PlantTemp;
 unsigned char *pnt;
 unsigned char SP=0;

 ADCON1=0x0E;
 TRISD=0xF0;
 TRISE.RE0=0;
  PORTE.RE0 =1;
 PR2=249;
 CCPR1L=0x7D;
 TRISC.RC2=0;
 T2CON=0x05;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"TEMPERATURE");
 Lcd_Out(2,1,"CONTROL (ON-OFF)");
 Delay_ms(2000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Enter Set Point");
 Lcd_Out(2,1,"SP:");
 Lcd_Cmd(_LCD_BLINK_CURSOR_ON);

 do {
 key=keytest();
 if(key!='N'&&key!='#'&&key!='*'){
 SP = SP*10+key;
 Lcd_Chr_Cp(key+'0');
 }
 }
 while(key!='#'||SP==0);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 ByteToStr(SP,txt);
 Lcd_Out(1,1,"SP = ");
 pnt=ltrim(txt);
 Lcd_Out_Cp(pnt);
 Lcd_chr_Cp(0xDF);
 Lcd_chr_Cp('C');
 Lcd_Out(2,1,"ENTER to cont.");
 do {
 key=keytest();
 }
 while(key!='#');

 for(;;){
 Lcd_Out(2,1,"                ");
 PlantTemp=(500.0*ADC_Read(0))/1023;
 floatToStr(PlantTemp,txt);
 pnt=strchr(txt, '.');
 *(pnt+2)='\0';
 pnt=ltrim(txt);
 Lcd_Out(2,1,pnt);
 Lcd_chr_Cp(0xDF);
 Lcd_chr_Cp('C');
 if(SP-PlantTemp>3)  PORTE.RE0 =0;
 else if (SP-PlantTemp<=0)  PORTE.RE0 =1;
 if (abs(SP-PlantTemp)>5){
 CCP1CON=0x0C;
 }
 else {
 CCP1CON=0x00;
 }
 Delay_ms(300);
 }

}
